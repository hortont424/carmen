//
//  DBListSplitView.h
//
//  Created by Dave Batton, August 2006.
//  http://www.Mere-Mortal-Software.com/
//
//  Copyright 2006 by Dave Batton. Some rights reserved.
//  http://creativecommons.org/licenses/by/2.5/
//

#import <Cocoa/Cocoa.h>
#import "KFSplitView.h"

@interface DBListSplitView : KFSplitView
{
	NSImage * bar;
	NSImage * grip;
	id bottomSubview;
}

@end
