//
//  AddEmergencyContact.m
//  DisasterHelper
//
//  Created by Tu (Tony) A. TRAN on 2/14/14.
//  Copyright (c) 2014 Tu (Tony) A. TRAN. All rights reserved.


#import <Foundation/Foundation.h>

@interface DHGeoforDirections : NSObject

- (id)init;
- (void)geocodeAddress:(NSString *)address
          withCallback:(SEL)callback
          withDelegate:(id)delegate;

@property (nonatomic, strong) NSDictionary *geocode;

@end
