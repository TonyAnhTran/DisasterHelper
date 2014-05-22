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
    self.popUpView.hidden=YES;
    self.popUpView.layer.cornerRadius = 5;
    self.popUpView.layer.masksToBounds = YES;
    
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
        if (![inputField.text isEqualToString:@""]) {
            SEL sel = @selector(addMarker);
            //[self performSelector:@selector(addMarker)];
            NSLog(@"%@",NSStringFromSelector(sel));
            [gs geocodeAddress:inputField.text withCallback:@selector(addMarker) withDelegate:self];
        }
        
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
    
    inputField.text=nil;
    // center the region around this map item's coordinate
    // self.mapView.centerCoordinate = markercoor;
    
}

#pragma mark - Actions

- (IBAction)dismissKeyboard:(id)sender {
    [inputField resignFirstResponder];
}

- (IBAction)MydetailWeather:(id)sender {
    self.popUpView.hidden=NO;
    
    NSError* error;
    NSString *latwea =[NSString stringWithFormat:@"%f",mapView.region.center.latitude];
    NSString *lngwea =[NSString stringWithFormat:@"%f",mapView.region.center.longitude];
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
        //    NSString *mainweather= [weather1 objectForKey:@"main"];
            NSString *maindescription= [weather1 objectForKey:@"description"];
            
            NSDictionary *wind = [json objectForKey:@"wind"];
        //    NSString *windeg= [wind objectForKey:@"deg"];
            NSString *winspeed= [wind objectForKey:@"speed"];
            
            
            //NSLog(@"test %@",mainweather);
            
            NSDictionary *temp = [json objectForKey:@"main"];
            // NSLog(@"test2 %@",temp);
            NSString *currenttemp= [temp objectForKey:@"temp"];
            CGFloat flcurrenttemp = (CGFloat)[currenttemp floatValue];
            int curenttempint = (int)roundf(flcurrenttemp);
            
            NSString *mintemp= [temp objectForKey:@"temp_min"];
            CGFloat flmintemp = (CGFloat)[mintemp floatValue];
            int mintempint = (int)roundf(flmintemp);
            
            NSString *maxtemp= [temp objectForKey:@"temp_max"];
            CGFloat flmaxtemp = (CGFloat)[maxtemp floatValue];
            int maxtempint = (int)ceilf(flmaxtemp);
            
            NSString *pressure= [temp objectForKey:@"pressure"];
            NSString *humidity= [temp objectForKey:@"humidity"];
            
            self.popUpTitle.text=@"Map center's weather";
            self.popUpSky.text=[NSString stringWithFormat:@"Sky: %@",maindescription];
            
            if ([unit isEqualToString:@"metric"]) {
                self.popUpTemp.text=[NSString stringWithFormat:@"Temp: %i°C",curenttempint];
                self.popUpRange.text=[NSString stringWithFormat:@"Range: %i°C-%i°C",mintempint,maxtempint];
            }
            else{
                self.popUpTemp.text=[NSString stringWithFormat:@"nTemp: %i°F",curenttempint];
                  self.popUpRange.text=[NSString stringWithFormat:@"Range: %i°F-%i°F",mintempint,maxtempint];

            }
            self.popUpHumidity.text=[NSString stringWithFormat:@"Humidity: %@%%",humidity];
            self.popUpPressure.text=[NSString stringWithFormat:@"Pressure: %@ hpa",pressure];
            self.popUpWind.text=[NSString stringWithFormat:@"Wind speed: %@ m/s",winspeed];
            

        }
        
        @catch (NSException *exception) {
            UIAlertView *error=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Sorry, we can't get weather data in that place now, try again late" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [error show];
        }
        @finally {
        }
        
    }
}

- (IBAction)popUpOk:(id)sender {
    self.popUpView.hidden=YES;
    
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
