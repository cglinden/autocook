#!/bin/sh
#
#       cook - file construction tool
#       Copyright (C) 1998, 1999, 2001, 2003, 2007 Peter Miller;
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
# MANIFEST: shell script to build the RPM package
#
case $# in
2)
        ;;
*)
        echo "Usage: $0 <tmp-dir> <tar-ball>" 1>&2
        exit 1
        ;;
esac
tmp=$1
tarball=$2

mkdir -p $tmp/BUILD $tmp/BUILD_ROOT $tmp/RPMS/i386 \
        $tmp/SOURCES $tmp/SPECS $tmp/SRPMS

here=`pwd`/$tmp

cat > $tmp/macros << fubar
%_builddir      $here/BUILD
%_buildroot     $here/BUILD_ROOT
%_rpmdir        $here/RPMS
%_sourcedir     $here/SOURCES
%_specdir       $here/SPECS
%_srcrpmdir     $here/SRPMS
fubar

mac=`rpm --showrc | awk '/^macrofile/{print $3}'`
cat > $tmp/rpmrc << fubar
macrofiles: ${mac}:$here/macros
fubar

rpmbuild -ta --rcfile /usr/lib/rpm/rpmrc:${tmp}/rpmrc --verbose --verbose $2
test $? -eq 0 || exit 1

exit 0
