//
//  ViewController.m
//  CLHeading Demo
//
//  Created by Henry Chan on 7/28/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "CompassViewController.h"
#import "DestinationDataStore.h"

//typedef enum {
//    TargetDestinationTypeFinalLocation,
//    TargetDestinationTypePointOfInterest
//} TargetDestinationType;

@interface CompassViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *magneticHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *trueHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentLatLngLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationLatLngLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceRemianingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *compassImageView;

@property (nonatomic, strong) CLLocationManager *locationManger;
//@property (nonatomic, strong) CLLocation *destinationLocation;
@property (nonatomic, strong) DestinationDataStore *destinationDataStore;
@property (nonatomic, strong) CLLocation *currentLocation;


@property (nonatomic, strong) CLLocation *currentTargetDestination;

@end

@implementation CompassViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 40.7470041,-73.8908797
    self.destinationDataStore = [DestinationDataStore sharedTargetDestination];
    
//    self.destinationLocation = [[CLLocation alloc] initWithLatitude:40.7470041 longitude:-73.8908797];
    
//    self.destinationLatLngLabel.text = [NSString stringWithFormat:@"Destination Lat: %.03f Lng: %.03f",self.destinationLocation.coordinate.latitude, self.destinationLocation.coordinate.longitude];
    
    
    
    self.locationManger = [CLLocationManager new];
    self.locationManger.delegate = self;
    // https://developer.apple.com/library/prerelease/ios/documentation/CoreLocation/Reference/CoreLocationConstantsRef/index.html#//apple_ref/c/data/kCLLocationAccuracyBestForNavigation
    self.locationManger.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [self.locationManger startUpdatingHeading];
    [self.locationManger startUpdatingLocation];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    

    [self setCurrentHeading];
    
    
}

- (void) setCurrentHeading {
    
    if (self.destinationDataStore.currentTargetDestinationType == TargetDestinationTypeNone) {
        
        self.destinationLatLngLabel.text = @"Destination not set...";
        
    } else if (self.destinationDataStore.currentTargetDestinationType == TargetDestinationTypeFinalLocation) {
        
        self.currentTargetDestination = self.destinationDataStore.finalLocation;
        
        self.destinationLatLngLabel.text = [NSString stringWithFormat:@"Destination Lat: %.03f Lng: %.03f",self.currentTargetDestination.coordinate.latitude, self.currentTargetDestination.coordinate.longitude];
        
    } else if (self.destinationDataStore.currentTargetDestinationType == TargetDestinationTypePointOfInterest) {
        
        self.currentTargetDestination = self.destinationDataStore.pointOfInterest;
        
        self.destinationLatLngLabel.text = [NSString stringWithFormat:@"Destination Lat: %.03f Lng: %.03f",self.currentTargetDestination.coordinate.latitude, self.currentTargetDestination.coordinate.longitude];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
 
//    if (self.currentLocation) {

        self.magneticHeadingLabel.text = [NSString stringWithFormat:@"Mag Heading: %f", newHeading.magneticHeading];
        
        self.trueHeadingLabel.text = [NSString stringWithFormat:@"True Heading: %f", newHeading.trueHeading];

        self.currentLatLngLabel.text = [NSString stringWithFormat:@"Current Lat: %.03f Lng: %.03f",self.locationManger.location.coordinate.latitude, self.locationManger.location.coordinate.longitude];
        
        double northHeading =  -newHeading.trueHeading; // degrees
        
        self.compassImageView.transform = CGAffineTransformMakeRotation(northHeading * M_PI / 180); // Setting it to true north
//    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    self.currentLocation = (CLLocation *)[locations firstObject];
    
    if (self.currentTargetDestination) {
        
        CLLocationDistance distance = [self.currentLocation distanceFromLocation:self.currentTargetDestination];
        
        self.distanceRemianingLabel.text = [NSString stringWithFormat:@"Distance Remaining: %.04f",distance];
        
    }
    
//    self.currentSpeed.text = [NSString stringWithFormat:@"Current Speed: %f", self.destinationLocation.speed];
    
}

@end
