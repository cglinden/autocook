#!/bin/sh
#
#       cook - file construction tool
#       Copyright (C) 1997, 1998, 2001, 2007 Peter Miller
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
# MANIFEST: Test the opcode functionality
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
        echo 'FAILED test of the opcode functionality' 1>&2
        cd $here
        rm -rf $work
        exit 1
}
no_result()
{
        set +x
        echo 'NO RESULT for test of the opcode functionality' 1>&2
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

#
# test the opcode functionality
#
cat > howto.cook << 'fubar'
if 0 then
{
        search_list = .;
        search_tmp = [tail [split ':' [search_path]]];
        search_name = bl;
        loop
        {
                search_dir = [head [search_tmp]];
                if [not [search_dir]] then
                        loopstop;
                search_tmp = [tail [search_tmp]];

                if [not [exists [search_name]]] then
                        ln -s [search_dir] [search_name]
                                set clearstat;
                search_list = [search_list] [search_name];
                search_name = b[search_name];
        }
}

test: { fail not this time; }
fubar
if test $? -ne 0 ; then no_result; fi

TAB=`awk 'BEGIN{printf("\11")}' /dev/null`
if test $? -ne 0 ; then no_result; fi

sed "s|<TAB>|$TAB|g" > test.ok << 'fubar'

   0:<TAB>push
   1:<TAB>string<TAB>"0"
   2:<TAB>jmpf<TAB>101
   3:<TAB>push
   4:<TAB>string<TAB>"search_list"
   5:<TAB>push
   6:<TAB>string<TAB>"."
   7:<TAB>assign<TAB><TAB># howto.cook:3
   8:<TAB>push
   9:<TAB>string<TAB>"search_tmp"
  10:<TAB>push
  11:<TAB>push
  12:<TAB>string<TAB>"tail"
  13:<TAB>push
  14:<TAB>string<TAB>"split"
  15:<TAB>string<TAB>":"
  16:<TAB>push
  17:<TAB>string<TAB>"search_path"
  18:<TAB>function<TAB># howto.cook:4
  19:<TAB>function<TAB># howto.cook:4
  20:<TAB>function<TAB># howto.cook:4
  21:<TAB>assign<TAB><TAB># howto.cook:4
  22:<TAB>push
  23:<TAB>string<TAB>"search_name"
  24:<TAB>push
  25:<TAB>string<TAB>"bl"
  26:<TAB>assign<TAB><TAB># howto.cook:5
  27:<TAB>push
  28:<TAB>string<TAB>"search_dir"
  29:<TAB>push
  30:<TAB>push
  31:<TAB>string<TAB>"head"
  32:<TAB>push
  33:<TAB>string<TAB>"search_tmp"
  34:<TAB>function<TAB># howto.cook:8
  35:<TAB>function<TAB># howto.cook:8
  36:<TAB>assign<TAB><TAB># howto.cook:8
  37:<TAB>push
  38:<TAB>push
  39:<TAB>string<TAB>"not"
  40:<TAB>push
  41:<TAB>string<TAB>"search_dir"
  42:<TAB>function<TAB># howto.cook:9
  43:<TAB>function<TAB># howto.cook:9
  44:<TAB>jmpf<TAB>46
  45:<TAB>goto<TAB>101
  46:<TAB>push
  47:<TAB>string<TAB>"search_tmp"
  48:<TAB>push
  49:<TAB>push
  50:<TAB>string<TAB>"tail"
  51:<TAB>push
  52:<TAB>string<TAB>"search_tmp"
  53:<TAB>function<TAB># howto.cook:11
  54:<TAB>function<TAB># howto.cook:11
  55:<TAB>assign<TAB><TAB># howto.cook:11
  56:<TAB>push
  57:<TAB>push
  58:<TAB>string<TAB>"not"
  59:<TAB>push
  60:<TAB>string<TAB>"exists"
  61:<TAB>push
  62:<TAB>string<TAB>"search_name"
  63:<TAB>function<TAB># howto.cook:13
  64:<TAB>function<TAB># howto.cook:13
  65:<TAB>function<TAB># howto.cook:13
  66:<TAB>jmpf<TAB>79
  67:<TAB>push
  68:<TAB>string<TAB>"ln"
  69:<TAB>string<TAB>"-s"
  70:<TAB>push
  71:<TAB>string<TAB>"search_dir"
  72:<TAB>function<TAB># howto.cook:14
  73:<TAB>push
  74:<TAB>string<TAB>"search_name"
  75:<TAB>function<TAB># howto.cook:14
  76:<TAB>push
  77:<TAB>string<TAB>"clearstat"
  78:<TAB>command<TAB>0<TAB># howto.cook:15
  79:<TAB>push
  80:<TAB>string<TAB>"search_list"
  81:<TAB>push
  82:<TAB>push
  83:<TAB>string<TAB>"search_list"
  84:<TAB>function<TAB># howto.cook:16
  85:<TAB>push
  86:<TAB>string<TAB>"search_name"
  87:<TAB>function<TAB># howto.cook:16
  88:<TAB>assign<TAB><TAB># howto.cook:16
  89:<TAB>push
  90:<TAB>string<TAB>"search_name"
  91:<TAB>push
  92:<TAB>push
  93:<TAB>string<TAB>"b"
  94:<TAB>push
  95:<TAB>push
  96:<TAB>string<TAB>"search_name"
  97:<TAB>function<TAB># howto.cook:17
  98:<TAB>catenate
  99:<TAB>assign<TAB><TAB># howto.cook:17
 100:<TAB>goto<TAB>27

   0:<TAB>push
   1:<TAB>string<TAB>"not"
   2:<TAB>string<TAB>"this"
   3:<TAB>string<TAB>"time"
   4:<TAB>fail

   0:<TAB>push
   1:<TAB>string<TAB>"test"
   2:<TAB>push
   3:<TAB>recipe

#!/bin/sh

#line 21 howto.cook
if test ! -e test
then
echo 'not this time' 1>&2
exit 1
fi
exit 0
fubar
if test $? -ne 0 ; then no_result; fi

$bin/cook -disassemble -script -nl search_path=a:a:b:c > test.out
if test $? -ne 0 ; then fail; fi

diff test.ok test.out
if test $? -ne 0 ; then fail; fi

#
# Only definite negatives are possible.
# The functionality exercised by this test appears to work,
# no other guarantees are made.
#
pass
