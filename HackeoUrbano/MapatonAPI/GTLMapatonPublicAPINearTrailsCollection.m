/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2016 Google Inc.
 */

//
//  GTLMapatonPublicAPINearTrailsCollection.m
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   Mapaton Public API (mapatonPublicAPI/v1)
// Description:
//   This is the public API for mapaton
// Classes:
//   GTLMapatonPublicAPINearTrailsCollection (0 custom class methods, 1 custom properties)

#import "GTLMapatonPublicAPINearTrailsCollection.h"

#import "GTLMapatonPublicAPINearTrails.h"

// ----------------------------------------------------------------------------
//
//   GTLMapatonPublicAPINearTrailsCollection
//

@implementation GTLMapatonPublicAPINearTrailsCollection
@dynamic items;

+ (NSDictionary *)arrayPropertyToClassMap {
  NSDictionary *map = @{
    @"items" : [GTLMapatonPublicAPINearTrails class]
  };
  return map;
}

@end