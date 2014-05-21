//
//  ChangePasswordController.m
//  DisasterHelper
//
//  Created by ENCLAVEIT on 3/19/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import "ChangePasswordController.h"

@interface ChangePasswordController ()

@end
UIAlertView *alertChangedPass;
UIAlertView *alertWrongOldPass;
UIAlertView *alertWrongConfirm;
@implementation ChangePasswordController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [scrollChangePass layoutIfNeeded];
    scrollChangePass.contentSize=contentView.bounds.size;
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
    self.view.backgroundColor = UIColorFromRGB(0x7c5c71);
    [backgroundImage setBackgroundColor:UIColorFromRGB(0x87CEFA)];
    [changePassImage setBackgroundColor:UIColorFromRGB(0x007fff)];
    
    //Drog shadow
    imageOldPass.layer.shadowColor = [UIColor grayColor].CGColor;
    imageOldPass.layer.shadowOffset = CGSizeMake(0, 2);
    imageOldPass.layer.shadowOpacity = 2;
    imageOldPass.layer.shadowRadius = 2.0;
    imageOldPass.clipsToBounds = NO;
    
    imageNewPass.layer.shadowColor = [UIColor grayColor].CGColor;
    imageNewPass.layer.shadowOffset = CGSizeMake(0, 2);
    imageNewPass.layer.shadowOpacity = 2;
    imageNewPass.layer.shadowRadius = 2.0;
    imageNewPass.clipsToBounds = NO;

    imageConfirmNewPass.layer.shadowColor = [UIColor grayColor].CGColor;
    imageConfirmNewPass.layer.shadowOffset = CGSizeMake(0, 2);
    imageConfirmNewPass.layer.shadowOpacity = 2;
    imageConfirmNewPass.layer.shadowRadius = 2.0;
    imageConfirmNewPass.clipsToBounds = NO;

    changePassImage.layer.shadowColor = [UIColor grayColor].CGColor;
    changePassImage.layer.shadowOffset = CGSizeMake(0, 2);
    changePassImage.layer.shadowOpacity = 2;
    changePassImage.layer.shadowRadius = 2.0;
    changePassImage.clipsToBounds = NO;
    
    //Custom navigator back button
    
    UIImage *buttonImage = [UIImage imageNamed:@"back-arrow.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;

    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changePassword:(id)sender {
    NSUserDefaults *checkLogin = [NSUserDefaults standardUserDefaults];
    NSString *check = [checkLogin valueForKey:@"checkLogin"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
   	NSString *internetStatus=[user objectForKey:@"Internet"];
    
    if ([internetStatus isEqualToString:@"NO"]) {
        NSLog(@"Run with out network and don't do any thing");
    } else if([internetStatus isEqualToString:@"YES"]) {
        if ([check isEqualToString:@"Offline"]) {
            UIAlertView *Offlinealert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"You can't change password when using offline mode" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [Offlinealert show];
            
        } else {
            NSString *oldPassword=oldPassTextField.text;
            NSString *newPassword=newPassTextField.text;
            NSString *confirmPassword=confirmPassTextField.text;
            //check right old password
            
            //Get current password
            
            
            //check right new password and confirm password
            if (![newPassword isEqualToString:confirmPassword]) {
                alertWrongConfirm=[[UIAlertView alloc]initWithTitle:@"Wrong Password" message:@"Your password does not match.\nPlease try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertWrongConfirm show];
                //oldPassTextField.text=@"";
                newPassTextField.text=@"";
                confirmPassTextField.text=@"";
            }
            else{
                //Update password
                NSUserDefaults *phonenumber = [NSUserDefaults standardUserDefaults];
                NSString *phoneNumber =[phonenumber valueForKey:@"phone"];
                NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
                NSString *ssid=[session objectForKey:@"ssid"];
                NSUserDefaults *ServerUrl = [NSUserDefaults standardUserDefaults];
                NSString *stringurl=[ServerUrl objectForKey:@"serverurl"];
                NSURL *url= [[NSURL alloc] initWithString:stringurl];
                
                
                //        NSURL *url = [[NSURL alloc] initWithString:@"http://192.168.10.91:3000/users"];
                NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] init];
                [myDictionary setObject:@"changePassword" forKey:@"key"];
                [myDictionary setObject:ssid forKey:@"sid"];
                [myDictionary setObject:oldPassword forKey:@"password"];
                [myDictionary setObject:phoneNumber forKey:@"phonenumber"];
                [myDictionary setObject:newPassword forKey:@"newpassword"];
                
                NSData *myData = [NSJSONSerialization dataWithJSONObject:myDictionary options:kNilOptions error:nil];
                
                Server *connect = [[Server alloc] init];
                NSString *result = [connect postRequest:url withData:myData];
                if([result isEqualToString:@"Password updated updated!"]){
                    //Alert user change pass success
                    alertChangedPass = [[UIAlertView alloc]initWithTitle:@"Changed Password" message:@"Your password has been changed.\n" delegate:self cancelButtonTitle:@"YES" otherButtonTitles: nil];
                    [alertChangedPass show];
                    oldPassTextField.text=@"";
                    newPassTextField.text=@"";
                    confirmPassTextField.text=@"";
                    
                }else{
                    if ([result isEqualToString:@"Old password doesnot match!"]) {
                        //Alert user old password wrong
                        alertWrongOldPass = [[UIAlertView alloc]initWithTitle:@"Wrong Password" message:@"Your old is not correct.\nPlease try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alertWrongOldPass show];
                        oldPassTextField.text=@"";
                    }
                }
                
                
            }
            
        }

    }
            
}

- (IBAction)dismissKeyboard:(id)sender {
    [oldPassTextField resignFirstResponder];
    [newPassTextField resignFirstResponder];
    [confirmPassTextField resignFirstResponder];
    
}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
//    if (alertView == alertWrongOldPass || alertView == alertWrongConfirm) {
//        if ([title isEqualToString:@"OK"]) {
//            [alertView dismissWithClickedButtonIndex:0 animated:YES];
//        }
//    }else{
//        if ([title isEqualToString:@"OK"]) {
//            [alertView dismissWithClickedButtonIndex:0 animated:YES];
//        }else{
//            //Call log out function
//            LogoutViewController *logout=[[LogoutViewController alloc]init];
//            
//        }
//    }
//}
@end
