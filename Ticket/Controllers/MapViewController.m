//
//  MapVC.m
//  Ticket
//
//  Created by Артем Б on 10.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import "MapViewController.h"
#import "LocationService.h"
#import "APIManager.h"
#import "City.h"
#import "MapPrice.h"

#define MAP_TAB NSLocalizedString(@"map_tab", nil)

@interface MapViewController ()<MKMapViewDelegate>

@property (nonatomic, strong) MKMapView* mapView;
@property (nonatomic, strong) LocationService* locationService;
@property (nonatomic, strong) City *origin;
@property (nonatomic, strong) NSArray* prices;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = MAP_TAB;
    _mapView = [[MKMapView alloc] initWithFrame: self.view.bounds];
    _mapView.showsUserLocation = true;
    _mapView.delegate = self;
    [self.view addSubview: _mapView];
    
    [[DataManager sharedInstance] loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(dataLoadedSuccessfully)
                                                 name:kDataManagerLoadDataDidComplete object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(updateCurrentLocation:)
                                                 name:kLocationServiceDidUpdateCurrentLocation object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dataLoadedSuccessfully {
    _locationService = [LocationService new];
}

- (void)updateCurrentLocation:(NSNotification*)notification {
    CLLocation *currentLocation = notification.object;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000000, 1000000);
    [_mapView setRegion: region animated: true];
    [self addressFromLocation:currentLocation];
    
    if (currentLocation) {
        _origin = [[DataManager sharedInstance] cityForLocation: currentLocation];
        if (_origin) {
            [[APIManager sharedInstance] mapPricesFor:_origin withCompletion:^(NSArray *prices) {
                self.prices = prices;
            }];
        }
    }
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        
        return nil;
    }
    static NSString *identifier = @"MarkerIdentifier";
    MKMarkerAnnotationView* annotationView = (MKMarkerAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView) {
        annotationView = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.canShowCallout = true;
        annotationView.calloutOffset = CGPointMake(-5.0, 5.0);
        UIButton *infoButtonAnnotation = [UIButton buttonWithType: UIButtonTypeDetailDisclosure];
        [infoButtonAnnotation addTarget:self action:@selector(annoButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView = infoButtonAnnotation;
    } else {
        annotationView.annotation = annotation;
    }
    return annotationView;
}

- (void)setPrices:(NSArray *)prices {
    _prices = prices;
    [_mapView removeAnnotations: _mapView.annotations];
    
    
    
    for (MapPrice *price in prices) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.title = [NSString stringWithFormat:@"%@ (%@)", price.destination.name, price.destination.code];
            annotation.subtitle = [NSString stringWithFormat:@"%ld руб.", (long)price.value];
            annotation.coordinate = price.destination.coordinate;
            [_mapView addAnnotation:annotation];
        });
    }
}

- (void)annoButtonDidTap:(UIButton*)sender{
    
}


- (void)addressFromLocation:(CLLocation*)location {
    CLGeocoder* geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if ([placemarks count] > 0){
            for (MKPlacemark* placemark in placemarks) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    _mapView.userLocation.title = [NSString stringWithFormat:@"%@ (%@)", placemark.name, placemark.country];

                });
            }
        }
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
