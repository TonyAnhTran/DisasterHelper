//
//  EditProfileController.m
//  DisasterHelper
//
//  Created by ENCLAVEIT on 3/19/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import "EditProfileController.h"
#import "NSData+Base64.h"

@interface EditProfileController (){
    UIAlertView *password;
    UIAlertView *connectFail;
    UIAlertView *updateSuccess;
    UIAlertView *enterAll;
    UIAlertView *alertWrongConfirm;
    UIAlertView *alertChangedPass;
    
    NSString *passwordField;
    NSString *userName;
    int choose;
    
    UIImage *imageDecoded;
}

@end

@implementation EditProfileController

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.scrollViewEditProfile layoutIfNeeded];
    self.scrollViewEditProfile.contentSize=self.contentViewEditProfile.bounds.size;
}


- (IBAction)choosePicture{
    //Click button choose picture
    choose=3;
    userNameTextField.hidden=NO;
    imageUsername.hidden=NO;
    passwordTextField.hidden=NO;
    imagePassword.hidden=NO;
    newPasswordImage.hidden=YES;
    oldPasswordImage.hidden=YES;
    imageConfirmPass.hidden=YES;
    imageNewPass.hidden=YES;
    saveChangeButton.hidden=NO;
    picker = [[UIImagePickerController alloc]init];
    picker.delegate=self;
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:picker animated:YES completion:nil ];
    //[picker release];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [profilePicture setImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    //Setting View
    backgroundImage.backgroundColor = UIColorFromRGB(0x35b5eb);
    saveChangeButton.backgroundColor = UIColorFromRGB(0xffa333);
    buttonChangePass.backgroundColor = UIColorFromRGB(0x24d35f);
    buttonUserInfo.backgroundColor = UIColorFromRGB(0x24d35f);
    //Drog shadow
//    profilePicture.layer.shadowColor = [UIColor grayColor].CGColor;
//    profilePicture.layer.shadowOffset = CGSizeMake(0, 2);
//    profilePicture.layer.shadowOpacity = 2;
//    profilePicture.layer.shadowRadius = 2.0;
//    profilePicture.clipsToBounds = NO;
//    
//    imageUsername.layer.shadowColor = [UIColor grayColor].CGColor;
//    imageUsername.layer.shadowOffset = CGSizeMake(0, 2);
//    imageUsername.layer.shadowOpacity = 2;
//    imageUsername.layer.shadowRadius = 2.0;
//    imageUsername.clipsToBounds = NO;
//    
//    buttonChangeImage.layer.shadowColor = [UIColor grayColor].CGColor;
//    buttonChangeImage.layer.shadowOffset = CGSizeMake(0, 2);
//    buttonChangeImage.layer.shadowOpacity = 2;
//    buttonChangeImage.layer.shadowRadius = 2.0;
//    buttonChangeImage.clipsToBounds = NO;
//    
//    saveChangeButton.layer.shadowColor = [UIColor grayColor].CGColor;
//    saveChangeButton.layer.shadowOffset = CGSizeMake(0, 2);
//    saveChangeButton.layer.shadowOpacity = 2;
//    saveChangeButton.layer.shadowRadius = 2.0;
//    saveChangeButton.clipsToBounds = NO;
//    
//    imagePassword.layer.shadowColor = [UIColor grayColor].CGColor;
//    imagePassword.layer.shadowOffset = CGSizeMake(0, 2);
//    imagePassword.layer.shadowOpacity = 2;
//    imagePassword.layer.shadowRadius = 2.0;
//    imagePassword.clipsToBounds = NO;
//    
//    imageNewPass.layer.shadowColor = [UIColor grayColor].CGColor;
//    imageNewPass.layer.shadowOffset = CGSizeMake(0, 2);
//    imageNewPass.layer.shadowOpacity = 2;
//    imageNewPass.layer.shadowRadius = 2.0;
//    imageNewPass.clipsToBounds = NO;
//    
//    imageConfirmPass.layer.shadowColor = [UIColor grayColor].CGColor;
//    imageConfirmPass.layer.shadowOffset = CGSizeMake(0, 2);
//    imageConfirmPass.layer.shadowOpacity = 2;
//    imageConfirmPass.layer.shadowRadius = 2.0;
//    imageConfirmPass.clipsToBounds = NO;
    
    //Custom navigator back button
    
    UIImage *buttonImage = [UIImage imageNamed:@"back111.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;

    profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2;
    profilePicture.clipsToBounds = YES;
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //Display User's current image and name
    
    NSUserDefaults *phonenumber = [NSUserDefaults standardUserDefaults];
    NSString *phoneNumber =[phonenumber valueForKey:@"phone"];
    NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
    NSString *ssid=[session objectForKey:@"ssid"];
    NSUserDefaults *ServerUrl = [NSUserDefaults standardUserDefaults];
    NSString *stringurl=[ServerUrl objectForKey:@"serverurl"];
    NSURL *url= [[NSURL alloc] initWithString:stringurl];
    
    labelPhoneNumber.text=phoneNumber;
//    NSURL *url = [NSURL URLWithString:@"http://192.168.10.115:3000/users/"];

    NSUserDefaults *checkLogin = [NSUserDefaults standardUserDefaults];
    NSString *check = [checkLogin valueForKey:@"checkLogin"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
   	NSString *internetStatus=[user objectForKey:@"Internet"];
    
    if ([internetStatus isEqualToString:@"NO"]) {
        NSLog(@"Run with out network and don't do any thing");
    } else if([internetStatus isEqualToString:@"YES"]) {
        if ([check isEqualToString:@"LOGIN"]) {
            NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] init];
            [myDictionary setObject:@"checkProfile" forKey:@"key"];
            [myDictionary setObject:ssid forKey:@"sid"];
            [myDictionary setObject:phoneNumber forKey:@"phonenumber"];
            
            NSData *myData = [NSJSONSerialization dataWithJSONObject:myDictionary
                                                             options:kNilOptions
                                                               error:nil];
            
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request setHTTPMethod:@"POST"];
            [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:myData];
            
            //Recieve data from server
            NSURLResponse *response;
            NSError *err;
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
            //NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            //NSLog(@"This is data %@",responseString);
            NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:responseData
                                                                       options:kNilOptions
                                                                         error:&err];
            // NSLog(@"Response Data is %@",responseDictionary);
            //NSLog(@"msg is %@", [responseDictionary objectForKey:@"msg"]);
            NSString *result= [resultData objectForKey:@"username"];
            userNameTextField.text=result;
            userName=userNameTextField.text;
            
            //Take base64 encoded string from result JSON
            NSString *imageDataEncodedeStringLoaded = [resultData objectForKey:@"photo_data"];
            NSLog(@"%@",imageDataEncodedeStringLoaded);
            
            if (imageDataEncodedeStringLoaded == NULL) {
                //Show original image here
                imageDecoded = [UIImage imageNamed:@"facebook-default-no-profile-pic.jpg"];
            }else{
                //Decode
                imageDecoded = [UIImage imageWithData:[NSData dataFromBase64String: imageDataEncodedeStringLoaded]];
            }
            //View
            [profilePicture setImage:imageDecoded];

        }
    }
       
    
    //Hidden everything
    userNameTextField.hidden=NO;
    imageUsername.hidden=NO;
    userNameTextField.userInteractionEnabled=NO;
    passwordTextField.hidden=YES;
    imagePassword.hidden=YES;
    newPasswordImage.hidden=YES;
    oldPasswordImage.hidden=YES;
    imageConfirmPass.hidden=YES;
    imageNewPass.hidden=YES;
    saveChangeButton.hidden=YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveChange:(id)sender {
    NSUserDefaults *checkLogin = [NSUserDefaults standardUserDefaults];
    NSString *check = [checkLogin valueForKey:@"checkLogin"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
   	NSString *internetStatus=[user objectForKey:@"Internet"];
    
    if ([internetStatus isEqualToString:@"NO"]) {
        NSLog(@"Run with out network and don't do any thing");
    } else if([internetStatus isEqualToString:@"YES"]) {
        if ([check isEqualToString:@"Offline"]) {
            UIAlertView *Offlinealert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"You can't change profile when using offline mode" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [Offlinealert show];
        }
        else if([check isEqualToString:@"LOGIN"]){
            //Update user info
            if ([passwordTextField.text isEqualToString:@""]) {
                //Alert type password
                password = [[UIAlertView alloc]initWithTitle:@"Wrong Password"
                                                     message:@"Please enter right password."
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles: nil];
                [password show];
            }
            else{
                @try{
                    //Connect to server
                    NSUserDefaults *phonenumber = [NSUserDefaults standardUserDefaults];
                    NSString *phoneNumber =[phonenumber valueForKey:@"phone"];
                    NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
                    NSString *ssid=[session objectForKey:@"ssid"];
                    NSUserDefaults *ServerUrl = [NSUserDefaults standardUserDefaults];
                    NSString *stringurl=[ServerUrl objectForKey:@"serverurl"];
                    NSURL *url= [[NSURL alloc] initWithString:stringurl];
                    
                    if (choose==1) {
                        //Change username
                        //                NSURL *url = [NSURL URLWithString:@"http://192.168.10.115:3000/users/"];
                        
                        NSMutableDictionary *newDictionary = [[NSMutableDictionary alloc] init];
                        // [newDictionary setObject:imageDataEncodedeString forKey:@"photo_data"];
                        [newDictionary setObject:@"updateInformation" forKey:@"key"];
                        [newDictionary setObject:ssid forKey:@"sid"];
                        [newDictionary setObject:passwordTextField.text forKey:@"password"];
                        [newDictionary setObject:userNameTextField.text forKey:@"username"];
                        [newDictionary setObject:phoneNumber forKey:@"phonenumber"];
                        
                        NSData *myData = [NSJSONSerialization dataWithJSONObject:newDictionary
                                                                         options:kNilOptions
                                                                           error:nil];
                        
                        Server *connect = [[Server alloc] init];
                        NSString *result = [connect postRequest:url withData:myData];
                        NSLog(@"%@",result);
                        if([result isEqualToString:@"User profile updated!"]){
                            //Alert send success
                            updateSuccess = [[UIAlertView alloc]initWithTitle:@"Updated" message:@"Your profile had been updated!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                            [updateSuccess show];
                            
                            
                        }
                        if ([result isEqualToString:@"Password doesnot match!"]){
                            //Alert password wrong
                            password = [[UIAlertView alloc]initWithTitle:@"Wrong Password"
                                                                 message:@"Please enter right password."
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles: nil];
                            [password show];
                        }
                        
                    }
                    //Change avatar
                    if(choose==3 ){
                        UIImage *newImage = [self imageWithImage:profilePicture.image scaledToSize:CGSizeMake(100, 100)];
                        NSData *imageData = UIImagePNGRepresentation(newImage);
                        NSString *imageDataEncodedeString = [imageData base64EncodedString];
                        NSLog(@"%@",imageDataEncodedeString);
                        
                        //                NSURL *url = [NSURL URLWithString:@"http://192.168.10.115:3000/users/"];
                        
                        NSMutableDictionary *newDictionary = [[NSMutableDictionary alloc] init];
                        [newDictionary setObject:imageDataEncodedeString forKey:@"photo_data"];
                        [newDictionary setObject:@"updateAvatar" forKey:@"key"];
                        [newDictionary setObject:ssid forKey:@"sid"];
                        [newDictionary setObject:passwordTextField.text forKey:@"password"];
                        //[newDictionary setObject:userNameTextField.text forKey:@"username"];
                        [newDictionary setObject:phoneNumber forKey:@"phonenumber"];
                        
                        NSData *myData = [NSJSONSerialization dataWithJSONObject:newDictionary
                                                                         options:kNilOptions
                                                                           error:nil];
                        
                        Server *connect = [[Server alloc] init];
                        NSString *result = [connect postRequest:url withData:myData];
                        NSLog(@"%@",result);
                        if([result isEqualToString:@"User avatar updated!"]){
                            //Alert send success
                            updateSuccess = [[UIAlertView alloc]initWithTitle:@"Updated" message:@"Your avatar had been updated!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                            [updateSuccess show];
                            
                            
                        }
                        if ([result isEqualToString:@"Password doesnot match!"]){
                            //Alert password wrong
                            password = [[UIAlertView alloc]initWithTitle:@"Wrong Password"
                                                                 message:@"Please enter right password."
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles: nil];
                            [password show];
                        }
                    }
                    if(choose==2){
                        //Change password
                        if (![newPasswordImage.text isEqualToString:oldPasswordImage.text]) {
                            alertWrongConfirm=[[UIAlertView alloc]initWithTitle:@"Wrong Password" message:@"Your password does not match.\nPlease try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                            [alertWrongConfirm show];
                            //oldPassTextField.text=@"";
                            newPasswordImage.text=@"";
                            oldPasswordImage.text=@"";
                        }
                        else{
                            //Update password
                            //                    NSURL *url = [NSURL URLWithString:@"http://192.168.10.115:3000/users/"];
                            
                            NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] init];
                            [myDictionary setObject:@"changePassword" forKey:@"key"];
                            [myDictionary setObject:ssid forKey:@"sid"];
                            [myDictionary setObject:passwordTextField.text forKey:@"password"];
                            [myDictionary setObject:phoneNumber forKey:@"phonenumber"];
                            [myDictionary setObject:oldPasswordImage.text forKey:@"newpassword"];
                            
                            NSData *myData = [NSJSONSerialization dataWithJSONObject:myDictionary
                                                                             options:kNilOptions
                                                                               error:nil];
                            
                            Server *connect = [[Server alloc] init];
                            NSString *result = [connect postRequest:url withData:myData];
                            if([result isEqualToString:@"Password updated updated!"]){
                                //Alert user change pass success
                                alertChangedPass = [[UIAlertView alloc]initWithTitle:@"Changed Password" message:@"Your password has been changed.\n" delegate:self cancelButtonTitle:@"YES" otherButtonTitles: nil];
                                [alertChangedPass show];
                                passwordTextField.text=@"";
                                newPasswordImage.text=@"";
                                oldPasswordImage.text=@"";
                                
                            }else{
                                if ([result isEqualToString:@"Old password doesnot match!"]) {
                                    //Alert user old password wrong
                                    password = [[UIAlertView alloc]initWithTitle:@"Wrong Password" message:@"Your old is not correct.\nPlease try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                    [password show];
                                    oldPasswordImage.text=@"";
                                }
                            }
                            
                        }
                    }
                }@catch (NSException *e){
                    //Alert can not connect with server
                    connectFail = [[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Can not connect with server now!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:    nil];
                    [connectFail show ];
                }
                
                
                
                //        //Enter password to confirm
                //        password = [[UIAlertView alloc]initWithTitle:@"Security"
                //                                             message:@"Please enter your password below:"
                //                                            delegate:self
                //                                   cancelButtonTitle:@"Cancel"
                //                                   otherButtonTitles:@"OK", nil];
                //        password.alertViewStyle=UIAlertViewStylePlainTextInput;
                //        [password textFieldAtIndex:0].delegate = self;
                //        [password show];
            }

    }
    }
}


-(UIImage*)imageWithImage:(UIImage*)image
             scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if (alertView == password) {
        if ([title isEqualToString:@"OK"]) {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
//        }else{
//            //pass.text=[password textFieldAtIndex:0].text;
//            passwordField=[password textFieldAtIndex:0].text ;
//            
//            [alertView dismissWithClickedButtonIndex:0 animated:YES];
//            //Connect to server
//            @try{
//                
//                NSUserDefaults *phonenumber = [NSUserDefaults standardUserDefaults];
//                NSString *phoneNumber =[phonenumber valueForKey:@"phone"];
//                
//                NSURL *url = [[NSURL alloc] initWithString:@"http://192.168.10.91:3000/users"];
//                NSMutableDictionary *newDictionary = [[NSMutableDictionary alloc] init];
//                [newDictionary setObject:@"updateInformation" forKey:@"key"];
//               // NSLog(@"Password:%@",passwordField );
//                [newDictionary setObject:passwordField forKey:@"password"];
//                [newDictionary setObject:userNameTextField.text forKey:@"username"];
//                [newDictionary setObject:phoneNumber forKey:@"phonenumber"];
//
//                NSData *myData = [NSJSONSerialization dataWithJSONObject:newDictionary options:NSJSONReadingMutableContainers error:nil];
//                
//                Server *connect = [[Server alloc] init];
//                NSString *result = [connect postRequest:url withData:myData];
//                
//                if([result isEqualToString:@"User profile updated!"]){
//                    //Alert send success
//                    updateSuccess = [[UIAlertView alloc]initWithTitle:@"Updated" message:@"Your profile had been updated!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                    [updateSuccess show];
//                    
//                    
//                }
//                if ([result isEqualToString:@"Password doesnot match!"]){
//                    //Alert password wrong
//                    password = [[UIAlertView alloc]initWithTitle:@"Security"
//                                                         message:@"Please enter your password below:"
//                                                        delegate:self
//                                               cancelButtonTitle:@"Cancel"
//                                               otherButtonTitles:@"OK", nil];
//                    password.alertViewStyle=UIAlertViewStylePlainTextInput;
//                    [password textFieldAtIndex:0].delegate = self;
//                    [password show];
//                }
//                
//                
//            }@catch (NSException *e){
//                //Alert can not connect with server
//                connectFail = [[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Can not connect with server now!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:    nil];
//                [connectFail show ];
//            }
//            
        }
    }

}


- (IBAction)dismissUsernameTextField:(id)sender {
    [userNameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [newPasswordImage resignFirstResponder];
    [oldPasswordImage resignFirstResponder];
}
- (IBAction)editName:(id)sender {
    choose=1;
    //Choose change name, show name and password
    userNameTextField.hidden=NO;
    imageUsername.hidden=NO;
    userNameTextField.userInteractionEnabled=YES;
    passwordTextField.hidden=NO;
    imagePassword.hidden=NO;
    newPasswordImage.hidden=YES;
    oldPasswordImage.hidden=YES;
    imageConfirmPass.hidden=YES;
    imageNewPass.hidden=YES;
    saveChangeButton.hidden=NO;

}

- (IBAction)editPass:(id)sender {
    choose=2;
    //Choose change pass, show password
    userNameTextField.hidden=NO;
    imageUsername.hidden=NO;
    userNameTextField.userInteractionEnabled=NO;
    passwordTextField.hidden=NO;
    imagePassword.hidden=NO;
    newPasswordImage.hidden=NO;
    oldPasswordImage.hidden=NO;
    imageConfirmPass.hidden=NO;
    imageNewPass.hidden=NO;
    saveChangeButton.hidden=NO;

}

- (IBAction)userInfo:(id)sender {
}
- (IBAction)ClickUsernameField:(id)sender {
    [self.scrollViewEditProfile setContentOffset:CGPointMake(0,userNameTextField.center.y-160) animated:YES];
}

- (IBAction)ClickReturnUsernameField:(id)sender {
    NSInteger nextTag = userNameTextField.tag + 1;
    // Try to find next responder
    UIResponder *nextResponder = [userNameTextField.superview viewWithTag:nextTag];
    
    if (nextResponder) {
        [self.scrollViewEditProfile setContentOffset:CGPointMake(0,userNameTextField.center.y+60) animated:YES];
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        [self.scrollViewEditProfile setContentOffset:CGPointMake(0,-63) animated:YES];
        [userNameTextField resignFirstResponder];
        //return YES;
    }
}

- (IBAction)ClickPasswordField:(id)sender {
    [self.scrollViewEditProfile setContentOffset:CGPointMake(0,passwordTextField.center.y-110) animated:YES];
}

- (IBAction)ClickReturnPasswordField:(id)sender {
    NSInteger nextTag = passwordTextField.tag + 1;
    // Try to find next responder
    UIResponder *nextResponder = [passwordTextField.superview viewWithTag:nextTag];
    
    if (nextResponder) {
        [self.scrollViewEditProfile setContentOffset:CGPointMake(0,-93) animated:YES];
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        [self.scrollViewEditProfile setContentOffset:CGPointMake(0,-63) animated:YES];
        [passwordTextField resignFirstResponder];
        //return YES;
    }
}

- (IBAction)ClickNewPasswordField:(id)sender {
    [self.scrollViewEditProfile setContentOffset:CGPointMake(0,newPasswordImage.center.y-145) animated:YES];
}

- (IBAction)ClickReturnNewPasswordField:(id)sender {
    NSInteger nextTag = newPasswordImage.tag + 1;
    // Try to find next responder
    UIResponder *nextResponder = [newPasswordImage.superview viewWithTag:nextTag];
    
    if (nextResponder) {
        [self.scrollViewEditProfile setContentOffset:CGPointMake(0,newPasswordImage.center.y-60) animated:YES];
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        [self.scrollViewEditProfile setContentOffset:CGPointMake(0,-63) animated:YES];
        [newPasswordImage resignFirstResponder];
        //return YES;
    }
}

- (IBAction)ClickConfirmPasswordField:(id)sender {
    [self.scrollViewEditProfile setContentOffset:CGPointMake(0,oldPasswordImage.center.y-170) animated:YES];
}

- (IBAction)ClickReturnConfirmPasswordField:(id)sender {
    NSInteger nextTag = oldPasswordImage.tag + 1;
    // Try to find next responder
    UIResponder *nextResponder = [oldPasswordImage.superview viewWithTag:nextTag];
    
    if (nextResponder) {
        [self.scrollViewEditProfile setContentOffset:CGPointMake(0,oldPasswordImage.center.y-80) animated:YES];
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        [self.scrollViewEditProfile setContentOffset:CGPointMake(0,-63) animated:YES];
        [oldPasswordImage resignFirstResponder];
        //return YES;
    }

}
@end
