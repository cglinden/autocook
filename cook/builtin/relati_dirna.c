/*
 *      cook - file construction tool
 *      Copyright (C) 1998, 1999, 2006, 2007 Peter Miller;
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
 * MANIFEST: functions to manipulate relati_dirnas
 */

#include <cook/builtin/relati_dirna.h>
#include <common/error_intl.h>
#include <cook/expr/position.h>
#include <cook/os_interface.h>
#include <common/str.h>
#include <common/str_list.h>
#include <common/trace.h>


/*
 * NAME
 *      builtin_reldir - relative directory part
 *
 * SYNOPSIS
 *      int builtin_reldir(string_list_ty *result, string_list_ty *args);
 *
 * DESCRIPTION
 *      "reldir" is a built-in function of cook, described as follows:
 *      This function requires one or more arguments, the name of a
 *      files of which to get the dir parts; files relative to the
 *      current directory wil return ".".
 *
 * RETURNS
 *      It returns a string containing the directory parts
 *      of the named files.
 *
 * CAVEAT
 *      The returned result is in dynamic memory.
 *      It is the responsibility of the caller to dispose of
 *      the result when it is finished, with a string_list_destructor() call.
 */

static int
interpret(string_list_ty *result, const string_list_ty *args,
    const expr_position_ty *pp, const struct opcode_context_ty *ocp)
{
    size_t          j;

    trace(("reldir\n"));
    (void)pp;
    (void)ocp;
    assert(result);
    assert(args);
    assert(args->nstrings);
    for (j = 1; j < args->nstrings; j++)
    {
        string_ty       *s;

        s = os_dirname_relative(args->string[j]);
        if (!s)
            return -1;
        string_list_append(result, s);
        str_free(s);
    }
    return 0;
}


builtin_ty builtin_reldir =
{
    "reldir",
    interpret,
    interpret,                  /* script */
};


builtin_ty builtin_relative_dirname =
{
    "relative_dirname",
    interpret,
    interpret,                  /* script */
};
