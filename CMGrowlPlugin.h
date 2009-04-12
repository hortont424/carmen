//
//  CMGrowlPlugin.h
//  Carmen
//
//  Created by Tim Horton on 2008.05.05.
//  Copyright 2008 Tim Horton. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Growl-WithInstaller/GrowlApplicationBridge.h"
#import "CMContext.h"

@interface CMGrowlPlugin : NSObject <GrowlApplicationBridgeDelegate>
{
	CMContext * lastContext;
}

- (void)doGrowl:(NSString *)title withMessage:(NSString *)message;
- (NSDictionary *) registrationDictionaryForGrowl;
- (NSString *) applicationNameForGrowl;

@end
