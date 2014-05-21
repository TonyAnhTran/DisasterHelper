//
//  LoginViewController.m
//  DisasterHelper
//
//  Created by Tan (Tharin) T.NGUYEN on 2/14/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import "LoginViewController.h"
#import "Server.h"
#import "NewServer.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LoginViewController (){
    UIAlertView *offlineAlert;
    UIAlertView *ServerDown;
}

@property (strong, nonatomic) UIAlertView *notexistAlert, *wrongPassAlert, *successAlert, *invalidFormatAlert, *checkAlertView;

@end


@implementation LoginViewController
@synthesize notexistAlert, wrongPassAlert, successAlert, invalidFormatAlert, checkAlertView;
@synthesize phoneString, passwordString;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.scollViewLogin layoutIfNeeded];
    self.scollViewLogin.contentSize=self.contentViewLogin.bounds.size;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self testInternetConnection];
   
    //RGB color macro
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
    [backgroundImage setBackgroundColor:UIColorFromRGB(0x87CEFA)];
    loginBackgroundImage.layer.shadowColor = [UIColor grayColor].CGColor;
    loginBackgroundImage.layer.shadowOffset = CGSizeMake(0, 3);
    loginBackgroundImage.layer.shadowOpacity = 3;
    loginBackgroundImage.layer.shadowRadius = 3.0;
    loginBackgroundImage.clipsToBounds = NO;
    
    labelDisasterHelper.layer.shadowColor = [UIColor grayColor].CGColor;
    labelDisasterHelper.layer.shadowOffset = CGSizeMake(0, 3);
    labelDisasterHelper.layer.shadowOpacity = 3;
    labelDisasterHelper.layer.shadowRadius = 3.0;
    labelDisasterHelper.clipsToBounds = NO;
    
//    NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
//    [session setValue:@"false" forKey:@"ssid"];
}
- (void)testInternetConnection
{
    internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Yayyy, we have the interwebs!");
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setValue:@"YES" forKey:@"Internet"];
        });
    };
    
    // Internet is not reachable
    internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            offlineAlert=[[UIAlertView alloc] initWithTitle:@"Connection error !" message:@"Network error, check your network and try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Using offline mode", nil];
//            [offlineAlert show];
            NSLog(@"Someone broke the internet :(");
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setValue:@"NO" forKey:@"Internet"];
        });
        
    };
    
    [internetReachableFoo startNotifier];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)checkLoginAccount {
    //get string from TextField
    phoneString = [phoneNumberTextField text];
    passwordString = [passwordTextField text];
    
    NSString *messageCheck;
    if (([phoneString isEqualToString:@""]) || ([passwordString isEqualToString:@""])) {
        messageCheck = @"Please input phone number and password before Log-in";
        checkAlertView = [[UIAlertView alloc] initWithTitle:@"Log-in Failed"
                                                    message:messageCheck
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
        [checkAlertView show];
        return FALSE;
    }

    return TRUE;
}

//- (IBAction)loginSystem:(id)sender {
//
//}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSUserDefaults *ServerUrl = [NSUserDefaults standardUserDefaults];
    NSString *stringurl=[ServerUrl objectForKey:@"serverurl"];
    NSURL *url= [[NSURL alloc] initWithString:stringurl];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *internetStatus=[user objectForKey:@"Internet"];
    
    if ([internetStatus isEqualToString:@"NO"]) {
            offlineAlert=[[UIAlertView alloc] initWithTitle:@"Connection error !"
                                                    message:@"Network error, check your network and try again"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:@"Using offline mode", nil];
                [offlineAlert show];
        
    } else if([internetStatus isEqualToString:@"YES"]){
        @try {
            if ([[segue identifier] isEqualToString:@"Login"])
            {
                if (![self checkLoginAccount]) {
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    [user setValue:@"No" forKey:@"checkLogin"];
                    return;
                }
                
                [phoneNumberTextField resignFirstResponder];
                [passwordTextField resignFirstResponder];
                
                phoneString = [phoneNumberTextField text];
                passwordString = [passwordTextField text];
                //            NSUserDefaults *phone = [NSUserDefaults standardUserDefaults];
                //            [phone setValue:phoneString forKey:@"phone"];
                AppDelegate *getPassword = [[AppDelegate alloc]init];
                getPassword.password=passwordString;
                
                //            NSURL *url = [[NSURL alloc] initWithString:@""];http://192.168.10.115:3000/users
                
                NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
                NSString *ssid=[session objectForKey:@"ssid"];
                NSLog(@"SSID: %@",ssid);
                
                NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] init];
                
                [myDictionary setObject:@"loginUser" forKey:@"key"];
                [myDictionary setObject:@"true" forKey:@"sid"];
                [myDictionary setObject:passwordString forKey:@"password"];
                [myDictionary setObject:phoneString forKey:@"phonenumber"];
                
                NSData *myData = [NSJSONSerialization dataWithJSONObject:myDictionary
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:nil];
                
                
                
                Server *connect = [[Server alloc] init];
                NSString *result = [connect postRequest:url withData:myData];
                 NSLog(@"result is: %@",result);
                
                if([result isEqualToString:@"User is still online!"]||[result isEqualToString:@"Login success!"])
                {
                    if ([result isEqualToString:@"Login success!"]) {
                        successAlert = [[UIAlertView alloc] initWithTitle:@"Log in successfully"
                                                                  message:@"Welcome to Disaster Helper Application"
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                        //[successAlert show];
                        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                        [user setValue:phoneString forKey:@"phone"];
                        [user setValue:@"LOGIN" forKey:@"checkLogin"];
                        //  NSLog(@"test1");
                    } else if ([result isEqualToString:@"User is still online!"]) {
                        
                        successAlert = [[UIAlertView alloc] initWithTitle:@"Logged in failed"
                                                                  message:@"User is still online, please wait some minute !"
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                        [successAlert show];
                        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                        [user setValue:phoneString forKey:@"phone"];
                        [user setValue:@"FALSE" forKey:@"checkLogin"];
                        // NSLog(@"test2");
                        
                        
                    }
                    
                }
                else
                {
                    
                    if([result isEqualToString:@"Phone number is not exist!"])
                    {
                        notexistAlert =[[UIAlertView alloc] initWithTitle:@"Log in Failed"
                                                                  message:@"Your account is not exist.\nPlease check again"
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                        [notexistAlert show];
                        
                    }
                    else if([result isEqualToString:@"Login failed! Please check your password again"])
                    {
                        wrongPassAlert = [[UIAlertView alloc] initWithTitle:@"Log in Failed"
                                                                    message:@"Wrong password.\nPlease check your password again"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                        [wrongPassAlert show];
                    }
                    else if([result isEqualToString:@"Invalid!"])
                    {
                        invalidFormatAlert = [[UIAlertView alloc] initWithTitle:@"Log in Failed"
                                                                        message:@"Please enter right phone number and password."
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [invalidFormatAlert show];
                    }
                    
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    [user setValue:@"No" forKey:@"checkLogin"];
                    [user setValue:@"" forKey:@"phone"];
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Login error");
            ServerDown=[[UIAlertView alloc] initWithTitle:@"Can not connect with server"
                                                  message:@"Something went wrong with our dear server. Please try again or choose offline mode!"
                                                 delegate:self
                                        cancelButtonTitle:@"Try again"
                                        otherButtonTitles:@"Offline mode", nil];
            [ServerDown show];
        }
    }
    
    }


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
     NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if (alertView == ServerDown)
    {
            if ([title isEqualToString:@"Offline mode"])
            {
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setValue:@"Offline" forKey:@"checkLogin"];
                NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
                [session setValue:@"" forKey:@"ssid"];
            }
        
    if (alertView == offlineAlert)
        {
            if ([title isEqualToString:@"Using offline mode"])
            {
//                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//                [user setValue:@"NoInternet" forKey:@"checkLogin"];
                NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
                [session setValue:@"" forKey:@"ssid"];
            }

        }
    
    }
}

- (IBAction)dismissPhoneTextField:(id)sender {
    [phoneNumberTextField resignFirstResponder];
}

- (IBAction)dismissPassTextField:(id)sender {
    NSInteger nextTag = passwordTextField.tag + 1;
    // Try to find next responder
    UIResponder *nextResponder = [passwordTextField.superview viewWithTag:nextTag];
    
    if (nextResponder) {
        [self.scollViewLogin setContentOffset:CGPointMake(0,passwordTextField.center.y-180) animated:YES];
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        [self.scollViewLogin setContentOffset:CGPointMake(0,-40) animated:YES];
        [passwordTextField resignFirstResponder];
       // return YES;
    }
    [passwordTextField resignFirstResponder];
}


-(IBAction)returned:(UIStoryboardSegue *)segue {

    NSUserDefaults *savePhone = [NSUserDefaults standardUserDefaults];
    if ([[savePhone valueForKey:@"save"]isEqualToString:@"TRUE"]) {
        phoneNumberTextField.text = [savePhone valueForKey:@"phoneforLogin"];
        passwordTextField.text = [savePhone valueForKey:@"passforLogin"];
    }
}
//- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex: (NSInteger *)buttonIndex {
//    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
//    //catch alerView
//    if (alertView == notexistAlert || alertView == wrongPassAlert || alertView == invalidFormatAlert) {
//        if ([title isEqualToString:@"OK"]) {
//            [self dismissModalViewControllerAnimated:YES];
//        }
//    }
//}

- (IBAction)clickTextFieldPassword:(id)sender {
    [self.scollViewLogin setContentOffset:CGPointMake(0,passwordTextField.center.y-180) animated:YES];
}
@end
