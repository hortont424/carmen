# Generated automatically from Makefile.in by configure.
#
# SFSEXP: Small, Fast S-Expression Library version 1.0
# Written by Matthew Sottile (matt@lanl.gov)
# 
# Copyright (2003-2006). The Regents of the University of California. This
# material was produced under U.S. Government contract W-7405-ENG-36 for Los
# Alamos National Laboratory, which is operated by the University of
# California for the U.S. Department of Energy. The U.S. Government has rights
# to use, reproduce, and distribute this software. NEITHER THE GOVERNMENT NOR
# THE UNIVERSITY MAKES ANY WARRANTY, EXPRESS OR IMPLIED, OR ASSUMES ANY
# LIABILITY FOR THE USE OF THIS SOFTWARE. If software is modified to produce
# derivative works, such modified software should be clearly marked, so as not
# to confuse it with the version available from LANL.
# 
# Additionally, this library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation; either version 2.1 of the
# License, or (at your option) any later version.
# 
# This library is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License
# for more details.
# 
# You should have received a copy of the GNU Lesser General Public License
# along with this library; if not, write to the Free Software Foundation,
# Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, U SA
# 
# LA-CC-04-094
# 

include ../makefile.include

LIBPATH=-L../src
INCPATH=-I../src
LIBS=-lsexp
PROFFLAGS=-g

SOURCES=binmode.c sexpvis.c rcfile.c packunpack.c \
	continuations.c callbacks.c simple_interp.c
OBJECTS=$(SOURCES:%.c=%.o)
EXECUTABLES=$(SOURCES:%.c=%)

LINK_FLAGS=$(LIBS)

all: COMPILE_FLAGS=$(OPTFLAGS) $(LIBPATH) $(INCPATH)
all: $(OBJECTS) $(EXECUTABLES)

prof: COMPILE_FLAGS=$(PROFFLAGS) $(LIBPATH) $(INCPATH)
prof: LINK_FLAGS+=-pg
prof: $(OBJECTS) $(EXECUTABLES)

debug: COMPILE_FLAGS=$(DEBUGFLAGS) $(LIBPATH) $(INCPATH)
debug: $(OBJECTS) $(EXECUTABLES)

##

$(EXECUTABLES):
	$(CC) $(COMPILE_FLAGS) $@.o -o $@ $(LINK_FLAGS)

.c.o:
	$(CC) $(COMPILE_FLAGS) $(CFLAGS) -c $<

.c:
	$(CC) $(COMPILE_FLAGS) $(CFLAGS) -c $<

clean:
	rm -f $(OBJECTS) $(EXECUTABLES)
