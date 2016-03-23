//
//  Trail.h
//  HackeoUrbano
//
//  Created by M on 3/18/16.
//  Copyright © 2016 Krieger. All rights reserved.
//

#import <Realm/Realm.h>

@interface Trail : RLMObject

@property long long identifier;
@property NSData *points;
@property NSString *name;

@end

RLM_ARRAY_TYPE(Trail)
