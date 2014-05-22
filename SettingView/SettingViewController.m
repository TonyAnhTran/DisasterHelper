//
//  SettingViewController.m
//  DisasterHelper
//
//  Created by Tu (Tony) A.TRAN on 4/10/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize WeatherUnitSegment,DirectionSegment,logout,logout1,map;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        map=[[MainViewController alloc]init];
    //    logout = [[SegueLogOut alloc]init];
    //    logout1=[[LogoutViewController alloc]init];
    NSUserDefaults *checkLogin = [NSUserDefaults standardUserDefaults];
    NSString *check = [checkLogin valueForKey:@"checkLogin"];
    
    if ([check isEqualToString:@"Offline"]) {
        [OfflineSwitch setOn:YES];
    }
    else{
        [OfflineSwitch setOn:FALSE];
    }
    
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
    
    //Victimradius.text=@"10";
    NSString *radius=[setting valueForKey:@"RadiusSearch"];
    NSString *day=[setting valueForKey:@"VictimTimeSet"];
    Victimradius.text=radius;
    VictimTime.text=day;
    
   // weatherTimes.text=@"5";

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)testInternetConnection
{
    internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"we have the internet");
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setValue:@"YES" forKey:@"Internet"];
        });
    };
    
    // Internet is not reachable
    internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //            offlineAlert=[[UIAlertView alloc] initWithTitle:@"Connection error !" message:@"Network error, check your network and try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Using offline mode", nil];
            //            [offlineAlert show];
            NSLog(@"Someone broke the internet :(");
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setValue:@"NO" forKey:@"Internet"];
        });
        
    };
    
    [internetReachableFoo startNotifier];
}


//Choose directions type in mapview by segment
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

//Choose weather unit by segment
- (IBAction)WeatherUnitSegmentAction:(id)sender {
     NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    NSString *message=[NSString stringWithFormat:@"Your main view weather data will update with new unit in 5 minutes"];
   
    if(self.WeatherUnitSegment.selectedSegmentIndex == 1){

        [setting setValue:@"metric" forKey:@"WeatherUnit"];
        [setting setValue:@"c" forKey:@"WeatherUnit2"];
        
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Success !" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
        // [weath getWeather];
    }
    else if(self.WeatherUnitSegment.selectedSegmentIndex == 0){
       
        [setting setValue:@"imperial" forKey:@"WeatherUnit"];
        [setting setValue:@"f" forKey:@"WeatherUnit2"];
        
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Success" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        //  [weath getWeather];
    }
}

//set radius value to get victims list
- (IBAction)VictimradiusSave:(id)sender {
    NSString *inputdata=Victimradius.text;
    int radius=[inputdata intValue];
    NSString *convert=[NSString stringWithFormat:@"%i",radius];
    NSLog(@"test: %i",radius);
    if (radius>0&&radius<12420) {
        NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
        [setting setValue:convert forKey:@"RadiusSearch"];
    } else {
        UIAlertView *radiusError =[[UIAlertView alloc]initWithTitle:@"Input error" message:@"Input date must be from 1-12420 miles, try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        Victimradius.text=@"";
        [radiusError show];
    }
}



- (IBAction)dismisskeyboard:(id)sender {
    [Victimradius resignFirstResponder];
    [VictimTime resignFirstResponder];
}

- (IBAction)VictimTimeSet:(id)sender {
    NSString *inputdata=VictimTime.text;
    int day=[inputdata intValue];
    NSString *convert=[NSString stringWithFormat:@"%i",day];
   // NSLog(@"test: %i",day);
    if (day>0&&day<8) {
        NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
        [setting setObject:convert forKey:@"VictimTimeSet"];
    } else {
        UIAlertView *dayError =[[UIAlertView alloc]initWithTitle:@"Input error" message:@"Input date must be from 1-7 day, try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        VictimTime.text=@"";
        [dayError show];

    }
}

- (IBAction)SwitchChange:(id)sender {
    NSUserDefaults *checkLogin = [NSUserDefaults standardUserDefaults];
    if ([sender isOn]) {
        [map clearmapdata];
        NSUserDefaults *victimData = [NSUserDefaults standardUserDefaults];
        [victimData removeObjectForKey:@"victimdata"];

        UIAlertView *OfflineAlert=[[UIAlertView alloc]initWithTitle:@"Offline Mode is On" message:@"Now you can work only with offline feature with out server connect" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [OfflineAlert show];
        [checkLogin setValue:@"Offline" forKey:@"checkLogin"];
        [self testInternetConnection];
    }
    else{

        UIAlertView *OfflineAlert=[[UIAlertView alloc]initWithTitle:@"You need login again" message:@"Login again to using online mode" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [OfflineAlert show];
        [OfflineSwitch setOn:YES];
        [self testInternetConnection];
//        [logout perform];
//        [logout1 prepareForSegue:(UIStoryboardSegue *) sender:<#(id)#>];
    }
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
