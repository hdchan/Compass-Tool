//
//  ViewController.m
//  CLHeading Demo
//
//  Created by Henry Chan on 7/28/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "CompassViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface CompassViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *magneticHeading;
@property (weak, nonatomic) IBOutlet UILabel *trueHeading;
@property (weak, nonatomic) IBOutlet UILabel *currentLatLng;
@property (weak, nonatomic) IBOutlet UILabel *destinationLatLng;
@property (weak, nonatomic) IBOutlet UILabel *distanceRemianing;
@property (weak, nonatomic) IBOutlet UIImageView *compass;
@property (nonatomic, strong) CLLocationManager *locationManger;
@property (nonatomic, strong) CLLocation *destinationLocation;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (weak, nonatomic) IBOutlet UILabel *currentSpeed;

@end

@implementation CompassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 40.7470041,-73.8908797
    self.destinationLocation = [[CLLocation alloc] initWithLatitude:40.7470041 longitude:-73.8908797];
    
    self.destinationLatLng.text = [NSString stringWithFormat:@"Destination Lat: %.03f Lng: %.03f",self.destinationLocation.coordinate.latitude, self.destinationLocation.coordinate.longitude];
    
    self.locationManger = [CLLocationManager new];
    self.locationManger.delegate = self;
    // https://developer.apple.com/library/prerelease/ios/documentation/CoreLocation/Reference/CoreLocationConstantsRef/index.html#//apple_ref/c/data/kCLLocationAccuracyBestForNavigation
    self.locationManger.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [self.locationManger startUpdatingHeading];
    [self.locationManger startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
 
    if (self.currentLocation) {

        self.magneticHeading.text = [NSString stringWithFormat:@"Mag Heading: %f", newHeading.magneticHeading];
        
        self.trueHeading.text = [NSString stringWithFormat:@"True Heading: %f", newHeading.trueHeading];

        self.currentLatLng.text = [NSString stringWithFormat:@"Current Lat: %.03f Lng: %.03f",self.locationManger.location.coordinate.latitude, self.locationManger.location.coordinate.longitude];
        
//        double adjacent = self.currentLocation.coordinate.latitude - self.destinationLocation.coordinate.latitude;
//        double opposite = self.currentLocation.coordinate.longitude - self.destinationLocation.coordinate.longitude;
//        
//        double OA = opposite / adjacent;
//        double destinationHeading = atan(OA); // radians
//        
        double northHeading =  -newHeading.trueHeading; // degrees
        
//        double destinationHeading = 0 - northOffset + destinationOffset;
        
        self.compass.transform = CGAffineTransformMakeRotation(northHeading * M_PI / 180); // Setting it to true north
    }
    
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    self.currentLocation = (CLLocation *)[locations firstObject];
    
    CLLocationDistance distance = [self.currentLocation distanceFromLocation:self.destinationLocation];
    
    self.distanceRemianing.text = [NSString stringWithFormat:@"Distance Remaining: %.04f",distance];
    
    self.currentSpeed.text = [NSString stringWithFormat:@"Current Speed: %f", self.currentLocation.speed];
    
}

@end
