//
//  CMTriggerController.m
//  CMTriggerController
//
//  Created by Tim Horton on 2008.04.13.
//  Copyright 2008 Tim Horton. All rights reserved.
//

#import "CMTriggerController.h"

@implementation CMTriggerController

+ (CMTriggerController *)sharedTriggerController
{
	static CMTriggerController * sharedTriggerController;
	
	if (!sharedTriggerController)
		sharedTriggerController = [[CMTriggerController alloc] init];
	
	return sharedTriggerController;
}

- (NSDictionary *)triggerNames
{
	return triggerNames;
}

- (NSDictionary *)schemeNames
{
	return schemeNames;
}

/**
 Loads a trigger plugin bundle.
*/
- (void)loadTriggerPlugin:(NSString *)path
{
	NSBundle * myBundle = [[NSBundle bundleWithPath:path] retain];
	if([[myBundle principalClass] conformsToProtocol:@protocol(CMTrigger)])
	{
		NSLog(@"Loaded Plugin: %@", [[myBundle principalClass] triggerName]);
		[[myBundle principalClass] initializeTrigger];
	}
	else
	{
		NSLog(@"Plugin '%@' is not a trigger.", path);
		return;
	}
	
	[triggerNames setObject:[[myBundle principalClass] triggerName] forKey:[[myBundle principalClass] schemeTriggerName]];
	[schemeNames setObject:[[myBundle principalClass] schemeTriggerName] forKey:[[myBundle principalClass] triggerName]];
	[bundles setObject:myBundle forKey:[[myBundle principalClass] triggerName]];
}

SCM calculate_context(SCM c)
{
	float prob = 1.0;
	int i = 0.0;
	
	for(; i < scm_to_int(scm_length(c)); i++)
		prob *= 1.0 - scm_to_double(scm_list_ref(c, scm_from_int(i)));
	
	prob = 1 - prob;
	
	return scm_from_double(prob);
}

- (void)loadPlugins
{
	[(id)self loadTriggerPlugin:@"/Users/hortont/Code/Carmen/CMLightTrigger/build/Debug/CMLightTrigger.bundle"];
	
	scm_c_define_gsubr("context", 1, 0, 0, calculate_context);
	scm_c_eval_string("(define (rule a b) (* a b))");
}

- (id)init
{
	self = [super init];
	
	if (self != nil)
	{
		scm_init_guile();
		
		triggerNames = [[NSMutableDictionary alloc] init];
		schemeNames = [[NSMutableDictionary alloc] init];
		bundles = [[NSMutableDictionary alloc] init];
		
		[self loadPlugins];
	}
	return self;
}

- (id)bundleForPlugin:(NSString *)name
{
	return [bundles objectForKey:name];
}

@end
