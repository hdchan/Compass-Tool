//
//  ViewController.m
//  CLHeading Demo
//
//  Created by Henry Chan on 7/28/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface ViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *magneticHeading;
@property (weak, nonatomic) IBOutlet UILabel *trueHeading;
@property (weak, nonatomic) IBOutlet UILabel *currentLatLng;
@property (weak, nonatomic) IBOutlet UILabel *destinationLatLng;
@property (weak, nonatomic) IBOutlet UILabel *distanceRemianing;
@property (weak, nonatomic) IBOutlet UIImageView *compass;
@property (nonatomic, strong) CLLocationManager *locationManger;
@property (nonatomic, strong) CLLocation *destinationLocation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 40.7470041,-73.8908797
    self.destinationLocation = [[CLLocation alloc] initWithLatitude:40.7470041 longitude:-73.8908797];
    
    self.destinationLatLng.text = [NSString stringWithFormat:@"Destination Lat: %.03f Lng: %.03f",self.destinationLocation.coordinate.latitude, self.destinationLocation.coordinate.longitude];
    
    self.locationManger = [CLLocationManager new];
    self.locationManger.delegate = self;
    [self.locationManger startUpdatingHeading];
    [self.locationManger startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
 
    self.magneticHeading.text = [NSString stringWithFormat:@"Mag Heading:%f", newHeading.magneticHeading];
    self.trueHeading.text = [NSString stringWithFormat:@"True Heading: %f", newHeading.trueHeading];
    
    self.currentLatLng.text = [NSString stringWithFormat:@"Current Lat: %.03f Lng: %.03f",self.locationManger.location.coordinate.latitude, self.locationManger.location.coordinate.longitude];
    
    self.compass.transform = CGAffineTransformMakeRotation((NSInteger)-newHeading.trueHeading * M_PI / 180); // Setting it to true north
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    NSLog(@"Updating Location");
    
    CLLocation *currentLocation = (CLLocation *)[locations firstObject];
    
    CLLocationDistance distance = [currentLocation distanceFromLocation:self.destinationLocation];
    
    self.distanceRemianing.text = [NSString stringWithFormat:@"Distance Remainig: %.04f",distance];
    
}

@end
