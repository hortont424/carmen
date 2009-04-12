//
//  CMRulesViewController.m
//  Carmen
//
//  Created by Tim Horton on 2008.05.17.
//  Copyright 2008 Tim Horton. All rights reserved.
//

#import "CMRulesViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation CMRulesViewController

- (void)awakeFromNib
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRuleList:) name:@"CMSelectedContextChanged" object:nil];
	[rulesView setTarget:self];
	[rulesView setDoubleAction:@selector(doubleClick:)];
}

- (void)updateRuleList:(NSNotification *)notification
{
	[rulesView reloadData];
	[rulesView setNeedsDisplay:YES];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex
{
	CMRule * representedRule = [[[sourceView itemAtRow:[sourceView selectedRow]] rules] objectAtIndex:rowIndex];
	
	NSString * title;
	
	if([aTableView selectedRow] == rowIndex)
		title = [NSString stringWithFormat:@"<span style='font-size: 14px; font-weight: bold; font-family: Lucida Grande; color: white;'>%@</span><br/><span style='font-size: 12px; font-weight: normal; font-family: Lucida Grande; color: lightgrey;'>%@</span>",[representedRule title],[representedRule description]];
	else
		title = [NSString stringWithFormat:@"<span style='font-size: 14px; font-weight: bold; font-family: Lucida Grande; color: black;'>%@</span><br/><span style='font-size: 12px; font-weight: normal; font-family: Lucida Grande; color: grey;'>%@</span>",[representedRule title],[representedRule description]];
	
	if([[aTableColumn identifier] isEqualToString:@"icon"])
		return [representedRule icon];
	else if([[aTableColumn identifier] isEqualToString:@"title"])
		return [[NSAttributedString alloc] initWithHTML:[title dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
	else if([[aTableColumn identifier] isEqualToString:@"priority"])
		return [NSNumber numberWithInt:(int)([[representedRule priority] doubleValue]*2.0)];
	else
		return nil;
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:anObject forTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex
{
	if(![[aTableColumn identifier] isEqualToString:@"priority"])
		return;
	
	[[[[sourceView itemAtRow:[sourceView selectedRow]] rules] objectAtIndex:rowIndex] setPriority:[NSNumber numberWithDouble:([anObject intValue]/2.0)]];
}

- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [[[sourceView itemAtRow:[sourceView selectedRow]] rules] count];
}

- (void)doubleClick:(id)sender
{
	CMRule * representedRule = [[[sourceView itemAtRow:[sourceView selectedRow]] rules] objectAtIndex:[sender selectedRow]];
	
	NSMutableArray * topLevelObjs = [NSMutableArray array];
    NSDictionary * nameTable = [NSDictionary dictionaryWithObjectsAndKeys:self, NSNibOwner, topLevelObjs, NSNibTopLevelObjects, nil];
	
    if(![[[CMTriggerController sharedTriggerController] bundleForPlugin:[representedRule title]] loadNibFile:@"CMTriggerUI" externalNameTable:nameTable withZone:nil])
    {
        NSLog(@"Warning! Could not load file.\n");
		return;
	}
	
	id sheet, currentRuleUIController;
	
	for(id obj in topLevelObjs)
	{
		if([obj respondsToSelector:@selector(isRuleUIController)])
			currentRuleUIController = obj;

		if([obj respondsToSelector:@selector(frame)])
			sheet = obj;
	}
	
	if(!sheet)
		return;
	
	[currentRuleUIController setDelegate:self];
	
	[currentRuleUIController setRepresentedRule:representedRule];
	
	NSRect rvf = [scrollView frame];
	rvf.size.height = [[scrollView superview] frame].size.height - [sheet bounds].size.height;
	rvf.origin.y = [sheet bounds].size.height;
	[NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(animationDone:) userInfo:[NSValue valueWithRect:rvf] repeats:NO];
	
	NSRect pvf = [propertiesView frame];
	pvf.size.height = [sheet bounds].size.height;
	pvf.origin.y = -pvf.size.height;
	
	[propertiesView setFrame:pvf];
	[sheet setFrame:[propertiesView bounds]];
	
	pvf.origin.y = 0;
	[propertiesView addSubview:sheet positioned:NSWindowAbove relativeTo:nil];
	
	[[propertiesView animator] setFrame:pvf];
}

- (void)updateTrigger
{
	[rulesView setNeedsDisplay:YES];
}

- (void)animationDone:(NSTimer *)timer
{
	[scrollView setFrame:[[timer userInfo] rectValue]];
}

@end
