//
//  CMGrowlPlugin.m
//  Carmen
//
//  Created by Tim Horton on 2008.05.05.
//  Copyright 2008 Tim Horton. All rights reserved.
//

#import "CMGrowlPlugin.h"


@implementation CMGrowlPlugin

- (id) init
{
	self = [super init];
	
	if (self != nil)
	{
		[GrowlApplicationBridge setGrowlDelegate:self];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentContext:) name:@"CMContextUpdated" object:nil];
	}
	
	return self;
}

- (void)doGrowl:(NSString *)title withMessage:(NSString *)message
{
	[GrowlApplicationBridge notifyWithTitle:title
								description:message
						   notificationName:title
								   iconData:nil
								   priority:0
								   isSticky:NO
							   clickContext:nil];
}

- (NSDictionary *) registrationDictionaryForGrowl
{
	NSArray *notifications = [NSArray arrayWithObjects:
							  NSLocalizedString(@"Context Changed", @"Growl message title"),
							  nil];
	
	return [NSDictionary dictionaryWithObjectsAndKeys:
			notifications, GROWL_NOTIFICATIONS_ALL,
			notifications, GROWL_NOTIFICATIONS_ALL,
			nil];
}

- (NSString *) applicationNameForGrowl
{
	return @"Carmen";
}

- (void)updateCurrentContext:(NSNotification *)notification
{
	if(lastContext != [[notification object] currentContext])
		[self doGrowl:@"Context Changed" withMessage:[[[notification object] currentContext] recursiveName]];
	
	lastContext = [[notification object] currentContext];
}

@end
