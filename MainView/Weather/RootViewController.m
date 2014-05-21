//
//  RootViewController.m
//  DisasterHelper
//
//  Created by Tu (Tony) A. TRAN on 2/14/14.
//  Copyright (c) 2014 Tu (Tony) A. TRAN. All rights reserved.
//
//

#import "RootViewController.h"
#import "WLWeatherLayer.h"
#import "WLWeatherLayerView.h"
#import "DHGeoforDirections.h"

@interface RootViewController ()
@property (nonatomic, strong) WLWeatherLayer *weatherLayer;
@end

@interface RootViewController (MKMapViewDelegate) <MKMapViewDelegate>
@end

@implementation RootViewController
@synthesize mapView;
@synthesize gs;
@synthesize currentLocation,userLocation;


#pragma mark - View lifecycle
-(void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    //Custom navigator back button
    
    UIImage *buttonImage = [UIImage imageNamed:@"back111.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    
    [super viewDidLoad];
    gs = [[DHGeoforDirections alloc] init];
    self.title = @"Weather";
    
    mapView.zoomEnabled       = YES;
    mapView.scrollEnabled     = YES;
    mapView.showsUserLocation = YES;
    
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    locationManager.distanceFilter = 10.0f;
    
    
    CLLocation *location = locationManager.location;
    
    locationManager.headingFilter = kCLHeadingFilterNone;
    [locationManager startUpdatingHeading];
    
    MKCoordinateRegion centerRegion;
    centerRegion.center.latitude  = location.coordinate.latitude;
    centerRegion.center.longitude = location.coordinate.longitude;
    
    centerRegion.span.latitudeDelta  = 0.1;
    centerRegion.span.longitudeDelta = 0.1;
    
    mapView.region = centerRegion;
    
    [WeatherUnit setTitle:@"°F" forState:UIControlStateNormal];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
   	NSString *internetStatus=[user objectForKey:@"Internet"];
    
    if ([internetStatus isEqualToString:@"NO"]) {
        NSLog(@"Run with out network and don't do any thing in weather view");
    } else if([internetStatus isEqualToString:@"YES"]) {
        self.weatherLayer = [[WLWeatherLayer alloc] init];
        [self.mapView addOverlay:self.weatherLayer];
    }
    
    [self setupInputAccessory];
}


-(void)CurrentLocationIdentifier
{
    //---- For getting current gps location
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    //------
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    currentLocation = newLocation;
    
}
- (void)setupInputAccessory {
    
    UIToolbar *doneToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    doneToolbar.barStyle = UIBarStyleBlackTranslucent;
    
    doneToolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelKeyboard:)],
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithKeyboard:)],
                         nil];
    
    [doneToolbar sizeToFit];
    
    inputField.inputAccessoryView = doneToolbar;
    
    inputField.inputAccessoryView.tintColor = [UIColor whiteColor];
    
    
}


- (void) cancelKeyboard: (UITextField *) textField {
    
    [inputField resignFirstResponder];
}

- (void) doneWithKeyboard: (UITextField *) textField {
    [inputField resignFirstResponder];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
   	NSString *internetStatus=[user objectForKey:@"Internet"];
    
    if ([internetStatus isEqualToString:@"NO"]) {
        NSLog(@"Run with out network and you can't search any thing");
        
    } else if([internetStatus isEqualToString:@"YES"]) {
        [inputField resignFirstResponder];
        SEL sel = @selector(addMarker);
        //[self performSelector:@selector(addMarker)];
        
        NSLog(@"%@",NSStringFromSelector(sel));
        [gs geocodeAddress:inputField.text withCallback:@selector(addMarker) withDelegate:self];
    }
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)addMarker {
    //MKMapItem *item =[[MKMapItem alloc]init];
    
    double lat = [[gs.geocode objectForKey:@"lat"] doubleValue];
    double lng = [[gs.geocode objectForKey:@"lng"] doubleValue];
    
    CLLocationCoordinate2D markercoor = CLLocationCoordinate2DMake(lat,lng);
    
    // item.placemark.coordinate = markercoor;
    
    MKCoordinateRegion centerRegion;
    centerRegion.center.latitude  = markercoor.latitude;
    centerRegion.center.longitude = markercoor.longitude;
    
    centerRegion.span.latitudeDelta  = 0.1;
    centerRegion.span.longitudeDelta = 0.1;
    
    mapView.region = centerRegion;
    
    // center the region around this map item's coordinate
    // self.mapView.centerCoordinate = markercoor;
    
}

#pragma mark - Actions

- (IBAction)dismissKeyboard:(id)sender {
    [inputField resignFirstResponder];
}

- (IBAction)MydetailWeather:(id)sender {
    NSError* error;
    NSString *latwea =[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    NSString *lngwea =[NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
   	NSString *internetStatus=[user objectForKey:@"Internet"];
    
    if ([internetStatus isEqualToString:@"NO"]) {
        NSLog(@"Run with out network and can get weather");
    }
    else if([internetStatus isEqualToString:@"YES"]) {
        @try {
            NSString *unit=[NSString stringWithFormat:@"metric"];
            NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
            // NSString *unit=@"metric";
            unit=[setting  valueForKey:@"WeatherUnit"];
            
            NSString *weatherUrl = @"http://api.openweathermap.org/data/2.5/weather?";
            NSString *url = [NSString stringWithFormat:@"%@lat=%@&lon=%@&mode=json&units=%@",weatherUrl,latwea,lngwea,unit];
            url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            
            NSLog(@"WEARHER URL :%@",url);
            NSURL *resulturl = [NSURL URLWithString:url];
            NSData *data = [NSData dataWithContentsOfURL: resulturl];
            NSDictionary *json = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:kNilOptions
                                  error:&error];
            
            
            // NSLog(@"Test 4: %@",json);
            NSArray *weather = [json objectForKey:@"weather"];
            NSDictionary *weather1 = [weather objectAtIndex:0];
            NSString *mainweather= [weather1 objectForKey:@"main"];
            NSString *maindescription= [weather1 objectForKey:@"description"];
            
            NSDictionary *wind = [json objectForKey:@"wind"];
            NSString *windeg= [wind objectForKey:@"deg"];
            NSString *winspeed= [wind objectForKey:@"speed"];
            
            
            //NSLog(@"test %@",mainweather);
            
            NSDictionary *temp = [json objectForKey:@"main"];
            // NSLog(@"test2 %@",temp);
            NSString *currenttemp= [temp objectForKey:@"temp"];
            CGFloat flcurrenttemp = (CGFloat)[currenttemp floatValue];
            int curenttempint = (int)ceilf(flcurrenttemp);
            
            NSString *mintemp= [temp objectForKey:@"temp_min"];
            CGFloat flmintemp = (CGFloat)[mintemp floatValue];
            int mintempint = (int)ceilf(flmintemp);
            
            NSString *maxtemp= [temp objectForKey:@"temp_max"];
            CGFloat flmaxtemp = (CGFloat)[maxtemp floatValue];
            int maxtempint = (int)roundf(flmaxtemp);
            
            NSString *pressure= [temp objectForKey:@"temp_max"];
            NSString *humidity= [temp objectForKey:@"humidity"];
            
            if ([unit isEqualToString:@"metric"]) {
                NSString *labeltext= [NSString stringWithFormat:@"Sky: %@\nTemp: %i°C\nRange: %i°C-%i°C \nHumidity: %@%%\nPressure: %@ hpa\n\nWind speed: %@ m/s\nWind direction: %@°",maindescription,curenttempint,mintempint,maxtempint,humidity,pressure,winspeed,windeg];
                UIAlertView *weatheralert =[[UIAlertView alloc]initWithTitle:@"Your location weather" message:labeltext delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [weatheralert show];
                
                NSArray *subviewArray = weatheralert.subviews;
                for(int x = 0; x < [subviewArray count]; x++){
                    
                    if([[[subviewArray objectAtIndex:x] class] isSubclassOfClass:[UILabel class]]) {
                        // UILabel *label = [subviewArray objectAtIndex:x];
                        // label.textAlignment = UITextAlignmentLeft;
                    }
                }
                
            } else {
                NSString *labeltext= [NSString stringWithFormat:@"Sky: %@\nTemp: %i°F\nRange: %i°F-%i°F \nHumidity: %@%%\nPressure: %@ hpa\n \nWind speed: %@ m/s\nWind direction: %@°",maindescription,curenttempint,mintempint,maxtempint,humidity,pressure,winspeed,windeg];
                UIAlertView *weatheralert =[[UIAlertView alloc]initWithTitle:@"Your location weather" message:labeltext delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [weatheralert show];
                
                NSArray *subviewArray = weatheralert.subviews;
                for(int x = 0; x < [subviewArray count]; x++){
                    
                    if([[[subviewArray objectAtIndex:x] class] isSubclassOfClass:[UILabel class]]) {
                        UILabel *label = [subviewArray objectAtIndex:x];
                        label.textAlignment = UITextAlignmentLeft;
                    }
                }
                
            }
            
        }
        
        @catch (NSException *exception) {
            NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
            NSString *unit2=[setting  valueForKey:@"WeatherUnit2"];
            // backup weather api
            NSString *weatherUrl2 =[NSString stringWithFormat:@"http://www.myweather2.com/developer/forecast.ashx?uac=TRdO4RNAQt&output=json&temp_unit=%@&",unit2];
            NSString *url2 = [NSString stringWithFormat:@"%@query=%@,%@",weatherUrl2,latwea,lngwea];
            url2 = [url2 stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            
            NSLog(@"WEARHER URL :%@",url2);
            NSURL *resulturl = [NSURL URLWithString:url2];
            NSData *data = [NSData dataWithContentsOfURL: resulturl];
            NSDictionary *json = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:kNilOptions
                                  error:&error];
            
            
            
            //        NSArray *weather = [json objectForKey:@"weather"];
            //        NSDictionary *weather1 = [weather objectAtIndex:0];
            //        NSString *mainweather= [weather1 objectForKey:@"main"];
            //NSLog(@"test %@",mainweather);
            
            
            NSDictionary *weather=[json objectForKey:@"weather"];
            
            NSDictionary *currentweather=[weather objectForKey:@"current_weather"];
            // NSDictionary *currentweather=[currentweathe objectAtIndex:0];
            NSString *currenttemp= [currentweather objectForKey:@"temp"];
            NSString *humidity= [currentweather objectForKey:@"humidity"];
            NSString *mainweather= [currentweather objectForKey:@"weather_text"];
            
            
            NSArray *forecast=[weather objectForKey:@"forecast"];
            
            NSDictionary *todaydate=[forecast objectAtIndex:0];
            
            NSString *mintemp= [todaydate objectForKey:@"night_min_temp"];
            NSString *maxtemp= [todaydate objectForKey:@"day_max_temp"];
            
            
            NSString *labeltext= [NSString stringWithFormat:@"Sky: %@\nTemp: %@°\nRange: %@°-%@° \nHumidity: %@%%",mainweather,currenttemp,mintemp,maxtemp,humidity];
            NSLog(@"label text %@",labeltext);
            
            
            
        }
        @finally {
        }
        
    }
}
- (IBAction)ChangeUnit:(id)sender {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
   	NSString *internetStatus=[user objectForKey:@"Internet"];
    
    if ([internetStatus isEqualToString:@"NO"]) {
        NSLog(@"Run with out network and don't do any thing");
    } else if([internetStatus isEqualToString:@"YES"]) {
        if ([WeatherUnit.currentTitle isEqualToString:@"°C"]) {
            self.weatherLayer.unitType=WLWeahterLayerUnitTypeF;
            [WeatherUnit setTitle:@"°F" forState:UIControlStateNormal];
            [self reloadLayer];
        }
        else if([WeatherUnit.currentTitle isEqualToString:@"°F"])
        {
            self.weatherLayer.unitType=!WLWeahterLayerUnitTypeF;
            [WeatherUnit setTitle:@"°C" forState:UIControlStateNormal];
            [self reloadLayer];
        }
        
    }
    
}
#pragma mark - Private method

- (void)reloadLayer
{
    [self.mapView removeOverlay:self.weatherLayer];
    [self.mapView addOverlay:self.weatherLayer];
}



@end


#pragma mark -
@implementation RootViewController (MKMapViewDelegate)

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if (overlay == self.weatherLayer) {
        WLWeatherLayerView *view = [[WLWeatherLayerView alloc] initWithOverlay:overlay];
        return view;
    }
    
    return nil;
}
- (IBAction)mylocation:(id)sender {
    locationManager = [[CLLocationManager alloc] init];
    [locationManager startUpdatingLocation];
    
    
    CLLocation *location = locationManager.location;
    
    MKCoordinateRegion centerRegion;
    centerRegion.center.latitude  = location.coordinate.latitude;
    centerRegion.center.longitude = location.coordinate.longitude;
    
    centerRegion.span.latitudeDelta  = 0.1;
    centerRegion.span.longitudeDelta = 0.1;
    
    mapView.region = centerRegion;
}

@end
