#include <libguile.h>
#include <stdio.h>
#include <string.h>

#import <mach/mach.h>
#import <IOKit/IOKitLib.h>
#import <IOKit/IOTypes.h>

#import <IOKit/IOCFPlugIn.h>
#import <IOKit/usb/IOUSBLib.h>
#import <IOKit/usb/USB.h>

SCM ambient_light_range(SCM lower_bound, SCM upper_bound)
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

SCM usb_device(SCM name)
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

SCM calculate_context(SCM c)
{
	float prob = 1.0;
	int i = 0.0;
	
	for(; i < scm_to_int(scm_length(c)); i++)
		prob *= 1.0 - scm_to_double(scm_list_ref(c, scm_from_int(i)));
	
	prob = 1 - prob;
	
	return scm_from_double(prob);
}

void register_procs()
{
	scm_c_define_gsubr("context", 1, 0, 0, calculate_context);
	scm_c_define_gsubr("ambient-light-range", 2, 0, 0, ambient_light_range);
	scm_c_define_gsubr("usb-device", 1, 0, 0, usb_device);
}

static void inner_main(void * closure, int argc, char ** argv)
{
	register_procs();
	scm_c_eval_string("(define (rule a b) (* a b))");
	printf("Probability: %f\n",scm_to_double(scm_c_eval_string("(context (list (rule (ambient-light-range .6 1.0) 0.7) (rule (usb-device \"Microsoft Wireless Optical Mouse® 1.00\") 0.9)))")));
}

int main()
{
	scm_boot_guile(0, 0, inner_main, 0);
	return 0;
}