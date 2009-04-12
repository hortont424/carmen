#import <Cocoa/Cocoa.h>
#import "Apple80211.h"

@interface ALController : NSObject
{
    IBOutlet id locationTable;
	IBOutlet id spinner;
	IBOutlet id locationName;
	IBOutlet id bigLocation;
	NSMutableDictionary * places;
	NSDictionary * probabilities;
	NSTimer * timer;
}

- (IBAction)addLocation:(id)sender;
- (IBAction)removeLocation:(id)sender;
- (IBAction)updateLocation:(id)sender;

+ (NSString *)MACToString:(const UInt8 *)MAC;
+ (float)partialProbability:(float)c withOptimal:(float)i;
+ (float)locationProbability:(NSDictionary *)testLocation knownLocation:(NSDictionary *)knownLocation;
- (void)scanAirport:(NSMutableDictionary *)dict;
- (NSDictionary *)locateMe:(id)stuff;

@end
