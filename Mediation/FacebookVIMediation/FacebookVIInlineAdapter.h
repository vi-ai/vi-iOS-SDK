//
//  FacebookVIInlineAdapter.h
//  FacebookVIMediation
//
//  Created by Vitalii Cherepakha on 9/27/17.
//  Copyright © 2017 Vitalii Cherepakha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VISDK/VIMediator.h>

@interface FacebookVIInlineAdapter : VIInlineMediator

- (void)load;

- (void)close;
- (void)start;
- (void)pause;
- (void)resume;

- (nullable NSString *)title;

- (nonnull instancetype)initWithPlacementID:(nonnull NSString*)placementID;

- (void)setContainerView:(nonnull UIView *)containerView;
@end
