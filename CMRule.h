//
//  CMRule.h
//  Carmen
//
//  Created by Tim Horton on 2008.05.17.
//  Copyright 2008 Tim Horton. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <libguile.h>
#import "sexp.h"
#import "sexp_addons.h"
#import "CMTriggerController.h"

@interface CMRule : NSObject
{
	NSImage * icon;
	NSString * title;
	NSString * schemeFragment;
}

- (void)setIcon:(NSImage *)newIcon;
- (NSImage *)icon;
- (void)setTitle:(NSString *)newTitle;
- (NSString *)title;
- (void)setPriority:(NSNumber *)newPriority;
- (NSNumber *)priority;
- (void)setSchemeFragment:(NSString *)newSchemeFragment;
- (NSString *)schemeFragment;
- (NSString *)description;

@end
