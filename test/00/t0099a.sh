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
# MANIFEST: Test the make2cook define functionality
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
        echo 'FAILED test of the make2cook define functionality' 1>&2
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
# test the make2cook define functionality
#
sed "s|<TAB>|$TAB|g" > test.in << 'fubar'
.SUFFIXES:
define \n


endef
sysdep-subdirs := $(subst $(\n), ,$(sysdep-subdirs))

# These are the subdirectories containing the library source.
+ansi_dirs<TAB>:= assert ctype locale math setjmp \
<TAB><TAB>signal stdio stdlib malloc string time
fubar
if test $? -ne 0 ; then fail; fi

sed "s|<TAB>|$TAB|g" > test.ok << 'fubar'
if [not [defined \\n]] then
#line 2 "test.in"
<TAB>\\n =
<TAB>\n;
if [not [defined sysdep-subdirs]] then

<TAB>sysdep-subdirs = [subst [\\n] " " [sysdep-subdirs]];
/*
 * These are the subdirectories containing the library source.
 */
if [not [defined +ansi_dirs]] then
#line 9 "test.in"
<TAB>+ansi_dirs = assert ctype locale math setjmp
<TAB>signal stdio stdlib malloc string time;
fubar
if test $? -ne 0 ; then fail; fi

$bin/make2cook -ln test.in test.out
if test $? -ne 0 ; then fail; fi

diff test.ok test.out
if test $? -ne 0 ; then fail; fi

#
# Only definite negatives are possible.
# The functionality exercised by this test appears to work,
# no other guarantees are made.
#
pass
