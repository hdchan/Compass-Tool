//
//  TargetDestination.m
//  Compass Tool
//
//  Created by Henry Chan on 7/31/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "DestinationDataStore.h"

@interface DestinationDataStore() 

@end

@implementation DestinationDataStore

+ (instancetype)sharedTargetDestination {
    static DestinationDataStore *_sharedTargetDestination = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedTargetDestination = [DestinationDataStore new];
    });
    
    return _sharedTargetDestination;
}




@end
