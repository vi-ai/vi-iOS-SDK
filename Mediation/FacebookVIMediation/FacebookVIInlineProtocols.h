//
//  FacebookVIInlineProtocols.h
//  FacebookVIMediation
//
//  Created by Vitalii Cherepakha on 10/2/17.
//  Copyright © 2017 Vitalii Cherepakha. All rights reserved.
//

#ifndef FacebookVIInlineProtocols_h
#define FacebookVIInlineProtocols_h

@class VIVideoRenderer;

@protocol VIVideoRendererDelegate

- (void)videoRendererVideoDidPause:(nonnull VIVideoRenderer *)videoRenderer;
- (void)videoRendererVideoDidPlay:(nonnull VIVideoRenderer *)videoRenderer;
- (void)videoRendererVideoDidFail:(nonnull VIVideoRenderer *)videoRenderer withError:(nullable NSError*)error;
- (void)videoRendererVideoDidComplete:(nonnull VIVideoRenderer *)videoRenderer;

@end


#endif /* FacebookVIInlineProtocols_h */
