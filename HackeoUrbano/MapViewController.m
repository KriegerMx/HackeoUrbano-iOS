//
//  MapViewController.m
//  HackeoUrbano
//
//  Created by Marlon Vargas Contreras on 5/3/16.
//  Copyright © 2016 Krieger. All rights reserved.
//

#import "MapViewController.h"

#define padding 15.0
#define screenWidth  [[UIScreen mainScreen] bounds].size.width
#define delta 0.004

@interface MapViewController () {
    MKMapView *map;
    
    CLLocationManager *locationManager;
    UITableView *trailsTableView;
    UIView *bottomView;
    UIImageView *accessoryImageView;
    BOOL showTableView;
    BOOL askedForLocation;
    
    NSMutableArray *trails;
    CLLocation *previousCenterLocation;
    GTLDashboardAPITrailDetailsCollection *trailDetailsCollection;
    
    UIView *loaderView;
}

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLocationManager];
    [self addViews];
    [self setTableView];
    [self addLoader];

    trails = [NSMutableArray new];
    [self.navigationController.navigationBar setTintColor:[HUColor navBarTintColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - location
- (void)askForLocationPermission {
    askedForLocation = YES;
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
}

- (void)setLocationManager {
    if ([self isUserLocationAvailable]) {
        locationManager = [CLLocationManager new];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
    } else {
        [self askForLocationPermission];
    }
}

- (BOOL)isUserLocationAvailable {
    if ([CLLocationManager locationServicesEnabled]){
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse && askedForLocation) {
        askedForLocation = NO;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [locationManager stopUpdatingLocation];
    locationManager = nil;
    CLLocation *userLocation = locations[0];
    [self adjustMapToLocation:userLocation];
    [self getTrailsForLocation:userLocation];
    previousCenterLocation = userLocation;
}

- (void)adjustMapToLocation:(CLLocation*)location {
    MKCoordinateSpan span;
    span.latitudeDelta = delta;
    span.longitudeDelta = delta;
    
    MKCoordinateRegion region;
    region.span = span;
    region.center = location.coordinate;
    
    [map setRegion:region animated:NO];
}


#pragma mark - views
- (void)addViews {
    [self addMap];
    [self addBottomView];
}

- (void)addMap {
    map = [MKMapView new];
    map.delegate = self;
    [self.view addSubview:map];
    
    [map mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (void)addBottomView {
    bottomView = [UIView new];
    bottomView.backgroundColor = [HUColor backgroundColor];
    bottomView.alpha = 0.8;
    [self.view addSubview:bottomView];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"Lista de recorridos";
    titleLabel.numberOfLines = 0;
    [bottomView addSubview:titleLabel];
    
    UIImage *accessoryImage = [UIImage imageNamed:@"ic_arrow"];
    accessoryImageView = [[UIImageView alloc] initWithImage:accessoryImage];
    [bottomView addSubview:accessoryImageView];
    
    [bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).offset(-44);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@44);
    }];
    
    [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView.mas_centerY);
        make.left.equalTo(bottomView.mas_left).offset(20);
        make.right.equalTo(accessoryImageView.mas_left);
        make.height.equalTo(@30);
    }];
    
    [accessoryImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView.mas_centerY);
        make.left.equalTo(titleLabel.mas_right);
        make.right.equalTo(bottomView.mas_right).offset(-20);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [bottomView addGestureRecognizer:tapRecognizer];
}

- (void)tap {
    showTableView = !showTableView;
    if (showTableView) {
        accessoryImageView.transform = CGAffineTransformMakeRotation(M_PI);
        [bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(64);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.height.equalTo(@44);
        }];
    } else {
        accessoryImageView.transform = CGAffineTransformMakeRotation(0);
        [bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom).offset(-44);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.height.equalTo(@44);
        }];
    }
    [UIView animateWithDuration:1.0 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - table  view
- (void)setTableView {
    trailsTableView = [UITableView new];
    trailsTableView.delegate = self;
    trailsTableView.dataSource = self;
    trailsTableView.estimatedRowHeight = 80.0;
    trailsTableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:trailsTableView];
    
    [trailsTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return trails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = trails[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [HUColor textColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TrailViewController *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"trailVC"];
    tvc.trailDetails = trailDetailsCollection[indexPath.row];
    [self.navigationController pushViewController:tvc animated:YES];
}

#pragma mark - services
- (void)getTrailsForLocation:(CLLocation*)location {
    if (!loaderView) {
        [self addLoader];
    }
    
    static GTLServiceDashboardAPI *service = nil;
    if (!service) {
        service = [GTLServiceDashboardAPI new];
        service.retryEnabled = YES;
    }
    
    MKMapRect mRect = map.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMinY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMaxY(mRect));
    
    CLLocationCoordinate2D eastCoordinate = MKCoordinateForMapPoint(eastMapPoint);
    CLLocationCoordinate2D westCoordinate = MKCoordinateForMapPoint(westMapPoint);
    
    GTLDashboardAPIGPSLocation *northEastCorner = [GTLDashboardAPIGPSLocation new];
    northEastCorner.latitude = [NSNumber numberWithFloat:eastCoordinate.latitude];
    northEastCorner.longitude = [NSNumber numberWithFloat:eastCoordinate.longitude];
    
    NSLog(@"%f, %f", eastCoordinate.latitude, eastCoordinate.longitude);
    NSLog(@"%f, %f", westCoordinate.latitude, westCoordinate.longitude);
    
    GTLDashboardAPIGPSLocation *southWestCorner = [GTLDashboardAPIGPSLocation new];
    southWestCorner.latitude = [NSNumber numberWithFloat:westCoordinate.latitude];
    southWestCorner.longitude = [NSNumber numberWithFloat:westCoordinate.longitude];
    
    GTLDashboardAPIAreaWrapper *areaWrapper = [GTLDashboardAPIAreaWrapper new];
    areaWrapper.northEastCorner = northEastCorner;
    areaWrapper.southWestCorner = southWestCorner;
    
    GTLQueryDashboardAPI *query = [GTLQueryDashboardAPI queryForTrailsNearPointWithObject:areaWrapper];
    
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        if (error) {
            [self removeLoader];
            NSLog(@"error: %@", error);
        } else {
            trailDetailsCollection = (GTLDashboardAPITrailDetailsCollection*)object;
            if (trailDetailsCollection.items.count == 0) {
                [self removeLoader];
                NSLog(@"0 recorridos");
            }
            for (GTLDashboardAPITrailDetails *trailDetails in trailDetailsCollection.items) {
                Trail *trail = [Trail objectForPrimaryKey:@(trailDetails.trailId.longLongValue)];
                NSString *trailName = [NSString stringWithFormat:@"%@ - %@", trailDetails.originStationName, trailDetails.destinationStationName];
                [trails addObject:trailName];
                if (trail) {
                    NSArray *points = [NSKeyedUnarchiver unarchiveObjectWithData:trail.points];
                    [self makePolylineWithPoints:points];
                } else {
                    RLMRealm *realm = [RLMRealm defaultRealm];
                    trail = [Trail new];
                    trail.identifier = trailDetails.trailId.longLongValue;
                    trail.name = trailName;
                    [realm beginWriteTransaction];
                    [realm addOrUpdateObject:trail];
                    [realm commitWriteTransaction];
                    [self getPointsForTrail:trailDetails.trailId cursor:nil];
                }
            }
            [trailsTableView reloadData];
        }
    }];
}

- (void)getPointsForTrail:(NSNumber*)trailId cursor:(NSString*)cursor {
    static GTLServiceDashboardAPI *service = nil;
    if (!service) {
        service = [GTLServiceDashboardAPI new];
        service.retryEnabled = YES;
    }
    
    GTLDashboardAPITrailPointsRequestParameter *trailPointsRequestParameter = [GTLDashboardAPITrailPointsRequestParameter new];
    trailPointsRequestParameter.trailId = trailId;
    trailPointsRequestParameter.numberOfElements = [NSNumber numberWithInt:100];
    if (cursor) {
        trailPointsRequestParameter.cursor = cursor;
    }
    
    GTLQueryDashboardAPI *query = [GTLQueryDashboardAPI queryForGetTrailSnappedPointsWithObject:trailPointsRequestParameter];
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        if (error) {
            NSLog(@"error: %@", error);
        } else {
            GTLDashboardAPITrailPointsResult *result = (GTLDashboardAPITrailPointsResult*)object;
            NSUInteger pointsCount = result.points.count;
            Trail *trail = [Trail objectForPrimaryKey:@(trailId.longLongValue)];
            NSMutableArray *points = [NSMutableArray new];
            [points addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:trail.points]];
            if (pointsCount > 0) {
                for (GTLDashboardAPITrailPointWrapper *wrapper in result.points) {
                    NSDictionary *dic = @{@"latitude":wrapper.location.latitude, @"longitude":wrapper.location.longitude};
                    [points addObject:dic];
                }
                
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm beginWriteTransaction];
                trail.points = [NSKeyedArchiver archivedDataWithRootObject:points];
                [realm commitWriteTransaction];
                if (pointsCount == 100) {
                    [self getPointsForTrail:trailId cursor:result.cursor];
                } else {
                    [self makePolylineWithPoints:points];
                }
            } else {
                [self makePolylineWithPoints:points];
            }
        }
    }];
}

- (void)makePolylineWithPoints:(NSArray*)points {
    [self removeLoader];
    CLLocationCoordinate2D coordinates[[points count]];
    int i = 0;
    for (NSDictionary *dic in points) {
        coordinates[i] = CLLocationCoordinate2DMake([[dic objectForKey:@"latitude"] floatValue], [[dic objectForKey:@"longitude"] floatValue]);
        i++;
    }
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coordinates count:[points count]];
    [map addOverlay:polyline];
}

#pragma mark - map
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    CLLocationCoordinate2D center = mapView.centerCoordinate;
    CLLocation *centerLocation = [[CLLocation alloc] initWithLatitude:center.latitude longitude:center.longitude];
    float distanceChange = [centerLocation distanceFromLocation:previousCenterLocation]/1000;
    if (distanceChange > 2.5) {
        previousCenterLocation = centerLocation;
        [self clearMapAndTableView];
        [self getTrailsForLocation:centerLocation];
    }
}

-(MKOverlayRenderer*)mapView:(MKMapView*)mapView rendererForOverlay:(id <MKOverlay>)overlay{
    float hue = arc4random()%360/360.0;
    float sat = arc4random()%100/100.0;
    float bri = arc4random()%100/100.0;
    
    UIColor *lineColor = [HUColor colorWithHue:hue saturation:sat brightness:bri alpha:1.0];
    
    MKPolylineRenderer* lineView = [[MKPolylineRenderer alloc] initWithPolyline:(MKPolyline*)overlay];
    lineView.strokeColor = lineColor;
    lineView.lineWidth = 4;
    return lineView;
}

- (void)clearMapAndTableView {
    trails = [NSMutableArray new];
    [trailsTableView reloadData];
    NSArray *overlays = [map overlays];
    [map removeOverlays:overlays];
}

#pragma mark - loader
- (void)addLoader {
    loaderView = [UIView new];
    loaderView.backgroundColor = [HUColor backgroundColor];
    [self.view addSubview:loaderView];
    
    UIActivityIndicatorView *loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loader startAnimating];
    [loaderView addSubview:loader];
    
    [loaderView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [loader mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(loaderView.mas_centerX);
        make.centerY.equalTo(loaderView.mas_centerY);
        make.height.equalTo(@44);
        make.width.equalTo(@44);
    }];
}

- (void)removeLoader {
    if (loaderView) {
        [loaderView removeFromSuperview];
        loaderView = nil;
    }
}

@end
