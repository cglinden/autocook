#!/bin/sh
#
#       cook - file construction tool
#       Copyright (C) 1997, 1998, 2007 Peter Miller
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
if test $? -ne 0 ; then exit 2; fi

bin="$here/${1-.}/bin"

pass()
{
        set +x
        cd $here
        rm -rf $work
        exit 0
}
fail()
{
        set +x
        echo 'FAILED test of the make2cook functionality' 1>&2
        cd $here
        rm -rf $work
        exit 1
}
no_result()
{
        set +x
        echo 'NO RESULT for test of the make2cook functionality' 1>&2
        cd $here
        rm -rf $work
        exit 2
}
trap \"no_result\" 1 2 3 15

mkdir $work $work/lib
if test $? -ne 0 ; then no_result; fi
cd $work
if test $? -ne 0 ; then no_result; fi

#
# Use the default error messages.  There is no other way to get
# predictable test behaviour on the unknown systems we will be tested on.
#
COOK_MESSAGE_LIBRARY=$work/no-such-dir
export COOK_MESSAGE_LIBRARY
unset LANG

TAB=`awk 'BEGIN{printf("\11")}' /dev/null`
test $? -eq 0 || no_result

#
# test the make2cook functionality
#
sed "s|<TAB>|$TAB|g" > test.in << 'fubar'
.SUFFIXES:
a: b
<TAB>$$ a(b,c)
fubar
if test $? -ne 0 ; then no_result; fi

sed "s|<TAB>|$TAB|g" > test.ok << 'fubar'
a: b
{
<TAB>$ a(b,c);
}
fubar
if test $? -ne 0 ; then no_result; fi

$bin/make2cook -e test.in test.out
if test $? -ne 0 ; then fail; fi

diff test.ok test.out
if test $? -ne 0 ; then fail; fi

#
# test the make2cook functionality
# comments within rule bodies
#
sed "s|<TAB>|$TAB|g" > test.in << 'fubar'
.SUFFIXES:
a: b
# this is a comment
<TAB>cat $^ > $@
fubar
if test $? -ne 0 ; then no_result; fi

sed "s|<TAB>|$TAB|g" > test.ok << 'fubar'
a: b
{
<TAB>/*
<TAB> * this is a comment
<TAB> */
<TAB>cat [resolve [need]] > [target];
}
fubar
if test $? -ne 0 ; then no_result; fi

$bin/make2cook -e test.in test.out
if test $? -ne 0 ; then fail; fi

diff test.ok test.out
if test $? -ne 0 ; then fail; fi

#
# test the make2cook functionality
# default rules with spaces
#
sed "s|<TAB>|$TAB|g" > test.in << 'fubar'
.SUFFIXES:
.SUFFIXES: .tex .w .ch
all: all.tex
fubar
if test $? -ne 0 ; then no_result; fi

sed "s|<TAB>|$TAB|g" > test.ok << 'fubar'
if [not [defined CWEAVE]] then
{
<TAB>CWEAVE = [getenv CWEAVE];
<TAB>if [not [CWEAVE]] then
<TAB><TAB>CWEAVE = cweave;
}

all: all.tex;

%0%.tex: %0%.w
{
<TAB>[CWEAVE] [resolve [head [need]]] - [target];
}
%0%.tex: %0%.w %0%.ch
{
<TAB>[CWEAVE] [resolve [need]] [target];
}
fubar
if test $? -ne 0 ; then no_result; fi

$bin/make2cook -e test.in test.out
if test $? -ne 0 ; then fail; fi

diff test.ok test.out
if test $? -ne 0 ; then fail; fi

#
# test the make2cook functionality
#
# This test exersizes a particularly obnoxious assignment, which was
# causing an infinite loop.
#
sed "s|<TAB>|$TAB|g" > test.in << 'fubar'
.SUFFIXES:
barf = $($(foo)bar)
fubar
if test $? -ne 0 ; then no_result; fi

sed "s|<TAB>|$TAB|g" > test.ok << 'fubar'
if [not [defined [foo]bar]] then
<TAB>[foo]bar = [getenv [foo]bar];
if [not [defined foo]] then
<TAB>foo = [getenv foo];

if [not [defined barf]] then
#line 2 "test.in"
<TAB>barf = [[foo]bar];
fubar
if test $? -ne 0 ; then no_result; fi

$bin/make2cook -e -ln test.in test.out
if test $? -ne 0 ; then fail; fi

diff test.ok test.out
if test $? -ne 0 ; then fail; fi

#
# Only definite negatives are possible.
# The functionality exercised by this test appears to work,
# no other guarantees are made.
#
pass
