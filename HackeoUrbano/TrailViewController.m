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
}

@end

@implementation TrailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - table views
- (void)addViews {
    NSMutableArray *arrangedSubviews = [NSMutableArray new];
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 20, 10, 20);

    map = [MKMapView new];
    [arrangedSubviews addObject:map];
    
    UIView *originView = [UIView new];
    [arrangedSubviews addObject:originView];
    
    originLabel = [UILabel new];
    originLabel.text = [NSString stringWithFormat:@"Origen: %@", @""];
    [originView addSubview:originLabel];
    
    UIView *destinationView = [UIView new];
    [arrangedSubviews addObject:destinationView];
    
    destinationLabel = [UILabel new];
    destinationLabel.text = [NSString stringWithFormat:@"Destino: %@", @""];
    [destinationView addSubview:destinationLabel];
    
    UIView *transportTypeView = [UIView new];
    [arrangedSubviews addObject:transportTypeView];
    
    transportTypeLabel = [UILabel new];
    transportTypeLabel.text = [NSString stringWithFormat:@"Tipo: %@", @""];
    [transportTypeView addSubview:transportTypeLabel];
    
    UIView *maxTariffView = [UIView new];
    [arrangedSubviews addObject:maxTariffView];
    
    maxTariffLabel = [UILabel new];
    maxTariffLabel.text = [NSString stringWithFormat:@"Tarifa máxima: %@", @""];
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


@end
