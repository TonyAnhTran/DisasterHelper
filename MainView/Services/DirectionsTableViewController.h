//
//  DirectionsTableViewController.h
//  DisasterHelper
//
//  Created by Tu (Tony) A. TRAN on 5/23/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DirectionsTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *arrData;
-(void)getDirectionsData:(NSArray*)step;
@end
