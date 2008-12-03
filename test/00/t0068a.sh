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
# MANIFEST: Test the make2cook include functionality
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
        echo 'FAILED test of the make2cook include functionality' 1>&2
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

MANPATH=${MANPATH-/usr/man}
for path in ${AEGIS_SEARCH_PATH-$here}
do
        if test -d $path/lib/$LANG/.
        then
                MANPATH=${MANPATH}:$path/lib/$LANG
        fi
done
IFS="$ifs_old"

TAB=`awk 'BEGIN{printf("\11")}' /dev/null`
test $? -eq 0 || fail

#
# test make2cook include
#
sed "s|<TAB>|$TAB|g" > test.in << 'fubar'
override OBJ = snot
.SUFFIXES:
.include guano
include *.mk
-include $(OBJ)
test:;@echo OK
fubar
if test $? -ne 0 ; then fail; fi

sed "s|<TAB>|$TAB|g" > test.ok << 'fubar'

OBJ = snot;

#include guano
#include-cooked [wildcard *.mk]
#include-cooked-nowarn [wildcard [OBJ]]
test:
{
<TAB>echo OK
<TAB><TAB>set silent;
}
fubar
if test $? -ne 0 ; then fail; fi
echo broken > broken
if test $? -ne 0 ; then fail; fi

$bin/make2cook test.in test.out < broken
if test $? -ne 0 ; then fail; fi

diff test.ok test.out
if test $? -ne 0 ; then fail; fi

#
# Only definite negatives are possible.
# The functionality exercised by this test appears to work,
# no other guarantees are made.
#
pass
