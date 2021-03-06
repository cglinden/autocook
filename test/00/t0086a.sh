#!/bin/sh
#
#       cook - file construction tool
#       Copyright (C) 1995, 1997, 1998, 2007 Peter Miller;
#       All rights reserved.
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
# MANIFEST: Test the c_incl -I- functionality
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
        echo 'FAILED test of the c_incl -I- functionality' 1>&2
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

#
# test the c_incl -I- functionality
#
mkdir a b
if test $? -ne 0 ; then fail; fi

cat > test.in << 'fubar'
#include "first.h"
#include <second.h>
blah blah blah
fubar
if test $? -ne 0 ; then fail; fi

cat > a/first.h << 'fubar'
blah blah blah
fubar
if test $? -ne 0 ; then fail; fi

cat > a/second.h << 'fubar'
it is wrong if this one is included
fubar
if test $? -ne 0 ; then fail; fi

cat > b/second.h << 'fubar'
blah blah blah
fubar
if test $? -ne 0 ; then fail; fi

cat > test.ok << 'fubar'
a/first.h
b/second.h
fubar
if test $? -ne 0 ; then fail; fi

$bin/c_incl -Ia -I- -Ib test.in > test.out
if test $? -ne 0 ; then fail; fi

diff test.ok test.out
if test $? -ne 0 ; then fail; fi

#
# Only definite negatives are possible.
# The functionality exercised by this test appears to work,
# no other guarantees are made.
#
pass
