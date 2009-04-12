//
//  CMTriggerController.h
//  CMTriggerController
//
//  Created by Tim Horton on 2008.04.13.
//  Copyright 2008 Tim Horton. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CMTrigger.h"

@interface CMTriggerController : NSObject
{
	NSMutableDictionary * triggerNames; // (scheme name) -> (trigger name)
	NSMutableDictionary * schemeNames; // (trigger name) -> (scheme name)
	NSMutableDictionary * bundles; // (scheme name) -> (bundle)
}

+ (CMTriggerController *)sharedTriggerController;

- (void)loadTriggerPlugin:(NSString *)path;

- (NSDictionary *)triggerNames;
- (NSDictionary *)schemeNames;

- (id)bundleForPlugin:(NSString *)name;

@end
