//
//  AppDelegate.m
//  DisasterHelper
//
//  Created by Tan (Tharin) T.NGUYEN on 2/14/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation AppDelegate
@synthesize nameTip,contentsTip,emergencyContact,userLocation,noticeContents,noticeNumber,noticeLat,noticeLong,password,noticeDate,noticeUsername,noticeId,noticeReplied;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //http://192.168.10.115:3000/users  @"http://projectdh.herokuapp.com/users"
    [GMSServices provideAPIKey:@"AIzaSyBz7GqCvizFHZ9OsjeZEYr4UvzJ70SYQrE"];
    NSUserDefaults *ServerUrl = [NSUserDefaults standardUserDefaults];
    NSString *serverIP= [NSString stringWithFormat:@"http://projectdh.herokuapp.com"];
    NSString *url= [NSString stringWithFormat:@"http://projectdh.herokuapp.com/users"];
    [ServerUrl setObject:url forKey:@"serverurl"];
    [ServerUrl setObject:serverIP forKey:@"serverIP"];
    
//    //[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigatorFlat.png"]];
//    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"navigatorFlat.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forBarMetrics:UIBarMetricsDefault];
//    // Set this in every view controller so that the back button displays back instead of the root view controller name
////    UIImage *backButtonImage = [[UIImage imageNamed:@"backButtonFlat.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)];
////    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    
//    //RGB color macro
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//    
//    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
//    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]setBackButtonBackgroundImage:<#(UIImage *)#> forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIImage *myImage = [UIImage imageNamed:@"navigator-bar.png"];
    //[myImage drawInRect:CGRectMake(0, 0,320 ,10 )];
    [[UINavigationBar appearance] setBackgroundImage:myImage forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundColor:UIColorFromRGB(0x000000)];

    
    
    
//    [[UINavigationBar appearance] setTintColor: UIColorFromRGB(0x3090c7)];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], UITextAttributeTextColor,
                                                           [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],UITextAttributeTextShadowColor,
                                                           [NSValue valueWithUIOffset:UIOffsetMake(0, 1)],
                                                           UITextAttributeTextShadowOffset,
                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], UITextAttributeFont, nil]];
    
    // Customing the segmented control
//    UIImage *segmentSelected = [[UIImage imageNamed:@"select-segment.png"]
//                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
//    UIImage *segmentUnselected = [[UIImage imageNamed:@"unselect-segment.png"]
//                                  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
////    UIImage *segmentSelectedUnselected =[[UIImage imageNamed:@"segcontrol_sel-uns.png"]
////                                         resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
////    UIImage *segUnselectedSelected =[[UIImage imageNamed:@"segcontrol_uns-sel.png"]
////                                     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
////    UIImage *segmentUnselectedUnselected =[[UIImage imageNamed:@"segcontrol_uns-uns.png"]
////                                           resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
//    
//    [[UISegmentedControl appearance] setBackgroundImage:segmentUnselected
//                                               forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [[UISegmentedControl appearance] setBackgroundImage:segmentSelected
//                                               forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
//    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                [UIFont systemFontOfSize:12], UITextAttributeFont,
//                                [UIColor blueColor], UITextAttributeTextColor,
//                                nil];
//    [[UISegmentedControl appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
//    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                           [UIFont boldSystemFontOfSize:12], UITextAttributeFont,
//                                           [UIColor whiteColor], UITextAttributeTextColor,
//                                           nil];
//    [[UISegmentedControl appearance] setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
//    [[UISegmentedControl appearance] setDividerImage:segmentUnselectedUnselected
//                                 forLeftSegmentState:UIControlStateNormal
//                                   rightSegmentState:UIControlStateNormal
//                                          barMetrics:UIBarMetricsDefault];
//    [[UISegmentedControl appearance] setDividerImage:segmentSelectedUnselected
//                                 forLeftSegmentState:UIControlStateSelected
//                                   rightSegmentState:UIControlStateNormal
//                                          barMetrics:UIBarMetricsDefault];
//    [[UISegmentedControl appearance]
//     setDividerImage:segUnselectedSelected
//     forLeftSegmentState:UIControlStateNormal
//     rightSegmentState:UIControlStateSelected
//     barMetrics:UIBarMetricsDefault];
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
