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
# MANIFEST: Test the implicit pattern functionality
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
        echo 'FAILED test of the implicit pattern functionality' 1>&2
        cd $here
        rm -rf $work
        exit 1
}
no_result()
{
        set +x
        echo 'NO RESULT for test of the implicit pattern functionality' 1>&2
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

#
# test the implicit pattern functionality
#
cat > howto.cook << 'fubar'
%1/%2/%.o %2/%3.lst: %%1/%2/%.c
{
    blah blah;
}
test:
{
    echo OK > test;
}
fubar
if test $? -ne 0 ; then no_result; fi

TAB=`awk 'BEGIN{printf("\11")}' /dev/null`
if test $? -ne 0 ; then no_result; fi

sed "s|<TAB>|$TAB|g" > test.ok << 'fubar'
cook: howto.cook: 1: at least one target of an implicit recipe must use all of
<TAB>the named pattern elements
cook: howto.cook: 5: statement failed
cook: howto.cook: found 1 fatal errors
fubar
if test $? -ne 0 ; then no_result; fi

$bin/cook -nl > LOG 2>&1 < /dev/null
if test $? -ne 1 ; then fail; fi

diff test.ok LOG
if test $? -ne 0 ; then fail; fi

#
# Only definite negatives are possible.
# The functionality exercised by this test appears to work,
# no other guarantees are made.
#
pass
