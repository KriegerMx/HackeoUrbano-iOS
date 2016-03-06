//
//  SWFrontViewController.m
//  SideMenu
//
//  Created by M on 1/8/16.
//  Copyright © 2016 M. All rights reserved.
//

#import "SWFrontViewController.h"

@interface SWFrontViewController ()

@end

@implementation SWFrontViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sideMenuSetup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)sideMenuSetup {
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController){
        UIImage *menuImage = [UIImage imageNamed:@"btn_menu"];
        UIBarButtonItem *sideMenuButton = [[UIBarButtonItem alloc] initWithImage:menuImage style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];
        self.navigationItem.leftBarButtonItem = sideMenuButton;
        [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:revealViewController.tapGestureRecognizer];
    }
}

@end
