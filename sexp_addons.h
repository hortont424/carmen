/*
 *  sexpr_addons.h
 *  Carmen
 *
 *  Created by Tim Horton on 2008.07.13.
 *  Copyright 2008 Tim Horton. All rights reserved.
 *
 */

#ifndef __SEXP_ADDONS_H__
#define __SEXP_ADDONS_H__

#include "sexp.h"

sexp_t * find_sexp_parent (const char *name, sexp_t * start, sexp_t * last);

#endif // __SEXP_ADDONS_H__
