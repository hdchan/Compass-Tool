//
//  MapViewController.m
//  Compass Tool
//
//  Created by Henry Chan on 7/30/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "DestinationDataStore.h"

@interface MapViewController () <CLLocationManagerDelegate, GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) DestinationDataStore *destinationDataStore;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [GMSServices provideAPIKey:@"AIzaSyARC-PfIvJxca9IZfLfZcB6xz7C_87FAZw"];
    
    self.mapView.delegate = self;
    
    self.destinationDataStore = [DestinationDataStore sharedTargetDestination];
    
    self.mapView.mapType = kGMSTypeTerrain;

    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:newLocation.coordinate.latitude
                                                            longitude:newLocation.coordinate.longitude
                                                                 zoom:14.0];
    
    [self.mapView setCamera:camera];
    
    [manager stopUpdatingLocation];

}

-(void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
    CLLocation *selectedLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    GMSMarker *marker = [GMSMarker markerWithPosition:selectedLocation.coordinate];
    [self.mapView clear];
    marker.map = self.mapView;
    
    self.destinationDataStore.finalLocation = selectedLocation;
    self.destinationDataStore.currentTargetDestinationType = TargetDestinationTypeFinalLocation;
    
}

@end
