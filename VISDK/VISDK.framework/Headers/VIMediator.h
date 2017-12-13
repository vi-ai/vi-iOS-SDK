//
//  VIMediator
//  VISDK
//
//  Created by Vitalii Cherepakha on 9/20/17.
//  Copyright © 2017 Vitalii Cherepakha. All rights reserved.
//

#ifndef VI_Mediator
#define VI_Mediator

#import <Foundation/Foundation.h>
#import "VIEnums.h"

@interface VIMediator : NSObject

@property (nonatomic, assign) MediatorState status;

- (nullable NSString *)title;

- (void)load;

- (void)close;

- (void)didReceiveError:(nonnull NSError *)error;
- (void)didReceiveLoadError:(nonnull NSError *)error;
- (void)didReceiveEventWithType:(VIAdEventType)type;


@end

//===============================================

@interface VIInterstitialMediator : VIMediator

- (void)showFromViewController:(nonnull UIViewController *)aViewController;

@end

//===============================================

@interface VIInlineMediator : VIMediator

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

- (void)setContainerView:(nonnull UIView *)containerView;

@end

#endif

