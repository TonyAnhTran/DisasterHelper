//
//  AddEmergencyContact.h
//  DisasterHelper
//
//  Created by ENCLAVEIT on 2/18/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Server.h"

@interface AddEmergencyContact : UIViewController
<ABPeoplePickerNavigationControllerDelegate, UIApplicationDelegate>

@property (weak, nonatomic) IBOutlet UILabel *contactName1;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber1;
@property (weak, nonatomic) IBOutlet UILabel *contactName2;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber2;

@property (weak, nonatomic) IBOutlet UILabel *contactName3;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber3;

@property (weak, nonatomic) NSString *contactName1String,*contactName2String,*contactName3String,*phoneName1String, *phoneName2String, *phoneName3String;

@property (weak, nonatomic) NSString *idEmergencyContact;


@property (strong, nonatomic) UINavigationController *navController;

@property Server *connect;

- (IBAction)showPicker1:(id)sender;
- (IBAction)showPicker2:(id)sender;
- (IBAction)showPicker3:(id)sender;
//- (IBAction)testbutton:(id)sender;




- (NSMutableArray *) getAllContactList;
@end
