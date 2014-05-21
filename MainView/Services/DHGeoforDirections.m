//
//  AddEmergencyContact.m
//  DisasterHelper
//
//  Created by Tu (Tony) A. TRAN on 2/14/14.
//  Copyright (c) 2014 Tu (Tony) A. TRAN. All rights reserved.


//#define kBgQueue dispatch_get_main_queue()(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

#import "DHGeoforDirections.h"

@implementation DHGeoforDirections
{
    NSData *_data;
}

@synthesize geocode;


- (id)init{
    self = [super init];
    geocode = [[NSDictionary alloc]initWithObjectsAndKeys:@"0.0",@"lat",@"0.0",@"lng",@"Null Island",@"address",nil];
    return self;
}

- (void)geocodeAddress:(NSString *)address withCallback:(SEL)sel withDelegate:(id)delegate {
   
    NSString *geocodingBaseUrl = @"http://maps.googleapis.com/maps/api/geocode/json?";
    NSString *url = [NSString stringWithFormat:@"%@address=%@&sensor=false", geocodingBaseUrl,address];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    NSURL *queryUrl = [NSURL URLWithString:url];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *data = [NSData dataWithContentsOfURL: queryUrl];
        
        [self fetchedData:data withCallback:sel withDelegate:delegate];
        
    });
    
}
- (void)fetchedData:(NSData *)data withCallback:(SEL)sel withDelegate:(id)delegate{
    
    @try{
    NSError* error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&error];
        
     //   NSLog(@"json is: %@", json);
    
    NSArray* results = [json objectForKey:@"results"];
        if (results.count>0) {
            NSDictionary *result = [results objectAtIndex:0];
            NSString *address = [result objectForKey:@"formatted_address"];
            NSDictionary *geometry = [result objectForKey:@"geometry"];
            NSDictionary *location = [geometry objectForKey:@"location"];
            
            NSString *lat = [location objectForKey:@"lat"];
            NSString *lng = [location objectForKey:@"lng"];
            
            NSDictionary *gc = [[NSDictionary alloc]initWithObjectsAndKeys:lat,@"lat",lng,@"lng",address,@"address",nil];
            
            geocode = gc;
            [delegate performSelector:sel];
            // NSLog(@"geo is : %@",geocode);
        }
   
   
    }
    @catch(NSException *e){
        NSLog(@"Error to geocoder marker");
    }@finally{
    }
}


@end

