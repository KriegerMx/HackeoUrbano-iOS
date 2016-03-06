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
    NSMutableArray *arrangedSubviews;

    map = [MKMapView new];
    [arrangedSubviews addObject:map];
    
    originLabel = [UILabel new];
    [arrangedSubviews addObject:originLabel];
    
    destinationLabel = [UILabel new];
    [arrangedSubviews addObject:destinationLabel];
    
    transportTypeLabel = [UILabel new];
    [arrangedSubviews addObject:transportTypeLabel];
    
    maxTariffLabel = [UILabel new];
    [arrangedSubviews addObject:maxTariffLabel];
    
    UIView *v = [UIView new];
    v.backgroundColor = [UIColor blackColor];
    [arrangedSubviews addObject:v];
    
//    photoImageView = [UIImageView new];
//    [arrangedSubviews addObject:photoImageView];
    
    [map mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@100);
    }];
    
    [originLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([self estimateHeightForLabel:originLabel]));
    }];
    
    [destinationLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([self estimateHeightForLabel:destinationLabel]));
    }];
    
    [transportTypeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([self estimateHeightForLabel:transportTypeLabel]));
    }];
    
    [maxTariffLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([self estimateHeightForLabel:maxTariffLabel]));
    }];
    
    [v mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@200);
    }];
    
//    [photoImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@100);
//    }];
    
    UIStackView *stackView = [[UIStackView alloc]initWithArrangedSubviews:arrangedSubviews];
    [stackView setTranslatesAutoresizingMaskIntoConstraints:NO];
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = 10.0;
    [self.view addSubview:stackView];
    
    UIScrollView *scrollView = [UIScrollView new];
    
    [scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.height.equalTo(stackView);
    }];
    
    [stackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.width.equalTo(self.view.mas_width);
    }];
}


- (float)estimateHeightForLabel:(UILabel *)label {
    float height = [label.text boundingRectWithSize:CGSizeMake(screenWidth-2*padding, INT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size.height;
    return height+1;
}


@end
