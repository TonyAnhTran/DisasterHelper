//
//  LogoutViewController.m
//  DisasterHelper
//
//  Created by Tan (Tharin) T. NGUYEN on 3/11/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import "LogoutViewController.h"
#import "MainFlatViewController.h"

@interface LogoutViewController ()
{
    //MainFlatViewController *weath;
}
@property (strong, nonatomic) UIAlertView *successAlert, *failAlert, *checkAlertView;
@end

@implementation LogoutViewController
@synthesize successAlert, failAlert, checkAlertView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
    
    imageBackground.backgroundColor=UIColorFromRGB(0xf4eece);
    
    //Custom back button
    UIImage *buttonImage = [UIImage imageNamed:@"back111.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    [super viewDidLoad];
	
    // Do any additional setup after loading the view.
    
    
    
}

NSInteger static compareViewsByOrigin(id sp1, id sp2, void *context)
{
    // UISegmentedControl segments use UISegment objects (private API). But we can safely cast them to UIView objects.
    float v1 = ((UIView *)sp1).frame.origin.x;
    float v2 = ((UIView *)sp2).frame.origin.x;
    if (v1 < v2)
        return NSOrderedAscending;
    else if (v1 > v2)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 //   NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
//    NSUserDefaults *checkLogin = [NSUserDefaults standardUserDefaults];
//    NSString *check = [checkLogin valueForKey:@"checkLogin"];
    NSString *ssid=[session objectForKey:@"ssid"];
    
    
    if ([ssid isEqualToString:@""]) {
        NSLog(@"Logout in offline mode");
    } else {
        @try
        {
            NSUserDefaults *ServerUrl = [NSUserDefaults standardUserDefaults];
            NSString *stringurl=[ServerUrl objectForKey:@"serverurl"];
            NSURL *url= [[NSURL alloc] initWithString:stringurl];
            
            if ([segue.identifier isEqualToString:@"CheckLogOut"])
            {
                //        NSURL *url = [[NSURL alloc] initWithString:@"http://192.168.10.115:3000/users"];
                
                
                NSString *ssid=[session objectForKey:@"ssid"];
                
                
                NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] init];
                [myDictionary setObject:@"logoutUser" forKey:@"key"];
                [myDictionary setObject:ssid forKey:@"sid"];
                [myDictionary setObject:[user valueForKey:@"phone"] forKey:@"phonenumber"];
                
                NSData *myData = [NSJSONSerialization dataWithJSONObject:myDictionary options:NSJSONReadingMutableContainers error:nil];
                
                Server *connect = [[Server alloc] init];
                NSString *result = [connect postRequest:url withData:myData];
                
                
                
                if(![result isEqualToString:@"Phone number is not exist!"])
                {
                    successAlert = [[UIAlertView alloc] initWithTitle:@"Logout successful" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [successAlert show];
                    [user setValue:@"" forKey:@"phone"];
                    [user setValue:@"" forKey:@"checkLogin"];
                    
                } else if([result isEqualToString:@"Phone number is not exist!"])
                {
                    failAlert =[[UIAlertView alloc] initWithTitle:@"Fail" message:@"Phone number is not exist!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [failAlert show];
                    
                }
            }
            

        }
        @catch (NSException *exception) {
            NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
            [session setValue:@"" forKey:@"ssid"];
             NSLog(@"Logout in offline mode");
        }
        @finally {
        }
        
    }
   

//    if ([check isEqualToString:@"Offline"]) {
//                
////        [session setValue:@"false" forKey:@"ssid"];
////        [setting setValue:@"false" forKey:@"NsTimestatus"];
////        [user setValue:@"Offline" forKey:@"checkLogin"];
//    }
    
}
@end
