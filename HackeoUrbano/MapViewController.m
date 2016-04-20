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
    UIButton *fetcherButton;
    
    CLLocationManager *locationManager;
    UITableView *trailsTableView;
    UIView *bottomView;
    UIImageView *accessoryImageView;
    BOOL showTableView;
    BOOL askedForLocation;
    
    NSMutableArray *trails;
    CLLocation *previousCenterLocation;
    GTLMapatonPublicAPINearTrailsCollection *nearTrailsCollection;
    
    UIView *loaderView;
    UIView *placeholderView;
}

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkLocation];

    trails = [NSMutableArray new];
    [self.navigationController.navigationBar setTintColor:[HUColor navBarTintColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - location
- (void)checkLocation {
    if ([CLLocationManager locationServicesEnabled]){
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
            [self setLocationManager];
        } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            [self askForLocationPermission];
        } else {
            [self showLocationPlaceholder];
        }
    } else {
        [self showLocationPlaceholder];
    }
}

- (void)askForLocationPermission {
    askedForLocation = YES;
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
}

- (void)setLocationManager {
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    [self addViews];
    [self setTableView];
    [self addLoader];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse && askedForLocation) {
        askedForLocation = NO;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
        [self addViews];
        [self setTableView];
        [self addLoader];
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
    
    fetcherButton = [UIButton buttonWithType:UIButtonTypeSystem];
    fetcherButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    fetcherButton.alpha = 0.8;
    [fetcherButton setTitle:@"Buscar en esta zona" forState:UIControlStateNormal];
    [fetcherButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fetcherButton setBackgroundColor:[HUColor secondaryColor]];
    [fetcherButton addTarget:self action:@selector(prepareFetch) forControlEvents:UIControlEventTouchUpInside];
    [fetcherButton setHidden:YES];
    [self.view addSubview:fetcherButton];
    
    [map mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [fetcherButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(map.mas_top).offset(20);
        make.left.equalTo(map.mas_left).offset(20);
        make.right.equalTo(map.mas_right).offset(-20);
        make.height.equalTo(@50);
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
    GTLMapatonPublicAPINearTrails *nearTrails = nearTrailsCollection[indexPath.row];
    tvc.trailId = nearTrails.trailId;
    [self.navigationController pushViewController:tvc animated:YES];
}

#pragma mark - services
- (void)getTrailsForLocation:(CLLocation*)location {
    if (!loaderView) {
        [self addLoader];
    }
    
    static GTLServiceMapatonPublicAPI *service = nil;
    if (!service) {
        service = [GTLServiceMapatonPublicAPI new];
        service.retryEnabled = YES;
    }
    
    MKMapRect mRect = map.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMinY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMaxY(mRect));
    
    CLLocationCoordinate2D eastCoordinate = MKCoordinateForMapPoint(eastMapPoint);
    CLLocationCoordinate2D westCoordinate = MKCoordinateForMapPoint(westMapPoint);
    
    GTLMapatonPublicAPIGPSLocation *northEastCorner = [GTLMapatonPublicAPIGPSLocation new];
    northEastCorner.latitude = [NSNumber numberWithFloat:eastCoordinate.latitude];
    northEastCorner.longitude = [NSNumber numberWithFloat:eastCoordinate.longitude];
    
    GTLMapatonPublicAPIGPSLocation *southWestCorner = [GTLMapatonPublicAPIGPSLocation new];
    southWestCorner.latitude = [NSNumber numberWithFloat:westCoordinate.latitude];
    southWestCorner.longitude = [NSNumber numberWithFloat:westCoordinate.longitude];
    
    GTLMapatonPublicAPIAreaWrapper *areaWrapper = [GTLMapatonPublicAPIAreaWrapper new];
    areaWrapper.northEastCorner = northEastCorner;
    areaWrapper.southWestCorner = southWestCorner;
    
    GTLQueryMapatonPublicAPI *query = [GTLQueryMapatonPublicAPI queryForTrailsNearPointWithObject:areaWrapper];
    
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        if (error) {
            [self removeLoader];
            [self showAlertWithTitle:@"Atención" message:error.localizedDescription];
        } else {
            nearTrailsCollection = (GTLMapatonPublicAPINearTrailsCollection*)object;
            if (nearTrailsCollection.items.count == 0) {
                [self removeLoader];
                NSLog(@"0 recorridos");
            }
            for (GTLMapatonPublicAPINearTrails *nearTrails in nearTrailsCollection.items) {
                Trail *trail = [Trail objectForPrimaryKey:@(nearTrails.trailId.longLongValue)];
                NSString *trailName = [NSString stringWithFormat:@"%@ - %@", nearTrails.originName, nearTrails.destinationName];
                [trails addObject:trailName];
                if (trail) {
                    NSArray *points = [NSKeyedUnarchiver unarchiveObjectWithData:trail.points];
                    [self makePolylineWithPoints:points];
                } else {
                    RLMRealm *realm = [RLMRealm defaultRealm];
                    trail = [Trail new];
                    trail.identifier = nearTrails.trailId.longLongValue;
                    trail.name = trailName;
                    [realm beginWriteTransaction];
                    [realm addOrUpdateObject:trail];
                    [realm commitWriteTransaction];
                    [self getPointsForTrail:nearTrails.trailId cursor:nil];
                }
            }
            [trailsTableView reloadData];
        }
    }];
}

- (void)getPointsForTrail:(NSNumber*)trailId cursor:(NSString*)cursor {
    static GTLServiceMapatonPublicAPI *service = nil;
    if (!service) {
        service = [GTLServiceMapatonPublicAPI new];
        service.retryEnabled = YES;
    }
    
    GTLMapatonPublicAPITrailPointsRequestParameter *trailPointsRequestParameter = [GTLMapatonPublicAPITrailPointsRequestParameter new];
    trailPointsRequestParameter.trailId = trailId;
    trailPointsRequestParameter.numberOfElements = [NSNumber numberWithInt:100];
    if (cursor) {
        trailPointsRequestParameter.cursor = cursor;
    }
    
    GTLQueryMapatonPublicAPI *query = [GTLQueryMapatonPublicAPI queryForGetTrailSnappedPointsWithObject:trailPointsRequestParameter];
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        if (error) {
            [self showAlertWithTitle:@"Atención" message:error.localizedDescription];
        } else {
            GTLMapatonPublicAPITrailPointsResult *result = (GTLMapatonPublicAPITrailPointsResult*)object;
            NSUInteger pointsCount = result.points.count;
            Trail *trail = [Trail objectForPrimaryKey:@(trailId.longLongValue)];
            NSMutableArray *points = [NSMutableArray new];
            [points addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:trail.points]];
            if (pointsCount > 0) {
                for (GTLMapatonPublicAPITrailPointWrapper *wrapper in result.points) {
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
    if(!fetcherButton.hidden){
        return;
    }
    CLLocation *centerLocation = [self getCenterLocation];
    float distanceChange = [centerLocation distanceFromLocation:previousCenterLocation]/1000;
    if (distanceChange > 2.5) {
        [fetcherButton setHidden:NO];
    }
}

- (void)prepareFetch {
    float latitudeDelta = map.region.span.latitudeDelta;
    if (latitudeDelta <= 0.0125) {
        [fetcherButton setHidden:YES];
        CLLocation *centerLocation = [self getCenterLocation];
        previousCenterLocation = centerLocation;
        [self clearMapAndTableView];
        [self getTrailsForLocation:centerLocation];
    } else {
        [self showAlertWithTitle:@"" message:@"El área de búsqueda es demasiado amplia, haz zoom para cargar los recorridos de una zona."];
    }
}

- (CLLocation *)getCenterLocation {
    CLLocationCoordinate2D center = map.centerCoordinate;
    CLLocation *centerLocation = [[CLLocation alloc] initWithLatitude:center.latitude longitude:center.longitude];
    return centerLocation;
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

#pragma mark - placeholder
- (void)showLocationPlaceholder {
    placeholderView = [UIView new];
    placeholderView.backgroundColor = [HUColor backgroundColor];
    [self.view addSubview:placeholderView];
    
    UIImage *placeholderImage = [UIImage imageNamed:@"img_pin"];
    UIImageView *placeholderImageView = [[UIImageView alloc] initWithImage:placeholderImage];
    [placeholderView addSubview:placeholderImageView];
    
    UILabel *placeholderLabel = [UILabel new];
    placeholderLabel.text = @"Debes dar acceso a tu ubicación para conocer las rutas cercanas";
    placeholderLabel.textColor = [HUColor textColor];
    placeholderLabel.textAlignment = NSTextAlignmentCenter;
    placeholderLabel.numberOfLines = 0;
    [placeholderView addSubview:placeholderLabel];
    
    UIButton *placeholderButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [placeholderButton setTitle:@"Intenta de nuevo" forState:UIControlStateNormal];
    [placeholderButton setTitleColor:[HUColor accentColor] forState:UIControlStateNormal];
    [placeholderButton addTarget:self action:@selector(tryAgain) forControlEvents:UIControlEventTouchUpInside];
    [placeholderView addSubview:placeholderButton];
    
    [placeholderView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [placeholderImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(placeholderView.mas_centerX);
        make.centerY.equalTo(placeholderView.mas_centerY).offset(-40);
        make.width.equalTo(@160);
        make.height.equalTo(@160);
    }];
    
    [placeholderLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(placeholderImageView.mas_bottom).offset(10);
        make.centerX.equalTo(placeholderView.mas_centerX);
        make.width.equalTo(@260);
        make.height.equalTo(@50);
    }];
    
    [placeholderButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(placeholderLabel.mas_bottom);
        make.centerX.equalTo(placeholderView.mas_centerX);
        make.width.equalTo(@150);
        make.height.equalTo(@30);
    }];
    
}

- (void)tryAgain {
    [self removePlaceholder];
    [self checkLocation];
}

- (void)removePlaceholder {
    if (placeholderView) {
        [placeholderView removeFromSuperview];
        placeholderView = nil;
    }
}

#pragma mark - alerts
- (void)showAlertWithTitle:(NSString*)title message:(NSString*)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
