//
//  WMOverlay.m
//  DisasterHelper
//
//  Created by Tu (Tony) A. TRAN on 2/14/14.
//  Copyright (c) 2014 Tu (Tony) A. TRAN. All rights reserved.
//
//

#import "WLWeatherLayer.h"

@implementation WLWeatherLayer

- (CLLocationCoordinate2D)coordinate
{
    return MKCoordinateForMapPoint(MKMapPointMake(MKMapRectGetMidX(MKMapRectWorld), MKMapRectGetMidY(MKMapRectWorld)));
}

- (MKMapRect)boundingMapRect
{
    return MKMapRectWorld;
}

- (NSURL *)imageURLWithTilePath:(NSString *)path
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
   	NSString *internetStatus=[user objectForKey:@"Internet"];
    
    u_int32_t random = arc4random_uniform(2);
    NSString *s;
    if ([internetStatus isEqualToString:@"NO"]) {
        NSLog(@"Run with out network and don't do any thing");
    } else if([internetStatus isEqualToString:@"YES"]) {
       s =
        [NSString stringWithFormat:@"http://mt%d.google.com/mapslt?lyrs=%@%%7Cinvert:%d&%@&w=256&h=256",
         random,
         self.unitType == WLWeahterLayerUnitTypeF ? @"weather_f_kph" : @"weather_c_kph",
         self.color == WLWeahterLayerFontColorWhite ? 0 : 1,
         path];
    }

    return [NSURL URLWithString:s];
}

@end
