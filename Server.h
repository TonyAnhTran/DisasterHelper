//
//  Server.h
//  DisasterHelper
//
//  Created by Violet on 3/5/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Server : NSObject
{
    NSURLConnection *conn;
    
}
@property (strong, nonatomic) NSDictionary *resultData;

-(NSString *)postRequest:(NSURL *)url withData: (NSData *)myData;
- (NSDictionary *) getRequest:(NSURL *) url;
@end
