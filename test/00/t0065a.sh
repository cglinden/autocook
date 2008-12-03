#!/bin/sh
#
#       cook - file construction tool
#       Copyright (C) 1994, 1997, 1998, 2007 Peter Miller
#
#       This program is free software; you can redistribute it and/or modify
#       it under the terms of the GNU General Public License as published by
#       the Free Software Foundation; either version 2 of the License, or
#       (at your option) any later version.
#
#       This program is distributed in the hope that it will be useful,
#       but WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#       GNU General Public License for more details.
#
#       You should have received a copy of the GNU General Public License
#       along with this program; if not, write to the Free Software
#       Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111, USA.
#
# MANIFEST: Test the make2cook functionality
#
work=${COOK_TMP:-/tmp}/$$
PAGER=cat
export PAGER
umask 022
unset COOK
here=`pwd`
if test $? -ne 0 ; then exit 1; fi

bin="$here/${1-.}/bin"

fail()
{
        set +x
        echo 'FAILED test of the make2cook functionality' 1>&2
        cd $here
        rm -rf $work
        exit 1
}
pass()
{
        set +x
        cd $here
        rm -rf $work
        exit 0
}
trap \"fail\" 1 2 3 15

mkdir $work $work/lib
if test $? -ne 0 ; then exit 1; fi
cd $work
if test $? -ne 0 ; then fail; fi

#
# Use the default error messages.  There is no other way to get
# predictable test behaviour on the unknown systems we will be tested on.
#
COOK_MESSAGE_LIBRARY=$work/no-such-dir
export COOK_MESSAGE_LIBRARY
unset LANG

TAB=`awk 'BEGIN{printf("\11")}' /dev/null`
test $? -eq 0 || fail

#
# make2cook
#
sed "s|<TAB>|$TAB|g" > test.in << 'fubar'
#
# zap the suffixes
#
.SUFFIXES:
.SUFFIXES: .c .o
.PHONY: test

#
# define some variables
#
a = b
c := d e
c += f

#
# this is a test
#
test:
<TAB>-@echo Hello, World

.c.o:; $(CC) $(CFLAGS) -c $*.c
fubar
if test $? -ne 0 ; then fail; fi

sed "s|<TAB>|$TAB|g" > test.ok << 'fubar'
if [not [defined CPPFLAGS]] then
<TAB>CPPFLAGS = [getenv CPPFLAGS];
if [not [defined TARGET_ARCH]] then
<TAB>TARGET_ARCH = [getenv TARGET_ARCH];
if [not [defined LDFLAGS]] then
<TAB>LDFLAGS = [getenv LDFLAGS];
if [not [defined CFLAGS]] then
<TAB>CFLAGS = [getenv CFLAGS];
if [not [defined CC]] then
{
<TAB>CC = [getenv CC];
<TAB>if [not [CC]] then
<TAB><TAB>CC = cc;
}
if [not [defined LINK.c]] then
{
<TAB>LINK.c = [getenv LINK.c];
<TAB>if [not [LINK.c]] then
<TAB><TAB>LINK.c = [CC] [CFLAGS] [CPPFLAGS] [LDFLAGS] [TARGET_ARCH];
}
if [not [defined LDLIBS]] then
<TAB>LDLIBS = [getenv LDLIBS];
if [not [defined LOADLIBES]] then
<TAB>LOADLIBES = [getenv LOADLIBES];
if [not [defined LINK.o]] then
{
<TAB>LINK.o = [getenv LINK.o];
<TAB>if [not [LINK.o]] then
<TAB><TAB>LINK.o = [CC] [LDFLAGS] [TARGET_ARCH];
}

/*
 * zap the suffixes
 */




/*
 * define some variables
 */
if [not [defined a]] then
<TAB>a = b;
if [not [defined c]] then
<TAB>c = d e;
c = [c] f;

/*
 * this is a test
 */
test:
<TAB>set force
{
<TAB>echo Hello, World
<TAB><TAB>set errok silent;
}
%0%.o: %0%.c
{
<TAB>[CC] [CFLAGS] -c %0%.c;
}

%0%: %0%.o
{
<TAB>[LINK.o] [resolve [need]] [LOADLIBES] [LDLIBS] -o [target];
}
%0%: %0%.c
{
<TAB>[LINK.c] [resolve [need]] [LOADLIBES] [LDLIBS] -o [target];
}
fubar
if test $? -ne 0 ; then fail; fi

$bin/make2cook -e test.in test.out
if test $? -ne 0 ; then fail; fi

diff test.ok test.out
if test $? -ne 0 ; then fail; fi

#
# Only definite negatives are possible.
# The functionality exercised by this test appears to work,
# no other guarantees are made.
#
pass
