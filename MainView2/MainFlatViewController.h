//
//  MainFlatViewController.h
//  DisasterHelper
//
//  Created by ENCLAVEIT on 3/20/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Server.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>


@interface MainFlatViewController : UIViewController<UIAccelerometerDelegate, UIAlertViewDelegate,GMSMapViewDelegate,CLLocationManagerDelegate>
{
    NSTimer *countdownTimer;
    NSString *longAtt;
    NSString *latAtt;
        
    __weak IBOutlet UIImageView *WeatherImage;
    IBOutlet UIImageView *hideMapImage;
   __weak IBOutlet GMSMapView *mapView;
    IBOutlet UINavigationItem *navigatorMainFlat;
    IBOutlet UILabel *sendRequestHelpLabel;
    __weak IBOutlet UILabel *Currentweather;
    IBOutlet UILabel *placeWeatherLabel;
    IBOutlet UILabel *tenkiWeatherLabel;
    IBOutlet UILabel *dayWeatherLabel;
    CLLocationManager *locationManager;
    
}

@property (nonatomic, strong) CLLocation *currentLocation;
//- (IBAction)updateWeather:(id)sender;
-(void)getWeather;
@property (nonatomic, strong) NSString *userLocation;
- (IBAction)sendRequestHelp:(id)sender;

@end
