//
//  CarmenController.h
//  Carmen
//
//  Created by Tim Horton on 2008.05.04.
//  Copyright 2008 Tim Horton. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CarmenController : NSObject
{

}

- (IBAction)updateRefreshRate:(id)sender; /// \todo This really doesn't belong here, but it seems we can't GET to CMContextController from the NIB

@end
