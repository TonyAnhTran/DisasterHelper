//
//  ViewContentsNotice.h
//  DisasterHelper
//
//  Created by ENCLAVEIT on 3/18/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Server.h"
#import "NewServer.h"
#import "QuartzCore/CALayer.h"
@interface ViewContentsNotice : UIViewController<UITableViewDelegate>
{
    IBOutlet UIImageView *profilePicture;
    IBOutlet UILabel *nameContactRequest;
    IBOutlet UILabel *phoneContactRequest;
    IBOutlet UITextView *requestContents;
   // IBOutlet UITextView *replyContents;
    IBOutlet UITextField *replyTextField;
    IBOutlet UIButton *replyButton;
    
    IBOutlet UIImageView *imageBackground;
    IBOutlet UIImageView *imageName;
    IBOutlet UIImageView *imageChat;
    IBOutlet UIImageView *imageUser;
    
    
    IBOutlet UIView *contentsViewNotice;
    IBOutlet UIScrollView *scrollNotice;
    
  //  IBOutlet UIButton *replyButton1;
    IBOutlet UILabel *positionLabel;
    
    IBOutlet UITableView *tableView1;
    
}
//@property (strong, nonatomic) IBOutlet UIView *contentViewContentsNotice;
//@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewContentsNotice;
- (IBAction)replyRequest:(id)sender;
- (IBAction)dismissReply:(id)sender;
- (IBAction)ClickReplyField:(id)sender;
- (IBAction)ClickrReturnReplyField:(id)sender;

@property (strong,nonatomic) AppDelegate * currentNotice;
@end
