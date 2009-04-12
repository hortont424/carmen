//
//  CarmenController.m
//  Carmen
//
//  Created by Tim Horton on 2008.05.04.
//  Copyright 2008 Tim Horton. All rights reserved.
//

#import "CarmenController.h"
#import "CMContextController.h"
#import "CMRule.h"
#import "CMFrequencyValueTransformer.h"

@implementation CarmenController

/**
 Set up reasonable application-wide defaults.
 Register value transformers.
*/
+ (void)initialize
{
	NSMutableDictionary * appDefaults = [[NSMutableDictionary alloc] init];
	
	[appDefaults setObject:[NSNumber numberWithInt:15] forKey:@"acRefreshFrequency"];		/// Default to 15 second refresh on AC power
	[appDefaults setObject:[NSNumber numberWithInt:30] forKey:@"batteryRefreshFrequency"];	/// Default to 30 second refresh on battery power
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
	
	
	CMFrequencyValueTransformer * frequencyTransformer = [[[CMFrequencyValueTransformer alloc] init] autorelease];
	[NSValueTransformer setValueTransformer:frequencyTransformer forName:@"FrequencyValueTransformer"];
}

- (void)awakeFromNib
{
	[CMTriggerController sharedTriggerController]; // need to load stuff!
	
	[self performSelector:@selector(setInitialContext:) withObject:self afterDelay:0.5];
}

- (void)setInitialContext:(id)stuff
{
	CMContext * rpi = [[CMContext alloc] initWithName:@"RPI"];
	CMContext * cary3 = [[CMContext alloc] initWithName:@"Cary 319"];
	CMContext * barton = [[CMContext alloc] initWithName:@"Barton"];
	CMContext * twentytwoten = [[CMContext alloc] initWithName:@"2210"];
	CMContext * lounge = [[CMContext alloc] initWithName:@"Lounge 1"];
	CMContext * home = [[CMContext alloc] initWithName:@"Home"];
	CMContext * myroom = [[CMContext alloc] initWithName:@"My Room"];
	CMContext * kitchen = [[CMContext alloc] initWithName:@"Kitchen"];
	
	[cary3 setParent:rpi];
	[barton setParent:rpi];
	[twentytwoten setParent:barton];
	[lounge setParent:barton];
	[myroom setParent:home];
	[kitchen setParent:home];
	
	CMRule * lightRule = [[CMRule alloc] init];
	[lightRule setIcon:[NSImage imageNamed:@"picture"]];
	[lightRule setTitle:@"Ambient Light"];
	[lightRule setSchemeFragment:@"(rule (ambient-light-range .3 1.0) .5)"];
	[cary3 addRule:lightRule];
	
	[[CMContextController sharedContextController] addContext:rpi];
	[[CMContextController sharedContextController] addContext:cary3];
	[[CMContextController sharedContextController] addContext:barton];
	[[CMContextController sharedContextController] addContext:twentytwoten];
	[[CMContextController sharedContextController] addContext:home];
	[[CMContextController sharedContextController] addContext:myroom];
	[[CMContextController sharedContextController] addContext:kitchen];
	[[CMContextController sharedContextController] addContext:lounge];
	
	[[CMContextController sharedContextController] setCurrentContext:nil];
}

- (IBAction)updateRefreshRate:(id)sender
{
	[[CMContextController sharedContextController] updateTimer];
}

@end
