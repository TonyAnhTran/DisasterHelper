//
//  SegueLogin.m
//  DisasterHelper
//
//  Created by Tan (Tharin) T. NGUYEN on 3/10/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import "SegueLogin.h"
#import "NewServer.h"
#import "Server.h"

@implementation SegueLogin
-(void)perform {
    NSUserDefaults *checkLogin = [NSUserDefaults standardUserDefaults];
     NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [checkLogin setValue:@"FALSE" forKey:@"save"];
    NSString *check = [checkLogin valueForKey:@"checkLogin"];
    NSString *internetStatus=[user objectForKey:@"Internet"];
    
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    [setting setValue:@"50" forKey:@"RadiusSearch"];
    [setting setValue:@"2" forKey:@"VictimTimeSet"];
    
    NSString *victimradius=[setting objectForKey:@"RadiusSearch"];
    //NSLog(@"Victim radius: %@",victimradius);
    NSString *victimTimeSet=[setting objectForKey:@"VictimTimeSet"];
    //NSLog(@"victim time set: %@",victimTimeSet);
    
    if ([internetStatus isEqualToString:@"NO"]) {
        NSLog(@"Run with out internet");
        [[self sourceViewController] presentModalViewController:[self destinationViewController]
                                                       animated:NO];
        
    } else if([internetStatus isEqualToString:@"YES"])
    {
        if ([check isEqualToString:@"Offline"])
        {
            [[self sourceViewController] presentModalViewController:[self destinationViewController]
                                                           animated:NO];
        }
        
        else if ([check isEqualToString:@"LOGIN"])
        {
            NSUserDefaults *phonenumber = [NSUserDefaults standardUserDefaults];
            NSString *userPhone =[phonenumber valueForKey:@"phone"];
            
            
            NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
            NSString *ssid=[session objectForKey:@"ssid"];
            
            NSUserDefaults *ServerUrl = [NSUserDefaults standardUserDefaults];
            NSString *stringurl=[ServerUrl objectForKey:@"serverurl"];
            NSURL *url= [[NSURL alloc] initWithString:stringurl];
            
            @try{
                NSMutableDictionary *myVictimlist = [[NSMutableDictionary alloc] init];
                [myVictimlist setValue:@"checkVictim" forKey:@"key"];
                [myVictimlist setValue:victimradius forKey:@"radius"];
                [myVictimlist setObject:ssid forKey:@"sid"];
                [myVictimlist setObject:victimTimeSet forKey:@"filter"];
                [myVictimlist setValue:userPhone forKey:@"phonenumber"];
                
                //          NSError* error;
                NSData *myData1 = [NSJSONSerialization dataWithJSONObject:myVictimlist
                                                                  options:kNilOptions
                                                                    error:nil];
                // NSLog(@"Mydata1: %@",myData1);
                
                //            NSURL *url = [[NSURL alloc] initWithString:@"http://192.168.10.115:3000/users"];
                NewServer *connect = [[NewServer alloc] init];
                NSArray *data = [[connect postRequest:url withData:myData1]mutableCopy];
                
                NSMutableArray *victimPhoneData=[data valueForKey:@"phonenumber"];
                for (int i=0; i<victimPhoneData.count; i++) {
                    NSString *victimPhone=[victimPhoneData objectAtIndex:i];
                    if ([victimPhone isEqualToString:userPhone]) {
                        [session setObject:@"YES" forKey:@"isVictim"];
                    }
                }
                
                NSUserDefaults *victimData = [NSUserDefaults standardUserDefaults];
                [victimData setValue:data forKey:@"victimdata"];
            }
            
            @catch(NSException *e){
                NSLog(@"Some thing wrong with get victim- SequeLongin.m");
                UIAlertView *offlineAlert=[[UIAlertView alloc] initWithTitle:@"Connection error !"
                                                                     message:@"Can't connect to server, automatic switch to offline mode. You can turn off it in setting."
                                                                    delegate:self
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                [offlineAlert show];
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setValue:@"Offline" forKey:@"checkLogin"];
                
            }
            
            @finally{}
            
            [[self sourceViewController] presentModalViewController:[self destinationViewController]
                                                           animated:NO];
        }

    }

        
    
}
@end
