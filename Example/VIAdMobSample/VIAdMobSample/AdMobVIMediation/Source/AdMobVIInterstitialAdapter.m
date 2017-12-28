//
//  AdMobVIInterstitialAdapter.m
//  AdMobVIMediation
//
//  Created by Vitalii Cherepakha on 9/18/17.
//  Copyright © 2017 Vitalii Cherepakha. All rights reserved.
//

#import "AdMobVIInterstitialAdapter.h"
#import <VISDK/VISDK.h>
#import <GoogleMobileAds/GoogleMobileAds.h>


@interface AdMobVIInterstitialAdapter() <GADInterstitialDelegate>

@property (nonatomic, strong, nullable) GADInterstitial *interstitialAd;
@property (nonatomic, strong, nonnull) NSString* placementID;

@end

@implementation AdMobVIInterstitialAdapter

- (instancetype)initWithPlacementID:(NSString*)placementID
{
    self = [super init];
    if (self != nil)
    {
        self.status = MediatorStateIdle;
        self.placementID = placementID;
    }
    return self;
}

- (void)close
{
    self.status = MediatorStateIdle;
    _interstitialAd = nil;
}


- (nullable NSString *)title
{
	return kAdMobKey;
}


- (void)showFromViewController:(nonnull UIViewController *)aViewController
{
    if (self.status == MediatorStateReady)
    {
        [self.interstitialAd presentFromRootViewController:aViewController];
    }
}

- (void)load
{
    if (self.interstitialAd == nil)
    {
        [self prepareAd];
    }
    
    GADRequest *request = [GADRequest request];
#ifdef DEBUG
    request.testDevices = @[ @"737b992853525e3a77c041c5205bdd74" ];
#endif
    [self.interstitialAd loadRequest:request];
    self.status = MediatorStateLoading;
}

- (void)prepareAd
{
    self.interstitialAd = [[GADInterstitial alloc] initWithAdUnitID:self.placementID];
    self.interstitialAd.delegate = self;
}

#pragma mark - GADInterstitialDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    self.status = MediatorStateReady;
    [super didReceiveEventWithType:VIAdEventLoaded];
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    [super didReceiveLoadError:error];
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad
{
    [super didReceiveEventWithType:VIAdEventClicked];
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad
{
    [super didReceiveEventWithType:VIAdEventStarted];
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad
{
	[super didReceiveEventWithType:VIAdEventCompleted];
}

@end
