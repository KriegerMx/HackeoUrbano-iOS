/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2016 Google Inc.
 */

//
//  GTLDashboardAPITrailPointWrapper.h
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   Dashboard API (dashboardAPI/v1)
// Description:
//   This API exposes the services required by the mapaton dashboard of mapaton
// Classes:
//   GTLDashboardAPITrailPointWrapper (0 custom class methods, 3 custom properties)

#if GTL_BUILT_AS_FRAMEWORK
  #import "GTL/GTLObject.h"
#else
  #import "GTLObject.h"
#endif

@class GTLDashboardAPIGPSLocation;
@class GTLDashboardAPITimeStamp;

// ----------------------------------------------------------------------------
//
//   GTLDashboardAPITrailPointWrapper
//

@interface GTLDashboardAPITrailPointWrapper : GTLObject
@property (nonatomic, retain) GTLDashboardAPIGPSLocation *location;
@property (nonatomic, retain) NSNumber *position;  // intValue
@property (nonatomic, retain) GTLDashboardAPITimeStamp *timeStamp;
@end
