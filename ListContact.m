//
//  ListContact.m
//  DisasterHelper
//
//  Created by Violet on 3/6/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import "ListContact.h"
#import "AddEmergencyContact.h"

@interface ListContact (){
    NSMutableArray *totalString;
    NSMutableArray *filteredString;
    BOOL isFiltered;
}

@end

@implementation ListContact
@synthesize  contactArray, tableview, idEmergencyContact;
@synthesize searchBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    AddEmergencyContact *emergencyObject = [[AddEmergencyContact alloc] init];
    contactArray = [emergencyObject getAllContactList];
    
   // totalString = [[NSMutableArray alloc] init];
   // totalString = contactArray;
    
    NSLog(@"TOTALSTRING IS %@", contactArray);
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length == 0){
        isFiltered = NO;
    }
    else{
        isFiltered = YES;
        filteredString = [[NSMutableArray alloc] init];
        
        for (NSObject *str in totalString){
            NSRange stringRange = [[str valueForKey:@"name"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSLog(@"StringName is %@", [str valueForKey:@"name"]);
            
            if (stringRange.location != NSNotFound) {
                [filteredString addObject:str];
            }
        }
    }
    [self.tableview reloadData];
}


-(void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    [self.tableview resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(isFiltered){
        return [filteredString count];
    }else{
        return [totalString count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString *CellIndetifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndetifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndetifier];
    }
    
    if(!isFiltered){
        cell.textLabel.text = [[totalString objectAtIndex:indexPath.row] valueForKey:@"name"];
    }else{
        cell.textLabel.text = [[filteredString objectAtIndex:indexPath.row] valueForKey:@"name"];
    }
    
    UIImage *img = [UIImage imageNamed:@"person.ico"];
    cell.imageView.image = img;

    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddEmergencyContact *emergencyContact = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEmergencyContact"] ;
    
        if([self.idEmergencyContact isEqualToString:@"one"]){
            if(!isFiltered)
            {
                emergencyContact.contactName1String = [[totalString objectAtIndex:indexPath.row] valueForKey:@"name"];
                emergencyContact.phoneName1String = [[totalString objectAtIndex:indexPath.row] valueForKey:@"phone"];
            }else{
                emergencyContact.contactName1String = [[filteredString objectAtIndex:indexPath.row] valueForKey:@"name"];
                emergencyContact.phoneName1String = [[filteredString objectAtIndex:indexPath.row] valueForKey:@"phone"];
            }

            emergencyContact.contactName2String = self.contactName2String;
            emergencyContact.phoneName2String = self.phoneName2String;
            
            emergencyContact.contactName3String = self.contactName3String;
            emergencyContact.phoneName3String = self.phoneName3String;
            
            emergencyContact.idEmergencyContact = @"one";
        }else if([self.idEmergencyContact isEqualToString:@"two"]){
            if(!isFiltered){
                emergencyContact.contactName2String = [[totalString objectAtIndex:indexPath.row] valueForKey:@"name"];
                emergencyContact.phoneName2String = [[totalString objectAtIndex:indexPath.row] valueForKey:@"phone"];
            }else{
                emergencyContact.contactName2String = [[filteredString objectAtIndex:indexPath.row] valueForKey:@"name"];
                emergencyContact.phoneName2String = [[filteredString objectAtIndex:indexPath.row] valueForKey:@"phone"];
            }
            
            emergencyContact.contactName1String = self.contactName1String;
            emergencyContact.phoneName1String = self.phoneName1String;
            
            emergencyContact.contactName3String = self.contactName3String;
            emergencyContact.phoneName3String = self.phoneName3String;
            emergencyContact.idEmergencyContact = @"two";
        }else if([self.idEmergencyContact isEqualToString:@"three"]){
            if(!isFiltered){
                emergencyContact.contactName3String = [[totalString objectAtIndex:indexPath.row] valueForKey:@"name"];
                emergencyContact.phoneName3String = [[totalString objectAtIndex:indexPath.row] valueForKey:@"phone"];
            }else{
                emergencyContact.contactName3String = [[filteredString objectAtIndex:indexPath.row] valueForKey:@"name"];
                emergencyContact.phoneName3String = [[filteredString objectAtIndex:indexPath.row] valueForKey:@"phone"];
            }
            
            emergencyContact.contactName2String = self.contactName2String;
            emergencyContact.phoneName2String = self.phoneName2String;
            
            emergencyContact.contactName1String = self.contactName1String;
            emergencyContact.phoneName1String = self.phoneName1String;
            
            emergencyContact.idEmergencyContact = @"three";
        }    
    
    
    [self presentViewController:emergencyContact animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancelButton:(UIBarButtonItem *)sender{
    AddEmergencyContact *emergencyContact = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEmergencyContact"] ;

        emergencyContact.contactName1String = self.contactName1String;
        emergencyContact.phoneName1String = self.phoneName1String;
        
        emergencyContact.contactName2String = self.contactName2String;
        emergencyContact.phoneName2String = self.phoneName2String;
        
        emergencyContact.contactName3String = self.contactName3String;
        emergencyContact.phoneName3String = self.phoneName3String;
    
    
    [self presentViewController:emergencyContact animated:YES completion:nil];
    
}
@end
