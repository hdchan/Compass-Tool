//
//  ViewController.m
//  CLHeading Demo
//
//  Created by Henry Chan on 7/28/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "CompassViewController.h"
#import "DestinationDataStore.h"
#import <JDStatusBarNotification/JDStatusBarNotification.h>

@interface CompassViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *magneticHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *trueHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentLatLngLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationLatLngLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceRemianingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *compassImageView;

@property (nonatomic, strong) CLLocationManager *locationManger;
@property (nonatomic, strong) DestinationDataStore *destinationDataStore;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) CLLocation *targetLocation;

@end

@implementation CompassViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.destinationDataStore = [DestinationDataStore sharedDataStore];
    
    self.locationManger = [CLLocationManager new];
    self.locationManger.delegate = self;

    
    self.locationManger.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [self.locationManger startUpdatingHeading];
    [self.locationManger startUpdatingLocation];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self setTargetHeading];
    
}

- (void) setTargetHeading {
    
    if (self.destinationDataStore.currentTargetDestinationType == TargetDestinationTypeNone) {
        
        self.targetLocation = nil;
        
        self.destinationLatLngLabel.text = @"Target destination not set...";
        
    } else if (self.destinationDataStore.currentTargetDestinationType == TargetDestinationTypeFinalLocation) {
        
        self.targetLocation = self.destinationDataStore.finalLocation;
        
        self.destinationLatLngLabel.text = [NSString stringWithFormat:@"Tar Lat: %f Lng: %f",self.targetLocation.coordinate.latitude, self.targetLocation.coordinate.longitude];
        
    } else if (self.destinationDataStore.currentTargetDestinationType == TargetDestinationTypePointOfInterest) {
        
        self.targetLocation = self.destinationDataStore.pointOfInterest;
        
        self.destinationLatLngLabel.text = [NSString stringWithFormat:@"Tar Lat: %f Lng: %f",self.targetLocation.coordinate.latitude, self.targetLocation.coordinate.longitude];
    }
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {

//    NSLog(@"%@", newHeading);
    
    self.magneticHeadingLabel.text = [NSString stringWithFormat:@"Mag Heading: %f", newHeading.magneticHeading];
    
    self.trueHeadingLabel.text = [NSString stringWithFormat:@"True Heading: %f", newHeading.trueHeading];

    self.currentLatLngLabel.text = [NSString stringWithFormat:@"Cur Lat: %f Lng: %f",self.locationManger.location.coordinate.latitude, self.locationManger.location.coordinate.longitude];
    
    
    double northHeading =  (0 - newHeading.trueHeading) * M_PI / 180; // radians after multiplication
    
    double offset = 0;
   
    if (self.targetLocation) {
        
        CLLocationDegrees offsetDegress = [self offsetOfTargetLocation:self.targetLocation fromLocation:self.currentLocation];
        
        offset = offsetDegress * M_PI / 180;

    }

    self.compassImageView.transform = CGAffineTransformMakeRotation(northHeading + offset);
    
    
//    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        
//       
//        
//        
//        
////        needle.transform = CGAffineTransformMakeRotation((degrees-newHeading.trueHeading) * M_PI / 180);
//        
//    } completion:nil];
    

    
}

- (CLLocationDegrees) offsetOfTargetLocation:(CLLocation *)targetLocation fromLocation:(CLLocation*)referenceLocation {
    
    // Give an offset in degrees away from north
    
    double offsetRadians = 0;

    
    double tarLat = targetLocation.coordinate.latitude;
    double tarLng = targetLocation.coordinate.longitude;
    
    double curLat = referenceLocation.coordinate.latitude;
    double curLng = referenceLocation.coordinate.longitude;
    
    double deltaY = tarLat - curLat;
    double deltaX = tarLng - curLng;
    
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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    self.currentLocation = (CLLocation *)[locations firstObject];
    
//    if (self.targetLocation) {
    
    CLLocationDistance distance = [self.currentLocation distanceFromLocation:self.targetLocation];
    
    self.distanceRemianingLabel.text = [NSString stringWithFormat:@"Dis Remaining: %f",distance];
        
//    }
    
}

@end
