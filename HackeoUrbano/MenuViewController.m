//
//  MenuViewController.m
//  HackeoUrbano
//
//  Created by M on 3/5/16.
//  Copyright © 2016 Krieger. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize bannerBackground;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setMenu];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.tableView setScrollEnabled:NO];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - settings

- (void)setMenu {
    [self setSections:@[@"Recorridos", @"Clasificación", @"Acerca de"]];
    [self setSectionIds:@[@"NavigationControllerRoutes", @"NavigationControllerRank", @"NavigationControllerAbout"]];
    [self setImages];
    [self setColors];
    [self setBanner];
}

- (void)setImages {
    [self setSelectedImages:@[@"menu_1_selected",@"menu_2_selected",@"menu_3_selected"]];
    [self setUnselectedImages:@[@"menu_1_unselected",@"menu_2_unselected",@"menu_3_unselected"]];
}

- (void)setColors {
    [self setSelectedSectionColor:[HUColor selectedSectionColor]];
    [self setUnselectedSectionColor:[HUColor unselectedSectionColor]];
    [self setSelectedSectionTextColor:[HUColor selectedSectionTextColor]];
    [self setUnselectedSectionTextColor:[HUColor unselectedSectionTextColor]];
}

- (void)setBanner {
    float revealWidth = self.revealViewController.rearViewRevealWidth;
    float width = self.view.frame.size.width;
    float offset = (width - revealWidth)/2;
    UIImageView *banner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner"]];
    [bannerBackground addSubview:banner];
    [banner mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(-offset);
        make.centerY.equalTo(bannerBackground.mas_centerY).offset(10);
        make.width.equalTo(@240);
        make.height.equalTo(@91);
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end
