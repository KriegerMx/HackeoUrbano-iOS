/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2016 Google Inc.
 */

//
//  GTLDashboardAPITrailPointsRequestParameter.h
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   Dashboard API (dashboardAPI/v1)
// Description:
//   This API exposes the services required by the mapaton dashboard of mapaton
// Classes:
//   GTLDashboardAPITrailPointsRequestParameter (0 custom class methods, 3 custom properties)

#if GTL_BUILT_AS_FRAMEWORK
  #import "GTL/GTLObject.h"
#else
  #import "GTLObject.h"
#endif

// ----------------------------------------------------------------------------
//
//   GTLDashboardAPITrailPointsRequestParameter
//

@interface GTLDashboardAPITrailPointsRequestParameter : GTLObject
@property (copy) NSString *cursor;
@property (retain) NSNumber *numberOfElements;  // intValue
@property (retain) NSNumber *trailId;  // longLongValue
@end
