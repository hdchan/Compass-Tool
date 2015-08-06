//
//  TargetDestination.h
//  Compass Tool
//
//  Created by Henry Chan on 7/31/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef enum {
    TargetDestinationTypeNone,
    TargetDestinationTypeFinalLocation,
    TargetDestinationTypePointOfInterest
} TargetDestinationType;

@interface DestinationDataStore : NSObject

@property (nonatomic, strong) CLLocation *finalLocation;
@property (nonatomic, strong) CLLocation *pointOfInterest;
@property (nonatomic) TargetDestinationType currentTargetDestinationType;

+ (instancetype)sharedDataStore;

@end
