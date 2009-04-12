//
//  CMPropertiesView.m
//  Carmen
//
//  Created by Tim Horton on 2008.07.15.
//  Copyright 2008 Tim Horton. All rights reserved.
//

#import "CMPropertiesView.h"


@implementation CMPropertiesView

- (void)drawRect:(NSRect)rect
{
	[[NSColor colorWithDeviceRed:.86 green:.89 blue:.92 alpha:1.0] setFill];
	NSRectFill(rect);
	
	[[NSColor colorWithDeviceRed:.76 green:.76 blue:.765 alpha:1.0] setFill];
	NSRectFill(NSMakeRect(0,0,rect.size.width,1));
	NSRectFill(NSMakeRect(0,rect.size.height - 1,rect.size.width,1));
}

@end
