//
//  RootViewController.h
//  DisasterHelper
//
//  Created by Tu (Tony) A. TRAN on 2/14/14.
//  Copyright (c) 2014 Tu (Tony) A. TRAN. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DHGeoforDirections.h"

@interface RootViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>

{
    CLLocationManager *locationManager;
    __weak IBOutlet UIButton *geocoder;
    __weak IBOutlet UITextField *inputField;
    __weak IBOutlet UIButton *WeatherUnit;


}
- (IBAction)MydetailWeather:(id)sender;

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) DHGeoforDirections *gs;
- (IBAction)geocoderAction:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) NSString *userLocation;
- (IBAction)ChangeUnit:(id)sender;


@end
