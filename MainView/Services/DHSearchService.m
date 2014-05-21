//
//  AddEmergencyContact.m
//  DisasterHelper
//
//  Created by Tu (Tony) A. TRAN on 2/14/14.
//  Copyright (c) 2014 Tu (Tony) A. TRAN. All rights reserved.
//


//#define kBgQueue dispatch_get_main_queue()(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

#import "DHSearchService.h"

@implementation DHSearchService
{
    NSData *_data;
}

@synthesize searchplace;

- (id)init{
    self = [super init];
    searchplace = [[NSDictionary alloc]initWithObjectsAndKeys:@"0.0",@"lat",@"0.0",@"lng",@"Null Island",@"address",@"name",@"icon",nil];
    return self;
}

- (void)searchQuery:(NSString *)query withCallback:(SEL)sel withDelegate:(id)delegate {
   
    NSString *geocodingBaseUrl = @"https://maps.googleapis.com/maps/api/place/textsearch/json?";
    NSString *url = [NSString stringWithFormat:@"%@query=%@&sensor=true&key=AIzaSyAJs7aFhIV3pp0stOa7SWkyqlhrK8TBtLM", geocodingBaseUrl,query];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSLog(@"url is: %@",url);
    NSURL *queryUrl = [NSURL URLWithString:url];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *data = [NSData dataWithContentsOfURL: queryUrl];
        
        [self fetchedData:data withCallback:sel withDelegate:delegate];
        
    });
    
}

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (void)fetchedData:(NSData *)data withCallback:(SEL)sel withDelegate:(id)delegate{
    
    @try{
    NSError* error;
    NSDictionary *json = [NSJSONSerialization
             JSONObjectWithData:data
             options:kNilOptions
             error:&error];
        
       // NSLog(@"json is: %@", json);
    
    NSArray* results = [json objectForKey:@"results"];
         for(int i=0;i<[results count];i++){
    NSDictionary *result = [results objectAtIndex:i];
    NSString *name = [result objectForKey:@"name"];
    NSString *address = [result objectForKey:@"formatted_address"];
    NSString *icon = [result objectForKey:@"icon"];
    NSDictionary *geometry = [result objectForKey:@"geometry"];
    NSDictionary *location = [geometry objectForKey:@"location"];
    
    NSString *lat = [location objectForKey:@"lat"];
    NSString *lng = [location objectForKey:@"lng"];

    NSDictionary *sp = [[NSDictionary alloc]initWithObjectsAndKeys:lat,@"lat",lng,@"lng",address,@"address",name,@"name",icon,@"icon",nil];
    
   
        searchplace = sp;
             [delegate performSelector:sel];
         }
   
    }
    @catch(NSException *e){
        UIAlertView *searchAlert=[[UIAlertView alloc] initWithTitle:@"Search error"
                                                            message:@"Please enter a valid location to search."
                                                           delegate:nil                                         cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
        [searchAlert show];
    }@finally{
    }
}


@end

