//
//  CMContext.h
//  Carmen
//
//  Created by Tim Horton on 2008.05.04.
//  Copyright 2008 Tim Horton. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CMRule.h"

@interface CMContext : NSObject
{
	NSString * name;
	CMContext * parent;
	NSString * uuid;
	
	NSMutableArray * children;
	NSMutableArray * rules;
}

- (id)initWithName:(NSString *)newName;

- (void)setName:(NSString *)newName;
- (void)setParent:(CMContext *)newParent;

- (NSString *)name;
- (CMContext *)parent;
- (NSString *)uuid;

- (NSString *)recursiveName;
- (unsigned int)depth;

- (NSMutableArray *)children;
- (void)addChild:(CMContext *)newChild;

- (NSMutableArray *)rules;
- (void)addRule:(CMRule *)newRule;

- (NSString *)schemeFragment;

@end
