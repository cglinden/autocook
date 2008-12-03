#!/bin/sh
#
#       cook - file construction tool
#       Copyright (C) 1998, 2007 Peter Miller
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
# MANIFEST: Test the cook_bom functionality
#
work=${COOK_TMP:-/tmp}/$$
PAGER=cat
export PAGER
umask 022
unset COOK
here=`pwd`
if test $? -ne 0 ; then exit 2; fi
SHELL=/bin/sh
export SHELL

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
        echo 'FAILED test of the cook_bom functionality' 1>&2
        cd $here
        rm -rf $work
        exit 1
}
no_result()
{
        set +x
        echo 'NO RESULT for test of the cook_bom functionality' 1>&2
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
unset LANGUAGE

#
# test the cook_bom functionality
#
cat > howto.cook << 'fubar'
test:
{
    fail;
}
fubar
if test $? -ne 0 ; then no_result; fi

mkdir deeper
if test $? -ne 0 ; then no_result; fi

TAB=`awk 'BEGIN{printf("\11")}' /dev/null`
if test $? -ne 0 ; then no_result; fi

sed "s|<TAB>|$TAB|g" > test.ok << 'fubar'
.cook.bom.dir = [relative_dirname [__FILE__]];
if [in [.cook.bom.dir] "."] then
<TAB>.cook.bom/dir = '';
else
<TAB>.cook.bom/dir = [.cook.bom.dir]/;

files_in_[.cook.bom.dir] =
<TAB>howto.cook
<TAB>test.ok
<TAB>;
all_files_in_[.cook.bom.dir] = [files_in_[.cook.bom.dir]];

specials_in_[.cook.bom.dir] =
<TAB>;
all_specials_in_[.cook.bom.dir] = [specials_in_[.cook.bom.dir]];

directories_in_[.cook.bom.dir] =
<TAB>deeper
<TAB>lib
<TAB>;
all_directories_in_[.cook.bom.dir] = [directories_in_[.cook.bom.dir]];

#include-cooked-nowarn [prepost [.cook.bom/dir] /manifest.cook \
<TAB>[directories_in_[.cook.bom.dir]]]

/*
 * These variables must be calculated again, as the above includes will
 * have over-written them, and they all use the same variables.
 */
.cook.bom.dir = [relative_dirname [__FILE__]];
if [in [.cook.bom.dir] "."] then
<TAB>.cook.bom/dir = '';
else
<TAB>.cook.bom/dir = [.cook.bom.dir]/;

if [defined all_files_in_[.cook.bom/dir]deeper] then
<TAB>all_files_in_[.cook.bom.dir] +=
<TAB><TAB>[addprefix deeper/ [all_files_in_[.cook.bom/dir]deeper]];
if [defined all_specials_in_[.cook.bom/dir]deeper] then
<TAB>all_specials_in_[.cook.bom.dir] +=
<TAB><TAB>[addprefix deeper/ [all_specials_in_[.cook.bom/dir]deeper]];
if [defined all_directories_in_[.cook.bom/dir]deeper] then
<TAB>all_directories_in_[.cook.bom.dir] +=
<TAB><TAB>[addprefix deeper/ [all_directories_in_[.cook.bom/dir]deeper]];

if [defined all_files_in_[.cook.bom/dir]lib] then
<TAB>all_files_in_[.cook.bom.dir] +=
<TAB><TAB>[addprefix lib/ [all_files_in_[.cook.bom/dir]lib]];
if [defined all_specials_in_[.cook.bom/dir]lib] then
<TAB>all_specials_in_[.cook.bom.dir] +=
<TAB><TAB>[addprefix lib/ [all_specials_in_[.cook.bom/dir]lib]];
if [defined all_directories_in_[.cook.bom/dir]lib] then
<TAB>all_directories_in_[.cook.bom.dir] +=
<TAB><TAB>[addprefix lib/ [all_directories_in_[.cook.bom/dir]lib]];

.cook.bom.dir = ;
.cook.bom/dir = ;
fubar
if test $? -ne 0 ; then no_result; fi

$bin/cook_bom . test.out
if test $? -ne 0 ; then fail; fi

diff test.ok test.out
if test $? -ne 0 ; then fail; fi

#
# Only definite negatives are possible.
# The functionality exercised by this test appears to work,
# no other guarantees are made.
#
pass
