//
//  CMHighlightedTextViewController.m
//  CMHighlightedTextViewController
//
//  Created by Tim Horton on 2008.05.19.
//  Copyright 2008 Tim Horton. All rights reserved.
//

// The biggest issue right now is making certain things only highlight after parens, so that something like abcordef doesn't trigger the 'or' highlighter
// Might just do a better, quicker job with ... regex ... or something!

#import "CMHighlightedTextViewController.h"

@implementation CMHighlightedTextViewController

#define MATCH_SMALLEST(a,c) for(NSString * word in (a)){ NSRange found = [string rangeOfString:word options:0 range:area]; if(found.location < highlightRange.location) {highlightRange = found; highlightColor = (c);}}

- (void)awakeFromNib
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textStorageDidProcessEditing:) name:NSTextStorageDidProcessEditingNotification object:nil];
	[textView setString:@"(context\n\t(list\n\t\t(rule (ambient-light-range 0.6 1.0) 0.7)\n\t\t(rule (usb-device-connected \"Apple iPhone\") 0.9)\n\t\t(rule (not (usb-device-connected \"Rensselaer Mobile Studio\")) 1.0)\n\t)\n)"];
}

- (void)textStorageDidProcessEditing:(NSNotification *)notification
{
	NSTextStorage * textStorage = [notification object];
	NSString * string = [textStorage string];

	NSRange area = NSMakeRange(0, [string length]);

	[textStorage removeAttribute:NSForegroundColorAttributeName range:area];
	[textStorage addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Monaco" size:12.0] range:area];

	while (area.length)
	{
		NSRange highlightRange = NSMakeRange(NSNotFound, 0);
		NSColor * highlightColor;
		
		MATCH_SMALLEST(([NSArray arrayWithObjects:@"context", @"list", @"rule", nil]), [NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.7 alpha:1.0]);
		MATCH_SMALLEST(([NSArray arrayWithObjects:@"ambient-light-range", @"usb-device-connected", nil]), [NSColor colorWithCalibratedRed:0.0 green:0.5 blue:0.0 alpha:1.0]);
		MATCH_SMALLEST(([NSArray arrayWithObjects:@"not", @"and", @"or", nil]), [NSColor colorWithCalibratedRed:0.0 green:0.5 blue:0.5 alpha:1.0]);
		MATCH_SMALLEST(([NSArray arrayWithObjects:@"(", @")", nil]), [NSColor colorWithCalibratedRed:0.5 green:0.0 blue:0.0 alpha:1.0]);
		
		if (highlightRange.location == NSNotFound)
			break;
		
		[textStorage addAttribute:NSForegroundColorAttributeName value:highlightColor range:highlightRange];
		area.location = NSMaxRange(highlightRange);
		area.length = [string length] - area.location;
	}
}

@end
