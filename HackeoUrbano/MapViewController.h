//
//  MapViewController.h
//  HackeoUrbano
//
//  Created by Marlon Vargas Contreras on 5/3/16.
//  Copyright © 2016 Krieger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import <MapKit/MapKit.h>
#import "HUColor.h"
#import "SWFrontViewController.h"
#import "TrailViewController.h"
#import "GTLServiceDashboardAPI.h"
#import "GTLDashboardAPIAreaWrapper.h"
#import "GTLDashboardAPIGPSLocation.h"
#import "GTLQueryDashboardAPI.h"
#import "GTLDashboardAPITrailDetailsCollection.h"
#import "GTLDashboardAPITrailDetails.h"

@interface MapViewController : SWFrontViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@end
