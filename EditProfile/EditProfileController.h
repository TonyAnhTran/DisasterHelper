//
//  EditProfileController.h
//  DisasterHelper
//
//  Created by ENCLAVEIT on 3/19/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Server.h"
#import "NewServer.h"
#import "QuartzCore/CALayer.h"
@interface EditProfileController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    IBOutlet UIImageView *profilePicture;
    IBOutlet UIImageView *imageUsername;
    IBOutlet UIImageView *imagePhoneNumber;
    
    
    UIImagePickerController *picker;
    IBOutlet UITextField *userNameTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UITextField *newPasswordImage;
    IBOutlet UITextField *oldPasswordImage;
    
    
    
    IBOutlet UIImageView *backgroundImage;
    IBOutlet UIButton *saveChangeButton;
    IBOutlet UIButton *buttonChangeImage;
    IBOutlet UIButton *buttonUserInfo;
    IBOutlet UIButton *buttonChangePass;
    
    
    
    
    IBOutlet UIImageView *imagePassword;
    IBOutlet UIImageView *imageNewPass;
    IBOutlet UIImageView *imageConfirmPass;
    IBOutlet UIImageView *imageComponent;
    
    
    IBOutlet UILabel *labelPhoneNumber;
    
    
    
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewEditProfile;
@property (strong, nonatomic) IBOutlet UIView *contentViewEditProfile;

- (IBAction) choosePicture;
@property (strong, nonatomic) IBOutlet UIButton *SaveChange;
- (IBAction)saveChange:(id)sender;
- (IBAction)dismissUsernameTextField:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *editName;
- (IBAction)editName:(id)sender;
- (IBAction)editPass:(id)sender;
//- (IBAction)userInfo:(id)sender;

- (IBAction)ClickUsernameField:(id)sender;
- (IBAction)ClickReturnUsernameField:(id)sender;
- (IBAction)ClickPasswordField:(id)sender;
- (IBAction)ClickReturnPasswordField:(id)sender;
- (IBAction)ClickNewPasswordField:(id)sender;
- (IBAction)ClickReturnNewPasswordField:(id)sender;
- (IBAction)ClickConfirmPasswordField:(id)sender;
- (IBAction)ClickReturnConfirmPasswordField:(id)sender;


@end
