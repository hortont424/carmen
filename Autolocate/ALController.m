#import "ALController.h"

@implementation ALController

- (IBAction)updateLocation:(id)sender
{
	if(timer)
	{
		[timer invalidate];
		timer = nil;
	}
	else
	{
		timer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(locateMe:) userInfo:nil repeats:YES];
		[timer performSelector:@selector(fire) withObject:self afterDelay:0.2];
	}
}

- (int)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [probabilities count];
}

NSInteger keySortByProbability(id a, id b, void *context)
{
	return [[context objectForKey:b] compare:[context objectForKey:a]];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row
{
	NSArray * keys = [[probabilities keysSortedByValueUsingSelector:@selector(compare:)] sortedArrayUsingFunction:&keySortByProbability context:probabilities];
	
	if(tableColumn == [tableView tableColumnWithIdentifier:@"Location"])
		return [keys objectAtIndex:row];
	else
		return [NSNumber numberWithFloat:100.0*[[probabilities objectForKey:[keys objectAtIndex:row]] floatValue]];
}

- (IBAction)addLocation:(id)sender
{
	[timer invalidate]; timer = nil;
	[places setObject:[self locateMe:nil] forKey:[locationName stringValue]];
	timer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(locateMe:) userInfo:nil repeats:YES];
	[timer performSelector:@selector(fire) withObject:self afterDelay:0.2];
}

- (IBAction)removeLocation:(id)sender
{
	
}

+ (NSString *)MACToString:(const UInt8 *)MAC
{
	return [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", MAC[0], MAC[1], MAC[2], MAC[3], MAC[4], MAC[5]];
}

+ (float)partialProbability:(float)c withOptimal:(float)i
{
	return powf(M_E,-(powf(c-i,2)/.03));
}

+ (float)locationProbability:(NSDictionary *)testLocation knownLocation:(NSDictionary *)knownLocation
{
	float totalProbability = 0;
	float count = 0;
	
	for(NSString * key in testLocation)
	{
		if([knownLocation objectForKey:key] == nil)
			continue;
			
		totalProbability += [ALController partialProbability:[[testLocation objectForKey:key] floatValue]
												 withOptimal:[[knownLocation objectForKey:key] floatValue]] * [[knownLocation objectForKey:key] floatValue];
		count += [[knownLocation objectForKey:key] floatValue];
	}
	
	if(count == 0)
		return 0;
	else
		return totalProbability/count;
}

- (void)scanAirport:(NSMutableDictionary *)dict
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
		NSString * mac = [ALController MACToString:ap->macAddress];
		
		NSMutableArray * strengthList = [dict objectForKey:mac];
		NSNumber * newStrength = [NSNumber numberWithFloat:((float)ap->signal-ap->noise)];
		
		NSLog(@"%@", newStrength);
		
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

// some sort of running average of the last, say 10, would allow us to run more continually, update faster, etc...
// that way we'd know when we stopped moving...
- (NSDictionary *)locateMe:(id)stuff
{
	[spinner startAnimation:self];
	NSMutableDictionary * outData = [[NSMutableDictionary alloc] init];
	NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];

	for(int i = 0; i < 10; i++)
		[self scanAirport:dict];
	
	for(NSString * key in dict)
	{
		NSEnumerator * sumenum = [[dict objectForKey:key] objectEnumerator];
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
	
	NSMutableDictionary * outputProb = [[NSMutableDictionary alloc] init];
	
	for(NSString * key in places)
	{
		[outputProb setObject:[NSNumber numberWithFloat:[ALController locationProbability:[NSDictionary dictionaryWithDictionary:outData] knownLocation:[places objectForKey:key]]] forKey:key];
	}
	
	probabilities = [[NSDictionary dictionaryWithDictionary:outputProb] retain];
	[locationTable reloadData];
	
	[bigLocation setStringValue:[[[probabilities keysSortedByValueUsingSelector:@selector(compare:)] sortedArrayUsingFunction:&keySortByProbability context:probabilities] objectAtIndex:0]];
	
	[spinner stopAnimation:self];
	
	NSDictionary * output = [NSDictionary dictionaryWithDictionary:outData];
	[outData release];
	[dict release];
	[outputProb release];
	
	return output;
}

- (void)awakeFromNib
{
	places = [[[NSUserDefaults standardUserDefaults] objectForKey:@"places"] mutableCopy];
	
	[bigLocation setStringValue:@""];
	
	if(!places)
		places = [[NSMutableDictionary alloc] init];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
	[[NSUserDefaults standardUserDefaults] setObject:places forKey:@"places"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end
