//
//  MainViewController.h
//  DisasterHelper
//
//  Created by Tu (Tony) A. TRAN on 2/14/14.
//  Copyright (c) 2014 Tu (Tony) A. TRAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

#import "Server.h"
#import "LoginViewController.h"
#import "NewServer.h"

#import "DHGeoforDirections.h"
#import "DHSearchService.h"

#import "CustomInforWindow.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

#import <AVFoundation/AVFoundation.h>



@interface MainViewController : UIViewController<UITextFieldDelegate,GMSMapViewDelegate,CLLocationManagerDelegate>{
    NSTimer *countdownTimer;
    NSString *longAtt;
    NSString *latAtt;

    
    __weak IBOutlet GMSMapView *mapView_;
    __weak IBOutlet UIButton *button;
    __weak IBOutlet UITextField *addressField;
    
//    __weak IBOutlet UITextField *startPoint;
//    
//    __weak IBOutlet UITextField *destinationPoint;
//    
//    __weak IBOutlet UIButton *sendRequestHelpButtonText;
    
    IBOutlet UITextField *searchTextField;
    
    //   __weak IBOutlet UIButton *clearMap;
}

- (IBAction)clear:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *sender;
//@property (strong, nonatomic) IBOutlet UISwitch *switchEnabled;

@property (strong,nonatomic) DHSearchService *sp;
@property (strong,nonatomic) DHGeoforDirections *gs;

- (IBAction)dismissKeyboard:(id)sender;

//- (IBAction)getDirectionsButton:(id)sender;

//- (IBAction)enabledStateChanged:(id)sender;
- (IBAction)changerMaptype:(id)sender;

- (IBAction)Getvictim:(id)sender;

@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) NSString *userLocation;
-(void)clearmapdata;
@end
