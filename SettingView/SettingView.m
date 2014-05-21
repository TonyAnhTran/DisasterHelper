//
//  SettingView.m
//  DisasterHelper
//
//  Created by Tu (Tony) A.TRAN on 4/10/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import "SettingView.h"

@implementation SettingView

@synthesize DirectionSegment,WeatherUnitSegment;


-(void)Setdefault{
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    NSString *directtype =[setting valueForKey:@"DirectionsType"];
    if ([directtype isEqualToString:@"driving"]) {
        DirectionSegment.selectedSegmentIndex = 0;
    } else {
        DirectionSegment.selectedSegmentIndex = 1;
    }
    
    NSString *weatherunit =[setting valueForKey:@"WeatherUnit"];
    if ([weatherunit isEqualToString:@"imperial"]) {
        WeatherUnitSegment.selectedSegmentIndex = 0;
    } else {
        WeatherUnitSegment.selectedSegmentIndex = 1;
    }
    
    Victimradius.text=@"10";
    NSString *radius=[setting valueForKey:@"RadiusSearch"];
    Victimradius.text=radius;
    
    [self Setdefault];

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
           }
    return self;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    NSString *directtype =[setting valueForKey:@"DirectionsType"];
    static NSString *MyIdentifier = @"aCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
                                      reuseIdentifier:MyIdentifier]; }
    switch ([indexPath section]) {
        case 0:{
            switch ([indexPath row]) {
                case 0:{
                    if ([directtype isEqualToString:@"driving"]) {
                        DirectionSegment.selectedSegmentIndex = 0;
                    } else {
                        DirectionSegment.selectedSegmentIndex = 1;
                    }
                    break;
                }
                case 1:{
                    Victimradius.text=@"10";
                    NSString *radius=[setting valueForKey:@"RadiusSearch"];
                    Victimradius.text=radius;
                    break;
                }

            break;
        }
        case 1:
            {
            switch ([indexPath row])
            {
                case 0:
                {
                    NSString *weatherunit =[setting valueForKey:@"WeatherUnit"];
                    if ([weatherunit isEqualToString:@"imperial"])
                    {
                        WeatherUnitSegment.selectedSegmentIndex = 0;
                    } else
                    {
                        WeatherUnitSegment.selectedSegmentIndex = 1;
                    }
                    break;
                }
            }
            break;
        }
        case 2:
            {
            //the third section
            break;
            }
        default:
            break;
    }
    }
    return cell;
}


- (IBAction)DirectionSegmnt:(id)sender {
    
    if(self.DirectionSegment.selectedSegmentIndex == 0){
        NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
        [setting setValue:@"driving" forKey:@"DirectionsType"];
        
    }
    else if(self.DirectionSegment.selectedSegmentIndex == 1){
        NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
        [setting setValue:@"walking" forKey:@"DirectionsType"];
    }
}
- (IBAction)WeatherUnitSegmentAction:(id)sender {

    // weath=[[MainFlatViewController alloc]init];
    if(self.WeatherUnitSegment.selectedSegmentIndex == 1){
        NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
        [setting setValue:@"metric" forKey:@"WeatherUnit"];
        [setting setValue:@"c" forKey:@"WeatherUnit2"];
        
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Success !" message:@"Your main view weather data will update with new unit in 5 minutes" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
        // [weath getWeather];
    }
    else if(self.WeatherUnitSegment.selectedSegmentIndex == 0){
        NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
        [setting setValue:@"imperial" forKey:@"WeatherUnit"];
        [setting setValue:@"f" forKey:@"WeatherUnit2"];
        
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Success" message:@"Your main view weather data will update with new unit in 5 minutes" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        //  [weath getWeather];
    }
}
- (IBAction)VictimradiusSave:(id)sender {
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    [setting setValue:Victimradius.text forKey:@"RadiusSearch"];
    
}

- (IBAction)dismisskeyboard:(id)sender {
    [Victimradius resignFirstResponder];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
