//
//  InlineMediationControllerObjC.m
//  VIFBSample
//
//  Created by Vitalii Cherepakha on 10/20/17.
//  Copyright © 2017 Vitalii Cherepakha. All rights reserved.
//

#import "InlineMediationControllerObjC.h"
#import <VISDK/VISDK.h>

@interface InlineMediationControllerObjC () <VIAdDelegate>

@property (nonatomic, strong) id<VIVideoAd> ad;

@property (nonatomic, strong) IBOutlet UIView* containerView;
@property (nonatomic, strong) IBOutlet UILabel* statusLabel;
@property (nonatomic, strong) IBOutlet UIButton* playButton;
@property (nonatomic, strong) IBOutlet UIButton *closeButton;
	

@end

@implementation InlineMediationControllerObjC

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self resetView];
}

- (void)prepareAD
{
#warning Configure with your placementID!
    VIPlacement* placement = [[VIPlacement alloc] initWith:@"pltw7ms3eco4z2jwbot" options:nil];
    self.ad = [[VISDK sharedInstance] createVideoAdFor:placement inContainer:self.containerView useCahe:YES];
    self.ad.delegate = self;
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
	if (self.ad.isPlaying) {
		[self.ad pause];
	} else if (self.ad.isPaused) {
		[self.ad resume];
	} else {
		[self.ad start];
	}
}
	
- (IBAction)closeButtonTouched:(id)sender {
	[self.ad close];
}
	
- (void)resetView {
	self.playButton.enabled = NO;
	self.statusLabel.text = @"Idling";
	self.closeButton.enabled = NO;
	[self.playButton setTitle:@"Play" forState: UIControlStateNormal];
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
			self.closeButton.enabled = YES;
			[self.playButton setTitle:@"Play" forState: UIControlStateNormal];

            NSLog(@"\n\tAd loaded\n");
            break;
		
        case VIAdEventStarted:
			[self.playButton setTitle:@"Pause" forState: UIControlStateNormal];

            NSLog(@"\n\tAd started\n");
            break;
		
        case VIAdEventClosed:
            NSLog(@"\n\tAd Closed\n");
			[self resetView];
			self.ad = nil;
            break;
		
        case VIAdEventClicked:
            NSLog(@"\n\tAd clicked\n");
            break;
		
        case VIAdEventPaused:
			self.statusLabel.text = @"Paused";
			[self.playButton setTitle:@"Resume" forState: UIControlStateNormal];
		
            NSLog(@"\n\tAd paused\n");
            break;
		
        case VIAdEventResumed:
			self.statusLabel.text = @"Resumed";
			[self.playButton setTitle:@"Pause" forState: UIControlStateNormal];
		
            NSLog(@"\n\tAd resumed\n");
            break;
		
        case VIAdEventExpired:
            NSLog(@"\n\tAd expired\n");
            break;
		
        case VIAdEventCompleted:
            NSLog(@"\n\tAd completed\n");
			[self resetView];
            self.ad = nil;
            break;
		
        default:
            break;
    }
}

@end
