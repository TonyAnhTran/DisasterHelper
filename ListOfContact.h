//
//  ListOfContact.h
//  DisasterHelper
//
//  Created by Violet on 3/6/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListOfContact : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *contactArray;
@end
