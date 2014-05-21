//
//  SettingViewController.h
//  DisasterHelper
//
//  Created by Tu (Tony) A.TRAN on 4/10/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SegueLogOut.h"
#import "LogoutViewController.h"
#import "MainViewController.h"
#import "Reachability.h"

@interface SettingViewController : UITableViewController{
    Reachability *internetReachableFoo;
    __weak IBOutlet UITextField *Victimradius;
    __weak IBOutlet UITextField *VictimTime;
    __weak IBOutlet UISwitch *OfflineSwitch;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *DirectionSegment;
- (IBAction)DirectionSegmnt:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *WeatherUnitSegment;
- (IBAction)WeatherUnitSegmentAction:(id)sender;
//@property (strong,nonatomic) MainFlatViewController *weath;
- (IBAction)VictimradiusSave:(id)sender;
- (IBAction)dismisskeyboard:(id)sender;
- (IBAction)VictimTimeSet:(id)sender;
- (IBAction)SwitchChange:(id)sender;

@property (strong,nonatomic) SegueLogOut *logout;
@property (strong,nonatomic) LogoutViewController *logout1;
@property (strong,nonatomic) MainViewController *map;


@end
