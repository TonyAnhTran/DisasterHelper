//
//  NewServer.h
//  DisasterHelper
//
//  Created by Tan (Tharin) T. NGUYEN on 3/12/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewServer : NSObject
{
    NSURLConnection *conn;
    
}
@property (strong, nonatomic) NSMutableArray *resultData;

-(NSString *)postRequest:(NSURL *)url withData: (NSData *)myData;
- (NSDictionary *) getRequest:(NSURL *) url;
@end