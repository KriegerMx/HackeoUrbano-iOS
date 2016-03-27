//
//  HUColor.h
//  HackeoUrbano
//
//  Created by M on 3/5/16.
//  Copyright © 2016 Krieger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HUColor : UIColor

//base
+ (UIColor *)primaryColor;
+ (UIColor *)secondaryColor;
+ (UIColor *)accentColor;
+ (UIColor *)backgroundColor;
+ (UIColor *)textColor;
+ (UIColor *)titleColor;

//menu
+ (UIColor *)menuColor;
+ (UIColor *)selectedSectionColor;
+ (UIColor *)selectedSectionTextColor;
+ (UIColor *)unselectedSectionColor;
+ (UIColor *)unselectedSectionTextColor;

//nav bar
+ (UIColor *)navBarTintColor;

//map
+ (UIColor *)polylineColor;


@end
