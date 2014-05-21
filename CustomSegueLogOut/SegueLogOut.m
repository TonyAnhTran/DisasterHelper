//
//  SegueLogOut.m
//  DisasterHelper
//
//  Created by Tan (Tharin) T. NGUYEN on 3/11/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import "SegueLogOut.h"

@implementation SegueLogOut
-(void)perform {
        NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
        NSUserDefaults *checkLogin = [NSUserDefaults standardUserDefaults];
        NSUserDefaults *victimData = [NSUserDefaults standardUserDefaults];
        
        NSString *check = [checkLogin valueForKey:@"checkLogin"];
        
        NSLog(@"Log out");
        [session setValue:@"" forKey:@"ssid"];
        [setting setValue:@"false" forKey:@"NsTimestatus"];
        [user setValue:@"Offline" forKey:@"checkLogin"];
        [victimData removeObjectForKey:@"victimdata"];
        
        NSLog(@"check login status: %@",check);
        
        [[self sourceViewController] presentModalViewController:[self destinationViewController] animated:NO];
}
@end
