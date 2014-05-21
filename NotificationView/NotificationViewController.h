//
//  NotificationViewController.h
//  DisasterHelper
//
//  Created by Tan (Tharin) T.NGUYEN on 2/14/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface NotificationViewController : UIViewController {
    
    IBOutlet UIImageView *image;
    IBOutlet UILabel *nameContactRequets;
    IBOutlet UILabel *phoneNumberRequest;
    IBOutlet UITextView *requestContents;
    IBOutlet UITextView *replyContents;
    
    
}
@property (strong,nonatomic) AppDelegate * currentNotice;

@property (weak, nonatomic) IBOutlet UIButton *replyRequest;

@end
