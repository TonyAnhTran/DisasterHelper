//
//  NewServer.m
//  DisasterHelper
//
//  Created by Tan (Tharin) T. NGUYEN on 3/12/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import "NewServer.h"

@implementation NewServer
@synthesize resultData;

-(NSMutableArray *)postRequest:(NSURL *)url withData:(NSData *)data
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    if(request== nil)
    {
        NSLog(@"Invalid request");
        return nil;
    }
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    
    //    //connect to server
    //    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //    if(conn)
    //    {
    //        // NSLog(@"Connect success");
    //    }
    //    else{
    //        NSLog(@"Connect fail");
    //        return nil;
    //    }
    
    //Recieve data from server
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
  //  NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
   // NSLog(@"This is data %@",responseString);
    resultData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&err];
    // NSLog(@"Response Data is %@",responseDictionary);
    //NSLog(@"msg is %@", [responseDictionary objectForKey:@"msg"]);
    return resultData;
    
}


-(NSDictionary *)getRequest:(NSURL *)url
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    if (request == nil) {
        NSLog(@"Invalid request");
        return nil;
    }
    
    
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    //Cach 1
    //Creat JSON string
    // NSData* nsdata = [NSData dataWithContentsOfURL:url];
    //NSMutableDictionary *yourDictionary = [NSJSONSerialization JSONObjectWithData:nsdata options:kNilOptions error:nil];
    //Cach 2
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    //NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSDictionary *yourDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&err];
    
    
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    if(conn) {
        //    responseData = [NSMutableData data];
        NSLog(@"Connect successful");
    }
    else {
        NSLog(@"Invalid connection");
        return nil;
    }
    NSLog(@"get is %@", yourDictionary);
    
    return yourDictionary;
}
@end
