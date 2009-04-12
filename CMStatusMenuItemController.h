//
//  CMStatusMenuItemController.h
//  Carmen
//
//  Created by Tim Horton on 2008.05.04.
//  Copyright 2008 Tim Horton. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CMContextController.h"
#import "CMWindowController.h"

@interface CMStatusMenuItemController : NSObject
{
	NSStatusItem * statusItem;
	NSMenu * mainMenu;
	
	NSMenuItem * currentContextItem;
	NSMenuItem * setContextMenuItem;
	
	IBOutlet id updater;
	IBOutlet NSWindow * mainWindow;
}

+ (CMStatusMenuItemController *)statusMenuItemController;

- (id)init;
- (void)awakeFromNib;

- (NSMenu *)createStatusMenu;
- (NSMenu *)createSetContextMenu;

- (void)updateCurrentContext:(NSNotification *)notification;
- (void)updateContextList:(NSNotification *)notification;

- (void)appendContext:(CMContext *)context toMenu:(NSMenu *)newMenu;

@end
