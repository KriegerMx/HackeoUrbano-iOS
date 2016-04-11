/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2016 Google Inc.
 */

//
//  GTLMapatonPublicAPINearTrails.h
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   Mapaton Public API (mapatonPublicAPI/v1)
// Description:
//   This is the public API for mapaton
// Classes:
//   GTLMapatonPublicAPINearTrails (0 custom class methods, 4 custom properties)

#if GTL_BUILT_AS_FRAMEWORK
  #import "GTL/GTLObject.h"
#else
  #import "GTLObject.h"
#endif

// ----------------------------------------------------------------------------
//
//   GTLMapatonPublicAPINearTrails
//

@interface GTLMapatonPublicAPINearTrails : GTLObject
@property (nonatomic, copy) NSString *branchName;
@property (nonatomic, copy) NSString *destinationName;
@property (nonatomic, copy) NSString *originName;
@property (nonatomic, retain) NSNumber *trailId;  // longLongValue
@end
