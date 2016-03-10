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
    
    MKPolyline *polyline;
}

@end

@implementation TrailViewController
@synthesize trailDetails;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addViews];
    [self getPoints];
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
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.25;
    span.longitudeDelta = 0.25;
    
    MKCoordinateRegion region;
    region.span = span;
    region.center = CLLocationCoordinate2DMake(19.4263367, -99.206531);
    
    [map setRegion:region animated:YES];
    
    UIView *originView = [UIView new];
    [arrangedSubviews addObject:originView];
    
    originLabel = [UILabel new];
    originLabel.text = [NSString stringWithFormat:@"Origen: %@", trailDetails.originStationName];
    [originView addSubview:originLabel];
    
    UIView *destinationView = [UIView new];
    [arrangedSubviews addObject:destinationView];
    
    destinationLabel = [UILabel new];
    destinationLabel.text = [NSString stringWithFormat:@"Destino: %@", trailDetails.destinationStationName];
    [destinationView addSubview:destinationLabel];
    
    UIView *transportTypeView = [UIView new];
    [arrangedSubviews addObject:transportTypeView];
    
    transportTypeLabel = [UILabel new];
    transportTypeLabel.text = [NSString stringWithFormat:@"Tipo: %@", trailDetails.transportType];
    [transportTypeView addSubview:transportTypeLabel];
    
    UIView *maxTariffView = [UIView new];
    [arrangedSubviews addObject:maxTariffView];
    
    maxTariffLabel = [UILabel new];
    maxTariffLabel.text = [NSString stringWithFormat:@"Tarifa máxima: %f", [trailDetails.maxTariff floatValue]];
    [maxTariffView addSubview:maxTariffLabel];
    
    UIView *surveyView = [UIView new];
    [arrangedSubviews addObject:surveyView];
    
    surveyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [surveyButton setTitle:@"Evaluar recorrido" forState:UIControlStateNormal];
    [surveyButton addTarget:self action:@selector(goToSurvey) forControlEvents:UIControlEventTouchUpInside];
    [surveyView addSubview:surveyButton];
    
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
    
    [surveyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(30+20));
    }];
    
    [surveyButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(surveyView).insets(insets);
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
        make.edges.equalTo(self.view);
    }];
    
    [stackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(self.view.mas_width);
    }];
}


- (float)estimateHeightForLabel:(UILabel *)label {
    float height = [label.text boundingRectWithSize:CGSizeMake(screenWidth-2*padding, INT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size.height;
    return height+1;
}

- (void)goToSurvey {
    SurveyViewController *svc = [SurveyViewController new];
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)getPoints {
    static GTLServiceDashboardAPI *service = nil;
    if (!service) {
        service = [GTLServiceDashboardAPI new];
        service.retryEnabled = YES;
    }
    
    GTLDashboardAPITrailPointsRequestParameter *trailPointsRequestParameter = [GTLDashboardAPITrailPointsRequestParameter new];
    trailPointsRequestParameter.trailId = trailDetails.trailId;
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
            
            polyline = [MKPolyline polylineWithCoordinates:coordinates count: [result.points count]];
            [map addOverlay:polyline];
        }
    }];
}

-(MKOverlayRenderer*)mapView:(MKMapView*)mapView rendererForOverlay:(id <MKOverlay>)overlay{
    MKPolylineRenderer* lineView = [[MKPolylineRenderer alloc] initWithPolyline:polyline];
    lineView.strokeColor = [UIColor blueColor];
    lineView.lineWidth = 7;
    return lineView;
}

@end
