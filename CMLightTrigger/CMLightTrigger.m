//
//  CMLightTrigger.m
//  CMLightTrigger
//
//  Created by Tim Horton on 2008.04.13.
//  Copyright 2008 Tim Horton. All rights reserved.
//

#import "CMLightTrigger.h"

SCM CMLightTrigger_(SCM lower_bound, SCM upper_bound)
{
	io_connect_t ioPort;
	int leftLight, rightLight;
	
	io_service_t serviceObject = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("AppleLMUController"));
	
	if (serviceObject)
	{
		IOServiceOpen(serviceObject, mach_task_self(), 0, &ioPort);
		IOObjectRelease(serviceObject);
	}
	
	IOConnectMethodScalarIScalarO(ioPort, 0, 0, 2, &leftLight, &rightLight);
	
	return scm_from_int(((leftLight+rightLight)/4096.0 > scm_to_double(lower_bound)) && 
						((leftLight+rightLight)/4096.0 < scm_to_double(upper_bound)));
}

SCM CMLightTriggerDescription_(SCM lower_bound, SCM upper_bound)
{
	return scm_from_locale_string([[NSString stringWithFormat:@"Brightness between %u%% and %u%%",(int)(scm_to_double(lower_bound)*100.0),(int)(scm_to_double(upper_bound)*100.0),nil] UTF8String]);
}

@implementation CMLightTrigger

+ (unsigned int)interfaceVersion
{
	return 0;
}

+ (NSString *)triggerName
{
	return @"Ambient Light";
}

+ (NSString *)schemeTriggerName
{
	return @"ambient-light-range";
}

+ (void)initializeTrigger
{
	scm_c_define_gsubr([[self schemeTriggerName] UTF8String], 2, 0, 0, CMLightTrigger_);
	scm_c_define_gsubr([[[self schemeTriggerName] stringByAppendingString:@"-description"] UTF8String], 2, 0, 0, CMLightTriggerDescription_);
}

@end
