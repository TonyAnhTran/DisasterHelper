//
//  NotificationViewController.m
//  DisasterHelper
//
//  Created by Tan (Tharin) T.NGUYEN on 2/14/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import "NotificationViewController.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController
@synthesize currentNotice;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
 //   UIImage *image;
    
    phoneNumberRequest.text=currentNotice.noticeNumber;
    requestContents.text=[NSString stringWithFormat:@"Lat=%@, Long=%@",currentNotice.noticeLat,currentNotice.noticeLong];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
