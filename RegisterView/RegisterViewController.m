//
//  RegisterViewController.m
//  DisasterHelper
//
//  Created by Tan (Tharin) T.NGUYEN on 2/14/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import "RegisterViewController.h"
#import "Server.h"
#import "LoginViewController.h"

@interface RegisterViewController ()
@property (strong, nonatomic) UIAlertView *alertWrongConfirmPass, *checkAlertView;
@property (strong, nonatomic) UIAlertView *alertRegisterSucceesss;
@property (strong, nonatomic) UIAlertView *alertWrongName;
@property (strong, nonatomic) UIAlertView *alertWrongPass;
@property (strong, nonatomic) UIAlertView *alertWrongPhone;
@property (strong, nonatomic) UIAlertView *alertAccountExist;
@property (strong, nonatomic) UIAlertView *alertInvalidValue;

@end

@implementation RegisterViewController

@synthesize alertWrongPass, alertAccountExist, alertInvalidValue, alertRegisterSucceesss, alertWrongConfirmPass, alertWrongName,alertWrongPhone, checkAlertView;
@synthesize nameString, phoneString, confirmString, passwordString;


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
    [self.scolleViewRegister layoutIfNeeded];
    self.scolleViewRegister.contentSize=self.contentViewRegister.bounds.size;
}

-(void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    //Custom back button
    
    UIImage *buttonImage = [UIImage imageNamed:@"back111.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//    [backgroundImage setBackgroundColor:UIColorFromRGB(0x87CEFA)];
//    [buttonSignup setBackgroundColor:UIColorFromRGB(0x87CEFA)];
//    [buttonSignup setBackgroundColor:UIColorFromRGB(0x007fff)];
//    [buttonBackLogin setBackgroundColor:UIColorFromRGB(0x007fff)];
//    
//    //Drog shadow here
//    imageName.layer.shadowColor = [UIColor grayColor].CGColor;
//    imageName.layer.shadowOffset = CGSizeMake(0, 2);
//    imageName.layer.shadowOpacity = 2;
//    imageName.layer.shadowRadius = 2.0;
//    imageName.clipsToBounds = NO;
//    
//    imagePhone.layer.shadowColor = [UIColor grayColor].CGColor;
//    imagePhone.layer.shadowOffset = CGSizeMake(0, 2);
//    imagePhone.layer.shadowOpacity = 2;
//    imagePhone.layer.shadowRadius = 2.0;
//    imagePhone.clipsToBounds = NO;
//    
//    imagePass.layer.shadowColor = [UIColor grayColor].CGColor;
//    imagePass.layer.shadowOffset = CGSizeMake(0, 2);
//    imagePass.layer.shadowOpacity = 2;
//    imagePass.layer.shadowRadius = 2.0;
//    imagePass.clipsToBounds = NO;
//    
//    imageConfirmPass.layer.shadowColor = [UIColor grayColor].CGColor;
//    imageConfirmPass.layer.shadowOffset = CGSizeMake(0, 2);
//    imageConfirmPass.layer.shadowOpacity = 2;
//    imageConfirmPass.layer.shadowRadius = 2.0;
//    imageConfirmPass.clipsToBounds = NO;
//    
//    buttonSignUp.layer.shadowColor = [UIColor grayColor].CGColor;
//    buttonSignUp.layer.shadowOffset = CGSizeMake(0, 2);
//    buttonSignUp.layer.shadowOpacity = 2;
//    buttonSignUp.layer.shadowRadius = 2.0;
//    buttonSignUp.clipsToBounds = NO;
//    
//    
//    buttonBackLogin.layer.shadowColor = [UIColor grayColor].CGColor;
//    buttonBackLogin.layer.shadowOffset = CGSizeMake(0, 2);
//    buttonBackLogin.layer.shadowOpacity = 2;
//    buttonBackLogin.layer.shadowRadius = 2.0;
//    buttonBackLogin.clipsToBounds = NO;
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)checkCreateAccount {
    //get string from TextField
    nameString = [[NSString alloc] initWithString:[nameTextField text]];
    phoneString = [[NSString alloc] initWithString:[phoneTextField text]];
    passwordString = [[NSString alloc] initWithString:[passwordTextField text]];
    confirmString = [[NSString alloc] initWithString:[confirmTextField text]];
    
    NSString *messageCheck;
    if (([phoneString isEqualToString:@""]) || ([passwordString isEqualToString:@""]) || [nameString isEqualToString:@""]) {
        messageCheck = @"Please input information for all fields.";
        checkAlertView = [[UIAlertView alloc] initWithTitle:@"Register Failed"
                                                    message:messageCheck
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
        [checkAlertView show];
        return FALSE;
    }
    if (![passwordString isEqualToString:confirmString]) {
        messageCheck = @"Wrong password.\nPlease check your password again.";
        checkAlertView = [[UIAlertView alloc] initWithTitle:@"Register Failed"
                                                    message:messageCheck
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
        [checkAlertView show];
        return FALSE;
    }
    return TRUE;
}

- (IBAction)registerButton:(id)sender {
    
    NSUserDefaults *ServerUrl = [NSUserDefaults standardUserDefaults];
    NSString *stringurl=[ServerUrl objectForKey:@"serverurl"];
    NSURL *url= [[NSURL alloc] initWithString:stringurl];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
   	NSString *internetStatus=[user objectForKey:@"Internet"];

    
    @try {
    if (![self checkCreateAccount]) {
        return;
    }
        
    [phoneTextField resignFirstResponder];
    [nameTextField resignFirstResponder];
    [confirmTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    
    nameString = [[NSString alloc] initWithString:[nameTextField text]];
    phoneString = [[NSString alloc] initWithString:[phoneTextField text]];
    passwordString = [[NSString alloc] initWithString:[passwordTextField text]];
    confirmString = [[NSString alloc] initWithString:[confirmTextField text]];
    NSString *result = [[NSString alloc] init];
    
//    NSUInteger *nameLength = [nameString length];
//    NSUInteger *phoneLength = [phoneString length];
//    NSUInteger *passLength = [passwordString length];
        if ([internetStatus isEqualToString:@"NO"]) {
            NSLog(@"Run with out network and can create account");
            
        }
        else if([internetStatus isEqualToString:@"YES"]) {
            NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] init];
            [myDictionary setObject:@"createUser" forKey:@"key"];
            [myDictionary setObject:@"true" forKey:@"sid"];
            [myDictionary setObject:nameString forKey:@"username"];
            [myDictionary setObject:passwordString forKey:@"password"];
            [myDictionary setObject:phoneString forKey:@"phonenumber"];
            
            
            NSData *myData = [NSJSONSerialization dataWithJSONObject:myDictionary options:NSJSONReadingMutableContainers error:nil];
            NSString *myString = [[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];
            NSLog(@"%@",myString);
            
            
            //creat server's address
            //    NSURL *url = [NSURL URLWithString:@"http://192.168.10.115:3000/users/"];
            Server *connect = [[Server alloc] init];
            result = [connect postRequest:url withData:myData];
            // create NSUserdefaults to save phone, pass for login
            NSUserDefaults *savePhone = [NSUserDefaults standardUserDefaults];
            
            if ([result isEqualToString:@"Create user success!"]) {
                alertRegisterSucceesss = [[UIAlertView alloc] initWithTitle:@"Register Successfully"
                                                                    message:@""
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertRegisterSucceesss show];
                
                // create NSUserdefaults to save phone, pass for login
                [savePhone setValue:@"TRUE" forKey:@"save"];
                [savePhone setValue:[phoneTextField text] forKey:@"phoneforLogin"];
                [savePhone setValue:[passwordTextField text] forKey:@"passforLogin"];
                
            } else if([result isEqualToString:@"This phonenumber has been registered!"]) {
                alertAccountExist = [[UIAlertView alloc] initWithTitle:@"Register Failed"
                                                               message:@"This phone number has been registered."
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
                [alertAccountExist show];
                [savePhone setValue:@"FALSE" forKey:@"save"];
            }
            else if([result isEqualToString:@"Create user fail!"] || [result isEqualToString:@"Invalid format!"])
            {
                alertInvalidValue  = [[UIAlertView alloc] initWithTitle:@"Register Failed"
                                                                message:@"Can't create this account."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alertInvalidValue show];
                [savePhone setValue:@"FALSE" forKey:@"save"];
            }

        }
    }
    @catch (NSException *exception) {
        NSLog(@"Register error");
        // create NSUserdefaults to save phone, pass for login
        NSUserDefaults *savePhone = [NSUserDefaults standardUserDefaults];
        [savePhone setValue:@"FALSE" forKey:@"save"];
    }

}

- (IBAction)ClickPasswordField:(id)sender {
    [self.scolleViewRegister setContentOffset:CGPointMake(0,passwordTextField.center.y-120) animated:YES];
}

- (IBAction)ClickReturnPasswordField:(id)sender {
    NSInteger nextTag = passwordTextField.tag + 1;
    // Try to find next responder
    UIResponder *nextResponder = [passwordTextField.superview viewWithTag:nextTag];
    
    if (nextResponder) {
        [self.scolleViewRegister setContentOffset:CGPointMake(0,passwordTextField.center.y-120) animated:YES];
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        [self.scolleViewRegister setContentOffset:CGPointMake(0,-60) animated:YES];
        [passwordTextField resignFirstResponder];
        //return YES;
    }
}

- (IBAction)ClickConfirmPassField:(id)sender {
    [self.scolleViewRegister setContentOffset:CGPointMake(0,passwordTextField.center.y-120) animated:YES];
}

- (IBAction)ClickReturnConfirmPassField:(id)sender {
    NSInteger nextTag = passwordTextField.tag + 1;
    // Try to find next responder
    UIResponder *nextResponder = [passwordTextField.superview viewWithTag:nextTag];
    
    if (nextResponder) {
        [self.scolleViewRegister setContentOffset:CGPointMake(0,passwordTextField.center.y-120) animated:YES];
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        [self.scolleViewRegister setContentOffset:CGPointMake(0,-60) animated:YES];
        [passwordTextField resignFirstResponder];
        //return YES;
    }
}





//- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex: (NSInteger *)buttonIndex {
//    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
//    //catch alerView
//    if (alertView == alertInvalidValue || alertView == alertAccountExist) {
//        if ([title isEqualToString:@"OK"]) {
//            [self dismissModalViewControllerAnimated:YES];        }
//    }
//}
- (IBAction)dismissConfirmText:(id)sender {
    [confirmTextField resignFirstResponder];
}

- (IBAction)dismissPasswordText:(id)sender {
    [passwordTextField resignFirstResponder];
}

- (IBAction)dismissPhoneText:(id)sender {
    [phoneTextField resignFirstResponder];
}

- (IBAction)dismissNameText:(id)sender {
    [nameTextField resignFirstResponder];
}
@end
