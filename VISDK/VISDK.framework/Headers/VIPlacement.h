//
//  VIPlacement.h
//  VISDK
//
//  Created by Nikita Levintsov on 3/7/17.
//  Copyright © 2017 Nikita Levintsov. All rights reserved.
//
#ifndef VIPlacement_H
#define VIPlacement_H

#import <Foundation/Foundation.h>

/**
 Backend provides specific ad content depending on placement
*/
@interface VIPlacement : NSObject

/// Placement identifier from the backend console
@property (nonnull, nonatomic, copy, readonly) NSString * placementId;

@property (nullable, nonatomic, strong, readonly) NSDictionary <NSString *, NSString *> * options;

/**
 Default initializer.
 @param aPlacementId from the backend console.
 @param options - for further extensions, could be null
 
 @return 'VIPlacement' object
*/
- (nonnull instancetype)initWith:(nonnull NSString *)aPlacementId
                         options:(nullable NSDictionary <NSString *, NSString *> *)options;

@end
#endif
