#!/bin/sh
#
#       cook - file construction tool
#       Copyright (C) 2002, 2007 Peter Miller;
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
# MANIFEST: shell script to insulate agains gettext vagueries
#
input=
output=-
msgfmt=
msgcat=

#
# read the command line arguments
#
while [ $# -gt 0 ]
do
    case "$1" in

    -*=*)
        name="`echo $1 | sed -e 's|^-*||' -e 's|=.*||'`"
        value="`echo $1 | sed 's|.*=||'`"
        eval "$name='$value'"
        ;;
    -*)
        # ignore unknown options.
        ;;
    *)
        input="$input $1"
        ;;
    esac
    shift
done
test "$input" != "" || input=-
test "$msgfmt" != "" || msgfmt=msgfmt

#
# See which way we should handle the processing.
#
exitstatus=1
if [ "$msgcat" != "" ]
then
    #
    # Versions of GNU Gettext which supply the `msgcat' program (for
    # joining message catalogues together) have a msgfmt program which
    # object to duplictes in the input.
    #
    # We use msgcat to resolve the duplicate (msgid "", the file header).
    #
    if $msgcat --use-first --force-po $input > /tmp/$$
    then
        if $msgfmt -o $output /tmp/$$
        then
            exitstatus=0
        fi
    fi
    rm /tmp/$$
else
    #
    # Old versions of GNU Gettext, and gettext from dumber
    # implementations, simply glue it all together.
    #
    if $msgfmt -o $output $input
    then
        exitstatus=0
    fi
fi

exit $exitstatus
