//
//  SettingView.h
//  DisasterHelper
//
//  Created by Tu (Tony) A.TRAN on 4/10/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingView : UITableView{
    __weak IBOutlet UITextField *Victimradius;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *DirectionSegment;
- (IBAction)DirectionSegmnt:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *WeatherUnitSegment;
- (IBAction)WeatherUnitSegmentAction:(id)sender;
//@property (strong,nonatomic) MainFlatViewController *weath;
- (IBAction)VictimradiusSave:(id)sender;
- (IBAction)dismisskeyboard:(id)sender;


@end
