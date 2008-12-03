#! /bin/sh
#
#       cook - file construction tool
#       Copyright (C) 1992, 1993, 1997, 2007 Peter Miller;
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
# MANIFEST: shell script to generate CHANGES file
#
case $# in
1)
        project=$1
        ;;

*)
        echo "usage: $0 <project>" 1>&2
        exit 1
        ;;
esac
set -e
aegis -l changes -p $project -v -pl 66 -pw 72 < /dev/null
changes=`aegis -list changes -terse -project $project`
for n in $changes
do
        echo '' | tr '\12' '\14'
        aegis -l change_details -p $project -c $n -v -pl 66 -pw 72 < /dev/null
done
exit 0
