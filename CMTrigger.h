/*
 *  CMTrigger.h
 *  CMTriggerController
 *
 *  Created by Tim Horton on 2008.04.13.
 *  Copyright 2008 Tim Horton. All rights reserved.
 *
 */

#import <Cocoa/Cocoa.h>
#import <libguile.h>

@protocol CMTrigger

+ (unsigned int)interfaceVersion;

+ (NSString *)triggerName;
+ (NSString *)schemeTriggerName;

+ (void)initializeTrigger;

@end
