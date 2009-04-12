//
//  CMContextController.m
//  Carmen
//
//  Created by Tim Horton on 2008.05.04.
//  Copyright 2008 Tim Horton. All rights reserved.
//

#import "CMContextController.h"

@implementation CMContextController

/**
 Determine whether we're on AC or battery power.
 
 \returns POWER_SOURCE_BATTERY or POWER_SOURCE_AC
*/
- (int)determinePowerSource
{
 	CFTypeRef blob = IOPSCopyPowerSourcesInfo();
	CFArrayRef sources = IOPSCopyPowerSourcesList(blob);
	
	for(int i = 0; i < CFArrayGetCount(sources); i++)
		if(!CFBooleanGetValue(CFDictionaryGetValue(IOPSGetPowerSourceDescription(blob, CFArrayGetValueAtIndex(sources, i)), CFSTR(kIOPSIsChargingKey))))
			return POWER_SOURCE_BATTERY;
	
	return POWER_SOURCE_AC;
}

/**
 If necessary, update the timer's interval based on our power source. Takes no action if the
 correct refresh frequency is already set; deletes the timer if we're set to not refresh.
 
 We need to make absolutely sure that we call this function whenever we go from no refresh
 to refreshing (either in the UI, or when the power state changes!); otherwise, since no polling
 is taking place, we'll never start the timer back up again.
 
 \todo Right now, we have no way of knowing if power source changes if the timer's currently disabled...
 \todo When context is forced, we don't need to tick the timer; do, however, make sure that this gets called when we switch back!
*/
- (void)updateTimer
{
	int refreshFrequency = [[NSUserDefaults standardUserDefaults] integerForKey:([self determinePowerSource] == POWER_SOURCE_AC ? @"acRefreshFrequency" : @"batteryRefreshFrequency")];
	
	if(refreshTimer)
	{
		if([refreshTimer timeInterval] == refreshFrequency)
			return;
		
		[refreshTimer invalidate];
		refreshTimer = nil;
	}
	
	if(refreshFrequency)
		refreshTimer = [NSTimer scheduledTimerWithTimeInterval:refreshFrequency target:self selector:@selector(autoRefreshContext:) userInfo:nil repeats:YES];
}

- (id)init
{
	self = [super init];
	
	if (self != nil)
	{
		contexts = [[NSMutableArray alloc] init];

		[self updateTimer];
	}
	return self;
}

/**
 \returns A shared singleton context controller.
*/
+ (CMContextController *)sharedContextController
{
	static CMContextController * sharedContextController;
	
	if (!sharedContextController)
		sharedContextController = [[CMContextController alloc] init];
	
	return sharedContextController;
}

- (void)addContext:(CMContext *)inContext
{
	[contexts addObject:inContext];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"CMContextListUpdated" object:self];
}

- (void)setCurrentContext:(CMContext *)inContext
{
	currentContext = inContext;
	
	if(currentContext == nil)
		[self autoRefreshContext:nil];
	else
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:@"CMContextUpdated" object:self];
		[self updateTimer];
	}
}

- (CMContext *)currentContext
{
	return currentContext;
}

- (NSArray *)contexts
{
	return [NSArray arrayWithArray:contexts];
}

- (bool)forcedContext
{
	return forcedContext;
}

- (void)setForcedContext:(bool)inForce
{
	forcedContext = inForce;
}

/**
 \returns An NSArray of all of the CMContexts at the top level of the hierarchy.
*/
- (NSArray *)topLevelContexts
{
	NSMutableArray * topLevelArray = [[NSMutableArray alloc] init];
	
	for(CMContext * ctx in [self contexts])
		if([ctx parent] == nil)
			[topLevelArray addObject:ctx];
	
	return [NSArray arrayWithArray:topLevelArray];
}

/**
 Iterates through each of the contexts, evaluates its scheme fragment, and sets
 the current context to that with the greatest score.
 
 \todo Eventually, we need to use the score in parent contexts to influence the scores of their children.
 This will have to be optional, because it might be unexpected.
*/
- (void)autoRefreshContext:(NSTimer *)timer
{
	NSLog(@"tick");
	[self updateTimer];
	
	if(forcedContext)
		return;
	
	CMContext * maximumContext = nil;
	float maximumContextValue = 0.0;
	
	for(CMContext * calcContext in contexts)
	{
		float currentContextValue = scm_to_double(scm_c_eval_string([[calcContext schemeFragment] UTF8String]));
		
		if(currentContextValue > maximumContextValue)
		{
			maximumContextValue = currentContextValue;
			maximumContext = calcContext;
		}
	}
	
	currentContext = maximumContext;
	
	if(currentContext == nil)
		currentContext = [contexts lastObject]; // this is where we do the default context dance
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"CMContextUpdated" object:self];
}

@end
