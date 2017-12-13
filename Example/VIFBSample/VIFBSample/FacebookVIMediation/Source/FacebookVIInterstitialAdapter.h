//
//  FacebookVIInterstitialAdapter.h
//  FacebookVIMediation
//
//  Created by Vitalii Cherepakha on 9/18/17.
//  Copyright © 2017 Vitalii Cherepakha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VISDK/VIMediator.h>

@interface FacebookVIInterstitialAdapter : VIInterstitialMediator

- (void)load;

- (void)close;

- (nullable NSString *)title;

- (nullable instancetype)initWithPlacementID:(nonnull NSString*)placementID;

- (void)showFromViewController:(nonnull UIViewController *)aViewController;

@end
