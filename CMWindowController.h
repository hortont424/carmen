//
//  CMWindowController.h
//  Carmen
//
//  Created by Tim Horton on 2008.05.05.
//  Copyright 2008 Tim Horton. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DBSourceView.h"

@interface CMWindowController : NSWindowController
{
	NSToolbar * prefsToolbar;
	NSArray * prefsGroups;
	IBOutlet NSView * generalView, * contextsView, * advancedView;
	NSString *currentPrefsGroup;
	NSView *currentPrefsView;
	
	IBOutlet DBSourceView * sourceView;
	IBOutlet id listSplitter, sourceSplitter;
	IBOutlet id listSplitterPlaceholder, sourceSplitterPlaceholder;
	
	IBOutlet id rulesView;
}

- (void)switchToViewFromToolbar:(NSToolbarItem *)item;
- (void)switchToView:(NSString *)identifier;
- (void)resizeWindowToSize:(NSSize)size withMinSize:(NSSize)minSize limitMaxSize:(BOOL)limitMaxSize;

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)groupId willBeInsertedIntoToolbar:(BOOL)flag;
- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar;
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar;
- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar;

- (float)toolbarHeight;
- (float)titleBarHeight;

@end
