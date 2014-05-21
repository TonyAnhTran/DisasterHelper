//
//  LoginViewController.h
//  DisasterHelper
//
//  Created by Tan (Tharin) T.NGUYEN on 2/14/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "QuartzCore/CALayer.h"
#import "Reachability.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate> {
    Reachability *internetReachableFoo;
    IBOutlet UILabel *labelDisasterHelper;
    IBOutlet UITextField *phoneNumberTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UIButton *loginButton;
    IBOutlet UIImageView *image;
    IBOutlet UIImageView *backgroundImage;
    IBOutlet UIImageView *loginBackgroundImage;
}
@property (strong, nonatomic)NSString *phoneString;
@property (strong, nonatomic)NSString *passwordString;
//@property (strong, nonatomic) UIScrollView *scollerLogin;
//@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) IBOutlet UIScrollView *scollViewLogin;
@property (strong, nonatomic) IBOutlet UIView *contentViewLogin;
- (IBAction)clickTextFieldPassword:(id)sender;


//- (IBAction)loginSystem:(id)sender;
- (IBAction)dismissPhoneTextField:(id)sender;
- (IBAction)dismissPassTextField:(id)sender;
//- (IBAction)textFieldDidBeginEditing:(id)sender;


- (IBAction)registerButton:(id)sender;

@end
