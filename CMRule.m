//
//  CMRule.m
//  Carmen
//
//  Created by Tim Horton on 2008.05.17.
//  Copyright 2008 Tim Horton. All rights reserved.
//

#import "CMRule.h"

@implementation CMRule

- (void)setIcon:(NSImage *)newIcon
{
	icon = newIcon;
}

- (NSImage *)icon
{
	return icon;
}

- (void)setTitle:(NSString *)newTitle
{
	title = newTitle;
}

- (NSString *)title
{
	return title;
}

/**
 \param newPriority an NSNumber representing the priority to be set
 
 Parses the current schemeFragment, finds the (rule a p) call, replaces p
 with the new priority, then generates a new scheme fragment.
*/
- (void)setPriority:(NSNumber *)newPriority
{
	sexp_t * e = parse_sexp((char *)[[self schemeFragment] UTF8String], [[self schemeFragment] length]);
	sexp_t * r = find_sexp("rule", e);
	
	r->next->next->val = (char *)[[newPriority stringValue] UTF8String];
	
	char totalExp[1024];
	print_sexp(totalExp, 1024, e);
	
	[self setSchemeFragment:[NSString stringWithUTF8String:totalExp]];
}

- (NSNumber *)priority
{
	sexp_t * e = parse_sexp((char *)[[self schemeFragment] UTF8String], [[self schemeFragment] length]);
	sexp_t * r = find_sexp("rule", e);
	
	return [NSNumber numberWithFloat:atof(r->next->next->val)];
}

- (void)setSchemeFragment:(NSString *)newSchemeFragment
{
	schemeFragment = newSchemeFragment;
}

- (NSString *)schemeFragment
{
	return schemeFragment;
}

- (NSString *)description
{
	NSString * schemeName = [[[CMTriggerController sharedTriggerController] schemeNames] objectForKey:[self title]];

	/// \todo really this needs to be more smart.... to understand negation and stuff...
	
	/**	\todo maybe go through and replace every function call with *-description, and create alternate versions of
		every builtin (and default *-descriptions for user created functions that don't do anything...)
		which modify the text intelligently to what they do... */
	
	sexp_t * e = parse_sexp((char *)[[self schemeFragment] UTF8String], [[self schemeFragment] length]);
	sexp_t * r = find_sexp_parent([schemeName UTF8String], e, NULL);
	
	char totalExp[1024];
	print_sexp(totalExp, 1024, r);
	
	NSString * schemeDescriptionFragment = [[NSString stringWithUTF8String:totalExp] stringByReplacingOccurrencesOfString:schemeName withString:[schemeName stringByAppendingString:@"-description"]];
	return [NSString stringWithUTF8String:scm_to_locale_string(scm_c_eval_string([schemeDescriptionFragment UTF8String]))];
}

@end
