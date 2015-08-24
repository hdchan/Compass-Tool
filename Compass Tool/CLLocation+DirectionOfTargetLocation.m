//
//  CLLocation+HeadingOfTargetLocation.m
//  Compass Tool
//
//  Created by Henry Chan on 8/23/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "CLLocation+DirectionOfTargetLocation.h"

@implementation CLLocation (DirectionOfTargetLocation)

- (CLLocationDirection) directionOfTargetLocation:(CLLocation *)targetLocation {
    
    // Give an offset in degrees away from north
    
    CLLocationDegrees offsetRadians = 0;
    
    
    CLLocationDegrees tarLat = targetLocation.coordinate.latitude;
    CLLocationDegrees tarLng = targetLocation.coordinate.longitude;
    
    CLLocationDegrees curLat = self.coordinate.latitude;
    CLLocationDegrees curLng = self.coordinate.longitude;
    
    CLLocationDegrees deltaY = tarLat - curLat;
    CLLocationDegrees deltaX = tarLng - curLng;
    
    // We need to calculate arc tan and arrange it depending on quadrant
    // tan(θ) = Opposite / Adjacent
    
    // Quadrants
    //    lat   +,+
    // VI  |  I
    // -------- long
    // III | II +,-
    
    // Lat = y Coords
    // Long = x Coords
    
    if (tarLat > curLat && tarLng > curLng) { // Quadrant I
        
        offsetRadians = atan(fabs(deltaX / deltaY));
        
    } else if (tarLat < curLat && tarLng > curLng) { // Quadrant II
        
        offsetRadians = (M_PI / 2) + atan(fabs(deltaY / deltaX));
        
    } else if (tarLat < curLat && tarLng < curLng) { // Quadrant III
        
        offsetRadians = M_PI + atan(fabs(deltaX / deltaY));
        
    } else if (tarLat > curLat && tarLng < curLng) { // Quadrant IV
        
        offsetRadians = (3 * M_PI / 2) + atan(fabs(deltaY / deltaX));
        
    } else if (tarLat > curLat && deltaX == 0) { // Directly North
        
        // offset is zero for north
        
    } else if (tarLat < curLat && deltaX == 0) { // Directly South
        
        offsetRadians = M_PI;
        
    } else if (deltaY == 0 && tarLng < curLng) { // Directly West
        
        offsetRadians = 3 * M_PI / 2;
        
    } else if (deltaY == 0 && tarLng > curLng) { // Directly East
        
        offsetRadians = M_PI / 2;
        
    }
    
    CLLocationDegrees offsetDegress = offsetRadians * ( 180.0 / M_PI );
    
    return offsetDegress;
    
}

@end
