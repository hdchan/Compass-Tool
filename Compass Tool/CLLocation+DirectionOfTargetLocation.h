//
//  CLLocation+HeadingOfTargetLocation.h
//  Compass Tool
//
//  Created by Henry Chan on 8/23/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (DirectionOfTargetLocation)

- (CLLocationDirection) directionOfTargetLocation:(CLLocation *)targetLocation;

@end
