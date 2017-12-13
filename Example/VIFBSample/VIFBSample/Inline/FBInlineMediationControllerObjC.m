//
//  FBInlineMediationControllerObjC.m
//  VIFBSample
//
//  Created by Vitalii Cherepakha on 10/20/17.
//  Copyright © 2017 Vitalii Cherepakha. All rights reserved.
//

#import "FBInlineMediationControllerObjC.h"
#import "FacebookVIInlineAdapter.h"
#import <VISDK/VISDK.h>

@interface FBInlineMediationControllerObjC () <VIAdDelegate>

@property (nonatomic, strong) id<VIVideoAd> ad;

@property (nonatomic, strong) IBOutlet UIView* containerView;
@property (nonatomic, strong) IBOutlet UILabel* statusLabel;
@property (nonatomic, strong) IBOutlet UIButton* playButton;


@end

@implementation FBInlineMediationControllerObjC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playButton.enabled = NO;
    self.statusLabel.text = @"Idling";
    
}

- (void)prepareAD
{
    VIPlacement* placement = [[VIPlacement alloc] initWith:@"фывфыв" options:nil];
    self.ad = [[VISDK sharedInstance] createVideoAdFor:placement inContainer:self.containerView useCahe:YES];
    self.ad.delegate = self;
    FacebookVIInlineAdapter* adapter = [[FacebookVIInlineAdapter alloc] initWithPlacementID:@"e90aa8b06e3c473aa0ba70ebfc8c5c89"];
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
    [self.ad start];
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
