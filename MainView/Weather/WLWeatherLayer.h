//
//  WMOverlay.h
//  DisasterHelper
//
//  Created by Tu (Tony) A. TRAN on 2/14/14.
//  Copyright (c) 2014 Tu (Tony) A. TRAN. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef enum
{
    WLWeahterLayerFontColorWhite,
    WLWeahterLayerFontColorBlack
} WLWeahterLayerFontColor;

typedef enum
{
    WLWeahterLayerUnitTypeF,
    WLWeahterLayerUnitTypeC
} WLWeahterLayerUnitType;

@interface WLWeatherLayer : NSObject <MKOverlay>

@property (nonatomic) WLWeahterLayerFontColor color;
@property (nonatomic) WLWeahterLayerUnitType unitType;

- (NSURL *)imageURLWithTilePath:(NSString *)path;

@end
