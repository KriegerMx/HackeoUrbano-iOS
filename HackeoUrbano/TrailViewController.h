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
#import "GTLServiceDashboardAPI.h"
#import "GTLDashboardAPIAreaWrapper.h"
#import "GTLDashboardAPIGPSLocation.h"
#import "GTLQueryDashboardAPI.h"
#import "GTLDashboardAPITrailDetailsCollection.h"
#import "GTLDashboardAPITrailDetails.h"
#import "GTLDashboardAPITrailPointsRequestParameter.h"
#import "GTLDashboardAPITrailPointsResult.h"
#import "GTLDashboardAPITrailPointWrapper.h"
#import "HUColor.h"

@interface TrailViewController : UIViewController <MKMapViewDelegate>

@property (copy) GTLDashboardAPITrailDetails *trailDetails;
@property (copy) NSNumber *trailId;

@end
