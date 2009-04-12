//
//  CMFrequencyValueTransformer.m
//  Carmen
//
//  Created by Tim Horton on 2008.07.15.
//  Copyright 2008 Tim Horton. All rights reserved.
//

#import "CMFrequencyValueTransformer.h"


@implementation CMFrequencyValueTransformer

+ (Class)transformedValueClass
{
	return [NSNumber class];
}

+ (BOOL)allowsReverseTransformation
{
	return YES;
}

- (id)reverseTransformedValue:(id)item
{
    switch([item intValue])
	{
		case 0:
			return [NSNumber numberWithInt:15];
		case 1:
			return [NSNumber numberWithInt:30];
		case 2:
			return [NSNumber numberWithInt:60];
		case 3:
		default:
			return [NSNumber numberWithInt:0];
	}
}

- (id)transformedValue:(id)item
{
    switch([item intValue])
	{
		case 15:
			return [NSNumber numberWithInt:0];
		case 30:
			return [NSNumber numberWithInt:1];
		case 60:
			return [NSNumber numberWithInt:2];
		case 0:
		default:
			return [NSNumber numberWithInt:3];
	}
}

@end
