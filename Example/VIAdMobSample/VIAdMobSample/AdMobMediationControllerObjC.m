//
//  AdMobMediationControllerObjC.m
//  VIAdMobSample
//
//  Created by Vitalii Cherepakha on 10/19/17.
//  Copyright © 2017 Vitalii Cherepakha. All rights reserved.
//

#import "AdMobMediationControllerObjC.h"
#import "AdMobVIInterstitialAdapter.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <VISDK/VISDK.h>

@interface AdMobMediationControllerObjC () <VIAdDelegate>

@property (nonatomic, strong) id<VIInterstitialAd> ad;

@property (nonatomic, strong) IBOutlet UILabel* statusLabel;
@property (nonatomic, strong) IBOutlet UIButton* playButton;

@end

@implementation AdMobMediationControllerObjC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playButton.enabled = NO;
    self.statusLabel.text = @"Idling";
	
#warning Configure with your ApplicationId!
    [GADMobileAds configureWithApplicationID:@"ca-app-pub-4499248058256064~1126671347"];
}

- (void)prepareAD
{
#warning Use your placementID here!
	VIPlacement* placement = [[VIPlacement alloc] initWith:@"pltjncfuej9qng5jpuz" options:nil];
    self.ad = [[VISDK sharedInstance] createInterstitialAdFor:placement];
    self.ad.delegate = self;
	
#warning Configure with your ApplicationId!
    AdMobVIInterstitialAdapter* adapter = [[AdMobVIInterstitialAdapter alloc] initWithPlacementID:@"ca-app-pub-4499248058256064/8430446295"];
    [self.ad registerMediation:adapter];
}

- (IBAction)loadButtonTouched:(id)sender
{
    if (self.ad == nil)
    {
        [self prepareAD];
    }
    
    [self.ad load];
    self.statusLabel.text = @"Loading...";
}

- (IBAction)playButtonTouched:(id)sender
{
    [self.ad showFromViewController:self];
}

#pragma mark - VIAdDelegate


- (void)adDidReceiveError:(nonnull NSError *)error
{
    UIAlertController* controller = [UIAlertController alertControllerWithTitle:@"Error"
                                                                        message:error.localizedDescription
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"Close"
                                                   style:UIAlertActionStyleCancel
                                                 handler:nil]];
    [self presentViewController:controller animated:true completion:nil];
}

- (void)adDidReceiveEvent:(nonnull VIAdEvent *)event
{
    switch (event.type)
    {
        case VIAdEventLoaded:
            self.statusLabel.text = @"Loaded";
            self.playButton.enabled = YES;
            break;
            
        case VIAdEventStarted:
            NSLog(@"Ad started");
            break;
            
        case VIAdEventClosed:
            NSLog(@"Ad Closed");
            self.playButton.enabled = NO;
            self.statusLabel.text = @"Idling";
            self.ad = nil;
            break;
            
        case VIAdEventClicked:
            NSLog(@"Ad clicked");
            break;
            
        case VIAdEventPaused:
            NSLog(@"Ad paused");
            break;
            
        case VIAdEventResumed:
            NSLog(@"Ad resumed");
            break;
            
        case VIAdEventExpired:
            NSLog(@"Ad expired");
            break;
            
        case VIAdEventCompleted:
            NSLog(@"Ad completed");
            self.playButton.enabled = NO;
            self.statusLabel.text = @"Idling";
            self.ad = nil;
            break;
            
        default:
            break;
    }
}


@end
