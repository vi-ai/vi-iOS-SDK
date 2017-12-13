//
//  AdMobVIInterstitialAdapter.h
//  AdMobVIMediation
//
//  Created by Vitalii Cherepakha on 9/18/17.
//  Copyright © 2017 Vitalii Cherepakha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VISDK/VIMediator.h>

@interface AdMobVIInterstitialAdapter : VIInterstitialMediator

- (void)load;

- (void)close;

- (nullable NSString *)title;

- (nonnull instancetype)initWithPlacementID:(nonnull NSString*)placementID;

- (void)showFromViewController:(nonnull UIViewController *)aViewController;

@end
