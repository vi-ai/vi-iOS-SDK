//
//  VISDK.h
//  VISDK
//
//  Created by Nikita Levintsov on 3/7/17.
//  Copyright © 2017 Nikita Levintsov. All rights reserved.
//

#ifndef VISDK_H
#define VISDK_H

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "VIOptions.h"
#import "VIPlacement.h"
#import "VIAd.h"
#import "VIAdEvent.h"
#import "VIMediator.h"
#import "VIEnums.h"

//! Project version number for VISDK.
FOUNDATION_EXPORT double VISDKVersionNumber;

//! Project version string for VISDK.
FOUNDATION_EXPORT const unsigned char VISDKVersionString[];

@protocol VIAd;
@class VIPlacement;
@class VIOptions;

/**
 Singletone, provides access to the api.
 Initialize in AppDelegate
*/
@interface VISDK : NSObject

/**
 Version of the SDK
*/
@property (nonnull, nonatomic, strong, readonly) NSString * version;

@property (nonatomic, strong, nullable, readonly) VIOptions * options;

+ (nonnull instancetype)createWithOptions:(nullable VIOptions *)options;

+ (nonnull instancetype)sharedInstance;

/**
 Put and hold instance of ViAd where you are going to display the instream ad.
 @param placement for ad
 @param view in which video ad will be displayed
 @return VIVideoAd instance
*/
- (nullable id<VIVideoAd>)createVideoAdFor:(nonnull VIPlacement *)placement
                               inContainer:(nonnull UIView *)view;

- (nullable id<VIVideoAd>)createVideoAdFor:(nonnull VIPlacement *)placement
                               inContainer:(nonnull UIView *)view
                                   useCahe:(BOOL)shouldUseCache;

/**
 Put and hold instance of VIInterstitialAd where you are going to display the interstitial ad.
 @param placement for ad
 @return VIInterstitialAd instance
*/
- (nullable id<VIInterstitialAd>)createInterstitialAdFor:(nonnull VIPlacement *)placement;

@end

#endif
