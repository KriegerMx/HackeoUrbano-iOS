//
//  TrailViewController.m
//  HackeoUrbano
//
//  Created by M on 3/6/16.
//  Copyright © 2016 Krieger. All rights reserved.
//

#import "TrailViewController.h"

#define padding 20.0
#define screenWidth  [[UIScreen mainScreen] bounds].size.width

@interface TrailViewController () {
    MKMapView *map;
    UILabel *originLabel;
    UILabel *destinationLabel;
    UILabel *transportTypeLabel;
    UILabel *maxTariffLabel;
    UIImageView *photoImageView;
    UIButton *surveyButton;
    HCSStarRatingView *ratingView;
    MKPolyline *polyline;
}

@end

@implementation TrailViewController
@synthesize trailDetails, trailId, rating;

- (void)viewDidLoad {
    [super viewDidLoad];
    if (trailDetails) {
        trailId = trailDetails.trailId;
        [self addViews];
        [self getPoints];
    } else {
        [self getTrailDetails];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)addViews {
    NSMutableArray *arrangedSubviews = [NSMutableArray new];
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 20, 10, 20);

    map = [MKMapView new];
    map.delegate = self;
    [arrangedSubviews addObject:map];
    
    UIView *originView = [UIView new];
    [arrangedSubviews addObject:originView];
    
    originLabel = [UILabel new];
    originLabel.text = [NSString stringWithFormat:@"Origen: %@", trailDetails.originStationName];
    originLabel.textColor = [HUColor textColor];
    originLabel.numberOfLines = 0;
    [originView addSubview:originLabel];
    
    UIView *destinationView = [UIView new];
    [arrangedSubviews addObject:destinationView];
    
    destinationLabel = [UILabel new];
    destinationLabel.text = [NSString stringWithFormat:@"Destino: %@", trailDetails.destinationStationName];
    destinationLabel.textColor = [HUColor textColor];
    destinationLabel.numberOfLines = 0;
    [destinationView addSubview:destinationLabel];
    
    UIView *transportTypeView = [UIView new];
    [arrangedSubviews addObject:transportTypeView];
    
    transportTypeLabel = [UILabel new];
    transportTypeLabel.text = [NSString stringWithFormat:@"Tipo: %@", trailDetails.transportType];
    transportTypeLabel.textColor = [HUColor textColor];
    transportTypeLabel.numberOfLines = 0;
    [transportTypeView addSubview:transportTypeLabel];
    
    UIView *maxTariffView = [UIView new];
    [arrangedSubviews addObject:maxTariffView];
    
    maxTariffLabel = [UILabel new];
    maxTariffLabel.text = [NSString stringWithFormat:@"Tarifa máxima: $%f", [trailDetails.maxTariff floatValue]];
    maxTariffLabel.textColor = [HUColor textColor];
    maxTariffLabel.numberOfLines = 0;
    [maxTariffView addSubview:maxTariffLabel];
    
    UIView *ratingBackground = [UIView new];
    [arrangedSubviews addObject:ratingBackground];
    
    UILabel *ratingLabel = [UILabel new];
    ratingLabel.text = @"Calificación:";
    ratingLabel.textColor = [HUColor textColor];
    [ratingBackground addSubview:ratingLabel];
    
    ratingView = [HCSStarRatingView new];
    ratingView.maximumValue = 5;
    ratingView.minimumValue = 0;
    ratingView.tintColor = [HUColor secondaryColor];
    ratingView.userInteractionEnabled = NO;
    [ratingBackground addSubview:ratingView];
    
    if (rating) {
        ratingView.value = [rating floatValue];
    } else {
        [self getRating];
    }
    
    [map mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@150);
    }];
    
    [originView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([self estimateHeightForLabel:originLabel]+20));
    }];
    
    [originLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(originView).insets(insets);
    }];
    
    [destinationView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([self estimateHeightForLabel:destinationLabel]+20));
    }];
    
    [destinationLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(destinationView).insets(insets);
    }];
    
    [transportTypeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([self estimateHeightForLabel:transportTypeLabel]+20));
    }];
    
    [transportTypeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(transportTypeView).insets(insets);
    }];
    
    [maxTariffView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([self estimateHeightForLabel:maxTariffLabel]+20));
    }];
    
    [maxTariffLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(maxTariffView).insets(insets);
    }];
    
    [ratingBackground mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@80);
    }];
    
    [ratingLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ratingBackground.mas_top);
        make.left.equalTo(ratingBackground.mas_left).offset(20);
        make.right.equalTo(ratingBackground.mas_right).offset(-20);
        make.bottom.equalTo(ratingView.mas_top).offset(-10);
    }];
    
    [ratingView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ratingLabel.mas_bottom).offset(10);
        make.left.equalTo(ratingBackground.mas_left).offset(20);
        make.right.equalTo(ratingBackground.mas_right).offset(-20);
        make.bottom.equalTo(ratingBackground.mas_bottom);
        make.height.equalTo(@30);
    }];
    
    UIScrollView *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    
    UIStackView *stackView = [[UIStackView alloc]initWithArrangedSubviews:arrangedSubviews];
    [stackView setTranslatesAutoresizingMaskIntoConstraints:NO];
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = 10.0;
    [scrollView addSubview:stackView];
    
    [scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 50, 0);
        make.edges.equalTo(self.view).insets(insets);
    }];
    
    [stackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(self.view.mas_width);
    }];
    
    surveyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [surveyButton setTitle:@"Evaluar recorrido" forState:UIControlStateNormal];
    [surveyButton setBackgroundColor:[HUColor secondaryColor]];
    [surveyButton setTitleColor:[HUColor whiteColor] forState:UIControlStateNormal];
    [surveyButton addTarget:self action:@selector(goToSurvey) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:surveyButton];
    
    [surveyButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (float)estimateHeightForLabel:(UILabel *)label {
    float height = [label.text boundingRectWithSize:CGSizeMake(screenWidth-2*padding, INT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size.height;
    return height+1;
}

- (void)goToSurvey {
    SurveyViewController *svc = [SurveyViewController new];
    svc.trailId = trailId;
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)getPoints {
    Trail *trail = [Trail objectForPrimaryKey:@(trailId.longLongValue)];
    if (trail) {
        NSArray *points = [NSKeyedUnarchiver unarchiveObjectWithData:trail.points];
        [self makePolylineWithPoints:points];
    } else {
        NSString *trailName = [NSString stringWithFormat:@"%@ - %@", trailDetails.originStationName, trailDetails.destinationStationName];
        RLMRealm *realm = [RLMRealm defaultRealm];
        trail = [Trail new];
        trail.identifier = trailId.longLongValue;
        trail.name = trailName;
        [realm beginWriteTransaction];
        [realm addOrUpdateObject:trail];
        [realm commitWriteTransaction];
        [self getPointsForCursor:nil];
    }
}

- (void)getPointsForCursor:(NSString*)cursor {
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
            NSLog(@"error: %@", error);
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
                    [self getPointsForCursor:result.cursor];
                } else {
                    [self makePolylineWithPoints:points];
                }
            } else {
                [self makePolylineWithPoints:points];
            }
        }
    }];
}

- (void)getTrailDetails {
    static GTLServiceMapatonPublicAPI *service = nil;
    if (!service) {
        service = [GTLServiceMapatonPublicAPI new];
        service.retryEnabled = YES;
    }
    
    GTLQueryMapatonPublicAPI *query = [GTLQueryMapatonPublicAPI queryForGetTrailDetailsWithTrailId:[trailId longLongValue]];
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        if (error) {
            NSLog(@"error: %@", error);
        } else {
            trailDetails = (GTLMapatonPublicAPITrailDetails*)object;
            [self addViews];
            [self getPoints];
        }
    }];
}

- (void)getRating {
    static GTLServiceHackeoUrbanoAPI *service = nil;
    if (!service) {
        service = [GTLServiceHackeoUrbanoAPI new];
        service.retryEnabled = YES;
    }
    
    GTLQueryHackeoUrbanoAPI *query = [GTLQueryHackeoUrbanoAPI queryForGetStatsWithTrailId:[trailId longLongValue]];
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        if (error) {
            NSLog(@"error: %@", error);
        } else {
            GTLHackeoUrbanoAPIRouteStatsWrapper *wrapper = (GTLHackeoUrbanoAPIRouteStatsWrapper*)object;
            rating = wrapper.rating;
            ratingView.value = [rating floatValue];
        }
    }];
}

- (void)makePolylineWithPoints:(NSArray*)points {
    CLLocationCoordinate2D coordinates[[points count]];
    int i = 0;
    for (NSDictionary *dic in points) {
        coordinates[i] = CLLocationCoordinate2DMake([[dic objectForKey:@"latitude"] floatValue], [[dic objectForKey:@"longitude"] floatValue]);
        i++;
    }
    polyline = [MKPolyline polylineWithCoordinates:coordinates count:[points count]];
    [map addOverlay:polyline];
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;
    
    MKCoordinateRegion region;
    region.span = span;
    region.center = polyline.coordinate;
    
    [map setRegion:region animated:YES];
}

-(MKOverlayRenderer*)mapView:(MKMapView*)mapView rendererForOverlay:(id <MKOverlay>)overlay{
    MKPolylineRenderer* lineView = [[MKPolylineRenderer alloc] initWithPolyline:polyline];
    lineView.strokeColor = [HUColor polylineColor];
    lineView.lineWidth = 4;
    return lineView;
}

@end
