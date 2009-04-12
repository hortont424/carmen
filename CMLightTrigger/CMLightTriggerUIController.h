#import <Cocoa/Cocoa.h>

@interface CMLightTriggerUIController : NSObject
{
	IBOutlet id window;
    IBOutlet id lowerLimit;
    IBOutlet id upperLimit;
	id representedRule;
	
	NSTimer * timer;
	
	id delegate;
}

@property(assign) id delegate;
@property(assign) id representedRule;

- (IBAction)lowerLimitChanged:(id)sender;
- (IBAction)upperLimitChanged:(id)sender;

- (IBAction)close:(id)sender;

- (BOOL)isRuleUIController; // this is necessary for all rule UI controllers... should find another way to do this...

- (NSString *)schemeFragment;

@end
