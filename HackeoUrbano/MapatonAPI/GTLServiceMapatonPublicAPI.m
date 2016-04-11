/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2016 Google Inc.
 */

//
//  GTLServiceMapatonPublicAPI.m
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   Mapaton Public API (mapatonPublicAPI/v1)
// Description:
//   This is the public API for mapaton
// Classes:
//   GTLServiceMapatonPublicAPI (0 custom class methods, 0 custom properties)

#import "GTLMapatonPublicAPI.h"

@implementation GTLServiceMapatonPublicAPI

#if DEBUG
// Method compiled in debug builds just to check that all the needed support
// classes are present at link time.
+ (NSArray *)checkClasses {
  NSArray *classes = @[
    [GTLQueryMapatonPublicAPI class],
    [GTLMapatonPublicAPIAreaWrapper class],
    [GTLMapatonPublicAPICursorParameter class],
    [GTLMapatonPublicAPIDate class],
    [GTLMapatonPublicAPIGPSLocation class],
    [GTLMapatonPublicAPINearTrails class],
    [GTLMapatonPublicAPINearTrailsCollection class],
    [GTLMapatonPublicAPISearchByKeywordParameter class],
    [GTLMapatonPublicAPITime class],
    [GTLMapatonPublicAPITimeStamp class],
    [GTLMapatonPublicAPITrailDetails class],
    [GTLMapatonPublicAPITrailDetailsCollection class],
    [GTLMapatonPublicAPITrailListResponse class],
    [GTLMapatonPublicAPITrailPointsRequestParameter class],
    [GTLMapatonPublicAPITrailPointsResult class],
    [GTLMapatonPublicAPITrailPointWrapper class]
  ];
  return classes;
}
#endif  // DEBUG

- (instancetype)init {
  self = [super init];
  if (self) {
    // Version from discovery.
    self.apiVersion = @"v1";

    // From discovery.  Where to send JSON-RPC.
    // Turn off prettyPrint for this service to save bandwidth (especially on
    // mobile). The fetcher logging will pretty print.
    self.rpcURL = [NSURL URLWithString:@"https://public-api-dot-mapaton-public.appspot.com/_ah/api/rpc?prettyPrint=false"];
  }
  return self;
}

@end
