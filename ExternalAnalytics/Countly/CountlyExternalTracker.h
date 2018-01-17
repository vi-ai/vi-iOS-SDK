//
//  CountlyExternalTracker.h
//  CountlyExternalTracker
//
//  Created by Maksym Kravchenko on 12/27/17.
//  Copyright © 2017 Maksym Kravchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VISDK/VIExternalTracker.h>


@interface CountlyExternalTracker : VIExternalTracker

//! If not set returns @"VISDK";
@property (nonatomic, copy, nonnull) NSString *eventId;

@end
