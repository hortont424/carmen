//
//  CMContextController.h
//  Carmen
//
//  Created by Tim Horton on 2008.05.04.
//  Copyright 2008 Tim Horton. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CMContext.h"
#import <IOKit/ps/IOPowerSources.h>
#import <IOKit/ps/IOPSKeys.h>

#define POWER_SOURCE_AC			0	///< We're either a desktop, or a charging laptop
#define POWER_SOURCE_BATTERY	1	///< We're on a laptop, on battery power

//! Manages list of contexts, current context, and automatic context refresh.
/**
 Manages the application-wide list of contexts, as well as the current context, and
 keeps the current context up-to date. This is where auto-detection takes place, as well
 as the home of the auto-detect timer.
*/
@interface CMContextController : NSObject
{
	CMContext * currentContext;		///< The currently active context, by autodetection or force.
	NSMutableArray * contexts;		///< An array of all available contexts. While this is a flat array, each context has a parent and children, allowing for heirarchy.
	bool forcedContext;				///< Determines whether or not the current context was forced by the user, or if we're in automatic mode.
	NSTimer * refreshTimer;			///< The timer used to automatically refresh the current context, if not forced.
}

+ (CMContextController *)sharedContextController;

- (void)addContext:(CMContext *)inContext;
- (void)setCurrentContext:(CMContext *)inContext;
- (CMContext *)currentContext;
- (NSArray *)contexts;

- (bool)forcedContext;
- (void)setForcedContext:(bool)inForce;

- (NSArray *)topLevelContexts;

- (void)autoRefreshContext:(NSTimer *)timer;
- (int)determinePowerSource;
- (void)updateTimer;

- (id)init;

@end
