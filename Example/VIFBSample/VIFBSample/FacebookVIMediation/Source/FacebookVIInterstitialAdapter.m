//
//  FacebookVIInterstitialAdapter.m
//  FacebookVIMediation
//
//  Created by Vitalii Cherepakha on 9/18/17.
//  Copyright © 2017 Vitalii Cherepakha. All rights reserved.
//

#import "FacebookVIInterstitialAdapter.h"
#import <VISDK/VISDK.h>
#import <FBAudienceNetwork/FBAudienceNetwork.h>


@interface FacebookVIInterstitialAdapter() <FBInterstitialAdDelegate>

@property (nonatomic, strong, nullable) FBInterstitialAd *interstitialAd;
@property (nonatomic, strong, nonnull) NSString* placementID;

@end

@implementation FacebookVIInterstitialAdapter

- (instancetype)initWithPlacementID:(NSString*)placementID
{
//#if TARGET_OS_SIMULATOR
//    return nil;
//#else
    self = [super init];
    if (self != nil)
    {
//#ifdef DEBUG
//        [FBAdSettings addTestDevice:[FBAdSettings testDeviceHash]];
//#endif
        self.status = MediatorStateIdle;
        self.placementID = placementID;
    }
    return self;
//#endif
}

- (void)close
{
    self.status = MediatorStateIdle;
    _interstitialAd = nil;
}


- (nullable NSString *)title
{
	return kFBMediationKey;
}


- (void)showFromViewController:(nonnull UIViewController *)aViewController
{
    if (self.status == MediatorStateReady)
    {
        [self.interstitialAd showAdFromRootViewController:aViewController];
    }
}

- (void)load
{
    if (self.interstitialAd == nil)
    {
        [self prepareAd];
    }
    [self.interstitialAd loadAd];
    self.status = MediatorStateLoading;
}

- (void)prepareAd
{
    self.interstitialAd = [[FBInterstitialAd alloc] initWithPlacementID:self.placementID];
    self.interstitialAd.delegate = self;
}

#pragma mark - FBInterstitialAdDelegate

- (void)interstitialAdDidClick:(FBInterstitialAd *)interstitialAd
{
    [super didReceiveEventWithType:VIAdEventClicked];
}

- (void)interstitialAdDidClose:(FBInterstitialAd *)interstitialAd
{
	[super didReceiveEventWithType:VIAdEventCompleted];
}

- (void)interstitialAdDidLoad:(FBInterstitialAd *)interstitialAd
{
    self.status = MediatorStateReady;
    [super didReceiveEventWithType:VIAdEventLoaded];
}

- (void)interstitialAd:(FBInterstitialAd *)interstitialAd didFailWithError:(NSError *)error
{
    [super didReceiveLoadError:error];
}

- (void)interstitialAdWillLogImpression:(FBInterstitialAd *)interstitialAd
{
    [super didReceiveEventWithType:VIAdEventStarted];
}

@end
