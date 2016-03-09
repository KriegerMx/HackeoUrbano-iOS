/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2016 Google Inc.
 */

//
//  GTLDashboardAPIAreaWrapper.h
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   Dashboard API (dashboardAPI/v1)
// Description:
//   This API exposes the services required by the mapaton dashboard of mapaton
// Classes:
//   GTLDashboardAPIAreaWrapper (0 custom class methods, 2 custom properties)

#if GTL_BUILT_AS_FRAMEWORK
  #import "GTL/GTLObject.h"
#else
  #import "GTLObject.h"
#endif

@class GTLDashboardAPIGPSLocation;

// ----------------------------------------------------------------------------
//
//   GTLDashboardAPIAreaWrapper
//

@interface GTLDashboardAPIAreaWrapper : GTLObject
@property (retain) GTLDashboardAPIGPSLocation *northEastCorner;
@property (retain) GTLDashboardAPIGPSLocation *southWestCorner;
@end