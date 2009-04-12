//
//  MyWindowController.m
//
//  Created by Dave Batton, August 2006.
//  http://www.Mere-Mortal-Software.com/
//
//  Copyright 2006 by Dave Batton. Some rights reserved.
//  http://creativecommons.org/licenses/by/2.5/
//
//  The Mailbox and Email classes used in this example are from the Introduction to Cocoa Bindings tutorial by Scott Stevenson. The full tutorial is available at CocoaDevCentral.com:
//  http://www.cocoadevcentral.com/articles/000080.php
//


#import "MyWindowController.h"

@implementation MyWindowController

- (id) init
{
    if (self = [super init]) {

	}
    return self;
}




- (void) dealloc
{
    [super dealloc];
}




- (void)awakeFromNib
{
		// This is required when subclassing NSWindowController.
	[self setWindowFrameAutosaveName:@"MainWindow"];
	
		// This will center the main window if there's no stored position for it.
	if ([[NSUserDefaults standardUserDefaults] stringForKey:@"NSWindow Frame MainWindow"] == nil)
		[[self window] center];

		// Set the splitters' autosave names.
	[sourceSplitView setPositionAutosaveName:@"SourceSplitter"];
	[sourceSplitView setPositionAutosaveName:@"ListSplitter"];

		// Place the source list view in the left panel.
	[sourceView setFrameSize:[sourceViewPlaceholder frame].size];
	[sourceViewPlaceholder addSubview:sourceView];

		// Place the content view in the right panel.
	[contentView setFrameSize:[contentViewPlaceholder frame].size];
	[contentViewPlaceholder addSubview:contentView];
	
	[[self window] setShowsToolbarButton:NO];
	[[[self window] toolbar] setSelectedItemIdentifier:@"Preferences"];
}




- (IBAction)addMailboxAction:(id)sender
{
	[[self window] makeFirstResponder:mailboxesTableView];
}

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar
{
	return [NSArray arrayWithObjects:@"Preferences",@"Contexts",@"Advanced",nil];
}



@end
