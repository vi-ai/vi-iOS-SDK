//
//  CountlyExternalTracker.m
//  CountlyExternalTracker
//
//  Created by Maksym Kravchenko on 12/27/17.
//  Copyright © 2017 Maksym Kravchenko. All rights reserved.
//

#import "CountlyExternalTracker.h"

#import <Countly/Countly.h>

static NSString * const kDefaultEventId = @"VISDK";


@implementation CountlyExternalTracker

NSString * const ktotalCountKey = @"totalCount";


@synthesize isValid = _isValid;

- (NSString *)eventId {
	if (_eventId == nil) {
		return kDefaultEventId;
	} else {
		return _eventId;
	}
}

- (nullable instancetype)initWithAppKey:(nonnull NSString *)appKey host:(nonnull NSString *)host {
	if (appKey.length < 1 || host.length < 1) {
		return nil;
	}
	
	self = [super init];
	if (self) {
		CountlyConfig *config = CountlyConfig.new;
#ifdef DEBUG
		config.enableDebug = YES;
#endif
		config.appKey = appKey;
		config.host = host;
		
		[Countly.sharedInstance startWithConfig:config];
		[Countly.sharedInstance setNewDeviceID:CLYIDFV onServer:YES];
		_isValid = YES;
	}
	return self;
}

- (nullable instancetype)init {
	return [self initWithAppKey:@"" host:@""];
}

- (void)adStart:(nonnull NSString *)placementId {
	[self recordEvent:@"adStart"  withPlacementId:placementId];
}

- (void)adComplete:(nonnull NSString *)placementId {
	[self recordEvent:@"adComplete"  withPlacementId:placementId];
}

- (void)adPaused:(nonnull NSString *)placementId {
	[self recordEvent:@"adPaused"  withPlacementId:placementId];
}

- (void)adResumed:(nonnull NSString *)placementId {
	[self recordEvent:@"adResumed"  withPlacementId:placementId];
}

- (void)adSkiped:(nonnull NSString *)placementId {
	[self recordEvent:@"adSkiped" withPlacementId:placementId];
}

- (void)adError:(nonnull NSString *)placementId {
	[self recordEvent:@"adError" withPlacementId:placementId];
}

- (void)adClicked:(nonnull NSString *)placementId {
	[self recordEvent:@"adClicked"  withPlacementId:placementId];
}

- (void)adVolumeChanged:(nonnull NSString *)placementId isMute: (BOOL)isMute {
	[self recordEvent:isMute ? @"adVolumeChanged_Mute" : @"adVolumeChanged_Unmute"  withPlacementId:placementId];
}
	 
- (void)recordEvent:(nonnull NSString *)event withPlacementId:(nonnull NSString *)placementId {
	 [Countly.sharedInstance recordEvent:self.eventId segmentation: @{ placementId : event, ktotalCountKey: event }];
 }

@end
