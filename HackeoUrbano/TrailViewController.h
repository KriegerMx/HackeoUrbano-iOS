//
//  TrailViewController.h
//  HackeoUrbano
//
//  Created by M on 3/6/16.
//  Copyright © 2016 Krieger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Masonry.h"
#import "SurveyViewController.h"
#import "GTLMapatonPublicAPI.h"
#import "GTLHackeoUrbanoAPI.h"
#import "HUColor.h"
#import "HCSStarRatingView.h"
#import "Trail.h"

@interface TrailViewController : UIViewController <MKMapViewDelegate>

@property (copy) GTLMapatonPublicAPITrailDetails *trailDetails;
@property (copy) NSNumber *trailId;
@property (copy) NSNumber *rating;

@end
