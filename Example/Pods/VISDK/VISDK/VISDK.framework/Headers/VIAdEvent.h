//
//  VIAdEvent.h
//  VISDK
//
//  Created by Nikita Levintsov on 5/15/17.
//  Copyright © 2017 Nikita Levintsov. All rights reserved.
//

#ifndef VIAdEvent_h
#define VIAdEvent_h


#import <Foundation/Foundation.h>
#import "VIEnums.h"

/**
 Wraps event type enum for further extensibility
*/
@interface VIAdEvent : NSObject

@property (nonatomic, assign, readonly) VIAdEventType type;

@end

#endif
