//
//  MainFlatViewController.m
//  DisasterHelper
//
//  Created by ENCLAVEIT on 3/20/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import "MainFlatViewController.h"

@interface MainFlatViewController ()<UITextFieldDelegate>{
    BOOL firstLocationUpdate_;
    
    }

@end
NSInteger secondsCount1 = 30;
UIAlertView *alert;
UIAlertView *successAlert;
UIAlertView *invalidFormatAlert;
UIAlertView *notexistAlert;
UIAlertView *confirm;

NSTimer *getdateSchedule;
NSTimer *getcitySchedule;
NSTimer *updatelocationSchedule;
NSTimer *updateweatherSchedule;
NSTimer *updateMapViewSchedule;

@implementation MainFlatViewController
@synthesize currentLocation,userLocation;
AVAudioPlayer *audioPlayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    
    //RGB color macro
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
    //Setting background
    self.view.backgroundColor = UIColorFromRGB(0x133353);
    hideMapImage.backgroundColor = UIColorFromRGB(0x133353);
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *internetStatus=[user objectForKey:@"Internet"];
    
    /////
    NSUserDefaults *checkLogin = [NSUserDefaults standardUserDefaults];
    NSString *check = [checkLogin valueForKey:@"checkLogin"];
    
    
    //Check user status
    NSUserDefaults *phonenumber = [NSUserDefaults standardUserDefaults];
    NSString *phoneNumber =[phonenumber valueForKey:@"phone"];
    
    NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
    NSString *ssid=[session objectForKey:@"ssid"];
    
    //set default value for setting view
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    [setting setValue:@"metric" forKey:@"WeatherUnit"];
    [setting setValue:@"driving" forKey:@"DirectionsType"];
    [setting setValue:@"5" forKey:@"RadiusSearch"];
    [setting setValue:@"2" forKey:@"VictimTimeSet"];
    [setting setValue:@"true" forKey:@"NsTimestatus"];

    NSString *Timestatus=[setting objectForKey:@"NsTimestatus"];
    [NSTimer scheduledTimerWithTimeInterval:60 target:self
                                   selector:@selector(checkNStimerstatus) userInfo:nil repeats:YES];
    
    
        if ([internetStatus isEqualToString:@"NO"]) {
            NSLog(@"Run Main flat view without internet");
        }
        else if([internetStatus isEqualToString:@"YES"])
        {
            if ([check isEqualToString:@"LOGIN"]){
                
                NSUserDefaults *ServerUrl = [NSUserDefaults standardUserDefaults];
                NSString *stringurl=[ServerUrl objectForKey:@"serverurl"];
                NSURL *url= [[NSURL alloc] initWithString:stringurl];
                
                
                //    NSURL *url = [[NSURL alloc] initWithString:@"http://192.168.10.115:3000/users"];
                NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] init];
                [myDictionary setObject:@"checkProfile" forKey:@"key"];
                [myDictionary setObject:ssid forKey:@"sid"];
                [myDictionary setObject:phoneNumber forKey:@"phonenumber"];
                
                NSData *myData = [NSJSONSerialization dataWithJSONObject:myDictionary
                                                                 options:kNilOptions
                                                                   error:nil];
                
                
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                [request setHTTPMethod:@"POST"];
                [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:myData];
                
                //Recieve data from server
                NSURLResponse *response;
                NSError *err;
                NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
                // NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                // NSLog(@"This is data %@",responseString);
                NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:responseData
                                                                           options:kNilOptions
                                                                             error:&err];
                //NSLog(@"Response Data is %@",responseDictionary);
                //NSLog(@"msg is %@", [responseDictionary objectForKey:@"msg"]);
                bool resultStt= [[resultData objectForKey:@"status"]boolValue];
                
                
                //false mean need help
                NSLog(@"resultSTT=%d",resultStt);
                
                if (!resultStt) {
                    sendRequestHelpLabel.text=@"Safe now";
                }
                else{
                    sendRequestHelpLabel.text=@"Send Request Help";
                }
            }
            
            
            
            // [self CurrentLocationIdentifier];
            //[self getcityName];
            //[self loadView];
            
            
            if ([Timestatus isEqualToString:@"true"]) {
                //schedule time to get date data about 6 hours
                getdateSchedule= [NSTimer scheduledTimerWithTimeInterval:21600.0 target:self
                                                                selector:@selector(getDate) userInfo:nil repeats:YES];
                //schedule time to update small map view every 1 minutes
                updateMapViewSchedule= [NSTimer scheduledTimerWithTimeInterval:60.0 target:self
                                                                      selector:@selector(updateMapview) userInfo:nil repeats:YES];
                
                //Get city name after load main view 3 seconds
                [NSTimer scheduledTimerWithTimeInterval:3.0 target:self
                                               selector:@selector(getcityName) userInfo:nil repeats:NO];
                //schedule time to update city name every 5 minutes
                getcitySchedule = [NSTimer scheduledTimerWithTimeInterval:300.0 target:self
                                                                 selector:@selector(getcityName) userInfo:nil repeats:YES];
                
                //Send curent location to server after load main view 3 seconds
                [NSTimer scheduledTimerWithTimeInterval:3.0 target:self
                                               selector:@selector(sendlocationtoServer) userInfo:nil repeats:NO];
                //schedule time to send location to server every 1 minutes
                updatelocationSchedule = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self
                                                                        selector:@selector(sendlocationtoServer) userInfo:nil repeats:YES];
                
                
                //get weather data after load main view 5 seconds
                [   NSTimer scheduledTimerWithTimeInterval:4.0 target:self
                                                  selector:@selector(getWeather) userInfo:nil repeats:NO];
                //schedule time for update weather data every n minutes
                updateweatherSchedule = [NSTimer scheduledTimerWithTimeInterval:300.0 target:self
                                                                       selector:@selector(getWeather) userInfo:nil repeats:YES];
            }

            
        }
    
       
    
	//Do any additional setup after loading the view.
        navigatorMainFlat.hidesBackButton=YES;
    
    // Listen to the myLocation property of GMSMapView.
    [mapView addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];

    
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView.myLocationEnabled = YES;
    });
    [self getDate];
    [super viewDidLoad];
}


//-(void)callMap{
//    //[super loadView];
//   GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:currentLocation.coordinate zoom:14];
//  
//    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
//    
//    [mapView setCamera:camera];
//}

-(void)checkNStimerstatus{
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    NSString *Timestatus=[setting objectForKey:@"NsTimestatus"];
    
    if ([Timestatus isEqualToString:@"false"]) {
        [getdateSchedule invalidate];
        getdateSchedule=nil;
        
        [getcitySchedule invalidate];
        getcitySchedule =nil;
        
        [updatelocationSchedule invalidate];
        updatelocationSchedule=nil;
        
        [updateweatherSchedule invalidate];
        updateweatherSchedule=nil;
        
        [updateMapViewSchedule invalidate];
        updateMapViewSchedule =nil;
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//funtion to getdate from current device date
-(void)getDate {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"dd"];
    NSString *myDayString = [NSString stringWithFormat:@"%@",
                             [df stringFromDate:[NSDate date]]];
    
    [df setDateFormat:@"MM"];
    NSString *myMonthString = [NSString stringWithFormat:@"%@",
                               [df stringFromDate:[NSDate date]]];
    
    
    NSDate *now = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"EEE"];
    NSString *week = [dateFormatter stringFromDate:now];
//    [df setDateFormat:@"yyyy"];
//    NSString *myYearString = [NSString stringWithFormat:@"%@",
//                              [df stringFromDate:[NSDate date]]];
    
   // NSLog(@"Day: %@", myDayString);
   // NSLog(@"Month: %@", myMonthString);
   // NSLog(@"Year: %@", myYearString);
    NSLog(@"day: %@", week);
    NSString *Currentdate= [NSString stringWithFormat:@"%@ %@/%@",week,myMonthString,myDayString];
   
    dayWeatherLabel.text = Currentdate;
    
}

//That two funtion to update location without google map 
//-(void)CurrentLocationIdentifier
//{
//    //---- For getting current gps location
//    locationManager = [CLLocationManager new];
//    locationManager.delegate = self;
//    locationManager.distanceFilter = kCLDistanceFilterNone;
//    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    [locationManager startUpdatingLocation];
//    //------
//}

//- (void)locationManager:(CLLocationManager *)manager
//    didUpdateToLocation:(CLLocation *)newLocation
//           fromLocation:(CLLocation *)oldLocation
//{
//    currentLocation = newLocation;
//   
//}

//get weather from Openweather API and one back up AIP
-(void)getWeather{
        
    NSError* error;
    NSString *latwea =[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    NSString *lngwea =[NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    
    @try {
        
       NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
       // NSString *unit=@"metric";
        NSString *unit;
        unit=[setting  valueForKey:@"WeatherUnit"];

        NSString *weatherUrl = @"http://api.openweathermap.org/data/2.5/weather?";
        NSString *url = [NSString stringWithFormat:@"%@lat=%@&lon=%@&mode=json&units=%@",weatherUrl,latwea,lngwea,unit];
        url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
               
        //NSLog(@"WEARHER URL :%@",url);
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
        Currentweather.text=mainweather;
        
        NSString *weathericon=[weather1 objectForKey:@"icon"];
      //  NSLog(@"test %@",weathericon);
        WeatherImage.image=[UIImage imageNamed:weathericon];
        
//        NSString *weathericonurl=@"http://openweathermap.org/img/w/";
//        NSString *fullurl=[NSString stringWithFormat:@"%@%@",weathericonurl,weathericon];
//        NSURL *imageURL = [NSURL URLWithString:fullurl];
//        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
//
//        UIImage *image = [UIImage imageWithData:imageData];
        
        
        
        //NSLog(@"test %@",mainweather);
        
        NSDictionary *temp = [json objectForKey:@"main"];
        // NSLog(@"test2 %@",temp);
        NSString *currenttemp= [temp objectForKey:@"temp"];
        CGFloat flcurrenttemp = (CGFloat)[currenttemp floatValue];
        int curenttempint = (int)ceilf(flcurrenttemp);
        
        NSString *mintemp= [temp objectForKey:@"temp_min"];
       // NSLog(@"Test 1: %@",mintemp);
        CGFloat flmintemp = (CGFloat)[mintemp floatValue];
       // NSLog(@"Test 2: %f",flmintemp);
        int mintempint = (int)ceilf(flmintemp);
       // NSLog(@"Test 3: %i",mintempint);
        
        NSString *maxtemp= [temp objectForKey:@"temp_max"];
        CGFloat flmaxtemp = (CGFloat)[maxtemp floatValue];
        int maxtempint = (int)roundf(flmaxtemp);
        
       // NSLog(@"Test min,max: %@,%@",mintemp,maxtemp);
        
        //  NSString *pressure= [temp objectForKey:@"temp_max"];
        NSString *humidity= [temp objectForKey:@"humidity"];
        
     
        // NSLog(@"label text %@",labeltext);
        
        
        if ([unit isEqualToString:@"metric"])
        {
            NSString *labeltext= [NSString stringWithFormat:@"Sky: %@\nTemp: %i°C\nRange: %i°-%i°C \nHumidity: %@%%",mainweather,curenttempint,mintempint,maxtempint,humidity];
            tenkiWeatherLabel.text = labeltext;
        }
        else
        {
            NSString *labeltext= [NSString stringWithFormat:@"Sky: %@\nTemp: %i°F\nRange: %i°-%i°F\nHumidity: %@%%",mainweather,curenttempint,mintempint,maxtempint,humidity];
            tenkiWeatherLabel.text = labeltext;
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
        tenkiWeatherLabel.text = labeltext;

        
    }
    @finally {
    }

}

//Get city name by Apple geocoder service
-(void)getcityName{
    //get City name
    
    //NSLog(@"curent coor: %f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation
                   completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error){
             NSLog(@"Geocode failed with error: %@", error);
             return;
         }
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         // NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
         //  NSLog(@"postalCode %@",placemark.postalCode);
          //  NSLog(@"locality %@",placemark.locality);
         
         if (placemark.locality==NULL) {
             if(placemark.subLocality==NULL){
                 NSString *currentcity =[NSString stringWithFormat:@"%@",placemark.administrativeArea];
                 placeWeatherLabel.text = currentcity;
                 placeWeatherLabel.font=[placeWeatherLabel.font fontWithSize:14];
             }
             else{
                 NSString *currentcity =[NSString stringWithFormat:@"%@",placemark.subLocality];
                 placeWeatherLabel.text = currentcity;
                 
             }
             
         }
         else{
             NSString *currentcity =[NSString stringWithFormat:@"%@",placemark.locality];
             placeWeatherLabel.text = currentcity;
             placeWeatherLabel.font=[placeWeatherLabel.font fontWithSize:16];
         }
         
     }];

}


- (void)dealloc {
    [mapView removeObserver:self
                  forKeyPath:@"myLocation"
                     context:NULL];
}
#pragma mark - KVO updates

//Set default small Map camera positon to current location
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!firstLocationUpdate_) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        firstLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                            zoom:14];
        
    }
    currentLocation = mapView.myLocation;
    
}

//Funtion to update mapview
-(void)updateMapview{
    CLLocation *location = mapView.myLocation;
    if (location) {
        mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                        zoom:14];
        [mapView animateToLocation:location.coordinate];
    }
    
}

//Funtion to send location to server
-(void)sendlocationtoServer{
    
    NSUserDefaults *checkLogin = [NSUserDefaults standardUserDefaults];
    NSString *check = [checkLogin valueForKey:@"checkLogin"];
    
    
    if ([check isEqualToString:@"LOGIN"])
    {
        userLocation=[NSString stringWithFormat:@"%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude];
        // NSLog(@"userlocation: %@",userLocation);
        NSUserDefaults *phonenumber = [NSUserDefaults standardUserDefaults];
        NSString *userPhone =[phonenumber valueForKey:@"phone"];
        NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
        NSString *ssid=[session objectForKey:@"ssid"];
        
        NSString *userlat = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
        NSString *userlong = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
        
        NSMutableDictionary *myLocationDic = [[NSMutableDictionary alloc] init];
        [myLocationDic setObject:@"updateLocation" forKey:@"key"];
        [myLocationDic setObject:userPhone forKey:@"phonenumber"];
        [myLocationDic setObject:ssid forKey:@"sid"];
        [myLocationDic setObject:userlat forKey:@"latitude"];
        [myLocationDic setObject:userlong forKey:@"longitude"];
        NSData *myData = [NSJSONSerialization dataWithJSONObject:myLocationDic
                                                         options:kNilOptions
                                                           error:nil];
        
        
        NSUserDefaults *ServerUrl = [NSUserDefaults standardUserDefaults];
        NSString *stringurl=[ServerUrl objectForKey:@"serverurl"];
        NSURL *url= [[NSURL alloc] initWithString:stringurl];
        //NSLog(@"location data : %@",myData);
        //NSLog(@"location data1 : %@",myLocationDic);
        //    NSURL *url = [[NSURL alloc] initWithString:@"http://192.168.10.115:3000/users"];
        Server *connect = [[Server alloc] init];
        [connect postRequest:url withData:myData];
        //NSLog(@"current lat: %@,%@",userlat,userlong);
    }
           
}


- (IBAction)sendRequestHelp:(id)sender {
    NSUserDefaults *session = [NSUserDefaults standardUserDefaults];

    NSUserDefaults *checkLogin = [NSUserDefaults standardUserDefaults];
    NSString *check = [checkLogin valueForKey:@"checkLogin"];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *internetStatus=[user objectForKey:@"Internet"];
    
        
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSString *internetStatus=[user objectForKey:@"Internet"];
//    
//    if ([internetStatus isEqualToString:@"NO"]) {
//        NSLog(@"Run with out network and don't do any thing");
//    } else if([internetStatus isEqualToString:@"YES"]) {
//        
//    }
    
    if ([sendRequestHelpLabel.text isEqualToString:@"Send Request Help"]) {
        //Ask user want to send request or not
        alert= [[UIAlertView alloc]initWithTitle:@"Send Request Help?"
                                         message:@"Do you want to send request help?"
                                        delegate:self
                               cancelButtonTitle:@"NO"
                               otherButtonTitles:@"SEND", nil];
        alert.alertViewStyle=UIAlertViewStylePlainTextInput;
        [alert textFieldAtIndex:0].delegate = self;
        [alert show];
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Alarm, Air Rescue, Coast Guard 1.wav",[[NSBundle mainBundle] resourcePath]]];
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        audioPlayer.numberOfLoops = -1;
        if (audioPlayer == nil) {
            NSLog(@"%@",[error description]);
        } else {
            [audioPlayer play];
            [self setTimer];
        }
    }
    
    if ([sendRequestHelpLabel.text isEqualToString:@"Safe now"])
    {
        //Do not send request help
        //Send request safe
        [session setObject:@"NO" forKey:@"isVictim"];
        if ([internetStatus isEqualToString:@"NO"]) {
            sendRequestHelpLabel.text=@"Send Request Help";
             //Add funtion to send request safe to friend by sms///
            NSLog(@"Run with out network and send SMS request safe");
        }
        else if([internetStatus isEqualToString:@"YES"]) {
    
            if([check isEqualToString:@"Offline"])
            {
                
                //Add funtion to send request safe to friend by sms///
                
                sendRequestHelpLabel.text=@"Send Request Help";
                NSLog(@"Confirm Safe in offline mode");
            }
            
            else if ([check isEqualToString:@"LOGIN"])
            {
                NSUserDefaults *phonenumber = [NSUserDefaults standardUserDefaults];
                NSString *phoneNumber =[phonenumber valueForKey:@"phone"];
                NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
                NSString *ssid=[session objectForKey:@"ssid"];
                NSUserDefaults *ServerUrl = [NSUserDefaults standardUserDefaults];
                NSString *stringurl=[ServerUrl objectForKey:@"serverurl"];
                NSURL *url= [[NSURL alloc] initWithString:stringurl];
                
                //        NSURL *url = [[NSURL alloc] initWithString:@"http://192.168.10.115:3000/users"];
                NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] init];
                [myDictionary setObject:@"confirmRequest" forKey:@"key"];
                [myDictionary setObject:ssid forKey:@"sid"];
                [myDictionary setObject:phoneNumber forKey:@"phonenumber"];
                
                NSData *myData = [NSJSONSerialization dataWithJSONObject:myDictionary
                                                                 options:kNilOptions
                                                                   error:nil];
                
                Server *connect = [[Server alloc] init];
                NSString *result = [connect postRequest:url withData:myData];
                
                NSLog(@"%@",result);
                //Alert about request sent or not
                if([result isEqualToString:@"Confirmed your safe!"])
                {
                    sendRequestHelpLabel.text=@"Send Request Help";
                    
                    
                }
                else if([result isEqualToString:@"Phone number is not exist!"])
                {
                    notexistAlert =[[UIAlertView alloc] initWithTitle:@"Fail" message:@"Account is not exist"delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [notexistAlert show];
                    double delayInSeconds = 10;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [notexistAlert dismissWithClickedButtonIndex:0 animated:YES];
                    });
                }
                
            }

        }

                
    }
}

- (void) setTimer {
    countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    
}
- (void) timerRun {
    //Count down time for response
    
    secondsCount1 = secondsCount1 - 1;
    
    if (secondsCount1 == 0) {
        [countdownTimer invalidate];
        countdownTimer = nil;
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        [audioPlayer stop];
        sendRequestHelpLabel.text=@"Safe now";
        //labelHelp.text = @"send help by system";
        secondsCount1 = 30;
        //Take a screen shot
        //        UIGraphicsBeginImageContext(self.view.bounds.size);
        //        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        //        UIImage *sceenshotImage= UIGraphicsGetImageFromCurrentImageContext();
        //        UIGraphicsEndImageContext();
        //        UIImageWriteToSavedPhotosAlbum(sceenshotImage, nil, nil, nil);
        [self sendRequestToServer];
    }
}

- (void) sendRequestToServer{
    
    NSUserDefaults *checkLogin = [NSUserDefaults standardUserDefaults];
    NSString *check = [checkLogin valueForKey:@"checkLogin"];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *internetStatus=[user objectForKey:@"Internet"];
    
      if ([internetStatus isEqualToString:@"NO"]) {
          NSLog(@"Run with out network and send request help via SMS");
          
      }
      else if([internetStatus isEqualToString:@"YES"]) {
          
          if ([check isEqualToString:@"Offline"]){
              //Add funtion to send offline request help only via SMS here
              NSLog(@"send request help Type 1 in offline mode via SMS");
          }
          
          else if ([check isEqualToString:@"LOGIN"])
          {
              NSUserDefaults *phonenumber = [NSUserDefaults standardUserDefaults];
              NSString *phoneNumber =[phonenumber valueForKey:@"phone"];
              NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
              NSString *ssid=[session objectForKey:@"ssid"];
              NSUserDefaults *ServerUrl = [NSUserDefaults standardUserDefaults];
              NSString *stringurl=[ServerUrl objectForKey:@"serverurl"];
              NSURL *url= [[NSURL alloc] initWithString:stringurl];
              
              
              latAtt=[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
              longAtt=[NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
              
              //    NSURL *url = [[NSURL alloc] initWithString:@"http://192.168.10.115:3000/users"];
              
              NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] init];
              [myDictionary setObject:@"sendRequest" forKey:@"key"];
              [myDictionary setObject:ssid forKey:@"sid"];
              [myDictionary setObject:@"1" forKey:@"reqtype"];
              [myDictionary setObject:phoneNumber forKey:@"phonenumber"];
              [myDictionary setObject:latAtt forKey:@"latitude"];
              [myDictionary setObject:longAtt forKey:@"longitude"];
              
              NSData *myData = [NSJSONSerialization dataWithJSONObject:myDictionary
                                                               options:kNilOptions
                                                                 error:nil];
              
              Server *connect = [[Server alloc] init];
              NSString *result = [connect postRequest:url withData:myData];
              
              NSLog(@"%@",result);
              //Alert about request sent or not
              if([result isEqualToString:@"Help request has been sent!"])
              {
                  successAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Sent request, calm down and wait for help." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                  [successAlert show];
                  double delayInSeconds = 10;
                  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                      [successAlert dismissWithClickedButtonIndex:0 animated:YES];
                  });
                  
              }
              else if([result isEqualToString:@"Phone number is not exist!"])
              {
                  notexistAlert =[[UIAlertView alloc] initWithTitle:@"Fail" message:@"Account is not exist"delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                  [notexistAlert show];
                  double delayInSeconds = 10;
                  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                      [notexistAlert dismissWithClickedButtonIndex:0 animated:YES];
                  });
              }
          }
       }

    
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    NSUserDefaults *session = [NSUserDefaults standardUserDefaults];

    if (alertView == notexistAlert ||  alertView == invalidFormatAlert || confirm){
        if ([title isEqualToString:@"OK"])
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else
    {
        switch (buttonIndex) {
            case 0:{
                //labelNotHelp.text = @"Do not help";
                [countdownTimer invalidate];
                countdownTimer = nil;
                //[alertView release];
                [audioPlayer stop];
                secondsCount1 = 30;
                break;
            }
            case 1:{
                // labelHelp.text = @"Send Help";
                [countdownTimer invalidate];
                [session setObject:@"YES" forKey:@"isVictim"];

                countdownTimer = nil;
                sendRequestHelpLabel.text=@"Safe now";
                //[alertView release];
                [audioPlayer stop];
                secondsCount1 = 30;
                //Take a screen shot
                //                UIGraphicsBeginImageContext(self.view.bounds.size);
                //                [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
                //                UIImage *sceenshotImage= UIGraphicsGetImageFromCurrentImageContext();
                //                UIGraphicsEndImageContext();
                //                UIImageWriteToSavedPhotosAlbum(sceenshotImage, nil, nil, nil);
                if ([[alertView textFieldAtIndex:0].text isEqualToString:@""]) {
                    [self sendRequestToServer];
                }
                else{
                    NSString *message=[alertView textFieldAtIndex:0].text;
                    [self sendRequestHelpType2:message];
                }
                break;
            }
            default:{
                break;
            }
        }
    }
}

- (void) sendRequestHelpType2:(NSString *)message{
    
    NSUserDefaults *checkLogin = [NSUserDefaults standardUserDefaults];
    NSString *check = [checkLogin valueForKey:@"checkLogin"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *internetStatus=[user objectForKey:@"Internet"];
    
    if ([internetStatus isEqualToString:@"NO"]) {
        NSLog(@"Run with out network and send request help via SMS");
        
    }
    else if([internetStatus isEqualToString:@"YES"]) {
    
    if ([check isEqualToString:@"Offline"]){
        //Add funtion to send offline request help only via SMS here
        NSLog(@"send request help Type 2 in offline mode by SMS");
    }
    
    else if ([check isEqualToString:@"LOGIN"])
    {
    NSUserDefaults *phonenumber = [NSUserDefaults standardUserDefaults];
    NSString *phoneNumber =[phonenumber valueForKey:@"phone"];
    NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
    NSString *ssid=[session objectForKey:@"ssid"];
    NSUserDefaults *ServerUrl = [NSUserDefaults standardUserDefaults];
    NSString *stringurl=[ServerUrl objectForKey:@"serverurl"];
    NSURL *url= [[NSURL alloc] initWithString:stringurl];
    
    latAtt=[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    longAtt=[NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    
//    NSURL *url = [[NSURL alloc] initWithString:@"http://192.168.10.115:3000/users"];
    
    NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] init];
    [myDictionary setObject:@"sendRequest" forKey:@"key"];
    [myDictionary setObject:ssid forKey:@"sid"];
    [myDictionary setObject:@"2" forKey:@"reqtype"];
    [myDictionary setObject:phoneNumber forKey:@"phonenumber"];
    [myDictionary setObject:message forKey:@"content"];
    [myDictionary setObject:latAtt forKey:@"latitude"];
    [myDictionary setObject:longAtt forKey:@"longitude"];
    
    NSData *myData = [NSJSONSerialization dataWithJSONObject:myDictionary
                                                     options:kNilOptions
                                                       error:nil];
    
    Server *connect = [[Server alloc] init];
    NSString *result = [connect postRequest:url withData:myData];
    
    NSLog(@"%@",result);
    //Alert about request sent or not
    if([result isEqualToString:@"Help request has been sent!"])
        {
        successAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Sent request, calm down and wait for help." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [successAlert show];
        double delayInSeconds = 10;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [successAlert dismissWithClickedButtonIndex:0 animated:YES];
        });
        
        }
    else if([result isEqualToString:@"Phone number is not exist!"])
        {
        notexistAlert =[[UIAlertView alloc] initWithTitle:@"Fail" message:@"Account is not exist"delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [notexistAlert show];
        double delayInSeconds = 10;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [notexistAlert dismissWithClickedButtonIndex:0 animated:YES];
        });
        }
    }
    }
    
}

//- (IBAction)updateWeather:(id)sender {
//    [self getDate];
//    [self getWeather];
//    [self getcityName];
//}

@end
