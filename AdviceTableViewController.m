//
//  AdviceTableViewController.m
//  DisasterHelper
//
//  Created by Tan (Tharin) T.NGUYEN on 2/14/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import "AdviceTableViewController.h"

@interface AdviceTableViewController ()

@end

@implementation AdviceTableViewController
NSMutableArray *tips;

// Send current tip to ViewContentsTip

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ViewContentsTip"]) {
        ViewContentsTip *dvc = [segue destinationViewController];
        NSIndexPath *path1= [self.tableView indexPathForSelectedRow];
        AppDelegate *c= [tips objectAtIndex:path1.row];
        [dvc setCurrentTip:c];
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
    
    
    //Custom navigator back button
    
    UIImage *buttonImage = [UIImage imageNamed:@"back111.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    tips = [[NSMutableArray alloc] init];
    AppDelegate *t=[[AppDelegate alloc]init];
    [t setNameTip:@"Accident Tips"];
    [t setContentsTip:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Accident Tips" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL]];
    [tips addObject:t];
    
    t=[[AppDelegate alloc] init];
    [t setNameTip:@"Drought"];
    [t setContentsTip:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Drought" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL]];
    [tips addObject:t];
    
    t=[[AppDelegate alloc] init];
    [t setNameTip:@"Earthquake"];
    [t setContentsTip:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Earthquake" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL]];
    [tips addObject:t];
    
    t=[[AppDelegate alloc] init];
    [t setNameTip:@"Evacuation Guidelines"];
    [t setContentsTip:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Evacuation Guidelines" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL]];
    [tips addObject:t];
    
    t=[[AppDelegate alloc] init];
    [t setNameTip:@"Extreme Heat"];
    [t setContentsTip:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Extreme Heat" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL]];
    [tips addObject:t];
    
    t=[[AppDelegate alloc] init];
    [t setNameTip:@"Floods"];
    [t setContentsTip:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Floods" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL]];
    [tips addObject:t];
    
    t=[[AppDelegate alloc] init];
    [t setNameTip:@"Health & Safety guide line"];
    [t setContentsTip:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Health & Safety guide line" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL]];
    [tips addObject:t];
    
    t=[[AppDelegate alloc] init];
    [t setNameTip:@"Home Fires"];
    [t setContentsTip:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Home Fires" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL]];
    [tips addObject:t];
    
    t=[[AppDelegate alloc] init];
    [t setNameTip:@"Hurricanes"];
    [t setContentsTip:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Hurricanes" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL]];
    [tips addObject:t];
    
    t=[[AppDelegate alloc] init];
    [t setNameTip:@"Landsides & Debris flow"];
    [t setContentsTip:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Landsides & Debris flow" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL]];
    [tips addObject:t];
    
    t=[[AppDelegate alloc] init];
    [t setNameTip:@"Severe Weather"];
    [t setContentsTip:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Severe Weather" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL]];
    [tips addObject:t];
    
    t=[[AppDelegate alloc] init];
    [t setNameTip:@"Space Weather"];
    [t setContentsTip:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Space Weather" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL]];
    [tips addObject:t];
    
    t=[[AppDelegate alloc] init];
    [t setNameTip:@"Thunderstorm and Lightning"];
    [t setContentsTip:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Thunderstorm and Lightning" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL]];
    [tips addObject:t];
    
    t=[[AppDelegate alloc] init];
    [t setNameTip:@"Tornadoes"];
    [t setContentsTip:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Tornadoes" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL]];
    [tips addObject:t];
    
    t=[[AppDelegate alloc] init];
    [t setNameTip:@"Tsunamis"];
    [t setContentsTip:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Tsunamis" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL]];
    [tips addObject:t];
    
    t=[[AppDelegate alloc] init];
    [t setNameTip:@"Volcanoes"];
    [t setContentsTip:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Volcanoes" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL]];
    [tips addObject:t];
    
    t=[[AppDelegate alloc] init];
    [t setNameTip:@"Wildfires"];
    [t setContentsTip:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Wildfires" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL]];
    [tips addObject:t];
    
    t=[[AppDelegate alloc] init];
    [t setNameTip:@"Winter Storms & Extreme Cold"];
    [t setContentsTip:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Winter Storms & Extreme Cold" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL]];
    [tips addObject:t];
    
    
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
    return [tips count];
}
//Style cell
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
    if (indexPath.row % 2 == 0) {
        [cell setBackgroundColor:UIColorFromRGB(0xaad9ed)];
    }else{
        [cell setBackgroundColor:UIColorFromRGB(0x83cdec)];
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
    static NSString *CellIdentifier = @"ViewTipsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    AppDelegate *current=[tips objectAtIndex:indexPath.row];
    [cell.textLabel setText:[current nameTip]];
    [[cell textLabel]setFont:[UIFont fontWithName:@"Arial" size:18.0]];
    cell.textLabel.numberOfLines = 2;
    cell.imageView.image = [UIImage imageNamed:@"advises-icon-3.png"];
    
  //  cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    //[cell setBackgroundColor:UIColorFromRGB(0x5d9cec)];
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
