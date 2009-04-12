//
//  main.m
//  WiFiTest
//
//  Created by Tim Horton on 2008.03.29.
//  Copyright Tim Horton 2008. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Apple80211.h"

static NSString *macToString(const UInt8 *mac)
{
	return [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]];
}

float partialProbability(float c, float i)
{
	return powf(M_E,-(powf(c-i,2)/.03));
}

float locationProbability(NSDictionary * testLocation, NSDictionary * knownLocation)
{
	//NSLog(@"%@\n%@", testLocation, knownLocation);
	
	float totalProbability = 0;
	int count = 0;
	
	for(NSString * key in testLocation)
	{
		if([knownLocation objectForKey:key] == nil)
			continue;
			
		totalProbability += partialProbability([[testLocation objectForKey:key] floatValue], [[knownLocation objectForKey:key] floatValue]);
		count++;
	}
	
	return totalProbability/count;
}

void scanAirport(NSMutableDictionary * dict)
{
	if(!WirelessIsAvailable())
	{
		NSLog(@"Airport is not available.");
		return;
	}
	
	WirelessContextPtr wctxt;
	NSArray * list;
	
	WirelessAttach(&wctxt, 0);
	
	WirelessScan(wctxt, (CFArrayRef *) &list, 0);
	
	NSEnumerator * en = [list objectEnumerator];
	const WirelessNetworkInfo * ap;
	while (ap = (const WirelessNetworkInfo *)[[en nextObject] bytes])
	{
		NSString * mac = macToString(ap->macAddress);
		
		NSMutableArray * strengthList = [dict objectForKey:mac];
		NSNumber * newStrength = [NSNumber numberWithFloat:((float)ap->signal-ap->noise)];
		
		if(strengthList == nil)
		{
			strengthList = [NSMutableArray arrayWithObject:newStrength];
			[dict setObject:strengthList forKey:mac];
		}
		else
		{
			[strengthList addObject:newStrength];
		}
	}

	WirelessDetach(wctxt);
}

int main(int argc, char *argv[])
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSMutableDictionary * outData = [[NSMutableDictionary alloc] init];
	
	NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
			
	printf("Scanning");
	for(int i = 0; i < 20; i++)
	{
		scanAirport(dict);
		printf(".");
	}
	
	printf("\n");
	
	for(NSString * key in dict)
	{
		NSEnumerator *sumenum = [[dict objectForKey:key] objectEnumerator];
		id sumobj;
		float sum = 0;
		int count = 0;
		
		while(sumobj = [sumenum nextObject])
		{
			sum += [sumobj floatValue];
			count++;
		}
		
		[outData setObject:[NSNumber numberWithFloat:((float)sum/count)/100.0] forKey:key];
	}
	
	NSLog(@"%@", outData);
	
	NSDictionary * caryDict = [[NSDictionary alloc] initWithObjectsAndKeys:
																		   [NSNumber numberWithFloat:.34799999],@"00:0d:3a:29:09:2b",
																		   [NSNumber numberWithFloat:.18000000],@"00:11:92:5a:d8:70",
																		   [NSNumber numberWithFloat:.71800003],@"00:1b:63:2b:20:4a",
																		   [NSNumber numberWithFloat:.17000000],@"00:11:92:5a:cd:e0",
																		   [NSNumber numberWithFloat:.18000000],@"00:1b:63:2c:09:41",
																		   nil];
	NSDictionary * places = [[NSDictionary alloc] initWithObjectsAndKeys:caryDict,@"Cary 319",nil];
	
	for(NSString * key in places)
	printf("%s Probability: %f\n", [key UTF8String], locationProbability([NSDictionary dictionaryWithDictionary:outData],[places objectForKey:key]));
	
	[NSKeyedArchiver archiveRootObject:places toFile:@"/Users/hortont/Desktop/places.plist"];
	
	[pool release];
	
	return 0;
}
