//
//  CMContext.m
//  Carmen
//
//  Created by Tim Horton on 2008.05.04.
//  Copyright 2008 Tim Horton. All rights reserved.
//

#import "CMContext.h"
#import "CMStringAdditions.h"

@implementation CMContext

- (id)initWithName:(NSString *)newName
{
	self = [super init];
	
	if (self != nil)
	{
		name = newName;
		uuid = [NSString stringWithNewUUID];
		children = [[NSMutableArray alloc] init];
		rules = [[NSMutableArray alloc] init];
		parent = nil;
	}
	
	return self;
}

- (void)setName:(NSString *)newName
{
	name = newName;
}

- (void)setParent:(CMContext *)newParent
{
	parent = newParent;	
	[parent addChild:self];
}

- (NSString *)name
{
	return name;
}

- (CMContext *)parent
{
	return parent;
}

- (NSString *)uuid
{
	return uuid;
}

- (NSString *)recursiveName
{
	CMContext * parentIterator = [self parent];
	NSString * recursiveName = [[NSString alloc] initWithString:name];
	
	while(parentIterator != nil)
	{
		recursiveName = [NSString stringWithFormat:@"%@ %C %@",[parentIterator name],(unichar) 0x2192,recursiveName,nil];
		parentIterator = [parentIterator parent];
	}
	
	return recursiveName;
}

- (unsigned int)depth
{
	CMContext * parentIterator = [self parent];
	int depth = 0;
	
	while(parentIterator != nil)
	{
		depth++;
		parentIterator = [parentIterator parent];
	}
	
	return depth;
}

- (NSMutableArray *)children
{
	return children;
}

- (void)addChild:(CMContext *)newChild
{
	[children addObject:newChild];
}

- (NSMutableArray *)rules
{
	return rules;
}

- (void)addRule:(CMRule *)newRule
{
	[rules addObject:newRule];
}

- (NSString *)schemeFragment
{
	NSMutableString * fragments = [[NSMutableString alloc] init];
	
	for(CMRule * currentContext in rules)
	{
		[fragments appendString:[currentContext schemeFragment]];
	}
	
	if([fragments isEqualToString:@""])
		return @"(+ 0 0)"; // how do we just return 0??
	else
		return [NSString stringWithFormat:@"(context (list %@))", fragments, nil];
}

@end
