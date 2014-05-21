//
//  RegisterViewController.h
//  DisasterHelper
//
//  Created by Tan (Tharin) T.NGUYEN on 2/14/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "QuartzCore/CALayer.h"
@interface RegisterViewController : UIViewController {
    
    IBOutlet UIImageView *image;
    IBOutlet UIImageView *imageName;
    IBOutlet UIImageView *imagePhone;
    IBOutlet UIImageView *imagePass;
    IBOutlet UIImageView *imageConfirmPass;
    
    __weak IBOutlet UITextField *nameTextField;
    __weak IBOutlet UITextField *confirmTextField;
    __weak IBOutlet UITextField *passwordTextField;
    __weak IBOutlet UITextField *phoneTextField;
    IBOutlet UIImageView *backgroundImage;
    IBOutlet UIButton *buttonSignup;
    
    IBOutlet UIButton *buttonBackLogin;
    IBOutlet UIButton *buttonSignUp;
   }
- (IBAction)dismissConfirmText:(id)sender;
- (IBAction)dismissPasswordText:(id)sender;
- (IBAction)dismissPhoneText:(id)sender;
- (IBAction)dismissNameText:(id)sender;

@property (strong, nonatomic) IBOutlet UIScrollView *scolleViewRegister;
@property (strong, nonatomic) IBOutlet UIView *contentViewRegister;

@property (strong, nonatomic) NSString *phoneString;
@property (strong, nonatomic) NSString *passwordString;
@property (strong, nonatomic) NSString *confirmString;
@property (strong, nonatomic) NSString *nameString;
//@property (strong,nonatomic) NSString *passMeassage;

- (IBAction)registerButton:(id)sender;

- (IBAction)ClickPasswordField:(id)sender;
- (IBAction)ClickReturnPasswordField:(id)sender;
- (IBAction)ClickConfirmPassField:(id)sender;
- (IBAction)ClickReturnConfirmPassField:(id)sender;


@end
