//
//  AppDelegate.h
//  DisasterHelper
//
//  Created by Tan (Tharin) T.NGUYEN on 2/14/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "QuartzCore/CALayer.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSString *nameTip;
@property (nonatomic, strong) NSString *contentsTip;
@property (nonatomic, strong) NSString *emergencyContact;
@property (nonatomic, strong) NSString *userLocation;
@property (nonatomic, strong) NSString *noticeNumber;
@property (nonatomic, strong) NSString *noticeUsername;
@property (nonatomic, strong) NSString *noticeLat;
@property (nonatomic, strong) NSString *noticeLong;
@property (nonatomic, strong) NSString *noticeContents;
@property (nonatomic, strong) NSString *noticeDate;
@property (nonatomic, strong) NSString *noticeId;
@property (nonatomic, strong) NSString *noticeReplied;
@property (nonatomic, strong) NSString *password;
@end
