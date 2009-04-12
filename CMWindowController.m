//
//  CMWindowController.m
//  Carmen
//
//  Created by Tim Horton on 2008.05.05.
//  Copyright 2008 Tim Horton. All rights reserved.
//

#import "CMWindowController.h"

@implementation CMWindowController

- (void)awakeFromNib
{
	prefsGroups = [NSArray arrayWithObjects:
	[NSMutableDictionary dictionaryWithObjectsAndKeys:
		@"Contexts", @"name",
		@"Contexts", @"display_name",
		@"carmen-icon", @"icon",
		[NSNumber numberWithBool:NO], @"resizeable",
		contextsView, @"view", nil],
	[NSMutableDictionary dictionaryWithObjectsAndKeys:
		@"Preferences", @"name",
		@"Preferences", @"display_name",
		@"carmen-icon", @"icon",
		[NSNumber numberWithBool:NO], @"resizeable",
		generalView, @"view", nil],
	[NSMutableDictionary dictionaryWithObjectsAndKeys:
		@"Advanced", @"name",
		@"Advanced", @"display_name",
		@"carmen-icon", @"icon",
		[NSNumber numberWithBool:NO], @"resizeable",
		advancedView, @"view", nil],
	nil];
	
	NSEnumerator *en = [prefsGroups objectEnumerator];
	NSMutableDictionary *group;
	while ((group = [en nextObject]))
	{
		NSView *view = [group valueForKey:@"view"];
		NSSize frameSize = [view frame].size;
		[group setValue:[NSNumber numberWithFloat:frameSize.width] forKey:@"min_width"];
		[group setValue:[NSNumber numberWithFloat:frameSize.height] forKey:@"min_height"];
	}	
	
	prefsToolbar = [[NSToolbar alloc] initWithIdentifier:@"prefsToolbar"];
	[prefsToolbar setDelegate:self];
	[prefsToolbar setAllowsUserCustomization:NO];
	[prefsToolbar setAutosavesConfiguration:NO];
	[prefsToolbar setDisplayMode:NSToolbarDisplayModeIconAndLabel];
	[[self window] setToolbar:prefsToolbar];
	
	currentPrefsGroup = nil;
	[self switchToView:@"Contexts"];
	
	[sourceView setFrame:[sourceSplitterPlaceholder frame]];
	[sourceSplitterPlaceholder addSubview:sourceView];
	
	[rulesView setFrame:[listSplitterPlaceholder frame]];
	[listSplitterPlaceholder addSubview:rulesView];
}

- (NSMutableDictionary *)groupById:(NSString *)groupId
{
	NSEnumerator *en = [prefsGroups objectEnumerator];
	NSMutableDictionary *group;
	
	while ((group = [en nextObject])) {
		if ([[group objectForKey:@"name"] isEqualToString:groupId])
			return group;
	}
	
	return nil;
}

- (void)switchToViewFromToolbar:(NSToolbarItem *)item
{
	[self switchToView:[item itemIdentifier]];
}

- (void)switchToView:(NSString *)groupId
{
	NSDictionary *group = [self groupById:groupId];
	if (!group) {
		NSLog(@"Bad prefs group '%@' to switch to!", groupId);
		return;
	}
	
	if (currentPrefsView == [group objectForKey:@"view"])
		return;
	
	if (currentPrefsGroup) {
		// Store current size
		NSMutableDictionary *oldGroup = [self groupById:currentPrefsGroup];
		NSSize size = [[self window] frame].size;
		size.height -= ([self toolbarHeight] + [self titleBarHeight]);
		[oldGroup setValue:[NSNumber numberWithFloat:size.width] forKey:@"last_width"];
		[oldGroup setValue:[NSNumber numberWithFloat:size.height] forKey:@"last_height"];
	}
	
	currentPrefsView = [group objectForKey:@"view"];
	
	NSSize minSize = NSMakeSize([[group valueForKey:@"min_width"] floatValue],
								[[group valueForKey:@"min_height"] floatValue]);
	NSSize size = minSize;
	if ([group objectForKey:@"last_width"])
		size = NSMakeSize([[group valueForKey:@"last_width"] floatValue],
						  [[group valueForKey:@"last_height"] floatValue]);
	
	BOOL resizeable = [[group valueForKey:@"resizeable"] boolValue];
	[[self window] setShowsResizeIndicator:resizeable];
	
	[[self window] setContentView:[[NSView alloc] init]];
	[self resizeWindowToSize:size withMinSize:minSize limitMaxSize:!resizeable];
	
	if ([prefsToolbar respondsToSelector:@selector(setSelectedItemIdentifier:)])
		[prefsToolbar setSelectedItemIdentifier:groupId];
	[[self window] setContentView:currentPrefsView];
	[self setValue:groupId forKey:@"currentPrefsGroup"];
}

- (float)toolbarHeight
{
	NSRect contentRect;
	
	contentRect = [NSWindow contentRectForFrameRect:[[self window] frame] styleMask:[[self window] styleMask]];
	return (NSHeight(contentRect) - NSHeight([[[self window] contentView] frame]));
}

- (float)titleBarHeight
{
	return [[self window] frame].size.height - [[[self window] contentView] frame].size.height - [self toolbarHeight];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)groupId willBeInsertedIntoToolbar:(BOOL)flag
{
	NSEnumerator *en = [prefsGroups objectEnumerator];
	NSDictionary *group;
	
	while ((group = [en nextObject]))
	{
		if ([[group objectForKey:@"name"] isEqualToString:groupId])
			break;
	}
	if (!group)
	{
		NSLog(@"Oops! toolbar delegate is trying to use '%@' as an ID!", groupId);
		return nil;
	}
	
	NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:groupId];
	[item setLabel:[group objectForKey:@"display_name"]];
	[item setPaletteLabel:[group objectForKey:@"display_name"]];
	[item setImage:[NSImage imageNamed:[group objectForKey:@"icon"]]];
	[item setTarget:self];
	[item setAction:@selector(switchToViewFromToolbar:)];
	
	return item;
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar
{
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:[prefsGroups count]];
	
	NSEnumerator *en = [prefsGroups objectEnumerator];
	NSDictionary *group;
	
	while ((group = [en nextObject]))
		[array addObject:[group objectForKey:@"name"]];
	
	return array;
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{
	return [self toolbarAllowedItemIdentifiers:toolbar];
}

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar
{
	return [self toolbarAllowedItemIdentifiers:toolbar];
}

- (void)resizeWindowToSize:(NSSize)size withMinSize:(NSSize)minSize limitMaxSize:(BOOL)limitMaxSize
{
	NSRect frame;
	float tbHeight, newHeight, newWidth;
	
	tbHeight = [self toolbarHeight];
	
	newWidth = size.width;
	newHeight = size.height;
	
	frame = [NSWindow contentRectForFrameRect:[[self window] frame]
									styleMask:[[self window] styleMask]];
	
	frame.origin.y += frame.size.height;
	frame.origin.y -= newHeight + tbHeight;
	frame.size.width = newWidth;
	frame.size.height = newHeight + tbHeight;
	
	frame = [NSWindow frameRectForContentRect:frame
									styleMask:[[self window] styleMask]];
	
	[[self window] setFrame:frame display:YES animate:YES];
	
	minSize.height += [self titleBarHeight];
	[[self window] setMinSize:minSize];
	
	[[self window] setMaxSize:(limitMaxSize ? minSize : NSMakeSize(FLT_MAX, FLT_MAX))];
}

@end
