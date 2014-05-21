//
//  ListContact.h
//  DisasterHelper
//
//  Created by Violet on 3/6/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ListContact : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *tableview;


@property (strong, nonatomic) NSArray *contactArray;

@property (weak, nonatomic) NSString *idEmergencyContact;
@property (weak, nonatomic) NSString *contactName1String, *contactName2String, *contactName3String,*phoneName1String,*phoneName2String,*phoneName3String;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;



@end
