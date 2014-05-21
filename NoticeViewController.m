//
//  NoticeViewController.m
//  DisasterHelper
//
//  Created by ENCLAVEIT on 3/18/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import "NoticeViewController.h"

@interface NoticeViewController ()

@end
NSMutableArray *noticesList;
@implementation NoticeViewController
NSString *resultNotice=@"";
NSString *bx;

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ViewNoticeContents"]) {
        
        ViewContentsNotice *dvc = [segue destinationViewController];
        NSIndexPath *path1= [self.tableView indexPathForSelectedRow];
        AppDelegate *c1= [noticesList objectAtIndex:path1.row];
        [dvc setCurrentNotice:c1];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Custom back button
    
    UIImage *buttonImage = [UIImage imageNamed:@"back111.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    NSUserDefaults *ServerUrl = [NSUserDefaults standardUserDefaults];
    NSString *stringurl=[ServerUrl objectForKey:@"serverurl"];
    NSURL *url= [[NSURL alloc] initWithString:stringurl];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *internetStatus=[user objectForKey:@"Internet"];
    
    
    
    //Create an array with the first item is System
    noticesList = [[NSMutableArray alloc]init];
    AppDelegate *noticeSystem=[[AppDelegate alloc]init];
    [noticeSystem setNoticeUsername:@"System"];
    [noticesList insertObject:noticeSystem atIndex:0];
    
    if ([internetStatus isEqualToString:@"NO"]) {
        NSLog(@"Run with out network and don't do any thing");
    } else if([internetStatus isEqualToString:@"YES"])
    {
        @try {
            //Connect with server
            
            NSUserDefaults *phonenumber = [NSUserDefaults standardUserDefaults];
            NSString *phoneNumber =[phonenumber valueForKey:@"phone"];
            NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
            NSString *ssid=[session objectForKey:@"ssid"];
            
            //        NSURL *url = [[NSURL alloc] initWithString:@"http://192.168.10.115:3000/users"];
            NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] init];
            [myDictionary setObject:@"checkMessage" forKey:@"key"];
            [myDictionary setObject:ssid forKey:@"sid"];
            [myDictionary setObject:phoneNumber forKey:@"phonenumber"];
            
            NSData *myData = [NSJSONSerialization dataWithJSONObject:myDictionary
                                                             options:kNilOptions
                                                               error:nil];
            NewServer *connect = [[NewServer alloc] init];
            NSMutableArray *returnFromNewser=[[connect postRequest:url withData:myData] mutableCopy];
            
            NSLog(@"%@",returnFromNewser);
            int length =[returnFromNewser count];
            if (length==0) {
                //do nothing
                NSLog(@"Return nothing");
            }else{
                //Get infomation and add to notice array
                for (int i=0; i<length; i++) {
                    AppDelegate *noticeUser = [[AppDelegate alloc]init];
                    
                    NSString *phone = [[returnFromNewser objectAtIndex:i]valueForKey:@"victimphone"];
                    NSString *contents= [[returnFromNewser objectAtIndex:i]valueForKey:@"content"];
                    NSString *date= [[returnFromNewser objectAtIndex:i]valueForKey:@"created_at"];
                    NSString *name= [[returnFromNewser objectAtIndex:i]valueForKey:@"victimname"];
                    NSString *lat = [[returnFromNewser objectAtIndex:i]valueForKey:@"victimlatitude"];
                    NSString *lon = [[returnFromNewser objectAtIndex:i]valueForKey:@"victimlongitude"];
                    NSString *noId = [[returnFromNewser objectAtIndex:i] valueForKey:@"id"];
                    NSString *replied = [[returnFromNewser objectAtIndex:i] valueForKey:@"replied"];
                    
                    [noticeUser setNoticeUsername:name];
                    [noticeUser setNoticeNumber:phone];
                    [noticeUser setNoticeLat:lat];
                    [noticeUser setNoticeLong:lon];
                    [noticeUser setNoticeContents:contents];
                    [noticeUser setNoticeDate:date];
                    [noticeUser setNoticeId:noId];
                    [noticeUser setNoticeReplied:replied];
                    [noticesList insertObject:noticeUser atIndex:1];
                }
            }
        }
        @catch (NSException *exception) {
            //Can not connect with server
            UIAlertView* notexistAlert =[[UIAlertView alloc] initWithTitle:@"Notification Center"
                                                                   message:@"There is no request sent."
                                                                  delegate:self
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil];
            [notexistAlert show];
            double delayInSeconds = 10;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [notexistAlert dismissWithClickedButtonIndex:0 animated:YES];
            });
        }

    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [noticesList count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //Edit color of row
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
    
    AppDelegate *current1=[noticesList objectAtIndex:indexPath.row];
    if ([[current1 noticeUsername] isEqualToString:@"System"]) {
        [cell setBackgroundColor:UIColorFromRGB(0xffa333)];
    }else{
        if (indexPath.row % 2 ==1) {
            [cell setBackgroundColor:UIColorFromRGB(0x83cdec)];
        }else{
            [cell setBackgroundColor:UIColorFromRGB(0xaad9ed)];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Row height
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Table Style
    NSString *CellIdentifier = @"NoticeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
//        cell = [[UITableViewCell alloc]
//                initWithStyle:UITableViewCellStyleDefault
//                reuseIdentifier:CellIdentifier];
    
    // Configure the cell...
    AppDelegate *current1=[noticesList objectAtIndex:indexPath.row];
    
    if ([[current1 noticeUsername] isEqualToString:@"System"]) {
        [cell.textLabel setText:[current1 noticeUsername]];
        cell.imageView.image = [UIImage imageNamed:@"global-2.png"];
        cell.imageView.frame= CGRectMake(cell.imageView.frame.origin.x, cell.imageView.frame.origin.y, cell.imageView.frame.size.width-10, cell.imageView.frame.size.height-10);
        [cell.detailTextLabel setText:@""];
    }else{
        [cell.textLabel setText:[current1 noticeUsername]];
        [cell.detailTextLabel setText:[current1 noticeDate]];
        [[cell detailTextLabel]setFont:[UIFont fontWithName:@"Arial" size:9]];
        NSString *didReplied = [NSString stringWithFormat:@"%@",[current1 noticeReplied]];
        if ([didReplied isEqualToString:@"0"]) {
            cell.imageView.image = [UIImage imageNamed:@"mail-unread-3.png"];
        }else{
            cell.imageView.image = [UIImage imageNamed:@"mail-read.png"];
        }
        
    }
    [[cell textLabel]setFont:[UIFont fontWithName:@"Arial" size:18.0]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

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
