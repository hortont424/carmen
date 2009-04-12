//
//  CMStringAdditions.m
//  Carmen
//
//  Created by Tim Horton on 2008.05.04.
//  Copyright 2008 Tim Horton. All rights reserved.
//

#import "CMStringAdditions.h"

@implementation NSString (CMStringAdditions)
/**
 Returns a universally unique identifying NSString. This is used to identify 
 contexts, even across name changes.
*/
+ (NSString *)stringWithNewUUID
{
	return (NSString *)CFUUIDCreateString(nil, CFUUIDCreate(nil));
}

@end
