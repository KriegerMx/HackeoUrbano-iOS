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
    svc.trailId = trailDetails.trailId;
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
            
            MKCoordinateSpan span;
            span.latitudeDelta = 0.05;
            span.longitudeDelta = 0.05;
            
            MKCoordinateRegion region;
            region.span = span;
            region.center = polyline.coordinate;
            
            [map setRegion:region animated:YES];
        }
    }];
}

-(MKOverlayRenderer*)mapView:(MKMapView*)mapView rendererForOverlay:(id <MKOverlay>)overlay{
    MKPolylineRenderer* lineView = [[MKPolylineRenderer alloc] initWithPolyline:polyline];
    lineView.strokeColor = [HUColor polylineColor];
    lineView.lineWidth = 4;
    return lineView;
}

@end
