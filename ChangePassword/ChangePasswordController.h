//
//  ChangePasswordController.h
//  DisasterHelper
//
//  Created by ENCLAVEIT on 3/19/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Server.h"
#import "LogoutViewController.h"
#import "QuartzCore/CALayer.h"
@interface ChangePasswordController : UIViewController
{
    
    IBOutlet UITextField *oldPassTextField;
    IBOutlet UITextField *newPassTextField;
    IBOutlet UITextField *confirmPassTextField;
    IBOutlet UIImageView *backgroundImage;
    IBOutlet UIButton *changePassImage;
    
    IBOutlet UIImageView *imageOldPass;
    IBOutlet UIImageView *imageNewPass;
    IBOutlet UIImageView *imageConfirmNewPass;
    
    
    IBOutlet UIScrollView *scrollChangePass;
    IBOutlet UIView *contentView;
}
- (IBAction)changePassword:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;


@end
