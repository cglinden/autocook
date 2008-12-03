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
# test the make2cook functionality
#
sed "s|<TAB>|$TAB|g" > test.in << 'fubar'
.SUFFIXES:

libs_for_gcc = -lgnu
normal_libs =

ifeq ($(CC),gcc)
foo: $(objects)
<TAB>$(CC) -o foo $(objects) $(libs_for_gcc)
else
foo: $(objects)
<TAB>$(CC) -o foo $(objects) $(normals_libs)
endif
fubar
if test $? -ne 0 ; then fail; fi

sed "s|<TAB>|$TAB|g" > test.ok << 'fubar'
if [not [defined normals_libs]] then
<TAB>normals_libs = [getenv normals_libs];
if [not [defined objects]] then
<TAB>objects = [getenv objects];
if [not [defined CC]] then
{
<TAB>CC = [getenv CC];
<TAB>if [not [CC]] then
<TAB><TAB>CC = cc;
}

if [not [defined libs_for_gcc]] then
#line 3 "test.in"
<TAB>libs_for_gcc = -lgnu;
if [not [defined normal_libs]] then
#line 4 "test.in"
<TAB>normal_libs = ;

#if [in [CC] gcc ]
foo: [objects]
{
#line 8 "test.in"
<TAB>[CC] -o foo [objects] [libs_for_gcc];
}
#else
#line 10 "test.in"
foo: [objects]
{
#line 11 "test.in"
<TAB>[CC] -o foo [objects] [normals_libs];
}
#endif
fubar
if test $? -ne 0 ; then fail; fi

$bin/make2cook -e -ln test.in test.out
if test $? -ne 0 ; then fail; fi

diff test.ok test.out
if test $? -ne 0 ; then fail; fi

#
# test the make2cook functionality
#
sed "s|<TAB>|$TAB|g" > test.in << 'fubar'
.SUFFIXES:

libs_for_gcc = -lgnu
normal_libs =

ifneq "$(CC)" "gcc"
libs = $(normal_libs)
else
libs = $(libs_for_gcc)
endif

foo: $(objects)
<TAB>$(CC) -o foo $(objects) $(libs)
fubar
if test $? -ne 0 ; then fail; fi

sed "s|<TAB>|$TAB|g" > test.ok << 'fubar'
if [not [defined objects]] then
<TAB>objects = [getenv objects];
if [not [defined CC]] then
{
<TAB>CC = [getenv CC];
<TAB>if [not [CC]] then
<TAB><TAB>CC = cc;
}

if [not [defined libs_for_gcc]] then
#line 3 "test.in"
<TAB>libs_for_gcc = -lgnu;
if [not [defined normal_libs]] then
#line 4 "test.in"
<TAB>normal_libs = ;

#if [not [in [CC] gcc ] ]
if [not [defined libs]] then
#line 7 "test.in"
<TAB>libs = [normal_libs];
#else
if [not [defined libs]] then
#line 9 "test.in"
<TAB>libs = [libs_for_gcc];
#endif

foo: [objects]
{
#line 13 "test.in"
<TAB>[CC] -o foo [objects] [libs];
}
fubar
if test $? -ne 0 ; then fail; fi

$bin/make2cook -e -ln test.in test.out
if test $? -ne 0 ; then fail; fi

diff test.ok test.out
if test $? -ne 0 ; then fail; fi

#
# test the make2cook functionality
#
sed "s|<TAB>|$TAB|g" > test.in << 'fubar'
.SUFFIXES:

ifndef slartibartfast

ifneq "$(CC)" "gcc"
libs = $(normal_libs)
else
libs = $(libs_for_gcc)
endif

foo: $(objects)
<TAB>$(CC) -o foo $(objects) $(libs)
endif
fubar
if test $? -ne 0 ; then fail; fi

sed "s|<TAB>|$TAB|g" > test.ok << 'fubar'
if [not [defined objects]] then
<TAB>objects = [getenv objects];
if [not [defined libs_for_gcc]] then
<TAB>libs_for_gcc = [getenv libs_for_gcc];
if [not [defined normal_libs]] then
<TAB>normal_libs = [getenv normal_libs];
if [not [defined CC]] then
{
<TAB>CC = [getenv CC];
<TAB>if [not [CC]] then
<TAB><TAB>CC = cc;
}
#line 3 "test.in"
#if [not [defined slartibartfast ] ]

#if [not [in [CC] gcc ] ]
if [not [defined libs]] then
#line 6 "test.in"
<TAB>libs = [normal_libs];
#else
if [not [defined libs]] then
#line 8 "test.in"
<TAB>libs = [libs_for_gcc];
#endif

foo: [objects]
{
#line 12 "test.in"
<TAB>[CC] -o foo [objects] [libs];
}
#endif
fubar
if test $? -ne 0 ; then fail; fi

$bin/make2cook -e -ln test.in test.out
if test $? -ne 0 ; then fail; fi

diff test.ok test.out
if test $? -ne 0 ; then fail; fi

#
# test the make2cook functionality
#
sed "s|<TAB>|$TAB|g" > test.in << 'fubar'
.SUFFIXES:

libs_for_gcc = -lgnu
normal_libs =

foo: $(objects)
ifeq ($(CC),gcc)
<TAB>$(CC) -o foo $(objects) $(libs_for_gcc)
else
<TAB>$(CC) -o foo $(objects) $(normals_libs)
endif
fubar
if test $? -ne 0 ; then fail; fi

sed "s|<TAB>|$TAB|g" > test.ok << 'fubar'
if [not [defined normals_libs]] then
<TAB>normals_libs = [getenv normals_libs];
if [not [defined CC]] then
{
<TAB>CC = [getenv CC];
<TAB>if [not [CC]] then
<TAB><TAB>CC = cc;
}
if [not [defined objects]] then
<TAB>objects = [getenv objects];

if [not [defined libs_for_gcc]] then
#line 3 "test.in"
<TAB>libs_for_gcc = -lgnu;
if [not [defined normal_libs]] then
#line 4 "test.in"
<TAB>normal_libs = ;

foo: [objects]
{
#line 7 "test.in"
<TAB>#if [in [CC] gcc ]
<TAB>[CC] -o foo [objects] [libs_for_gcc];
<TAB>#else
<TAB>[CC] -o foo [objects] [normals_libs];
<TAB>#endif
}
fubar
if test $? -ne 0 ; then fail; fi

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
