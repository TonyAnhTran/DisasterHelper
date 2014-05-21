//
//  EmergencyContacts.h
//  DisasterHelper
//
//  Created by ENCLAVEIT on 3/21/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Server.h"
#import "QuartzCore/CALayer.h"
@interface EmergencyContacts : UIViewController<UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UILabel *policeLabel;
    IBOutlet UILabel *fireLabel;
    IBOutlet UILabel *ambulanceLabel;
    
    IBOutlet UILabel *nameUser1;
    IBOutlet UILabel *nameUser2;
    IBOutlet UILabel *nameUser3;
    
    IBOutlet UILabel *phoneUser1;
    IBOutlet UILabel *phoneUser2;
    IBOutlet UILabel *phoneUser3;
    
    IBOutlet UIButton *buttonUser3;
    IBOutlet UIButton *buttonUser2;
    IBOutlet UIButton *buttonUser1;
    IBOutlet UIButton *buttonPolice;
    IBOutlet UIButton *buttonAmbulance;
    IBOutlet UIButton *buttonFire;
    IBOutlet UIButton *buttonEditPolice;
    IBOutlet UIButton *buttonEditFire;
    IBOutlet UIButton *buttonEditAmbulance;
        
    IBOutlet UIImageView *imageUser1;
    IBOutlet UIImageView *imageUser2;
    IBOutlet UIImageView *imageUser3;
    IBOutlet UIImageView *imageBackground;
    IBOutlet UIImageView *imageEmergenyNumber;
    
    UIImagePickerController *picker;
    
    
    IBOutlet UIButton *saveChangeButton;
    
    IBOutlet UILabel *pass;
}

- (IBAction)editPoliceNumber:(id)sender;
- (IBAction)editFireNumber:(id)sender;
- (IBAction)editAmbulanceNumber:(id)sender;
- (IBAction)editUser1:(id)sender;
- (IBAction)editUser2:(id)sender;
- (IBAction)editUser3:(id)sender;


- (IBAction)callPolice:(id)sender;
- (IBAction)callFire:(id)sender;
- (IBAction)callAmbulance:(id)sender;
- (IBAction)callUser1:(id)sender;
- (IBAction)callUser2:(id)sender;
- (IBAction)callUser3:(id)sender;

- (IBAction)chooseImageUser1:(id)sender;
- (IBAction)chooseImageUser2:(id)sender;
- (IBAction)chooseImageUser3:(id)sender;

- (IBAction)saveChange:(id)sender;

@end
