//
//  CountlyExternalTracker.h
//  CountlyExternalTracker
//
//  Created by Maksym Kravchenko on 12/27/17.
//  Copyright © 2017 Maksym Kravchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VISDK/VIExternalTracker.h>

static NSString * _Nonnull const countlyDebugAppKey = @"2ba378414a92f61179e5df6b69e5b66fce912f3d";
static NSString * _Nonnull const countlyDebugHostKey = @"https://try.count.ly/";

@interface CountlyExternalTracker : VIExternalTracker

//! If not set returns @"VISDK";
@property (nonatomic, copy, nonnull) NSString *eventId;

- (nullable instancetype)initWithAppKey:(nonnull NSString *)appKey host:(nonnull NSString *)host NS_DESIGNATED_INITIALIZER;

@end
