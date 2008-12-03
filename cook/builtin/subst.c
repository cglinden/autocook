/*
 *      cook - file construction tool
 *      Copyright (C) 1994, 1997-1999, 2006, 2007 Peter Miller;
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
 * MANIFEST: functions to implement builtin subst function
 */

#include <cook/builtin/subst.h>
#include <common/error_intl.h>
#include <cook/expr/position.h>
#include <common/str_list.h>
#include <common/trace.h>


static int
interpret(string_list_ty *result, const string_list_ty *arg,
    const expr_position_ty* pp, const struct opcode_context_ty *ocp)
{
    size_t          j;
    string_ty       *s;

    trace(("subst\n"));
    (void)ocp;
    if (arg->nstrings < 3)
    {
        sub_context_ty *scp;

        scp = sub_context_new();
        sub_var_set_string(scp, "Name", arg->string[0]);
        error_with_position
        (
            pp,
            scp,
            i18n("$name: requires two or more arguments")
        );
        sub_context_delete(scp);
        return -1;
    }
    for (j = 3; j < arg->nstrings; ++j)
    {
        s = str_substitute(arg->string[1], arg->string[2], arg->string[j]);
        string_list_append(result, s);
        str_free(s);
    }
    return 0;
}


builtin_ty builtin_subst =
{
    "subst",
    interpret,
    interpret,                  /* script */
};

builtin_ty builtin_substitute =
{
    "substitute",
    interpret,
    interpret,                  /* script */
};
