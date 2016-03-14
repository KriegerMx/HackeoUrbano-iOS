//
//  RankingTrailCell.m
//  HackeoUrbano
//
//  Created by M on 3/14/16.
//  Copyright © 2016 Krieger. All rights reserved.
//

#import "RankingTrailCell.h"

@implementation RankingTrailCell
@synthesize trailNameLabel, ratingView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        trailNameLabel = [UILabel new];
        trailNameLabel.numberOfLines = 0;
        trailNameLabel.textColor = [HUColor textColor];
        [self addSubview:trailNameLabel];
        
        ratingView = [HCSStarRatingView new];
        ratingView.maximumValue = 5;
        ratingView.minimumValue = 0;
        ratingView.value = 0;
        ratingView.tintColor = [HUColor secondaryColor];
        ratingView.userInteractionEnabled = NO;
        [self addSubview:ratingView];
        
        [self updateConstraintsIfNeeded];
    }
    return self;
}

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) updateConstraints{
    [super updateConstraints];
    
    [trailNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
        make.bottom.equalTo(ratingView.mas_top).offset(-10);
    }];
    
    
    [ratingView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(trailNameLabel.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.height.lessThanOrEqualTo(@20);
    }];
}

@end
