//
//  AddEmergencyContact.m
//  DisasterHelper
//
//  Created by ENCLAVEIT on 2/18/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import "AddEmergencyContact.h"
#import "Server.h"
#import "ListContact.h"
#import <UIKit/UIKit.h>

@interface AddEmergencyContact ()

@end
NSInteger contactIndex;

@implementation AddEmergencyContact
@synthesize contactName1,contactName2,contactName3,phoneNumber1,phoneNumber2,phoneNumber3;
@synthesize connect;


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
    connect = [[Server alloc] init];
    
    if([_contactName1String length] == 0){
        self.contactName1.text = @"Contact 1";
        self.phoneNumber1.text = @"Phone number 1";
    }
    else{
        self.contactName1.text = _contactName1String;
        self.phoneNumber1.text = _phoneName1String;
    }
    
    if([_contactName2String length] == 0){
        self.contactName2.text = @"Contact 2";
        self.phoneNumber2.text = @"Phone number 2";
    }else{
        self.contactName2.text = _contactName2String;
        self.phoneNumber2.text = _phoneName2String;
    }
    if([_contactName3String length] == 0){
        self.contactName3.text = @"Contact 3";
        self.phoneNumber3.text = @"Phone number 3";

    }else{
        self.contactName3.text = _contactName3String;
        self.phoneNumber3.text = _phoneName3String;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//  Touch on contact 1

- (IBAction)showPicker1:(id)sender {
    ListContact *listContactObject = [self.storyboard instantiateViewControllerWithIdentifier:@"ListContact"];
    
    listContactObject.idEmergencyContact = @"one";
    
    //save data of old emergency contact
    listContactObject.contactName1String = self.contactName1.text;
    listContactObject.phoneName1String = self.phoneNumber1.text;
    listContactObject.contactName2String = self.contactName2.text;
    listContactObject.contactName3String = self.contactName3.text;
    listContactObject.phoneName2String = self.phoneNumber2.text;
    listContactObject.phoneName3String = self.phoneNumber3.text;
    
    [self presentViewController:listContactObject animated:YES completion:nil];
}

//  Touch on contact 2


- (IBAction)showPicker2:(id)sender {
    ListContact *listContactObject = [self.storyboard instantiateViewControllerWithIdentifier:@"ListContact"];
    
    listContactObject.idEmergencyContact = @"two";
    
    //save data of old emergency contact
    listContactObject.contactName2String = self.contactName2.text;
    listContactObject.phoneName2String =self.phoneNumber2.text;

    listContactObject.contactName1String = self.contactName1.text;
    listContactObject.contactName3String =  self.contactName3.text;
    listContactObject.phoneName1String =self.phoneNumber1.text;
    listContactObject.phoneName3String = self.phoneNumber3.text;
    
    [self presentViewController:listContactObject animated:YES completion:nil];
    
}

- (IBAction)showPicker3:(id)sender {
    ListContact *listContactObject = [self.storyboard instantiateViewControllerWithIdentifier:@"ListContact"];
    
    listContactObject.idEmergencyContact = @"three";
    //save data of old emergency contact
    listContactObject.contactName3String = self.contactName3.text;
    listContactObject.phoneName3String = self.phoneNumber3.text;
    listContactObject.contactName1String = self.contactName1.text;
    listContactObject.contactName2String = self.contactName2.text;
    listContactObject.phoneName1String = self.phoneNumber1.text;
    listContactObject.phoneName2String = self. phoneNumber2.text;
    
    [self presentViewController:listContactObject animated:YES completion:nil];

}


- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    [self displayPerson:person];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}
- (void)displayPerson:(ABRecordRef)person
{
    NSString* name = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                    kABPersonFirstNameProperty);
    switch (contactIndex) {
        case 1:
            self.contactName1.text=name; break;
        case 2:
            self.contactName2.text=name; break;
        case 3:
            self.contactName3.text=name; break;
            
        default:
            break;
    }
    //self.firstName.text = name;
    
    NSString* phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
                                                     kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        phone = @"[None]";
    }
    switch (contactIndex) {
        case 1:
            self.phoneNumber1.text=phone; break;
        case 2:
            self.phoneNumber2.text=phone; break;
        case 3:
            self.phoneNumber3.text=phone; break;
            
        default:
            break;
    }

    //self.phoneNumber.text = phone;
    CFRelease(phoneNumbers);
}


- (NSMutableArray *)getAllContactList{
  //get all contact from server and compair
    NSMutableArray *contactResultArray = [[NSMutableArray alloc] init];
    
    NSUserDefaults *ServerUrl = [NSUserDefaults standardUserDefaults];
    NSString *stringurl=[ServerUrl objectForKey:@"serverurl"];
    NSURL *url= [[NSURL alloc] initWithString:stringurl];
    
//    NSURL *url = [[NSURL alloc] initWithString:@"http://192.168.10.91:3000/users.json"];
    NSUserDefaults *checkLogin = [NSUserDefaults standardUserDefaults];
    NSString *check = [checkLogin valueForKey:@"checkLogin"];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
   	NSString *internetStatus=[user objectForKey:@"Internet"];
    
    if ([internetStatus isEqualToString:@"NO"]) {
        NSLog(@"Run with out network and don't do any thing");
    } else if([internetStatus isEqualToString:@"YES"]) {
        if ([check isEqualToString:@"Offline"]) {
            UIAlertView *Offlinealert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"You can't get online contact when using offline mode" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [Offlinealert show];
        }
        
        else if ([check isEqualToString:@"LOGIN"]){
            NSArray *contactFromServerArray = [[NSArray alloc] init];
            connect = [[Server alloc]init];
            contactFromServerArray = [connect getRequest:url];
            
            //get all contact from iphone
            ABAddressBookRef addressBook = ABAddressBookCreate();
            CFArrayRef addressBookData = ABAddressBookCopyArrayOfAllPeople(addressBook);
            
            CFIndex count = CFArrayGetCount(addressBookData);
            
            NSMutableArray *allContactArray = [NSMutableArray new];
            
            for (CFIndex idx = 0; idx < count; idx++) {
                ABRecordRef person = CFArrayGetValueAtIndex(addressBookData, idx);
                
                NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
                
                NSString *phone = nil;
                ABMultiValueRef phoneRef = ABRecordCopyValue(person,
                                                             kABPersonPhoneProperty);
                if (ABMultiValueGetCount(phoneRef) > 0) {
                    phone = (__bridge_transfer NSString*)
                    ABMultiValueCopyValueAtIndex(phoneRef, 0);
                } else {
                    phone = @"[None]";
                }
                if(firstName){
                    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
                    [dictionary setObject:firstName forKey:@"name"];
                    [dictionary setObject:phone forKey:@"phone"];
                    
                    [allContactArray addObject:dictionary];
                }
            }
            
            //get list of contact that use application
            
            for(int i=0;i < [allContactArray count]; i++){
                for (int j=0; j < [contactFromServerArray count]; j++) {
                    if([ [[allContactArray objectAtIndex:i] valueForKey:@"phone"] isEqualToString:[[contactFromServerArray objectAtIndex:j] valueForKey:@"phonenumber"]]){
                        
                        [contactResultArray addObject:[allContactArray objectAtIndex:i]];
                        break;
                    }
                }
            }
        }

    }
    
       return contactResultArray;
}


-(void)checkDuplicateCotact
{
    NSLog(@"Error if user choose duplicate contact");
}

@end
