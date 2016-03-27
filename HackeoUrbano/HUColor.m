//
//  HUColor.m
//  HackeoUrbano
//
//  Created by M on 3/5/16.
//  Copyright © 2016 Krieger. All rights reserved.
//

#import "HUColor.h"

@implementation HUColor

+ (UIColor*)UIColorFromRGB:(NSInteger)rgbValue {
    float r = ((float)((rgbValue & 0xFF0000) >> 16))/255.0;
    float g = ((float)((rgbValue & 0xFF00) >> 8))/255.0;
    float b = ((float)(rgbValue & 0xFF))/255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}

+ (UIColor *)backgroundColor {
    return [self whiteColor];
}

#pragma mark - base

+ (UIColor *)primaryColor {
    return [self UIColorFromRGB:0x80CBC4];
}

+ (UIColor *)secondaryColor {
    return [self UIColorFromRGB:0x26A69A];
}

+ (UIColor *)accentColor {
    return [self UIColorFromRGB:0xEF5350];
}

+ (UIColor *)textColor {
    return [self UIColorFromRGB:0x8E8E8E];
}

+ (UIColor *)titleColor {
    return [self UIColorFromRGB:0x4A4A4A];
}

#pragma mark - menu
+ (UIColor *)menuColor {
    return [self whiteColor];
}

+ (UIColor *)selectedSectionColor {
    return [self primaryColor];
}

+ (UIColor *)selectedSectionTextColor {
    return [self whiteColor];
}

+ (UIColor *)unselectedSectionColor {
    return [self clearColor];
}

+ (UIColor *)unselectedSectionTextColor {
    return [self UIColorFromRGB:0x2f3133];
}

+ (UIColor *)navBarTintColor {
    return [self UIColorFromRGB:0x26A69A];
}

+ (UIColor *)polylineColor {
    return [self UIColorFromRGB:0x26A69A];
}

@end
