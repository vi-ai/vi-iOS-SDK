//
//  FacebookVIInlineAdapter.m
//  FacebookVIMediation
//
//  Created by Vitalii Cherepakha on 9/27/17.
//  Copyright © 2017 Vitalii Cherepakha. All rights reserved.
//

#import "FacebookVIInlineAdapter.h"
#import <VISDK/VISDK.h>
#import "FacebookVIInlineProtocols.h"
#import <FBAudienceNetwork/FBAudienceNetwork.h>


@interface VIVideoRenderer : FBMediaViewVideoRenderer

@property (nonatomic, assign) BOOL isVideo;
@property (nonatomic, weak, nullable)id<VIVideoRendererDelegate> delegate;

@end

@implementation VIVideoRenderer

- (instancetype)init
{
    self = [super init];
    self.isVideo = false;
    return self;
}

- (void)videoDidLoad
{
    self.isVideo = true;
    [super videoDidLoad];
}

- (void)videoDidEnd
{
    [super videoDidEnd];
    [self.delegate videoRendererVideoDidComplete:self];
}

- (void)videoDidPause
{
    [super videoDidPause];
    [self.delegate videoRendererVideoDidPause:self];
}

- (void)videoDidPlay
{
    [super videoDidPlay];
    [self.delegate videoRendererVideoDidPlay:self];
}

- (void)videoDidFailWithError:(NSError *)error
{
    [super videoDidFailWithError:error];
    [super videoDidFailWithError:error];
}

@end


@interface FacebookVIInlineAdapter () <FBNativeAdDelegate, FBMediaViewDelegate, VIVideoRendererDelegate>

@property (nonatomic, strong, nullable) FBMediaView* adView;
@property (nonatomic, strong, nullable) FBNativeAd *nativeAd;
@property (nonatomic, strong, nonnull) NSString* placementID;

// UI

@property (nonatomic, strong, nullable) UIButton* playControlButton;
@property (nonatomic, strong, nullable) UIButton* closeButton;
@property (nonatomic, strong, nullable) UILabel* timeLabel;


@end

@implementation FacebookVIInlineAdapter

- (instancetype)initWithPlacementID:(NSString*)placementID
{
#if TARGET_OS_SIMULATOR
    return nil;
#else
    self = [super init];
    if (self != nil)
    {
#ifdef DEBUG
        [FBAdSettings addTestDevice:[FBAdSettings testDeviceHash]];
#endif
        self.status = MediatorStateIdle;
        self.placementID = placementID;
        self.startsWhenReady = NO;
    }
    return self;
#endif
}

- (void)close
{
    self.status = MediatorStateIdle;
    _nativeAd = nil;
    [self.adView.videoRenderer pauseVideo];
}

- (void)start
{
    [self.adView.videoRenderer playVideo];
}

- (void)pause
{
    [self.adView.videoRenderer pauseVideo];
}

- (void)resume
{
    [self.adView.videoRenderer playVideo];
}


- (nullable NSString *)title
{
    return @"Facebook";
}

- (void)load
{
    if (self.status == MediatorStateIdle)
    {
        if (self.nativeAd == nil)
        {
            [self prepareAd];
        }
        [self.nativeAd loadAd];
        self.status = MediatorStateLoading;
    }
}

- (void)prepareAd
{
    self.nativeAd = [[FBNativeAd alloc] initWithPlacementID:self.placementID];
    self.nativeAd.mediaCachePolicy = FBNativeAdsCachePolicyVideo;
    self.nativeAd.delegate = self;
}

- (void)setContainerView:(UIView *)containerView
{
    [self.nativeAd unregisterView];
    
    self.adView = [[FBMediaView alloc] initWithNativeAd:self.nativeAd];
    self.adView.delegate = self;
    VIVideoRenderer* renderer = [[VIVideoRenderer alloc] init];
    renderer.delegate = self;
    [self.adView setVideoRenderer:renderer];
    __typeof__(self) __weak welf = self;
    [renderer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1)
                                           queue:dispatch_get_main_queue()
                                      usingBlock:^(CMTime time) {
                                          [welf updateTimeLabelWithTime:time];
                                      }];
    
    self.adView.translatesAutoresizingMaskIntoConstraints = NO;
    [containerView addSubview:self.adView];
    
    [[self.adView.leftAnchor constraintEqualToAnchor:containerView.leftAnchor] setActive:YES];
    [[self.adView.rightAnchor constraintEqualToAnchor:containerView.rightAnchor] setActive:YES];
    [[self.adView.topAnchor constraintEqualToAnchor:containerView.topAnchor] setActive:YES];
    [[self.adView.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor] setActive:YES];
    
    
//    [self.adView.videoRenderer playVideo];
    
    [self.nativeAd registerViewForInteraction:containerView
                           withViewController:nil];
    
    [self prepareUIForContainerView:containerView];
    
}

- (void)prepareUIForContainerView:(nonnull UIView*)containerView
{
    NSBundle* bundle = [NSBundle bundleForClass:[FacebookVIInlineAdapter class]];
    
    self.playControlButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    self.playControlButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self updatePlayControlButtonForPause];
    [self.playControlButton addTarget:self action:@selector(playControlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [containerView addSubview:self.playControlButton];
    
    [[self.playControlButton.leftAnchor constraintEqualToAnchor:containerView.leftAnchor constant:5] setActive:YES];
    [[self.playControlButton.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor constant:-5] setActive:YES];
    
    self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    UIImage* closeIcon = [UIImage imageNamed:@"close_icon" inBundle:bundle compatibleWithTraitCollection:nil];
    [self.closeButton setImage:closeIcon forState: UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [containerView addSubview:self.closeButton];
    
    [[self.closeButton.leftAnchor constraintEqualToAnchor:containerView.leftAnchor constant:5] setActive:YES];
    [[self.closeButton.topAnchor constraintEqualToAnchor:containerView.topAnchor constant:5] setActive:YES];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.timeLabel.font = [UIFont systemFontOfSize:10];
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.text = [self timeFormatFromTime:0];
    
    [containerView addSubview:self.timeLabel];
    
    [[self.timeLabel.rightAnchor constraintEqualToAnchor:containerView.rightAnchor constant:-5] setActive:YES];
    [[self.timeLabel.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor constant:-5] setActive:YES];
    
    [containerView layoutIfNeeded];
    
    self.timeLabel.hidden = YES;
    self.closeButton.hidden = YES;
    self.playControlButton.hidden = YES;
}

- (void)closeButtonClicked:(UIButton*)sender
{
    [super didReceiveEventWithType:VIAdEventClosed];
}

- (void)playControlButtonClicked:(UIButton*)sender
{
    if (self.adView.videoRenderer.isPlaying == true)
    {
        [self.adView.videoRenderer pauseVideo];
        [self updatePlayControlButtonForPlay];
    }
    else
    {
        [self.adView.videoRenderer playVideo];
        [self updatePlayControlButtonForPause];
    }
}

- (void)updatePlayControlButtonForPlay
{
    NSBundle* bundle = [NSBundle bundleForClass:[FacebookVIInlineAdapter class]];
    UIImage* pauseIcon = [UIImage imageNamed:@"play_icon" inBundle:bundle compatibleWithTraitCollection:nil];
    [self.playControlButton setImage:pauseIcon forState: UIControlStateNormal];
}

- (void)updatePlayControlButtonForPause
{
    NSBundle* bundle = [NSBundle bundleForClass:[FacebookVIInlineAdapter class]];
    UIImage* pauseIcon = [UIImage imageNamed:@"pause_icon" inBundle:bundle compatibleWithTraitCollection:nil];
    [self.playControlButton setImage:pauseIcon forState: UIControlStateNormal];
}

- (void)updateTimeLabelWithTime:(CMTime)time
{
    if (CMTIME_IS_VALID(time) && CMTIME_IS_VALID(self.adView.videoRenderer.duration))
    {
        NSInteger duration = CMTimeGetSeconds(self.adView.videoRenderer.duration);
        NSInteger currentTime = CMTimeGetSeconds(time);
        self.timeLabel.text = [self timeFormatFromTime:duration - currentTime];
    }
}

- (NSString*)timeFormatFromTime:(NSInteger)time
{
    NSMutableString* result = [NSMutableString string];
    
    NSInteger hours = time / 3600;
    time = time%hours;
    NSInteger minutes = time / 60;
    time = time%minutes;
    NSInteger seconds = time;
    
    [result appendString:[NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds]];
    
    if (hours > 0)
    {
        [result insertString:[NSString stringWithFormat:@"%02ld:", (long)hours] atIndex:0];
    }
    
    return result;
}

- (void)prepareUIForVideo:(BOOL)isVideo
{
    if (isVideo == YES)
    {
        self.playControlButton.hidden = NO;
        self.timeLabel.hidden = NO;
        self.closeButton.hidden = YES;
    }
    else
    {
        self.playControlButton.hidden = YES;
        self.timeLabel.hidden = YES;
        self.closeButton.hidden = NO;
    }
}



#pragma mark - FBNativeAdDelegate

- (void)nativeAdDidLoad:(FBNativeAd *)nativeAd
{
    
    self.status = MediatorStateReady;
    
    [super didReceiveEventWithType:VIAdEventLoaded];
    [self updateTimeLabelWithTime:self.adView.videoRenderer.currentTime];
}

- (void)nativeAd:(FBNativeAd *)nativeAd didFailWithError:(NSError *)error
{
    self.status = MediatorStateIdle;
    [super didReceiveLoadError:error];
}

- (void)nativeAdDidClick:(FBNativeAd *)nativeAd
{
    [super didReceiveEventWithType:VIAdEventClicked];
}

#pragma mark - FBMediaViewDelegate

- (void)mediaViewDidLoad:(FBMediaView *)mediaView
{
    if (self.startsWhenReady == true)
    {
        [mediaView.videoRenderer playVideo];
    }
    
    if ([mediaView.videoRenderer isKindOfClass:[VIVideoRenderer class]])
    {
        BOOL isVideo = ((VIVideoRenderer*)(mediaView.videoRenderer)).isVideo;
        [self prepareUIForVideo:isVideo];
    }
}

#pragma mark - VIVideoRendererDelegate

- (void)videoRendererVideoDidPause:(VIVideoRenderer *)videoRenderer
{
    [super didReceiveEventWithType:VIAdEventPaused];
}

- (void)videoRendererVideoDidPlay:(VIVideoRenderer *)videoRenderer
{
        if (videoRenderer == nil || (CMTIME_IS_VALID(videoRenderer.currentTime) && CMTimeGetSeconds(videoRenderer.currentTime) == 0))
        {
            [super didReceiveEventWithType:VIAdEventStarted];
        }
        else
        {
            [super didReceiveEventWithType:VIAdEventResumed];
        }
}

- (void)videoRendererVideoDidFail:(VIVideoRenderer *)videoRenderer withError:(NSError*)error
{
    [super didReceiveError:error];
}

- (void)videoRendererVideoDidComplete:(VIVideoRenderer *)videoRenderer
{
    self.status = MediatorStateIdle;
    [super didReceiveEventWithType:VIAdEventCompleted];
}

@end

