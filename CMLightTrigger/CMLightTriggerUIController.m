#import "CMLightTrigger.h"
#import "CMLightTriggerUIController.h"
#import "sexp.h"

@implementation CMLightTriggerUIController

@synthesize delegate;

- (void)awakeFromNib
{
	timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateLightMeter:) userInfo:nil repeats:YES];
}

- (void)updateLightMeter:(NSTimer *)sender
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
	
	NSLog(@"%f", (leftLight+rightLight)/4096.0);
}

- (IBAction)lowerLimitChanged:(id)sender
{
	[delegate updateTrigger];
	[representedRule setSchemeFragment:[self schemeFragment]];
}

- (IBAction)upperLimitChanged:(id)sender
{
	[delegate updateTrigger];
	[representedRule setSchemeFragment:[self schemeFragment]];
}

- (IBAction)close:(id)sender
{
	NSLog(@"clear");
	[timer invalidate];
	timer = nil;
}

- (BOOL)isRuleUIController
{
	return YES;
}

- (id)representedRule
{
	return representedRule;
}

- (void)setRepresentedRule:(id)newRepresentedRule
{
	representedRule = newRepresentedRule;
	
	sexp_t * e = parse_sexp((char *)[[representedRule schemeFragment] UTF8String], [[representedRule schemeFragment] length]);
	sexp_t * r = find_sexp("ambient-light-range", e);
	
	[lowerLimit setIntValue:(atof(r->next->val) * 100.0)];
	[upperLimit setIntValue:(atof(r->next->next->val) * 100.0)];
}

- (NSString *)schemeFragment
{
	/// \todo need a better way to figure out what our scheme name is ... can't hard code that.
	
	sexp_t * e = parse_sexp((char *)[[representedRule schemeFragment] UTF8String], [[representedRule schemeFragment] length]);
	sexp_t * r = find_sexp("ambient-light-range", e);
	
	r->next->val = (char *)[[NSString stringWithFormat:@"%0.2f",((float)[lowerLimit intValue])/100.0] UTF8String];
	r->next->next->val = (char *)[[NSString stringWithFormat:@"%0.2f",((float)[upperLimit intValue])/100.0] UTF8String];
	
	char totalExp[1024];
	print_sexp(totalExp, 1024, e);
	
	return [NSString stringWithUTF8String:totalExp];
}

@end
