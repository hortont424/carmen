//
//  CMRulesViewController.h
//  Carmen
//
//  Created by Tim Horton on 2008.05.17.
//  Copyright 2008 Tim Horton. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CMContextController.h"

@interface CMRulesViewController : NSObject
{
	IBOutlet NSTableView * rulesView;
	IBOutlet NSOutlineView * sourceView;
	IBOutlet NSScrollView * scrollView;
	
	IBOutlet id propertiesView;
}

- (void)doubleClick:(id)sender;

@end
