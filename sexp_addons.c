/*
 *  sexpr_addons.c
 *  Carmen
 *
 *  Created by Tim Horton on 2008.07.13.
 *  Copyright 2008 Tim Horton. All rights reserved.
 *
 */

#include "sexp_addons.h"

sexp_t * find_sexp_parent (const char *name, sexp_t * start, sexp_t * last)
{
	sexp_t *temp;
	
	if (start == NULL)
		return NULL;
	
	if (start->ty == SEXP_LIST)
	{
		temp = find_sexp_parent (name, start->list, start);
		if (temp == NULL)
			return find_sexp_parent (name, start->next, start);
		else
			return temp;
	}
	else
	{
		if (start->val != NULL && strcmp (start->val, name) == 0)
			return last;
		else
			return find_sexp_parent (name, start->next, start);
	}
	
	return NULL;
}
