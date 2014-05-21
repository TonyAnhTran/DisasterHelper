//
//  MainViewController.m
//  DisasterHelper
//
//  Created by Tu (Tony) A. TRAN on 2/14/14.
//  Copyright (c) 2014 Tu (Tony) A. TRAN. All rights reserved.
//

#import "MainViewController.h"
#import "MDDirectionService.h"
//#import "AlertPrompt.h"
#import <GoogleMaps/GoogleMaps.h>
#import "LoginViewController.h"

@interface MainViewController (){
    //waypoint and waypointStrings_ using for get directions
    NSMutableArray *waypoints_;
    NSMutableArray *waypointStrings_;
    
    // use for zoom to first current locations
    BOOL firstLocationUpdate_;
    
    // victimArray use for display Victims marker
    NSMutableArray *victimArray;
    
    // user for send request help
    UIAlertView *alert;
    UIAlertView *prompt;
    UIAlertView *confirm;
    
    NSString *victimPhone;
    NSString *victimlocation;
    NSString *markerlocation;
    
    UITextField *textField1;
    UITextField *textField2;
    
    NSMutableArray *newsearchVictimarr;
    
   
}

@property (nonatomic, retain) CLLocationManager *locationManager;



@end
NSInteger secondsCount = 30;
 AVAudioPlayer *audioPlayer;

@implementation MainViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

@synthesize sp,gs,userLocation,currentLocation,locationManager;




- (void)loadView
{
    [super loadView];
    
    waypoints_ = [[NSMutableArray alloc]init];
    waypointStrings_ = [[NSMutableArray alloc]init];
    newsearchVictimarr=[[NSMutableArray alloc]init];
    victimArray = [[NSMutableArray alloc] init];
    
    //get victimData from SegueLogin.m
    NSUserDefaults *victimData = [NSUserDefaults standardUserDefaults];
    victimArray =[victimData valueForKey:@"victimdata"];
    
    NSUserDefaults *ServerUrl = [NSUserDefaults standardUserDefaults];
    //NSString *stringurl=[ServerUrl objectForKey:@"serverurl"];
    NSString *serverIP=[ServerUrl objectForKey:@"serverIP"];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
   	NSString *internetStatus=[user objectForKey:@"Internet"];
    
    if ([internetStatus isEqualToString:@"NO"]) {
        NSLog(@"Run with out network and can't get victim list");
        
    }
    else if([internetStatus isEqualToString:@"YES"]) {
        // add victim markers
        for(int i=0;i<[victimArray count];i++)
        {
            
            NSDictionary *dict=(NSDictionary *)[victimArray objectAtIndex:i];
            double lat=[[dict valueForKey:@"latitude"] doubleValue];
            double lon=[[dict valueForKey:@"longitude"] doubleValue];
            NSString *name=[dict valueForKey:@"username"];
            NSString *avatar=[dict objectForKey:@"avatar_url"];
            victimPhone=[dict objectForKey:@"phonenumber"];
            //  NSLog(@"avatar: %@",avatar);
            
            // If avatar is default then server url is...
            if ([avatar isEqualToString:@"default_avatar.png"]) {
                
                NSString *serverurl=@"/images/";
                NSString *fullurl=[NSString stringWithFormat:@"%@%@%@",serverIP,serverurl,avatar];
                NSURL *imageURL = [NSURL URLWithString:fullurl];
                //NSLog(@"url: %@",imageURL);
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                UIImage *firstavatar=[UIImage imageWithData:imageData];
                UIImage *newImage = [self imageWithImage:firstavatar scaledToSize:CGSizeMake(40, 40)];
                NSData *newimageData = UIImagePNGRepresentation(newImage);
                
                
                // Using for get victim address from geocoding if nescessary
                //NSString *phone=[dict valueForKey:@"phonenumber"];
                //        NSString *location= [NSString stringWithFormat:@"%f,%f",lat,lon];
                //
                //        NSString *geocodingBaseUrl = @"http://maps.googleapis.com/maps/api/geocode/json?";
                //        NSString *url = [NSString stringWithFormat:@"%@address=%@&sensor=false", geocodingBaseUrl,location];
                //        url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                //
                //        NSURL *queryUrl = [NSURL URLWithString:url];
                //        NSData *data = [NSData dataWithContentsOfURL: queryUrl];
                //
                //        NSError* error;
                //        NSDictionary *json = [NSJSONSerialization
                //                              JSONObjectWithData:data
                //                              options:kNilOptions
                //                              error:&error];
                //
                //        //   NSLog(@"json is: %@", json);
                //
                //        NSArray* results = [json objectForKey:@"results"];
                //        NSDictionary *result = [results objectAtIndex:0];
                //        NSString *address = [result objectForKey:@"formatted_address"];
                
                
                GMSMarker *marker= [[GMSMarker alloc] init];
                marker.position= CLLocationCoordinate2DMake(lat,lon);
                marker.icon =[UIImage imageWithData:newimageData];
                marker.title = name;
                marker.snippet = @"Help me! Click on get victim button to update victims list and my location address";
                marker.map = mapView_;
                //  NSLog(@"victim added");
                
                
            }
            else {
                
                NSString *serverurl=serverIP;
                NSString *fullurl=[NSString stringWithFormat:@"%@%@",serverurl,avatar];
                NSURL *imageURL = [NSURL URLWithString:fullurl];
                //   NSLog(@"url: %@",imageURL);
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                UIImage *firstavatar=[UIImage imageWithData:imageData];
                UIImage *newImage = [self imageWithImage:firstavatar scaledToSize:CGSizeMake(40, 40)];
                NSData *newimageData = UIImagePNGRepresentation(newImage);
                
                GMSMarker *marker= [[GMSMarker alloc] init];
                marker.position= CLLocationCoordinate2DMake(lat,lon);
                marker.icon =[UIImage imageWithData:newimageData];
                marker.title = name;
                marker.snippet = @"Help me! Click on get victim button to update victims list and my location address";
                marker.map = mapView_;
                //  NSLog(@"victim added")
            }
        }

    }
    
       
    //set camere default by that location if GPS not run
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:37.778376
                                                            longitude:-122.409853
                                                                 zoom:13];
    // default map settings
    mapView_.myLocationEnabled = YES;
    mapView_.settings.compassButton= YES;
    mapView_.settings.zoomGestures =YES;
    mapView_.settings.indoorPicker = YES;
    mapView_.delegate = self;
    [mapView_ setCamera:camera];
    
}


//resize image method, using for resize image to upload to server and resize victim avatar
-(UIImage*)imageWithImage:(UIImage*)image
             scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


//Add "Back" navigation bar
-(void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    
    //Customize back button arrow in navigation bar
    UIImage *buttonImage = [UIImage imageNamed:@"back111.png"];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setImage:buttonImage forState:UIControlStateNormal];
    button1.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button1 addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    [super viewDidLoad];
    //custom navigator back button 
    

    
    //sp use for search services
    sp = [[DHSearchService alloc] init];
    
    //gs use for geocoding services
    gs = [[DHGeoforDirections alloc] init];
    
    // Listen to the myLocation property of GMSMapView.
    [mapView_ addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    //schedule time to update first current location to server 
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self
//                                   selector:@selector(sendlocationtoServer) userInfo:nil repeats:NO];
    //schedule time to update location every 300 seconds
//    [NSTimer scheduledTimerWithTimeInterval:300.0 target:self
//                                   selector:@selector(sendlocationtoServer) userInfo:nil repeats:YES];
    
    
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView_.myLocationEnabled = YES;
    });
    
    
}


//Get directions by long press at mapview
- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(
                                                                 coordinate.latitude,
                                                                 coordinate.longitude);
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    
    // positionString = current marker position
    NSString *positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                coordinate.latitude,coordinate.longitude];
    //marker.map = mapView_;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
   	NSString *internetStatus=[user objectForKey:@"Internet"];
    
    if ([internetStatus isEqualToString:@"NO"]) {
        NSLog(@"Run with out network and can't get marker info");
        
    } else if([internetStatus isEqualToString:@"YES"]) {
        // Add marker by long press using geocoding services to get current marker informations
        [gs geocodeAddress:positionString withCallback:@selector(addMarkerbyLongpress) withDelegate:self];
        
        //add marker to array for count how many maker
        [waypoints_ addObject:marker];
        
        //add marker position to waypointStrings_ to send to DHGeoforDirections.m
        [waypointStrings_ addObject:positionString];
        
        // Get directions only with two first marker locations
        if([waypoints_ count]>1&&[waypoints_ count]<3)
        {
            
            NSString *sensor = @"false";
            NSArray *parameters = [NSArray arrayWithObjects:sensor, waypointStrings_,
                                   nil];
            NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
            NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters
                                                              forKeys:keys];
            MDDirectionService *mds=[[MDDirectionService alloc] init];
            SEL selector = @selector(addDirections:);
            [mds setDirectionsQuery:query
                       withSelector:selector
                       withDelegate:self];
        }

    }
        
}



//Add directions and add polyline
- (void)addDirections:(NSDictionary *)json {
    NSDictionary *routes = [json objectForKey:@"routes"][0];
    NSDictionary *route = [routes objectForKey:@"overview_polyline"];
    NSString *overview_route = [route objectForKey:@"points"];
    GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeWidth = 10.0f;
    polyline.map = mapView_;
   // NSLog(@"%@",overview_route);
    
    
// get directions data to print
   // NSLog(@"%@",routes);
    NSArray *display=[routes objectForKey:@"legs"];
    NSDictionary *total=[display objectAtIndex:0];
    NSDictionary *distance=[total objectForKey:@"distance"];
    NSDictionary *duration=[total objectForKey:@"duration"];
    NSArray *steps=[total objectForKey:@"steps"];
    
    
    NSString *stringdistance =[distance objectForKey:@"text"];
    NSString *stringduration=[duration objectForKey:@"text"];
    NSString *stringstartpoint=[total objectForKey:@"start_address"];
    NSString *stringdespoint=[total objectForKey:@"end_address"];

    NSString *directtype=@"driving";
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    directtype =[setting valueForKey:@"DirectionsType"];
    
//create text to print
    NSString *Resultis=[NSString stringWithFormat:@"Start point: %@\nDestination point: %@\nTotal distance: %@\nTotal time: %@\nDirections type: %@",stringstartpoint,stringdespoint,stringdistance,stringduration,directtype];
    //NSLog(@"%@",Resultis);
    
//display alert view with directions data
    UIAlertView *directions =[[UIAlertView alloc]initWithTitle:@"Directions result" message:Resultis delegate:nil cancelButtonTitle:@"See on map" otherButtonTitles:nil];
    [directions show];
    
    
// Left alignment text in alert view
    NSArray *subviewArray = directions.subviews;
    for(int x = 0; x < [subviewArray count]; x++){
        
        if([[[subviewArray objectAtIndex:x] class] isSubclassOfClass:[UILabel class]]) {
            //UILabel *label = [subviewArray objectAtIndex:x];
            //label.textAlignment = UITextAlignmentLeft;
            }
        }
    
    for (int i=0;i<[steps count];i++) {
        
//Get step by step to directions
    // NSLog(@"step test: %@",steps);
    //NSDictionary *stepbystep=[steps objectAtIndex:i];
   // NSLog(@"step test: %@",stepbystep);
    //NSString *instructionsHtml=[stepbystep objectForKey:@"html_instructions"];
   // NSLog(@"Step %i: %@",i,instructionsHtml);
    }

}

// Funtion to send location to server, but it not nescessary right now, because one funtion the same in MainFlatviewController.m did it
-(void)sendlocationtoServer{
    userLocation=[NSString stringWithFormat:@"%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude];
    
    NSUserDefaults *phonenumber = [NSUserDefaults standardUserDefaults];
    NSString *userPhone =[phonenumber valueForKey:@"phone"];
    NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
    NSString *ssid=[session objectForKey:@"ssid"];
    
    NSUserDefaults *ServerUrl = [NSUserDefaults standardUserDefaults];
    NSString *stringurl=[ServerUrl objectForKey:@"serverurl"];
    NSURL *url= [[NSURL alloc] initWithString:stringurl];
    
    NSString *userlat = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    NSString *userlong = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    
    //get City name
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
         NSLog(@"locality %@",placemark.locality);
        // NSLog(@"postalCode %@",placemark.postalCode);
         
     }];
    @try{
        NSMutableDictionary *myLocationDic = [[NSMutableDictionary alloc] init];
        [myLocationDic setObject:@"updateLocation" forKey:@"key"];
        [myLocationDic setObject:ssid forKey:@"sid"];
        [myLocationDic setObject:userPhone forKey:@"phonenumber"];
        [myLocationDic setObject:userlat forKey:@"latitude"];
        [myLocationDic setObject:userlong forKey:@"longitude"];
        NSData *myData = [NSJSONSerialization dataWithJSONObject:myLocationDic options:NSJSONReadingMutableContainers error:nil];
        
        
//        NSURL *url = [[NSURL alloc] initWithString:@"http://192.168.10.115:3000/users"];
        Server *connect = [[Server alloc] init];
        [connect postRequest:url withData:myData];
    }
    
    @catch(NSException *e){
        UIAlertView *searchAlert=[[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                            message:@"Can't update location to server."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
        [searchAlert show];
    }
    @finally{}
}



- (void)dealloc {
    [mapView_ removeObserver:self
                  forKeyPath:@"myLocation"
                     context:NULL];
}

#pragma mark - KVO updates

//set default camera position is current location when load map 
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!firstLocationUpdate_) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        firstLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:12];
    }
   currentLocation = mapView_.myLocation;
    }


// Clear current map view
- (IBAction)clear:(id)sender {
    [mapView_ clear];
    [waypoints_ removeAllObjects];
    [waypointStrings_ removeAllObjects];
    [victimArray removeAllObjects];
    
}
-(void)clearmapdata{
    [victimArray removeAllObjects];
}

//Search for a lot of place when click on button
- (IBAction)searchplace:(id)sender {
    [addressField resignFirstResponder];
//    SEL sel = @selector(addMarkerbySearch);
//    //[self performSelector:@selector(addMarkerbySearch)];
//    
//    NSLog(@"%@",NSStringFromSelector(sel));
    [sp searchQuery:addressField.text withCallback:@selector(addMarkerbySearch) withDelegate:self];
    NSLog(@"You are searching for : %@ ",addressField.text);
    addressField.text=@"";
    
}

// Search one adress
- (IBAction)geocode:(id)sender {
    [addressField resignFirstResponder];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
   	NSString *internetStatus=[user objectForKey:@"Internet"];
    
    if ([internetStatus isEqualToString:@"NO"]) {
        NSLog(@"Run with out network and can search geocoder");
    } else if([internetStatus isEqualToString:@"YES"]) {
        SEL sel = @selector(addMarkerbyGeocoding);
        //[self performSelector:@selector(addMarker)];
        
        NSLog(@"%@",NSStringFromSelector(sel));
        [gs geocodeAddress:addressField.text withCallback:@selector(addMarkerbyGeocoding) withDelegate:self];
    }
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


// Add marker with result from server by click on search button
- (void)addMarkerbySearch {
    
    double lat = [[sp.searchplace objectForKey:@"lat"] doubleValue];
    double lng = [[sp.searchplace objectForKey:@"lng"] doubleValue];
    NSString *iconurl = [sp.searchplace objectForKey:@"icon"];
    NSString *searchname=[sp.searchplace objectForKey:@"name"];
    NSString *searchaddress=[sp.searchplace objectForKey:@"address"];
    NSString *seacchsnippet=[NSString stringWithFormat:@"%@:\n %@",searchname,searchaddress];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    CLLocationCoordinate2D searchlocation = CLLocationCoordinate2DMake(lat,lng);
    marker.position = searchlocation;
    marker.title = @"This place is:";
    marker.snippet = seacchsnippet;
    marker.icon = [UIImage imageNamed:iconurl];
    marker.map = mapView_;
    
    markerlocation=[NSString stringWithFormat:@"%f,%f",lat,lng];
   // GMSCameraUpdate *searchLocateCam = [GMSCameraUpdate setTarget:searchlocation zoom:16.0];
   // [mapView_ animateWithCameraUpdate:searchLocateCam];
    NSLog(@"Current place's coordinate is: %f,%f",searchlocation.latitude, searchlocation.longitude, nil);
    
}

// Add marker by geocoding service
- (void)addMarkerbyGeocoding {
    
    double lat = [[gs.geocode objectForKey:@"lat"] doubleValue];
    double lng = [[gs.geocode objectForKey:@"lng"] doubleValue];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    CLLocationCoordinate2D geolocation = CLLocationCoordinate2DMake(lat,lng);
    marker.position = geolocation;
    marker.title = @"This place is:";
    marker.snippet= [gs.geocode objectForKey:@"address"];
    //marker.icon = [UIImage imageNamed:@"arrow.png"];
    marker.map = mapView_;
    markerlocation=[NSString stringWithFormat:@"%f,%f",lat,lng];
    GMSCameraUpdate *geoLocateCam = [GMSCameraUpdate setTarget:geolocation zoom:16.0];
    [mapView_ animateWithCameraUpdate:geoLocateCam];
   // NSLog(@"Current place's coordinate is: %f,%f",geolocation.latitude, geolocation.longitude, nil);
    
}

// Add marker by long press in mapview via geocoding service
- (void)addMarkerbyLongpress {
    
    double lat = [[gs.geocode objectForKey:@"lat"] doubleValue];
    double lng = [[gs.geocode objectForKey:@"lng"] doubleValue];
    markerlocation=[NSString stringWithFormat:@"%f,%f",lat,lng];
    GMSMarker *marker = [[GMSMarker alloc] init];
    CLLocationCoordinate2D geolocation = CLLocationCoordinate2DMake(lat,lng);
    marker.position = geolocation;
    marker.title = @"This place is:";
    marker.snippet= [gs.geocode objectForKey:@"address"];
   // marker.icon = [UIImage imageNamed:@"arrow.png"];
    marker.map = mapView_;
    
}

// Change custom infowindow when click on marker
//-(UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
//    CustomInforWindow *InfoWindow  =  [[[NSBundle mainBundle] loadNibNamed:@"ViewMapMarker" owner:self options:nil] objectAtIndex:0];
//
////  for(int i=0;i<[victimArray count];i++)
////    {
////        NSDictionary *dict=(NSDictionary *)[victimArray objectAtIndex:i];
////
////        NSString *namenumber=[dict valueForKey:@"username"];
////        NSString *phonenumber=[dict valueForKey:@"username"];
//
//    InfoWindow.name.text= marker.title;
//    InfoWindow.phone.text= marker.snippet;
//
////    }
//return InfoWindow;
//}

// Set action when click on map Marker
- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker*)marker
    {
        //event when marker is a place
        if([marker.title isEqualToString:@"This place is:"]){
            confirm = [[UIAlertView alloc] initWithTitle:@"What do you want?"
                                                 message:@""
                                                delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:@"Get direction to here",nil];
            [confirm show];

        }
        
        //event when marker is a victim
        else{
    //victimPhone= marker.snippet;
    victimlocation= [NSString stringWithFormat:@"%f,%f",marker.position.latitude,marker.position.longitude];
       // NSLog(@"victimlocation 1: %@",victimlocation);
    confirm = [[UIAlertView alloc] initWithTitle:@"Victim was saved?"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Victim is safe now",@"Get direction to victim",@"This user is a spammer",nil];
    [confirm show];
        }
}

// my location button
- (IBAction)geosv:(id)sender {
    CLLocation *location = mapView_.myLocation;
    if (location) {
        mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:14];
        [mapView_ animateToLocation:location.coordinate];
    }
    
}

//Dismiss keyboard when click on "Return", search place, geocoding, search victims
- (IBAction)dismissKeyboard:(id)sender {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *internetStatus=[user objectForKey:@"Internet"];
    [mapView_ clear];
    [waypoints_ removeAllObjects];
    [waypointStrings_ removeAllObjects];

    if (addressField.text.length<1) {
        [addressField resignFirstResponder];
    } else {
       
        if ([internetStatus isEqualToString:@"NO"]) {
            NSLog(@"Run with out network and can't search ");
        } else if([internetStatus isEqualToString:@"YES"]) {
            // add marker when geocoding retun
            SEL sel = @selector(addMarkerbyGeocoding);
            NSLog(@"%@",NSStringFromSelector(sel));
            
            //call geocoding funtion
            [gs geocodeAddress:addressField.text withCallback:@selector(addMarkerbyGeocoding) withDelegate:self];
            
            //call search place funtion
            [sp searchQuery:addressField.text withCallback:@selector(addMarkerbySearch) withDelegate:self];
            //NSLog(@"You are searching for : %@ ",addressField.text);
            
            //Check victim array data to find victim from input
            for (int i=0; i<[victimArray count]; i++)
            {
                
                // NSLog(@"input: %@", addressField.text);
                //  NSLog(@"victim array: %@" ,victimArray);
                NSDictionary *dict=(NSDictionary *)[victimArray objectAtIndex:i];
                NSString *name=[dict valueForKey:@"username"];
                
                //lower victim name to search
                NSString *namelower = [name lowercaseString];
                //lower input text
                NSString *addresslower=[addressField.text lowercaseString];
                
                NSString *phone=[dict valueForKey:@"phonenumber"];
                double lat=[[dict valueForKey:@"latitude"] doubleValue];
                double lon=[[dict valueForKey:@"longitude"] doubleValue];
                //CLLocationCoordinate2D geolocation = CLLocationCoordinate2DMake(lat,lon);
                
                NSString *avatar=[dict objectForKey:@"avatar_url"];
                
                //            if ([name rangeOfString:addressField.text].location != NSNotFound||[phone rangeOfString:addressField.text].location != NSNotFound||[namelower rangeOfString:addressField.text].location != NSNotFound)
                
                //compare search input with victim array name
                if ([namelower rangeOfString:addresslower].location != NSNotFound||[phone rangeOfString:addressField.text].location != NSNotFound)
                {
                    
                    if ([avatar isEqualToString:@"default_avatar.png"]) {
                        
                        NSString *serverurl=@"http://192.168.10.115:3000/images/";
                        NSString *fullurl=[NSString stringWithFormat:@"%@%@",serverurl,avatar];
                        NSURL *imageURL = [NSURL URLWithString:fullurl];
                        
                        // NSLog(@"url: %@",imageURL);
                        
                        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                        UIImage *firstavatar=[UIImage imageWithData:imageData];
                        UIImage *newImage = [self imageWithImage:firstavatar scaledToSize:CGSizeMake(40, 40)];
                        NSData *newimageData = UIImagePNGRepresentation(newImage);
                        
                        NSString *location= [NSString stringWithFormat:@"%f,%f",lat,lon];
                        
                        NSString *geocodingBaseUrl = @"http://maps.googleapis.com/maps/api/geocode/json?";
                        NSString *url = [NSString stringWithFormat:@"%@address=%@&sensor=false", geocodingBaseUrl,location];
                        url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                        
                        NSURL *queryUrl = [NSURL URLWithString:url];
                        NSData *data = [NSData dataWithContentsOfURL: queryUrl];
                        
                        NSError* error;
                        NSDictionary *json = [NSJSONSerialization
                                              JSONObjectWithData:data
                                              options:kNilOptions
                                              error:&error];
                        
                        //   NSLog(@"json is: %@", json);
                        
                        NSArray* results = [json objectForKey:@"results"];
                        NSDictionary *result = [results objectAtIndex:0];
                        NSString *address = [result objectForKey:@"formatted_address"];
                        
                        GMSMarker *marker= [[GMSMarker alloc] init];
                        marker.position= CLLocationCoordinate2DMake(lat,lon);
                        marker.icon =[UIImage imageWithData:newimageData];
                        marker.title = name;
                        marker.snippet = address;
                        marker.map = mapView_;
                        
                    }
                    else {
                        NSString *serverurl=@"http://192.168.10.115:3000";
                        NSString *fullurl=[NSString stringWithFormat:@"%@%@",serverurl,avatar];
                        NSURL *imageURL = [NSURL URLWithString:fullurl];
                        
                        // NSLog(@"url: %@",imageURL);
                        
                        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                        UIImage *firstavatar=[UIImage imageWithData:imageData];
                        UIImage *newImage = [self imageWithImage:firstavatar scaledToSize:CGSizeMake(40, 40)];
                        NSData *newimageData = UIImagePNGRepresentation(newImage);
                        
                        NSString *location= [NSString stringWithFormat:@"%f,%f",lat,lon];
                        
                        NSString *geocodingBaseUrl = @"http://maps.googleapis.com/maps/api/geocode/json?";
                        NSString *url = [NSString stringWithFormat:@"%@address=%@&sensor=false", geocodingBaseUrl,location];
                        url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                        
                        NSURL *queryUrl = [NSURL URLWithString:url];
                        NSData *data = [NSData dataWithContentsOfURL: queryUrl];
                        
                        NSError* error;
                        NSDictionary *json = [NSJSONSerialization
                                              JSONObjectWithData:data
                                              options:kNilOptions
                                              error:&error];
                        
                        //   NSLog(@"json is: %@", json);
                        
                        NSArray* results = [json objectForKey:@"results"];
                        NSDictionary *result = [results objectAtIndex:0];
                        NSString *address = [result objectForKey:@"formatted_address"];
                        
                        GMSMarker *marker= [[GMSMarker alloc] init];
                        marker.position= CLLocationCoordinate2DMake(lat,lon);
                        marker.icon =[UIImage imageWithData:newimageData];
                        marker.title = name;
                        marker.snippet = address;
                        marker.map = mapView_;
                        
                    }
                    
                }
            }

        }
                
    }
    addressField.text=@"";
    [addressField resignFirstResponder];
   // [startPoint resignFirstResponder];
    //[destinationPoint resignFirstResponder];
}

// Declare action when click on alert button
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSUserDefaults *phonenumber = [NSUserDefaults standardUserDefaults];
    NSString *phoneNumber =[phonenumber valueForKey:@"phone"];
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
    NSString *ssid=[session objectForKey:@"ssid"];
    
    NSUserDefaults *ServerUrl = [NSUserDefaults standardUserDefaults];
    NSString *stringurl=[ServerUrl objectForKey:@"serverurl"];
    NSURL *url= [[NSURL alloc] initWithString:stringurl];
    
    
    // "confirm" is map marker object, "promt" is directions alert
    if (alertView == confirm||alertView == prompt){
        if (alertView == confirm)
        {
            if ([title isEqualToString:@"Victim is safe now"])
            {
                NSMutableDictionary *userReport = [[NSMutableDictionary alloc] init];
                [userReport setValue:@"confirmOther" forKey:@"key"];
                [userReport setValue:ssid forKey:@"sid"];
                [userReport setValue:victimPhone forKey:@"targetphone"];
                [userReport setValue:phoneNumber forKey:@"phonenumber"];
            
                
                NSData *myData1 = [NSJSONSerialization dataWithJSONObject:userReport options:NSJSONReadingMutableContainers error:nil];
            
//            NSURL *url = [[NSURL alloc] initWithString:@"http://192.168.10.115:3000/users"];
            Server *connect = [[Server alloc] init];
            [connect postRequest:url withData:myData1];
              // NSLog(@"mydata1: %@",userReport);
            }
            
            else if([title isEqualToString:@"Get direction to here"])
            {
                [waypoints_ removeAllObjects];
                [waypointStrings_ removeAllObjects];
                NSString *mylocation =[NSString stringWithFormat:@"%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude];
            
                [waypointStrings_ addObject:mylocation];
                NSLog(@"my location is: %@",mylocation);
                NSLog(@"user location : %@",mylocation);
                SEL sel = @selector(addMarkerbyGeocoding);
                NSLog(@"%@",NSStringFromSelector(sel));
                [gs geocodeAddress:mylocation withCallback:@selector(addMarkerbyGeocoding) withDelegate:self];
            
                [waypointStrings_ addObject:markerlocation];
                NSLog(@"marker location is: %@",markerlocation);
            
                    if([waypointStrings_ count]>1)
                        {
                        NSString *sensor = @"false";
                        NSArray *parameters = [NSArray arrayWithObjects:sensor, waypointStrings_,
                                       nil];
                        NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
                        NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters
                                                                  forKeys:keys];
                        MDDirectionService *mds=[[MDDirectionService alloc] init];
                        SEL selector = @selector(addDirections:);
                        [mds setDirectionsQuery:query
                           withSelector:selector
                           withDelegate:self];
                        }
            
            }
        
            else if([title isEqualToString:@"Get direction to victim"])
            {
            
                NSString *mylocation =[NSString stringWithFormat:@"%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude];
            
                [waypointStrings_ addObject:mylocation];
                NSLog(@"user location : %@",mylocation);
                SEL sel = @selector(addMarkerbyGeocoding);
                NSLog(@"%@",NSStringFromSelector(sel));
                [gs geocodeAddress:mylocation withCallback:@selector(addMarkerbyGeocoding) withDelegate:self];
            
                NSLog(@"victimlocation : %@",victimlocation);
                [waypointStrings_ addObject:victimlocation];
//            [gs geocodeAddress:victimlocation withCallback:@selector(addMarkerbyLongpress) withDelegate:self];
            
            
                mylocation=@"";
                victimlocation=@"";
            
                    if([waypointStrings_ count]>1)
                    {
                        NSString *sensor = @"false";
                        NSArray *parameters = [NSArray arrayWithObjects:sensor, waypointStrings_,
                                       nil];
                        NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
                        NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters
                                                                  forKeys:keys];
                        MDDirectionService *mds=[[MDDirectionService alloc] init];
                        SEL selector = @selector(addDirections:);
                        [mds setDirectionsQuery:query
                           withSelector:selector
                           withDelegate:self];
                    }

            }
        
            else if([title isEqualToString:@"This user is a spammer"])
            {
                    NSMutableDictionary *userReport = [[NSMutableDictionary alloc] init];
                    [userReport setValue:@"reportUser" forKey:@"key"];
                    [userReport setValue:ssid forKey:@"sid"];
                    [userReport setValue:phoneNumber forKey:@"phonenumber"];
                    [userReport setValue:victimPhone forKey:@"targetphone"];
                
                    NSData *myData1 = [NSJSONSerialization dataWithJSONObject:userReport options:NSJSONReadingMutableContainers error:nil];
            
//                    NSURL *url = [[NSURL alloc] initWithString:@"http://192.168.10.115:3000/users"];
                    Server *connect = [[Server alloc] init];
                    [connect postRequest:url withData:myData1];
                 NSLog(@"jsondata: %@",userReport);
            }
       
    }
    
    if (alertView == prompt)
    {
        if ([title isEqualToString:@"Cancel"]) {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
        else
        {   [textField1 resignFirstResponder];
            [textField2 resignFirstResponder];
            @try{
                
                NSString *entered1 = textField1.text;
                NSString *entered2 = textField2.text;
                //label.text = [NSString stringWithFormat:@"You typed: %@", entered];
                NSLog(@"%@", entered1);
                NSLog(@"%@", entered2);
                
                
                [waypointStrings_ addObject:entered1];
                SEL sel = @selector(addMarkerbyGeocoding);
                NSLog(@"%@",NSStringFromSelector(sel));
                [gs geocodeAddress:entered1 withCallback:@selector(addMarkerbyGeocoding) withDelegate:self];
                
                [waypointStrings_ addObject:entered2];
                [gs geocodeAddress:entered2 withCallback:@selector(addMarkerbyLongpress) withDelegate:self];
                
                
                entered1=@"";
                entered2=@"";
                
                if([waypointStrings_ count]>1)
                {
                    NSString *sensor = @"false";
                    NSArray *parameters = [NSArray arrayWithObjects:sensor, waypointStrings_,
                                           nil];
                    NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
                    NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters
                                                                      forKeys:keys];
                    MDDirectionService *mds=[[MDDirectionService alloc] init];
                    SEL selector = @selector(addDirections:);
                    [mds setDirectionsQuery:query
                               withSelector:selector
                               withDelegate:self];
                }
            }
            @catch(NSException *e){
                UIAlertView *searchAlert=[[UIAlertView alloc] initWithTitle:@"Can't get direction"
                                                                    message:@"Please input Start and Destination point."
                                                                   delegate:nil                                         cancelButtonTitle:@"OK"
                                                          otherButtonTitles: nil];
                [searchAlert show];
            }
            @finally{}
   
        }
    }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Change map type between "Hybrid" and "Normal"
- (IBAction)changerMaptype:(id)sender {
    if (mapView_.mapType==kGMSTypeNormal)
    {
        mapView_.mapType=kGMSTypeHybrid;
    }
    else { mapView_.mapType = kGMSTypeNormal;}
}


// Get and display victims with adress data when click on that button
- (IBAction)Getvictim:(id)sender {
    [mapView_ clear];
    [waypoints_ removeAllObjects];
    [waypointStrings_ removeAllObjects];
    [victimArray removeAllObjects];
//    NSUserDefaults *victimData = [NSUserDefaults standardUserDefaults];
//    victimArray =[victimData valueForKey:@"victimdata"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
   	NSString *internetStatus=[user objectForKey:@"Internet"];
    
    NSUserDefaults *phonenumber = [NSUserDefaults standardUserDefaults];
    NSString *userPhone =[phonenumber valueForKey:@"phone"];
    
    NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
    NSString *ssid=[session objectForKey:@"ssid"];
    
    NSUserDefaults *ServerUrl = [NSUserDefaults standardUserDefaults];
    NSString *stringurl=[ServerUrl objectForKey:@"serverurl"];
    NSString *serverIP=[ServerUrl objectForKey:@"serverIP"];
    NSURL *url= [[NSURL alloc] initWithString:stringurl];
    
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    NSString *victimradius=[setting objectForKey:@"RadiusSearch"];
    NSString *victimTimeSet=[setting objectForKey:@"VictimTimeSet"];
    
    NSUserDefaults *checkLogin = [NSUserDefaults standardUserDefaults];
    NSString *check = [checkLogin valueForKey:@"checkLogin"];
    if ([internetStatus isEqualToString:@"NO"]) {
        NSLog(@"Run with out network and can't get victim");
    } else if([internetStatus isEqualToString:@"YES"]) {
        if ([check isEqualToString:@"LOGIN"]) {
            @try {
                NSMutableDictionary *myVictimlist = [[NSMutableDictionary alloc] init];
                [myVictimlist setValue:@"checkVictim" forKey:@"key"];
                [myVictimlist setValue:victimradius forKey:@"radius"];
                [myVictimlist setObject:ssid forKey:@"sid"];
                [myVictimlist setObject:victimTimeSet forKey:@"filter"];
                [myVictimlist setValue:userPhone forKey:@"phonenumber"];
                
                
                // NSError* error;
                NSData *myData1 = [NSJSONSerialization dataWithJSONObject:myVictimlist options:NSJSONReadingMutableContainers error:nil];
                
                //  NSLog(@"my data1 %@",myData1);
                
                //    NSURL *url = [[NSURL alloc] initWithString:@"http://192.168.10.115:3000/users"];
                NewServer *connect = [[NewServer alloc] init];
                NSArray *data = [connect postRequest:url withData:myData1];
                
                //   NSLog(@"data %@",data);
                
                //NSLog(@"data is: %@",data);
                NSUserDefaults *victimData = [NSUserDefaults standardUserDefaults];
                [victimData setValue:data forKey:@"victimdata"];
                victimArray =[victimData valueForKey:@"victimdata"];
                
                // NSLog(@"victim array: %@",victimArray);
                
                for(int i=0;i<[victimArray count];i++)
                {
                    NSDictionary *dict=(NSDictionary *)[victimArray objectAtIndex:i];
                    //NSLog(@"dict: %@",dict);
                    double lat=[[dict valueForKey:@"latitude"] doubleValue];
                    double lon=[[dict valueForKey:@"longitude"] doubleValue];
                    NSString *name=[dict valueForKey:@"username"];
                    
                    NSString *avatar=[dict objectForKey:@"avatar_url"];
                    
                    // NSLog(@"avatar: %@",avatar);
                    
                    if ([avatar isEqualToString:@"default_avatar.png"]) {
                        
                        NSString *serverurl=@"/images/";
                        NSString *fullurl=[NSString stringWithFormat:@"%@%@%@",serverIP,serverurl,avatar];
                        NSURL *imageURL = [NSURL URLWithString:fullurl];
                        
                        // NSLog(@"url: %@",imageURL);
                        
                        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                        UIImage *firstavatar=[UIImage imageWithData:imageData];
                        UIImage *newImage = [self imageWithImage:firstavatar scaledToSize:CGSizeMake(40, 40)];
                        NSData *newimageData = UIImagePNGRepresentation(newImage);
                        
                        NSString *location= [NSString stringWithFormat:@"%f,%f",lat,lon];
                        
                        NSString *geocodingBaseUrl = @"http://maps.googleapis.com/maps/api/geocode/json?";
                        NSString *url = [NSString stringWithFormat:@"%@address=%@&sensor=false", geocodingBaseUrl,location];
                        url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                        
                        NSURL *queryUrl = [NSURL URLWithString:url];
                        NSData *data = [NSData dataWithContentsOfURL: queryUrl];
                        
                        NSError* error;
                        NSDictionary *json = [NSJSONSerialization
                                              JSONObjectWithData:data
                                              options:kNilOptions
                                              error:&error];
                        
                        //   NSLog(@"json is: %@", json);
                        
                        NSArray* results = [json objectForKey:@"results"];
                        NSDictionary *result = [results objectAtIndex:0];
                        NSString *address = [result objectForKey:@"formatted_address"];
                        
                        GMSMarker *marker= [[GMSMarker alloc] init];
                        marker.position= CLLocationCoordinate2DMake(lat,lon);
                        marker.icon =[UIImage imageWithData:newimageData];
                        marker.title = name;
                        marker.snippet = address;
                        marker.map = mapView_;
                        
                    }
                    else {
                        NSString *serverurl=serverIP;
                        NSString *fullurl=[NSString stringWithFormat:@"%@%@",serverurl,avatar];
                        NSURL *imageURL = [NSURL URLWithString:fullurl];
                        
                        // NSLog(@"url: %@",imageURL);
                        
                        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                        UIImage *firstavatar=[UIImage imageWithData:imageData];
                        UIImage *newImage = [self imageWithImage:firstavatar scaledToSize:CGSizeMake(40, 40)];
                        NSData *newimageData = UIImagePNGRepresentation(newImage);
                        
                        NSString *location= [NSString stringWithFormat:@"%f,%f",lat,lon];
                        
                        NSString *geocodingBaseUrl = @"http://maps.googleapis.com/maps/api/geocode/json?";
                        NSString *url = [NSString stringWithFormat:@"%@address=%@&sensor=false", geocodingBaseUrl,location];
                        url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                        
                        NSURL *queryUrl = [NSURL URLWithString:url];
                        NSData *data = [NSData dataWithContentsOfURL: queryUrl];
                        
                        NSError* error;
                        NSDictionary *json = [NSJSONSerialization
                                              JSONObjectWithData:data
                                              options:kNilOptions
                                              error:&error];
                        
                        //   NSLog(@"json is: %@", json);
                        
                        NSArray* results = [json objectForKey:@"results"];
                        NSDictionary *result = [results objectAtIndex:0];
                        NSString *address = [result objectForKey:@"formatted_address"];
                        
                        GMSMarker *marker= [[GMSMarker alloc] init];
                        marker.position= CLLocationCoordinate2DMake(lat,lon);
                        marker.icon =[UIImage imageWithData:newimageData];
                        marker.title = name;
                        marker.snippet = address;
                        marker.map = mapView_;
                        
                    }
                    // NSLog(@"victim added");
                };
                
            }
            @catch (NSException *exception) {
                NSLog(@"Get victim button error-(void)getvicitm");
            }
            @finally {
                
            }
            
        }
  
    }
    
}

//Get directions button
- (IBAction)buttonTapAction:(id)sender {
    [mapView_ clear];
    [waypoints_ removeAllObjects];
    [waypointStrings_ removeAllObjects];
    
    prompt = [[UIAlertView alloc] initWithTitle:@"Get directions"
                                                        message:@"Input Start and Destination point here."
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles: @"Ok",nil];
      
    [prompt show];
    CGFloat height = 25.0;
    
    UILabel *msgLabel = [[prompt subviews] objectAtIndex:2];
    
    textField1 = [[UITextField alloc] initWithFrame:CGRectMake(msgLabel.frame.origin.x, msgLabel.frame.origin.y+msgLabel.frame.size.height, msgLabel.frame.size.width, height)];
    textField1.placeholder=@"Start point";
    [textField1 setBackgroundColor:[UIColor whiteColor]];
    textField2 = [[UITextField alloc] initWithFrame:CGRectOffset(textField1.frame, 0, height + 4)];
    textField2.placeholder=@"Destination point";
    [textField2 setBackgroundColor:[UIColor whiteColor]];
    
    NSArray *followringSubviews = [[prompt subviews] subarrayWithRange:NSMakeRange(3, [[prompt subviews] count] - 3)];
    [followringSubviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.frame = CGRectOffset(view.frame, 0, 3*height);
        
    }];
    [prompt addSubview:textField1];
    [prompt addSubview:textField2];
    
    textField1.delegate = self;
    textField2.delegate = self;
    prompt.frame = CGRectUnion(prompt.frame, CGRectOffset(prompt.frame, 0, 80));
    [textField1 resignFirstResponder];
    [textField2 resignFirstResponder];
 
}

@end