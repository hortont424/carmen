//
//  CMStatusMenuItemController.m
//  Carmen
//
//  Created by Tim Horton on 2008.05.04.
//  Copyright 2008 Tim Horton. All rights reserved.
//

#import "CMStatusMenuItemController.h"

#define BOLD_SYSTEM_FONT	[NSDictionary dictionaryWithObjectsAndKeys:[NSFont boldSystemFontOfSize:14.0], NSFontAttributeName, [NSColor blackColor], NSForegroundColorAttributeName, nil]
#define SYSTEM_FONT			[NSDictionary dictionaryWithObjectsAndKeys:[NSFont systemFontOfSize:14.0], NSFontAttributeName, [NSColor blackColor], NSForegroundColorAttributeName, nil]

@interface CMStatusMenuItemController (PRIVATE)
	- (void)appendContext:(CMContext *)context toMenu:(NSMenu *)newMenu;
	- (NSMenu *)createSetContextMenu;
	- (NSMenu *)createStatusMenu;

	- (void)forceContext:(id)sender;
	- (void)showContexts:(id)sender;
	- (void)showPreferences:(id)sender;
	- (void)checkForUpdates:(id)sender;
	- (void)showAboutPanel:(id)sender;

	- (void)updateCurrentContext:(NSNotification *)notification;
	- (void)updateContextList:(NSNotification *)notification;
@end

@implementation CMStatusMenuItemController

+ (CMStatusMenuItemController *)statusMenuItemController
{
	return [[[self alloc] init] autorelease];
}

- (id)init
{
	self = [super init];
	
	if(self != nil)
	{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentContext:) name:@"CMContextUpdated" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateContextList:) name:@"CMContextListUpdated" object:nil];
	}
	
	return self;
}

- (void)awakeFromNib
{
	statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:24.0];
	
	mainMenu = [self createStatusMenu];
	[mainMenu setDelegate:self];
	
	[statusItem setHighlightMode:YES];
	[statusItem setImage:[NSImage imageNamed:@"carmen-statusmenuicon.png"]];
	[statusItem setMenu:mainMenu];
}

#pragma mark Menu Creation

- (void)appendContext:(CMContext *)context toMenu:(NSMenu *)newMenu
{
	NSMenuItem * newMenuItem = [[NSMenuItem alloc] initWithTitle:[context name] action:@selector(forceContext:) keyEquivalent:@""];
	[newMenuItem setRepresentedObject:context];
	[newMenuItem setIndentationLevel:[context depth]];
	
	if(context == [[CMContextController sharedContextController] currentContext] && [[CMContextController sharedContextController] forcedContext])
		[newMenuItem setState:1];
	
	if([context depth] == 0)
		[newMenuItem setAttributedTitle:[[NSAttributedString alloc] initWithString:[newMenuItem title] attributes:BOLD_SYSTEM_FONT]];
	
	[newMenu addItem:newMenuItem];
	
	for(CMContext * ctx in [context children])
		[self appendContext:ctx toMenu:newMenu];
}

- (NSMenu *)createSetContextMenu
{
	NSMenu * newMenu = [[NSMenu alloc] init];
	[newMenu setAutoenablesItems:NO];
	
	NSMenuItem * redetectItem = [[NSMenuItem alloc] initWithTitle:@"" action:@selector(forceContext:) keyEquivalent:@""];
	[redetectItem setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Autodetect" attributes:BOLD_SYSTEM_FONT]];
	
	if(![[CMContextController sharedContextController] forcedContext])
		[redetectItem setState:1];
	
	[newMenu addItem:redetectItem];
	
	[newMenu addItem:[NSMenuItem separatorItem]];
	
	for(CMContext * ctx in [[CMContextController sharedContextController] topLevelContexts])
		[self appendContext:ctx toMenu:newMenu];
	
	[newMenu addItem:[NSMenuItem separatorItem]];

	[newMenu addItemWithTitle:@"New Context..." action:nil keyEquivalent:@""];
	
	return newMenu;
}

- (NSMenu *)createStatusMenu
{
	NSMenu * newMenu = [[NSMenu alloc] init];
	[newMenu setAutoenablesItems:NO];
	
	NSMenuItem * contextHeaderItem = [[NSMenuItem alloc] init];
	[contextHeaderItem setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Current Context" attributes:BOLD_SYSTEM_FONT]];
	[contextHeaderItem setEnabled:NO];
	[newMenu addItem:contextHeaderItem];
	
	currentContextItem = [[NSMenuItem alloc] initWithTitle:@"*" action:nil keyEquivalent:@""];
	//[currentContextItem setImage:[NSImage imageNamed:@"carmen-statusmenuicon.png"]];
	[currentContextItem setEnabled:NO];
	[newMenu addItem:currentContextItem];
	
	[newMenu addItem:[NSMenuItem separatorItem]];
	
	setContextMenuItem = [[NSMenuItem alloc] initWithTitle:@"Set Context" action:nil keyEquivalent:@""];
	[setContextMenuItem setSubmenu:[self createSetContextMenu]];
	[newMenu addItem:setContextMenuItem];
	
	[newMenu addItemWithTitle:@"Contexts..." action:@selector(showContexts:) keyEquivalent:@""];
	
	[newMenu addItem:[NSMenuItem separatorItem]];
	
	[newMenu addItemWithTitle:@"Preferences..." action:@selector(showPreferences:) keyEquivalent:@""];
	[newMenu addItemWithTitle:@"Check for Updates..." action:@selector(checkForUpdates:) keyEquivalent:@""];
	[newMenu addItemWithTitle:@"About..." action:@selector(showAboutPanel:) keyEquivalent:@""];
	
	[newMenu addItem:[NSMenuItem separatorItem]];
	
	NSMenuItem * quitItem = [[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""];
	[quitItem setTarget:NSApp];
	[newMenu addItem:quitItem];
	
	return newMenu;
}

#pragma mark Menu Callbacks

- (void)forceContext:(id)sender
{
	[[CMContextController sharedContextController] setForcedContext:([sender representedObject] != nil)];
	[[CMContextController sharedContextController] setCurrentContext:[sender representedObject]];
}

- (void)showContexts:(id)sender
{
	[mainWindow makeKeyAndOrderFront:sender];
	[[mainWindow delegate] switchToView:@"Contexts"];
	[NSApp activateIgnoringOtherApps:YES];
}

- (void)showPreferences:(id)sender
{
	[mainWindow makeKeyAndOrderFront:sender];
	[[mainWindow delegate] switchToView:@"Preferences"];
	[NSApp activateIgnoringOtherApps:YES];
}

- (void)checkForUpdates:(id)sender
{
	[updater checkForUpdates:sender];
	[NSApp activateIgnoringOtherApps:YES];
}

- (void)showAboutPanel:(id)sender
{
	[NSApp orderFrontStandardAboutPanel:sender];
	[NSApp activateIgnoringOtherApps:YES];
}

#pragma mark Notification Callbacks

- (void)updateCurrentContext:(NSNotification *)notification
{
	[currentContextItem setAttributedTitle:[[NSAttributedString alloc] initWithString:[[[notification object] currentContext] recursiveName] attributes:SYSTEM_FONT]];	
	[self updateContextList:notification];
}

- (void)updateContextList:(NSNotification *)notification
{
	[setContextMenuItem setSubmenu:[self createSetContextMenu]];
}

@end
