//
//  EmergencyContacts.m
//  DisasterHelper
//
//  Created by ENCLAVEIT on 3/21/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import "EmergencyContacts.h"

@interface EmergencyContacts ()

@end
UIAlertView *changePoliceNumber;
UIAlertView *changeFireNumber;
UIAlertView *changeAmbulanceNumber;
UIAlertView *userNotExist;
UIAlertView *duplicateUser;
UIAlertView *password;
UIAlertView *connectFail;
UIAlertView *updateSuccess;
UIAlertView *enterAll;


NSString *passwordField=@"";

NSString *policeNumber=@"113",*fireNumber=@"114",*ambulanceNumber=@"115";
NSString *user1Number=@"Phone number 1",*user2Number=@"Phone number 2",*user3Number=@"Phone number 3";
NSString *user1Name=@"Contact 1",*user2Name=@"Contact 2",*user3Name=@"Contact 3";

ABPeoplePickerNavigationController *picker1;

@implementation EmergencyContacts
int userID=0;

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
    //RGB color macro
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
    //Setting View
    imageBackground.backgroundColor=UIColorFromRGB(0xaad9ed);
    imageUser3.backgroundColor=UIColorFromRGB(0x83cdec);
    //imageEmergenyNumber.backgroundColor=UIColorFromRGB(0xf4eece);
    
    //Custom navigator back button
    
    UIImage *buttonImage = [UIImage imageNamed:@"back111.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;

//    //Drog Shadow here
//    buttonUser1.layer.shadowColor = [UIColor grayColor].CGColor;
//    buttonUser1.layer.shadowOffset = CGSizeMake(0, 2);
//    buttonUser1.layer.shadowOpacity = 2;
//    buttonUser1.layer.shadowRadius = 2;
//    buttonUser1.clipsToBounds = NO;
//    
//    buttonUser2.layer.shadowColor = [UIColor grayColor].CGColor;
//    buttonUser2.layer.shadowOffset = CGSizeMake(0, 2);
//    buttonUser2.layer.shadowOpacity = 2;
//    buttonUser2.layer.shadowRadius = 2;
//    buttonUser2.clipsToBounds = NO;
//    
//    buttonUser3.layer.shadowColor = [UIColor grayColor].CGColor;
//    buttonUser3.layer.shadowOffset = CGSizeMake(0, 2);
//    buttonUser3.layer.shadowOpacity = 2;
//    buttonUser3.layer.shadowRadius = 2;
//    buttonUser3.clipsToBounds = NO;
//    
//    buttonPolice.layer.shadowColor = [UIColor grayColor].CGColor;
//    buttonPolice.layer.shadowOffset = CGSizeMake(0, 2);
//    buttonPolice.layer.shadowOpacity = 2;
//    buttonPolice.layer.shadowRadius = 2;
//    buttonPolice.clipsToBounds = NO;
//    
//    buttonFire.layer.shadowColor = [UIColor grayColor].CGColor;
//    buttonFire.layer.shadowOffset = CGSizeMake(0, 2);
//    buttonFire.layer.shadowOpacity = 2;
//    buttonFire.layer.shadowRadius = 2;
//    buttonFire.clipsToBounds = NO;
//    
//    buttonAmbulance.layer.shadowColor = [UIColor grayColor].CGColor;
//    buttonAmbulance.layer.shadowOffset = CGSizeMake(0, 2);
//    buttonAmbulance.layer.shadowOpacity = 2;
//    buttonAmbulance.layer.shadowRadius = 2;
//    buttonAmbulance.clipsToBounds = NO;
//    
//    buttonEditAmbulance.layer.shadowColor = [UIColor grayColor].CGColor;
//    buttonEditAmbulance.layer.shadowOffset = CGSizeMake(0, 2);
//    buttonEditAmbulance.layer.shadowOpacity = 2;
//    buttonEditAmbulance.layer.shadowRadius = 2;
//    buttonEditAmbulance.clipsToBounds = NO;
//    
//    buttonEditFire.layer.shadowColor = [UIColor grayColor].CGColor;
//    buttonEditFire.layer.shadowOffset = CGSizeMake(0, 2);
//    buttonEditFire.layer.shadowOpacity = 2;
//    buttonEditFire.layer.shadowRadius = 2;
//    buttonEditFire.clipsToBounds = NO;
//    
//    buttonEditPolice.layer.shadowColor = [UIColor grayColor].CGColor;
//    buttonEditPolice.layer.shadowOffset = CGSizeMake(0, 2);
//    buttonEditPolice.layer.shadowOpacity = 2;
//    buttonEditPolice.layer.shadowRadius = 2;
//    buttonEditPolice.clipsToBounds = NO;
//    
//    saveChangeButton.layer.shadowColor = [UIColor grayColor].CGColor;
//    saveChangeButton.layer.shadowOffset = CGSizeMake(0, 2);
//    saveChangeButton.layer.shadowOpacity = 2;
//    saveChangeButton.layer.shadowRadius = 2;
//    saveChangeButton.clipsToBounds = NO;

    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //self.view.backgroundColor = UIColorFromRGB(0x4fc1e9);
    saveChangeButton.backgroundColor = UIColorFromRGB(0xffa333);
    
    
    policeLabel.text=policeNumber;
    fireLabel.text=fireNumber;
    ambulanceLabel.text=ambulanceNumber;
    
    phoneUser1.text=user1Number;
    phoneUser2.text=user2Number;
    phoneUser3.text=user3Number;
    
    nameUser1.text=user1Name;
    nameUser2.text=user2Name;
    nameUser3.text=user3Name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editPoliceNumber:(id)sender {
    //Edit police number
    
    changePoliceNumber = [[UIAlertView alloc]initWithTitle:@"Change Police number"
                                                   message:@"Please enter number you want to add."
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Save", nil];
    changePoliceNumber.alertViewStyle=UIAlertViewStylePlainTextInput;
    [changePoliceNumber textFieldAtIndex:0].delegate = self;
    [changePoliceNumber show];
}
- (IBAction)editFireNumber:(id)sender {
    //Edit fire number
    changeFireNumber = [[UIAlertView alloc]initWithTitle:@"Change Fire number"
                                                 message:@"Please enter number you want to add."
                                                delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:@"Save", nil];
    changeFireNumber.alertViewStyle=UIAlertViewStylePlainTextInput;
    [changeFireNumber textFieldAtIndex:0].delegate = self;
    [changeFireNumber show];
    
}
- (IBAction)editAmbulanceNumber:(id)sender {
    //Edit ambulance number
    changeAmbulanceNumber = [[UIAlertView alloc]initWithTitle:@"Change Ambulance number"
                                                      message:@"Please enter number you want to add."
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Save", nil];
    changeAmbulanceNumber.alertViewStyle=UIAlertViewStylePlainTextInput;
    [changeAmbulanceNumber textFieldAtIndex:0].delegate = self;
    [changeAmbulanceNumber show];
}

- (IBAction)editUser1:(id)sender {
    //edit user 1
    userID=1;
    picker1 = [[ABPeoplePickerNavigationController alloc] init];
    picker1.peoplePickerDelegate = self;
    [self presentModalViewController:picker1 animated:YES];
}

- (IBAction)editUser2:(id)sender {
    //edit user 2
    userID=2;
    picker1 = [[ABPeoplePickerNavigationController alloc] init];
    picker1.peoplePickerDelegate = self;
    [self presentModalViewController:picker1 animated:YES];
}

- (IBAction)editUser3:(id)sender {
    //edit user 3
    userID=3;
    picker1 = [[ABPeoplePickerNavigationController alloc] init];
    picker1.peoplePickerDelegate = self;
    [self presentModalViewController:picker1 animated:YES];
}

- (void)peoplePickerNavigationControllerDidCancel: (ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissModalViewControllerAnimated:YES];
}
- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    [self displayPerson:person];
    [self dismissModalViewControllerAnimated:YES];
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

- (void)displayPerson:(ABRecordRef)person
{NSString* name = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                    kABPersonFirstNameProperty);
    NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
    NSString *ssid=[session objectForKey:@"ssid"];
    
    NSUserDefaults *checkLogin = [NSUserDefaults standardUserDefaults];
    NSString *check = [checkLogin valueForKey:@"checkLogin"];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
   	NSString *internetStatus=[user objectForKey:@"Internet"];
    
    
    NSUserDefaults *ServerUrl = [NSUserDefaults standardUserDefaults];
    NSString *stringurl=[ServerUrl objectForKey:@"serverurl"];
    NSURL *url= [[NSURL alloc] initWithString:stringurl];
    
    switch (userID) {
        case 1:
        {
            //add name and phone number user 1
            nameUser1.text = name;
            NSString* phone = nil;
            ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
                                                             kABPersonPhoneProperty);
            if (ABMultiValueGetCount(phoneNumbers) > 0) {
                phone = (__bridge_transfer NSString*)
                ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
            } else {
                phone = @"[None]";
            }
            phoneUser1.text = phone;
            CFRelease(phoneNumbers);
            if ([internetStatus isEqualToString:@"NO"]) {
                
                NSLog(@"Run with out network and don't do any thing");
                
            } else if([internetStatus isEqualToString:@"YES"]) {
                if ([check isEqualToString:@"LOGIN"]) {
                    NSUserDefaults *phonenumber = [NSUserDefaults standardUserDefaults];
                    NSString *phoneNumber =[phonenumber valueForKey:@"phone"];
                    //            NSURL *url = [[NSURL alloc] initWithString:@"http://192.168.10.115:3000/users"];
                    NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] init];
                    [myDictionary setObject:@"checkUserExist" forKey:@"key"];
                    [myDictionary setObject:ssid forKey:@"sid"];
                    [myDictionary setObject:phoneNumber forKey:@"phonenumber"];
                    [myDictionary setObject:phone forKey:@"targetphone"];
                    
                    NSData *myData = [NSJSONSerialization dataWithJSONObject:myDictionary
                                                                     options:kNilOptions
                                                                       error:nil];
                    Server *connect = [[Server alloc]init];
                    NSString *result=[connect postRequest:url withData:myData];
                    if ([result isEqualToString:@"Found user!"]) {
                        break;
                    }else{
                        userNotExist = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                                 message:@"This user does not use this application.\nDo you want to continue?"
                                                                delegate:self
                                                       cancelButtonTitle:@"YES"
                                                       otherButtonTitles:@"NO", nil];
                        [userNotExist show];
                        
                        break;
                    }
                }

            }
            
        }
            
        case 2:{
            //add name and phone number user 2
            nameUser2.text = name;
            NSString* phone = nil;
            ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
                                                             kABPersonPhoneProperty);
            if (ABMultiValueGetCount(phoneNumbers) > 0) {
                phone = (__bridge_transfer NSString*)
                ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
            } else {
                phone = @"[None]";
            }
            phoneUser2.text = phone;
            CFRelease(phoneNumbers);
            if ([internetStatus isEqualToString:@"NO"]) {
                NSLog(@"Run with out network and don't do any thing");
            } else if([internetStatus isEqualToString:@"YES"]) {
                if ([check isEqualToString:@"LOGIN"]) {
                    //NSURL *url = [[NSURL alloc] initWithString:@"http://192.168.10.115:3000/users"];
                    NSUserDefaults *phonenumber = [NSUserDefaults standardUserDefaults];
                    NSString *phoneNumber =[phonenumber valueForKey:@"phone"];
                    NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] init];
                    [myDictionary setObject:@"checkUserExist" forKey:@"key"];
                    [myDictionary setObject:ssid forKey:@"sid"];
                    [myDictionary setObject:phoneNumber forKey:@"phonenumber"];
                    [myDictionary setObject:phone forKey:@"targetphone"];
                    
                    NSData *myData = [NSJSONSerialization dataWithJSONObject:myDictionary
                                                                     options:kNilOptions
                                                                       error:nil];
                    Server *connect = [[Server alloc]init];
                    NSString *result=[connect postRequest:url withData:myData];
                    if ([result isEqualToString:@"Found user!"]) {
                        break;
                    }else{
                        userNotExist = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                                 message:@"This user does not use this application.\nDo you want to continue?"
                                                                delegate:self
                                                       cancelButtonTitle:@"YES"
                                                       otherButtonTitles:@"NO", nil];
                        [userNotExist show];
                        
                        break;
                    }
                    
                }

            }
            //          
        }
        case 3:{
            //add name and phone number user 2
            nameUser3.text = name;
            NSString* phone = nil;
            ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
                                                             kABPersonPhoneProperty);
            if (ABMultiValueGetCount(phoneNumbers) > 0) {
                phone = (__bridge_transfer NSString*)
                ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
            } else {
                phone = @"[None]";
            }
            phoneUser3.text = phone;
            CFRelease(phoneNumbers);
            
            if ([internetStatus isEqualToString:@"NO"]) {
                NSLog(@"Run with out network and don't do any thing");
            } else if([internetStatus isEqualToString:@"YES"]) {
                
                if ([check isEqualToString:@"LOGIN"]) {
                    //NSURL *url = [[NSURL alloc] initWithString:@"http://192.168.10.115:3000/users"];
                    NSUserDefaults *phonenumber = [NSUserDefaults standardUserDefaults];
                    NSString *phoneNumber =[phonenumber valueForKey:@"phone"];
                    NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] init];
                    [myDictionary setObject:@"checkUserExist" forKey:@"key"];
                    [myDictionary setObject:ssid forKey:@"sid"];
                    [myDictionary setObject:phoneNumber forKey:@"phonenumber"];
                    [myDictionary setObject:phone forKey:@"targetphone"];
                    
                    NSData *myData = [NSJSONSerialization dataWithJSONObject:myDictionary
                                                                     options:kNilOptions
                                                                       error:nil];
                    Server *connect = [[Server alloc]init];
                    NSString *result=[connect postRequest:url withData:myData];
                    if ([result isEqualToString:@"Found user!"]) {
                        break;
                    }else{
                        userNotExist = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                                 message:@"This user does not use this application.\nDo you want to continue?"
                                                                delegate:self
                                                       cancelButtonTitle:@"YES"
                                                       otherButtonTitles:@"NO", nil];
                        [userNotExist show];
                        
                        break;
                    }
                }
            }
           
//         
        }
        default:
            break;
    }
    if ([phoneUser1.text isEqualToString:phoneUser2.text] || [phoneUser1.text isEqualToString:phoneUser3.text]|| [phoneUser2.text isEqualToString:phoneUser3.text]) {
        //Duplicate number
        duplicateUser = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                  message:@"You have choosed the same number.\nPlease edit for your safe!"
                                                 delegate:self
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles: nil];
        [duplicateUser show];
    }
    
}

- (IBAction)callPolice:(id)sender {
    //Call police
    
    NSString *phoneNumberCall=[NSString stringWithFormat:@"tel:%@",policeLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumberCall]];
}

- (IBAction)callFire:(id)sender {
    //Call fire
    NSString *phoneNumberCall=[NSString stringWithFormat:@"tel:%@",fireLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumberCall]];
}

- (IBAction)callAmbulance:(id)sender {
    //Call ambulance
    NSString *phoneNumberCall=[NSString stringWithFormat:@"tel:%@",ambulanceLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumberCall]];
}

- (IBAction)callUser1:(id)sender {
    NSString *phoneNumberCall=[NSString stringWithFormat:@"tel:%@",phoneUser1.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumberCall]];
}

- (IBAction)callUser2:(id)sender {
    NSString *phoneNumberCall=[NSString stringWithFormat:@"tel:%@",phoneUser2.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumberCall]];
}

- (IBAction)callUser3:(id)sender {
    NSString *phoneNumberCall=[NSString stringWithFormat:@"tel:%@",phoneUser3.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumberCall]];
}

- (IBAction)chooseImageUser1:(id)sender {
    picker = [[UIImagePickerController alloc]init];
    picker.delegate=self;
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentModalViewController:picker animated:YES];
    userID=1;
}

- (IBAction)chooseImageUser2:(id)sender {
    picker = [[UIImagePickerController alloc]init];
    picker.delegate=self;
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentModalViewController:picker animated:YES];
    userID=2;
}

- (IBAction)chooseImageUser3:(id)sender {
    picker = [[UIImagePickerController alloc]init];
    picker.delegate=self;
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentModalViewController:picker animated:YES];
    userID=3;
}

- (IBAction)saveChange:(id)sender {
    NSUserDefaults *checkLogin = [NSUserDefaults standardUserDefaults];
    NSString *check = [checkLogin valueForKey:@"checkLogin"];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
   	NSString *internetStatus=[user objectForKey:@"Internet"];
    
    
    
    if (!([nameUser1.text isEqualToString:@"Contact 1"]
          ||[nameUser2.text isEqualToString:@"Contact 2"]
          ||[nameUser3.text isEqualToString:@"Contact 3"]) ) {
        
        if ([internetStatus isEqualToString:@"NO"]) {
            NSLog(@"Run with out network and don't do any thing");
        } else if([internetStatus isEqualToString:@"YES"]) {
            if ([check isEqualToString:@"Offline"]) {
            }
            
            else if ([check isEqualToString:@"LOGIN"]) {
                //Enter password to confirm
                password = [[UIAlertView alloc]initWithTitle:@"Security"
                                                     message:@"Please enter your password below:"
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"OK", nil];
                password.alertViewStyle=UIAlertViewStylePlainTextInput;
                [password textFieldAtIndex:0].delegate = self;
                [password textFieldAtIndex:0].secureTextEntry = YES;
                [password show];
            }else{
                //aler enter all
                enterAll = [[UIAlertView alloc]initWithTitle:@"Missing Field"
                                                     message:@"Please choose three emergency contacts before saving to server for your safe."
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:   nil];
                [enterAll show];
                //Save change to serveR
            }

        }
    }
           
    
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //UIImageView *img=[[UIImageView alloc]initWithImage:image];
    
    switch (userID) {
        case 1:
        {
            imageUser1.image=image;
            [self dismissModalViewControllerAnimated:YES];
            break;
        }
        case 2:
        {
            imageUser2.image=image;
            [self dismissModalViewControllerAnimated:YES];
            break;
        }
        case 3:{
            imageUser3.image=image;
            [self dismissModalViewControllerAnimated:YES];
            break;
        }
        default:
            break;
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSUserDefaults *checkLogin = [NSUserDefaults standardUserDefaults];
    NSString *check = [checkLogin valueForKey:@"checkLogin"];
    
    
    NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
    NSString *ssid=[session objectForKey:@"ssid"];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
   	NSString *internetStatus=[user objectForKey:@"Internet"];
    
    NSUserDefaults *ServerUrl = [NSUserDefaults standardUserDefaults];
    NSString *stringurl=[ServerUrl objectForKey:@"serverurl"];
    NSURL *url= [[NSURL alloc] initWithString:stringurl];
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    //Alert change ambulance, fire, police number
    if (alertView == changeAmbulanceNumber || alertView == changeFireNumber || alertView == changePoliceNumber) {
        if ([title isEqualToString:@"Cancel"]) {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
        else{
            if (alertView==changePoliceNumber) {
                policeLabel.text=[alertView textFieldAtIndex:0].text;
                policeNumber=[alertView textFieldAtIndex:0].text;
                [alertView dismissWithClickedButtonIndex:0 animated:YES];
            }
            if (alertView==changeFireNumber) {
                fireLabel.text=[alertView textFieldAtIndex:0].text;
                fireNumber=[alertView textFieldAtIndex:0].text;
                [alertView dismissWithClickedButtonIndex:0 animated:YES];
            }
            if (alertView == changeAmbulanceNumber) {
                ambulanceLabel.text=[alertView textFieldAtIndex:0].text;
                ambulanceNumber=[alertView textFieldAtIndex:0].text;
                [alertView dismissWithClickedButtonIndex:0 animated:YES];
            }
        }
    }
    if (alertView == userNotExist) {
        if ([title isEqualToString:@"YES"]) {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }else{
            picker1 = [[ABPeoplePickerNavigationController alloc] init];
            picker1.peoplePickerDelegate = self;
            [self presentModalViewController:picker1 animated:YES];
        }
    }
    if (alertView == password) {
        if ([title isEqualToString:@"Cancel"]) {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            
            phoneUser1.text=user1Number;
            nameUser1.text=user1Name;
            
            phoneUser2.text=user2Number;
            nameUser2.text=user2Name;
            
            phoneUser3.text=user3Number;
            nameUser3.text=user3Name;
           
        }else{
            //pass.text=[password textFieldAtIndex:0].text;
            passwordField=[password textFieldAtIndex:0].text ;
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            
            if ([internetStatus isEqualToString:@"NO"]) {
                NSLog(@"Run with out network and don't do any thing");
            }
            else if([internetStatus isEqualToString:@"YES"]) {
                if ([check isEqualToString:@"Offline"]) {
                    
                }
                else if ([check isEqualToString:@"LOGIN"]) {
                    @try{
                        
                        NSUserDefaults *phonenumber = [NSUserDefaults standardUserDefaults];
                        NSString *phoneNumber =[phonenumber valueForKey:@"phone"];
                        
                        //                NSURL *url = [[NSURL alloc] initWithString:@"http://192.168.10.115:3000/users"];
                        NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] init];
                        [myDictionary setObject:@"updateInformation" forKey:@"key"];
                        //passwordField=pass.text;
                        //NSLog(@"Password:%@",passwordField );
                        [myDictionary setObject:passwordField forKey:@"password"];
                        [myDictionary setObject:ssid forKey:@"sid"];
                        [myDictionary setObject:phoneNumber forKey:@"phonenumber"];
                        [myDictionary setObject:phoneUser1.text forKey:@"econtact1"];
                        [myDictionary setObject:phoneUser2.text forKey:@"econtact2"];
                        [myDictionary setObject:phoneUser3.text forKey:@"econtact3"];
                        NSData *myData = [NSJSONSerialization dataWithJSONObject:myDictionary
                                                                         options:kNilOptions
                                                                           error:nil];
                        
                        Server *connect = [[Server alloc] init];
                        NSString *result = [connect postRequest:url withData:myData];
                        
                        if([result isEqualToString:@"User profile updated!"]){
                            //Alert send success
                            updateSuccess = [[UIAlertView alloc]initWithTitle:@"Updated" message:@"Your emergency contacts had been updated!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                            [updateSuccess show];
                            
                            //Save contacts
                            user1Name=nameUser1.text;
                            user1Number=phoneUser1.text;
                            
                            user2Name=nameUser2.text;
                            user2Number=phoneUser2.text;
                            
                            user3Number=phoneUser3.text;
                            user3Name=nameUser3.text;
                            
                            
                        }
                        if ([result isEqualToString:@"Password doesnot match!"]){
                            //Alert password wrong
                            password = [[UIAlertView alloc]initWithTitle:@"Security"
                                                                 message:@"Please enter your password below:"
                                                                delegate:self
                                                       cancelButtonTitle:@"Cancel"
                                                       otherButtonTitles:@"OK", nil];
                            password.alertViewStyle=UIAlertViewStylePlainTextInput;
                            [password textFieldAtIndex:0].delegate = self;
                            [password show];
                        }
                        
                        
                    }@catch (NSException *e){
                        //Alert can not connect with server
                        connectFail = [[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Can not connect with server now!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:    nil];
                        [connectFail show ];
                    }
                    
                }

            }
                        //Connect to server
            
        }
    }
    if (alertView == connectFail || alertView == updateSuccess || alertView == enterAll) {
        if ([title isEqualToString:@"OK"]) {
            //hide alertview
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
    }
}


@end
