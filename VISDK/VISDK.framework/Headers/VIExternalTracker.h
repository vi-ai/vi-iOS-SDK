//
//  VIExternalTracker.h
//  VISDK
//
//  Created by Maksym Kravchenko on 12/26/17.
//  Copyright © 2017 Vitalii Cherepakha. All rights reserved.
//

#ifndef VIExternalTracker_H
#define VIExternalTracker_H


#import <Foundation/Foundation.h>

/**
 Provides functional for tracking events with castom service.
 */
@interface VIExternalTracker : NSObject

/**
 Set property to YES after correct initialization of Tracker.
 If NO - tracker won't be registered.
 */
@property (nonatomic, assign, readonly) BOOL isValid;

- (void)adStart:(nonnull NSString *)placementId;
- (void)adComplete:(nonnull NSString *)placementId;
- (void)adPaused:(nonnull NSString *)placementId;
- (void)adResumed:(nonnull NSString *)placementId;
- (void)adSkiped:(nonnull NSString *)placementId;
- (void)adError:(nonnull NSString *)placementId;
- (void)adClicked:(nonnull NSString *)placementId;
- (void)adVolumeChanged:(nonnull NSString *)placementId isMute:(BOOL)isMute;

- (nullable instancetype)init;

@end

#endif
