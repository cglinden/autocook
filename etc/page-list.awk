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
# MANIFEST: page-list.awk
#
function output_end()
{
        if (start == 0)
                return;
        if (middle != 0)
                printf(",")
        middle = 1
        printf("%d", start);
        if (start != finish)
                printf("-%d", finish);
        start = 0;
        finish = 0;
}

function output(n)
{
        if (start == 0)
        {
                start = n
                finish = n
                return
        }
        if (n == finish + 1)
        {
                finish = n;
                return
        }
        output_end();
        start = n;
        finish = n;
}

function output_even()
{
        if ((page[finish] % 2) != 0)
        {
                output_end();
                printf(",_");
        }
}

/Page:/ {
        page[$3] = $2
        if ($3 > max)
                max = $3
}
END {
        output(1);
        output(2);
        numtoc = 0
        for (j = 3; j <= max; ++j)
        {
                if (page[j] > 1000)
                {
                        output(j);
                        numtoc++
                }
        }
        output_even();
        for (j = 3; j <= max; ++j)
        {
                if (page[j] < 1000)
                        output(j);
        }
        output_even();
        output_end();
        printf("\n");
}
