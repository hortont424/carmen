//
//  CMSourceListController.m
//  Carmen
//
//  Created by Tim Horton on 2008.05.05.
//  Copyright 2008 Tim Horton. All rights reserved.
//

#import "CMSourceListController.h"
#import "CMContextController.h"

@implementation CMSourceListController

- (void)awakeFromNib
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateContextList:) name:@"CMContextUpdated" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateContextList:) name:@"CMContextListUpdated" object:nil];
}

- (void)expandAll
{
	NSArray * contexts = [[CMContextController sharedContextController] topLevelContexts];
	
	for(CMContext * context in contexts)
		[sourceList expandItem:context expandChildren:YES];
}

- (void)updateContextList:(id)sender
{
	[sourceList reloadData];
	[self expandAll];
	[sourceList selectRow:[sourceList rowForItem:[[CMContextController sharedContextController] currentContext]] byExtendingSelection:NO];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"CMSelectedContextChanged" object:self];
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"CMSelectedContextChanged" object:self];
}

-(BOOL)outlineView:(NSOutlineView *)ov isItemExpandable:(id)item
{
	id children = (item ? [item children] : [[CMContextController sharedContextController] topLevelContexts]);

	if ((!children) || ([children count] < 1))
		return NO;

	return YES;
}

-(int)outlineView:(NSOutlineView *)ov numberOfChildrenOfItem:(id)item
{
	id children = (item ? [item children] : [[CMContextController sharedContextController] topLevelContexts]);

	return [children count];
}

-(id)outlineView:(NSOutlineView *)ov child:(NSInteger)childIndex ofItem:(id)item
{
	id children = (item ? [item children] : [[CMContextController sharedContextController] topLevelContexts]);
	
	if ((!children) || ([children count] <= childIndex))
		return nil;
	
	return [children objectAtIndex:childIndex];
}

-(id)outlineView:(NSOutlineView *)ov objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
	if([[tableColumn identifier] isEqualToString:@"icon"])
		return [item name];
	
	return nil;
}


@end
