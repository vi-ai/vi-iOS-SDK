//
//  VIAdManager.h
//  VISDK
//
//  Created by Nikita Levintsov on 3/7/17.
//  Copyright © 2017 Nikita Levintsov. All rights reserved.
//

#ifndef VIAD_H
#define VIAD_H

#import <Foundation/Foundation.h>

@class VIAdEvent, VIMediator;

@protocol VIAdDelegate;

/**
 Common interface to rule process of displaying ad
*/
@protocol VIAd <NSObject>

@property (nullable, nonatomic, weak) id<VIAdDelegate> delegate;

@property (nonatomic, assign, readonly) BOOL cacheMediaContent;

// YES if ad is ready to display
@property (nonatomic, assign, readonly) BOOL isReady;

@property (nonatomic, assign, readonly) BOOL isLoading;

@property (nonatomic, assign, readonly) BOOL isPaused;

@property (nonatomic, assign, readonly) BOOL isPlaying;

/**
    Load ad for specified placement.
    Performs async network request in background.
    Listn for delegate method 'adDidReceiveEvent:VIAdEventLoaded' in case of success and 'adDidReceiveError:' for fail.
    Both will be fired on the main queue.
*/
- (void)load;

/**
    Stops playing all the ads.
    All VISDK views will be removed from the provided container.
    Delegate will be notified with 'VIAdEventClosed'
*/
- (void)close;

@optional

- (void)registerMediations:(NSArray <VIMediator*>* _Nonnull)mediations;
- (void)registerMediation:(VIMediator* _Nonnull)mediation;
- (void)clearMediators;

@end

/**
 Callbacks on video display events
*/
@protocol VIAdDelegate <NSObject>

@optional

/**
 Notifies about any error occured during loading and displaying ad
 @param error with domain 'VISDKErrorDomain'
*/
- (void)adDidReceiveError:(nonnull NSError *)error;

/**
 Notifies delegate about change of current state in ad lifecycle
 @param event see event.type enum for description
*/
- (void)adDidReceiveEvent:(nonnull VIAdEvent *)event;

@end

/**
 Interface to display native video ad
*/
@protocol VIVideoAd <VIAd>

/**
 If YES ad will be started automatically when it become ready.
 @default is NO
*/
@property (nonatomic, assign) BOOL startsWhenReady;

/**
    Initiate playing ad.
    Call 'start' after receiving 'VIAdEventLoaded' event.
    If ad displaying is in progress all calls of 'start' will be ignored.
    VISDK will create own view and place it above the container provided in 'createVideoAdFor: inContainer:' by adding as a subview.
    Nature of the ad depends on server response for specific placement. Only native video ads are currently supported.
    Expect 'VIAdEventStarted' right after ad has run.
    All possible playback errors will be passed in 'adDidReceiveError:'
    After ad display finish delegate will be notified with 'VIAdEventCompleted'
*/
- (void)start;

/**
 Pause video playback
*/
- (void)pause;

/**
 Resume video playback
*/
- (void)resume;

@end

/**
 Interface to display interstitial ad
*/
@protocol VIInterstitialAd <VIAd>

/**
 If isReady == YES, ad will be presented. Otherwise this call will be ignored.
 @param aViewController from which ad will be presented modally
*/
- (void)showFromViewController:(nonnull UIViewController *)aViewController;

@end

#endif
