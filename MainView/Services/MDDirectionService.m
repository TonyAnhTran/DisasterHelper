//
//  AddEmergencyContact.m
//  DisasterHelper
//
//  Created by Tu (Tony) A. TRAN on 2/14/14.
//  Copyright (c) 2014 Tu (Tony) A. TRAN. All rights reserved.
//


#import "MDDirectionService.h"

@implementation MDDirectionService{
  @private
  BOOL _sensor;
  BOOL _alternatives;
  NSURL *_directionsURL;
  NSArray *_waypoints;
    NSString *directionstype;
}

static NSString *kMDDirectionsURL = @"http://maps.googleapis.com/maps/api/directions/json?";

- (void)setDirectionsQuery:(NSDictionary *)query withSelector:(SEL)selector
              withDelegate:(id)delegate{
    
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    NSString *directtype =[setting valueForKey:@"DirectionsType"];
    
  NSArray *waypoints = [query objectForKey:@"waypoints"];
  NSString *origin = [waypoints objectAtIndex:0];
  int waypointCount = [waypoints count];
  int destinationPos = waypointCount -1;
  NSString *destination = [waypoints objectAtIndex:destinationPos];
  NSString *sensor = [query objectForKey:@"sensor"];
  NSMutableString *url =
  [NSMutableString stringWithFormat:@"%@&origin=%@&destination=%@&mode=%@&sensor=%@",
   kMDDirectionsURL,origin,destination,directtype,sensor];
  if(waypointCount>2) {
    [url appendString:@"&waypoints=optimize:true"];
    int wpCount = waypointCount-2;
    for(int i=1;i<wpCount;i++){
      [url appendString: @"|"];
      [url appendString:[waypoints objectAtIndex:i]];
    }
  }
    url = [url stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
    _directionsURL = [NSURL URLWithString:url];
    NSLog(@"direction url is :%@",_directionsURL);
  [self retrieveDirections:selector withDelegate:delegate];
}
- (void)retrieveDirections:(SEL)selector withDelegate:(id)delegate{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData* data =
        [NSData dataWithContentsOfURL:_directionsURL];
      [self fetchedData:data withSelector:selector withDelegate:delegate];
    });
}

- (void)fetchedData:(NSData *)data
       withSelector:(SEL)selector
       withDelegate:(id)delegate{
    @try{
  NSError* error;
  NSDictionary *json = [NSJSONSerialization
                        JSONObjectWithData:data
                                   options:kNilOptions
                                     error:&error];

  [delegate performSelector:selector withObject:json];
        
        
   // NSLog(@"Directions Json is: %@",json);
    }
    
    @catch(NSException *e){
        UIAlertView *searchAlert=[[UIAlertView alloc] initWithTitle:@"Get Direction Error"
                                                            message:@"Can't get directions between two that points."
                                                           delegate:nil                                         cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
        [searchAlert show];
    }@finally{}

}

@end
