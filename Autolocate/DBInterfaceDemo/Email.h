//
//  Email.h
//  MailDemo
//
//  Created by Scott Stevenson on Wed Apr 21 2004.
//  Copyright (c) 2004 Tree House Ideas. All rights reserved.
//


#import <Cocoa/Cocoa.h>


@interface Email : NSObject {
    NSMutableDictionary *properties;
}

- (NSMutableDictionary *)properties;
- (void) setProperties:(NSDictionary *)newProperties;
- (NSString *)subject;
- (void)setSubject:(NSString *)newSubject;


@end
