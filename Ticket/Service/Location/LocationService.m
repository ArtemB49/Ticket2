//
//  LocationService.m
//  Ticket
//
//  Created by Артем Б on 10.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import "LocationService.h"

@interface LocationService()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLLocation* currentLocation;

@end

@implementation LocationService

- (instancetype)init{
    self = [super init];
    if (self) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        [_locationManager requestAlwaysAuthorization];
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [_locationManager startUpdatingLocation];
        
    } else if (status != kCLAuthorizationStatusNotDetermined){
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Упс!" message:@"Не удалось определить текущий город" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDefault handler:nil]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController: alertController animated:true completion:nil];
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (!_currentLocation) {
        _currentLocation = [locations firstObject];
        [_locationManager stopUpdatingLocation];
        [[NSNotificationCenter defaultCenter] postNotificationName: kLocationServiceDidUpdateCurrentLocation object: _currentLocation];
    }
}

@end
