//
//  SWMenuViewController.h
//  SideMenu
//
//  Created by M on 1/8/16.
//  Copyright © 2016 M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface SWMenuViewController : UITableViewController

@property (nonatomic) NSArray *sections;
@property (nonatomic) NSArray *sectionIds;
@property (nonatomic) NSArray *selectedImages;
@property (nonatomic) NSArray *unselectedImages;
@property (nonatomic) NSInteger previouslySelectedRow;
@property (nonatomic) UIColor *selectedSectionTextColor;
@property (nonatomic) UIColor *unselectedSectionTextColor;
@property (nonatomic) UIColor *selectedSectionColor;
@property (nonatomic) UIColor *unselectedSectionColor;

@end
