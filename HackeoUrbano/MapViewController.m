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
    
    NSMutableArray *trails;
    GTLDashboardAPITrailDetailsCollection *trailDetailsCollection;
}

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLocationManager];
    [self addViews];
    [self setTableView];

    trails = [NSMutableArray new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - location
- (void)askForLocationPermission {
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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [locationManager stopUpdatingLocation];
    locationManager = nil;
    CLLocation *userLocation = locations[0];
    [self getTrailsForLocation:userLocation];
    [self adjustMapToLocation:userLocation];
}

- (void)adjustMapToLocation:(CLLocation*)location {
    MKCoordinateSpan span;
    span.latitudeDelta = delta*4;
    span.longitudeDelta = delta*4;
    
    MKCoordinateRegion region;
    region.span = span;
    region.center = location.coordinate;
    
    [map setRegion:region animated:YES];
}


#pragma mark - table views
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

#pragma mark - tableView
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

#pragma mark - Table view data source
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TrailViewController *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"trailVC"];
    tvc.trailDetails = trailDetailsCollection[indexPath.row];
    [self.navigationController pushViewController:tvc animated:YES];
}

#pragma mark - table view
- (void)getTrailsForLocation:(CLLocation*)location {
    static GTLServiceDashboardAPI *service = nil;
    if (!service) {
        service = [GTLServiceDashboardAPI new];
        service.retryEnabled = YES;
    }
    
    GTLDashboardAPIGPSLocation *northEastCorner = [GTLDashboardAPIGPSLocation new];
    northEastCorner.latitude = [NSNumber numberWithFloat:location.coordinate.latitude + delta/2];
    northEastCorner.longitude = [NSNumber numberWithFloat:location.coordinate.longitude + delta/2];
    
    GTLDashboardAPIGPSLocation *southWestCorner = [GTLDashboardAPIGPSLocation new];
    southWestCorner.latitude = [NSNumber numberWithFloat:location.coordinate.latitude - delta/2];
    southWestCorner.longitude = [NSNumber numberWithFloat:location.coordinate.longitude - delta/2];
    
    GTLDashboardAPIAreaWrapper *areaWrapper = [GTLDashboardAPIAreaWrapper new];
    areaWrapper.northEastCorner = northEastCorner;
    areaWrapper.southWestCorner = southWestCorner;
    
    GTLQueryDashboardAPI *query = [GTLQueryDashboardAPI queryForTrailsNearPointWithObject:areaWrapper];
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        if (error) {
            NSLog(@"error: %@", error);
        } else {
            trailDetailsCollection = (GTLDashboardAPITrailDetailsCollection*)object;
            NSLog(@"%lu", (unsigned long)trailDetailsCollection.items.count);
            for (GTLDashboardAPITrailDetails *trailDetails in trailDetailsCollection.items) {
                NSString *trailName = [NSString stringWithFormat:@"%@ - %@", trailDetails.originStationName, trailDetails.destinationStationName];
                [trails addObject:trailName];
                [self getPointsForTrail:trailDetails.trailId];
            }
            [trailsTableView reloadData];
        }
    }];
}

- (void)getPointsForTrail:(NSNumber*)trailId {
    static GTLServiceDashboardAPI *service = nil;
    if (!service) {
        service = [GTLServiceDashboardAPI new];
        service.retryEnabled = YES;
    }
    
    GTLDashboardAPITrailPointsRequestParameter *trailPointsRequestParameter = [GTLDashboardAPITrailPointsRequestParameter new];
    trailPointsRequestParameter.trailId = trailId;
    trailPointsRequestParameter.numberOfElements = [NSNumber numberWithInt:100];
    
    GTLQueryDashboardAPI *query = [GTLQueryDashboardAPI queryForGetTrailSnappedPointsWithObject:trailPointsRequestParameter];
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        if (error) {
            NSLog(@"error: %@", error);
        } else {
            GTLDashboardAPITrailPointsResult *result = (GTLDashboardAPITrailPointsResult*)object;
            NSLog(@"finisshed");
            
            CLLocationCoordinate2D coordinates[[result.points count]];
            
            int i = 0;
            for (GTLDashboardAPITrailPointWrapper *trailPointWrapper in result.points) {
                GTLDashboardAPIGPSLocation *location = trailPointWrapper.location;
                coordinates[i] = CLLocationCoordinate2DMake([location.latitude floatValue], [location.longitude floatValue]);
                i++;
            }
            
            MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coordinates count: [result.points count]];
            [map addOverlay:polyline];
        }
    }];
}

-(MKOverlayRenderer*)mapView:(MKMapView*)mapView rendererForOverlay:(id <MKOverlay>)overlay{
    static int i = 0;

    float hue = arc4random()%360/360.0;
    float sat = arc4random()%100/100.0;
    float bri = arc4random()%100/100.0;
    
    NSLog(@"%f, %f, %f", hue, sat, bri);
    
    UIColor *lineColor = [HUColor colorWithHue:hue saturation:sat brightness:bri alpha:1.0];
    
    MKPolylineRenderer* lineView = [[MKPolylineRenderer alloc] initWithPolyline:(MKPolyline*)overlay];
    lineView.strokeColor = lineColor;
    lineView.lineWidth = 7;
    return lineView;
}


@end
