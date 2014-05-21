//
//  LogoutViewController.h
//  DisasterHelper
//
//  Created by Tan (Tharin) T. NGUYEN on 3/11/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Server.h"
#import "MainFlatViewController.h"

@interface LogoutViewController : UIViewController{
    
    
    IBOutlet UIImageView *imageBackground;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
@end
