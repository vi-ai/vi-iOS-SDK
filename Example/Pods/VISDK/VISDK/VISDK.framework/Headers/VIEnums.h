//
//  VIEnums.h
//  VISDK
//
//  Created by Vitalii Cherepakha on 9/26/17.
//  Copyright © 2017 Vitalii Cherepakha. All rights reserved.
//

#ifndef Enums_h
#define Enums_h


typedef NS_ENUM(NSUInteger, MediatorState)
{
    MediatorStateIdle,
    MediatorStateReady,
    MediatorStateLoading,
};

typedef NS_ENUM(NSUInteger, VIAdEventType) {
    VIAdEventLoaded,    // Ad is succesfully loaded and ready to display. Call 'start' to start displaying the ad.
    VIAdEventStarted,   // Ad is on the screen and just started
    VIAdEventCompleted, // All pods were displayed till the end
    VIAdEventPaused,
    VIAdEventResumed,
    VIAdEventExpired,
    VIAdEventClicked,   // User clecked on See more button
    VIAdEventClosed     // Ad was closed by method 'stop' of VIAd protocol
};



#endif /* Enums_h */
