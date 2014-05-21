//
//  ViewContentsNotice.m
//  DisasterHelper
//
//  Created by ENCLAVEIT on 3/18/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import "ViewContentsNotice.h"

@interface ViewContentsNotice (){
    double friendlat;
    double friendlng;
}

@end
NSString *contentofRequest;
NSMutableArray *returnFromNewser;
@implementation ViewContentsNotice

@synthesize currentNotice;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLayoutSubviews{
    
    //Scroll
    [super viewDidLayoutSubviews];
    [scrollNotice layoutIfNeeded];
    scrollNotice.contentSize=contentsViewNotice.bounds.size;
}

-(void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    
    //Custom back button
    UIImage *buttonImage = [UIImage imageNamed:@"back111.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
    //Setting View
    imageName.backgroundColor= UIColorFromRGB(0x83cdec);
    imageBackground.backgroundColor=UIColorFromRGB(0xaad9ed);
    requestContents.backgroundColor=UIColorFromRGB(0xffffff);
    imageUser.backgroundColor=UIColorFromRGB(0xffffff);
    replyButton.backgroundColor=UIColorFromRGB(0xed6350);
    
    
    
    //drog shadow
//    imageName.layer.shadowColor = [UIColor grayColor].CGColor;
//    imageName.layer.shadowOffset = CGSizeMake(0, 2);
//    imageName.layer.shadowOpacity = 2;
//    imageName.layer.shadowRadius = 2.0;
//    imageName.clipsToBounds = NO;
//    
//    imageChat.layer.shadowColor = [UIColor grayColor].CGColor;
//    imageChat.layer.shadowOffset = CGSizeMake(0, 2);
//    imageChat.layer.shadowOpacity = 2;
//    imageChat.layer.shadowRadius = 2.0;
//    imageChat.clipsToBounds = NO;
    
    
    [super viewDidLoad];
	NSUserDefaults *ServerUrl = [NSUserDefaults standardUserDefaults];
    NSString *stringurl=[ServerUrl objectForKey:@"serverurl"];
    NSURL *url= [[NSURL alloc] initWithString:stringurl];
    NSUserDefaults *checkLogin = [NSUserDefaults standardUserDefaults];
    NSString *check = [checkLogin valueForKey:@"checkLogin"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
   	NSString *internetStatus=[user objectForKey:@"Internet"];
    
    if ([internetStatus isEqualToString:@"NO"]) {
        NSLog(@"Run with out network and don't do any thing");
    } else if([internetStatus isEqualToString:@"YES"]) {
        if ([check isEqualToString:@"Offline"]) {
            UIAlertView *Offlinealert=[[UIAlertView alloc]initWithTitle:@"Error"
                                                                message:@"You can't get notification when using offline mode"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
            [Offlinealert show];
        }
        else if ([check isEqualToString:@"LOGIN"]){
            // Do any additional setup after loading the view.
            if ([currentNotice.noticeUsername isEqualToString:@"System"]) {
                
                
                //Display system here
                requestContents.hidden=YES;
                nameContactRequest.hidden=YES;
                replyTextField.hidden=YES;
                replyButton.hidden=YES;
                imageChat.hidden=YES;
                positionLabel.hidden=YES;
                phoneContactRequest.text=@"System";
                [phoneContactRequest setFont: [UIFont fontWithName:@"Arial" size:30.0]];
                [imageName setFrame:CGRectMake(28, 29, 304, 400)];
                [profilePicture setImage:[UIImage imageNamed:@"iPhone-Icon1.png"]];
                scrollNotice.scrollEnabled=NO;
                
                //Connect to server to get notification
                
                NSUserDefaults *phonenumber = [NSUserDefaults standardUserDefaults];
                NSString *phoneNumber =[phonenumber valueForKey:@"phone"];
                NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
                NSString *ssid=[session objectForKey:@"ssid"];
                
                //        NSURL *url = [[NSURL alloc] initWithString:@"http://192.168.10.115:3000/users"];
                NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] init];
                [myDictionary setObject:@"loadNotification" forKey:@"key"];
                [myDictionary setObject:ssid forKey:@"sid"];
                [myDictionary setObject:phoneNumber forKey:@"phonenumber"];
                
                NSData *myData = [NSJSONSerialization dataWithJSONObject:myDictionary
                                                                 options:kNilOptions
                                                                   error:nil];
                
                NewServer *connect = [[NewServer alloc] init];
                returnFromNewser = [connect postRequest:url withData:myData];
                
            }else{
                //Display user here
                phoneContactRequest.text=currentNotice.noticeNumber;
                phoneContactRequest.font=[phoneContactRequest.font fontWithSize:14];
                tableView1.hidden=YES;
                
                NSString *content1= currentNotice.noticeContents;
                if ([content1 isEqualToString:@"HELP!"]) {
                    content1 = @"HELP ME NOW!!!!";
                    requestContents.text=[NSString stringWithFormat:@"%@ \n", content1];
                }else{
                    requestContents.text=[NSString stringWithFormat:@"%@ \n", currentNotice.noticeContents];
                }
                nameContactRequest.text=[currentNotice noticeUsername];
                nameContactRequest.font=[nameContactRequest.font fontWithSize:18];
                requestContents.editable =  NO;
                [NSTimer scheduledTimerWithTimeInterval:3.0 target:self
                                               selector:@selector(getFriendlocation) userInfo:nil repeats:NO];
            }
        }

    }
            
}

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
    return [returnFromNewser count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Table height
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Table style
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:@"cell"];
    }
    //Configure cell
    NSString *title1 = [[returnFromNewser objectAtIndex:indexPath.row] valueForKey:@"title"] ;
    if ([title1 isEqualToString:@"System"]) {
        [[cell textLabel] setText : [[returnFromNewser objectAtIndex:indexPath.row] valueForKey:@"notify"] ];
        [[cell textLabel]setFont:[UIFont fontWithName:@"Arial" size:14.0]];
        NSString *datetime=[[returnFromNewser objectAtIndex:indexPath.row] valueForKey:@"created_at"];
        cell.detailTextLabel.text=datetime;
        [[cell detailTextLabel]setFont:[UIFont fontWithName:@"Arial" size:9]];
        cell.textLabel.numberOfLines = 3;
    }
    else{
        //Do nothing
    }
    
    return cell;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)replyRequest:(id)sender {
    if ([replyTextField.text isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Reply failed" message:@"Please enter some information in the text field." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else{
        //Send to server
        @try{
            
            NSUserDefaults *phonenumber = [NSUserDefaults standardUserDefaults];
            NSString *phoneNumber =[phonenumber valueForKey:@"phone"];
            
            NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
            NSString *ssid=[session objectForKey:@"ssid"];
            
            NSUserDefaults *ServerUrl = [NSUserDefaults standardUserDefaults];
            NSString *stringurl=[ServerUrl objectForKey:@"serverurl"];
            NSURL *url= [[NSURL alloc] initWithString:stringurl];
      //  latAtt=[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
      //  longAtt=[NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
//        NSURL *url = [[NSURL alloc] initWithString:@"http://192.168.10.115:3000/users"];
            NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] init];
            [myDictionary setObject:@"replyMessage" forKey:@"key"];
            [myDictionary setObject:ssid forKey:@"sid"];
            [myDictionary setObject:phoneNumber forKey:@"phonenumber"];
            [myDictionary setObject:currentNotice.noticeNumber forKey:@"targetphone"];
            [myDictionary setObject:replyTextField.text forKey:@"content"];
            [myDictionary setObject:currentNotice.noticeId forKey:@"msg_id"];
        
            NSData *myData = [NSJSONSerialization dataWithJSONObject:myDictionary
                                                             options:kNilOptions
                                                               error:nil];
        
            Server *connect = [[Server alloc] init];
            NSString *result = [connect postRequest:url withData:myData];
            if ([result isEqualToString:@"Reply message has been sent!"]) {
//            UIAlertView *alertReply = [[UIAlertView alloc]initWithTitle:@"Sent message" message:@"Your message has been sent" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alertReply show];
                requestContents.text= [NSString stringWithFormat:@"%@\n----------------------------------------------------\nMe: %@",requestContents.text,replyTextField.text];
                replyTextField.text=@"";
                [self.navigationController popViewControllerAnimated:YES];
            }
        }@catch (NSException *e) {
            UIAlertView *alerReplyFail = [[UIAlertView alloc]initWithTitle:@"Can't reply"
                                                                   message:@"Your message can't be sent.\nPlease check again."
                                                                  delegate:self
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles: nil];
            [alerReplyFail show];
        }
    }
    
}

// Convert friend location to address and display in notification view
-(void)getFriendlocation{
    if ([currentNotice.noticeNumber isEqualToString:@"System"]) {
        positionLabel.text = NULL;
    }
    
    else{
        // CLLocationCoordinate2D friendlocation=CLLocationCoordinate2DMake(lat, lon);
        NSString *stringfriend=[NSString stringWithFormat:@"%@,%@",[currentNotice noticeLat],[currentNotice noticeLong]];
        
        NSString *geocodingBaseUrl = @"http://maps.googleapis.com/maps/api/geocode/json?";
        NSString *url = [NSString stringWithFormat:@"%@address=%@&sensor=false", geocodingBaseUrl,stringfriend];
        url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        NSURL *queryUrl = [NSURL URLWithString:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSData *data = [NSData dataWithContentsOfURL: queryUrl];
            
            @try{
                NSError* error;
                NSDictionary *json = [NSJSONSerialization
                                      JSONObjectWithData:data
                                      options:kNilOptions
                                      error:&error];
                NSArray* results = [json objectForKey:@"results"];
                NSDictionary *result = [results objectAtIndex:0];
                NSString *address = [result objectForKey:@"formatted_address"];
                //     NSDictionary *geometry = [result objectForKey:@"geometry"];
                // NSDictionary *location = [geometry objectForKey:@"location"];
                NSLog(@"address: %@",address);
                positionLabel.text = address;
                positionLabel.font=[positionLabel.font fontWithSize:11];
            }
            @catch(NSException *e){
                NSLog(@"Error when get friend location");
            }@finally{}
        });
    }
}

- (IBAction)dismissReply:(id)sender {
    [replyTextField resignFirstResponder];
}

- (IBAction)ClickReplyField:(id)sender {
    [scrollNotice setContentOffset:CGPointMake(0,replyTextField.center.y-200) animated:YES];
}

- (IBAction)ClickrReturnReplyField:(id)sender {
    NSInteger nextTag = replyTextField.tag + 1;
    // Try to find next responder
    UIResponder *nextResponder = [replyTextField.superview viewWithTag:nextTag];
    
    if (nextResponder) {
        [scrollNotice setContentOffset:CGPointMake(0,replyTextField.center.y-200) animated:YES];
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        [scrollNotice setContentOffset:CGPointMake(0,0) animated:YES];
        [replyTextField resignFirstResponder];
    }
}
@end
