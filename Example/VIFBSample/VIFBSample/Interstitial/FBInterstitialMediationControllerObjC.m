//
//  FBInterstitialMediationControllerObjC.m
//  VIFBSample
//
//  Created by Vitalii Cherepakha on 10/20/17.
//  Copyright © 2017 Vitalii Cherepakha. All rights reserved.
//

#import "FBInterstitialMediationControllerObjC.h"
#import "FacebookVIInterstitialAdapter.h"
#import <VISDK/VISDK.h>

@interface FBInterstitialMediationControllerObjC ()

@property (nonatomic, strong) id<VIInterstitialAd> ad;

@property (nonatomic, strong) IBOutlet UILabel* statusLabel;
@property (nonatomic, strong) IBOutlet UIButton* playButton;


@end

@implementation FBInterstitialMediationControllerObjC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playButton.enabled = NO;
    self.statusLabel.text = @"Idling";
    
}

- (void)prepareAD
{
#warning Configure with your placementID!
    VIPlacement* placement = [[VIPlacement alloc] initWith:@"pltr1zx2wwwrr71n824" options:nil];
    self.ad = [[VISDK sharedInstance] createInterstitialAdFor:placement];
    self.ad.delegate = self;
	
#warning Configure with your PlacementID!
    FacebookVIInterstitialAdapter* adapter = [[FacebookVIInterstitialAdapter alloc] initWithPlacementID:@"2007707356109450_2008142456065940"];
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
            NSLog(@"\n\tAd loaded\n");
            break;
            
        case VIAdEventStarted:
            NSLog(@"\n\tAd started\n");
            break;
            
        case VIAdEventClosed:
            NSLog(@"\n\tAd Closed\n");
            self.playButton.enabled = NO;
            self.statusLabel.text = @"Idling";
            self.ad = nil;
            break;
            
        case VIAdEventClicked:
            NSLog(@"\n\tAd clicked\n");
            break;
            
        case VIAdEventPaused:
            NSLog(@"\n\tAd paused\n");
            break;
            
        case VIAdEventResumed:
            NSLog(@"\n\tAd resumed\n");
            break;
            
        case VIAdEventExpired:
            NSLog(@"\n\tAd expired\n");
            break;
            
        case VIAdEventCompleted:
            NSLog(@"\n\tAd completed\n");
            self.playButton.enabled = NO;
            self.statusLabel.text = @"Idling";
            self.ad = nil;
            break;
            
        default:
            break;
    }
}

@end
