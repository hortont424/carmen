//
//  SDUSBTrigger.m
//  SDUSBTrigger
//
//  Created by Tim Horton on 2008.04.13.
//  Copyright 2008 Tim Horton. All rights reserved.
//

#import "SDUSBTrigger.h"

#import <IOKit/IOKitLib.h>
#import <IOKit/IOCFPlugIn.h>
#import <IOKit/usb/IOUSBLib.h>
#import <IOKit/usb/USB.h>

SCM SDUSBTrigger_(SCM name)
{
	io_iterator_t iterator = 0;
	
	CFDictionaryRef matchDict = IOServiceMatching(kIOUSBDeviceClassName);
	IOServiceGetMatchingServices(kIOMasterPortDefault, matchDict, &iterator);

	io_service_t device;
	int cnt = 0;
	
	int found_device = false;

	while(device = IOIteratorNext(iterator))
	{
		io_name_t dev_name;

		if(IORegistryEntryGetName(device, dev_name) == KERN_SUCCESS)
			if(!strncmp(dev_name,scm_to_locale_string(name),strlen(scm_to_locale_string(name))))
				found_device = true;
		
		IOObjectRelease(device);

		++cnt;
	}
	
	IOObjectRelease(iterator);
	
	return scm_from_int(found_device);
}

@implementation SDUSBTrigger

+ (unsigned int)interfaceVersion
{
	return 0;
}

+ (NSString *)triggerName
{
	return @"USB Device";
}

+ (NSString *)schemeTriggerName
{
	return @"usb-device";
}

+ (void)initializeTrigger
{
	scm_c_define_gsubr([[self schemeTriggerName] UTF8String], 1, 0, 0, SDUSBTrigger_);
}

@end
