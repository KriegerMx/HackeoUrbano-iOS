/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2016 Google Inc.
 */

//
//  GTLDashboardAPITrailPointsResult.m
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   Dashboard API (dashboardAPI/v1)
// Description:
//   This API exposes the services required by the mapaton dashboard of mapaton
// Classes:
//   GTLDashboardAPITrailPointsResult (0 custom class methods, 2 custom properties)

#import "GTLDashboardAPITrailPointsResult.h"

#import "GTLDashboardAPITrailPointWrapper.h"

// ----------------------------------------------------------------------------
//
//   GTLDashboardAPITrailPointsResult
//

@implementation GTLDashboardAPITrailPointsResult
@dynamic cursor, points;

+ (NSDictionary *)arrayPropertyToClassMap {
  NSDictionary *map = @{
    @"points" : [GTLDashboardAPITrailPointWrapper class]
  };
  return map;
}

@end
