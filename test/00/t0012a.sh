#!/bin/sh
#
#       cook - file construction tool
#       Copyright (C) 1992-1995, 1997, 1998, 2001, 2007 Peter Miller;
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
# MANIFEST: test the "find_command" builtin function
#
tmp=${COOK_TMP:-/tmp}/$$
PAGER=cat
export PAGER
umask 022
unset COOK
here=`pwd`
if test $? -ne 0 ; then exit 1; fi

bin="$here/${1-.}/bin"

fail()
{
        echo 'FAILED test of builtin function "find_command"' 1>&2
        cd $here
        rm -rf $tmp
        exit 1
}
pass()
{
        cd $here
        rm -rf $tmp
        exit 0
}
trap "fail" 1 2 3 15

mkdir $tmp $tmp/lib
cd $tmp

#
# Use the default error messages.  There is no other way to get
# predictable test behaviour on the unknown systems we will be tested on.
#
COOK_MESSAGE_LIBRARY=$work/no-such-dir
export COOK_MESSAGE_LIBRARY
unset LANG

#
# note: Linux has a symlink /bin/sh -> /bin/bash
#
cat > Howto.cook <<foobar
exe = ;
if [in [substr 1 6 [os]] CYGWIN NUTCRA] then
        exe = .exe;
test:
{
        if [find_command '{s h * t}' ] then fail;
        path =
                [stringset
                        [split ':' [getenv PATH]]
                        /bin /usr/bin /sbin /usr/sbin
                ];
        /* function print 'SH =' [find_command sh]; */
        if [not [in [find_command sh]
                [addsuffix /sh[exe] [path]]
                ] ] then fail;
}
foobar
if test $? -ne 0 ; then fail; fi

$bin/cook -nl
if test $? -ne 0 ; then fail; fi

# probably OK
pass
