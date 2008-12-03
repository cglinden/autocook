/*
 *      cook - file construction tool
 *      Copyright (C) 1998, 2006, 2007 Peter Miller;
 *      All rights reserved.
 *
 *      This program is free software; you can redistribute it and/or modify
 *      it under the terms of the GNU General Public License as published by
 *      the Free Software Foundation; either version 2 of the License, or
 *      (at your option) any later version.
 *
 *      This program is distributed in the hope that it will be useful,
 *      but WITHOUT ANY WARRANTY; without even the implied warranty of
 *      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *      GNU General Public License for more details.
 *
 *      You should have received a copy of the GNU General Public License
 *      along with this program; if not, write to the Free Software
 *      Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111, USA.
 *
 * MANIFEST: functions to catenate three strings
 */

#include <common/str.h>
#include <common/stracc.h>


/*
 * NAME
 *      str_cat_three - join three strings
 *
 * SYNOPSIS
 *      string_ty *str_cat_three(string_ty *, string_ty *, string_ty *);
 *
 * DESCRIPTION
 *      The str_cat_three function is used to concatenate three strings to form
 *      a new string.
 *
 * RETURNS
 *      string_ty * - a pointer to a string in dynamic memory.
 *      Use str_free when finished with.
 *
 * CAVEAT
 *      The contents of the structure pointed to MUST NOT be altered.
 */

string_ty *
str_cat_three(string_ty * s1, string_ty * s2, string_ty * s3)
{
    static stracc   sa;

    sa_open(&sa);
    sa_chars(&sa, s1->str_text, s1->str_length);
    sa_chars(&sa, s2->str_text, s2->str_length);
    sa_chars(&sa, s3->str_text, s3->str_length);
    return sa_close(&sa);
}
