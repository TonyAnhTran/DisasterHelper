//
//  ViewContentsTip.h
//  DisasterHelper
//
//  Created by ENCLAVEIT on 2/17/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface ViewContentsTip : UIViewController
{
    IBOutlet UIWebView *web;
}
@property (nonatomic, strong) AppDelegate *currentTip;

@end
