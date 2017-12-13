//
//  MopubVIInterstitialAdapter.m
//  AdMobVIMediation
//
//  Created by Vitalii Cherepakha on 9/18/17.
//  Copyright © 2017 Vitalii Cherepakha. All rights reserved.
//

#import "MopubVIInterstitialAdapter.h"
#import <VISDK/VISDK.h>
#import <MoPub/MoPub.h>


@interface MopubVIInterstitialAdapter() <MPInterstitialAdControllerDelegate>

@property (nonatomic, strong, nullable) MPInterstitialAdController *interstitialAd;
@property (nonatomic, strong, nonnull) NSString* placementID;

@end

@implementation MopubVIInterstitialAdapter

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
    return @"AdMob";
}


- (void)showFromViewController:(nonnull UIViewController *)aViewController
{
    if (self.status == MediatorStateReady)
    {
        [self.interstitialAd showFromViewController:aViewController];
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
    self.interstitialAd = [MPInterstitialAdController interstitialAdControllerForAdUnitId:self.placementID];
#ifdef DEBUG
//    self.interstitialAd.testing = YES;
#endif
    self.interstitialAd.delegate = self;
}

#pragma mark - GADInterstitialDelegate

- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial
{
    self.status = MediatorStateReady;
    [super didReceiveEventWithType:VIAdEventLoaded];
}

- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial
{
    NSError* error = [NSError errorWithDomain:@"com.mopub.mediation.adapter"
                                         code:0
                                     userInfo:@{NSLocalizedDescriptionKey : @"Load did failed"}];
    [super didReceiveLoadError:error];
}

- (void)interstitialDidReceiveTapEvent:(MPInterstitialAdController *)interstitial
{
    [super didReceiveEventWithType:VIAdEventClicked];
}

- (void)interstitialWillAppear:(MPInterstitialAdController *)interstitial
{
    [super didReceiveEventWithType:VIAdEventStarted];
}

- (void)interstitialWillDisappear:(MPInterstitialAdController *)interstitial
{
    [super didReceiveEventWithType:VIAdEventClosed];
}

@end
