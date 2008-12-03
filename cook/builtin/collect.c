/*
 *      cook - file construction tool
 *      Copyright (C) 1991-1994, 1997-1999, 2006, 2007 Peter Miller;
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
 * MANIFEST: functions to implement the builtin collect functions
 *
 * The builtin function all append their results to the supplied
 * `result' word list.  The first word of the `args' word list
 * is the name of the function.
 *
 * all of the functions return 0 in success, or -1 on error.
 */

#include <common/ac/stdio.h>
#include <common/ac/string.h>
#include <common/ac/errno.h>

#include <common/error.h>
#include <common/error_intl.h>
#include <common/star.h>
#include <common/trace.h>
#include <cook/builtin/collect.h>
#include <cook/expr/position.h>
#include <cook/option.h>
#include <cook/os_interface.h>


/*
 * NAME
 *      builtin_collect - get output of a command
 *
 * SYNOPSIS
 *      int builtin_collect(string_list_ty *result, string_list_ty *args);
 *
 * DESCRIPTION
 *      Collect is a built-in function of cook, described as follows:
 *      This function requires one or more arguments.
 *
 * RETURNS
 *      A word list containing the values of the output lines of the
 *      program given in the arguments.
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
    FILE            *fp;
    string_ty       *s;
    char            *delim;
    int             status;
    int             silent;
    int             errok;

    trace(("collect\n"));
    (void)ocp;
    assert(result);
    assert(args);
    assert(args->nstrings);
    if (args->nstrings < 2)
    {
        sub_context_ty  *scp;

        scp = sub_context_new();
        sub_var_set_string(scp, "Name", args->string[0]);
        error_with_position
        (
            pp,
            scp,
            i18n("$name: requires one or more arguments")
        );
        sub_context_delete(scp);
        return -1;
    }
    s = wl2str(args, 1, args->nstrings - 1, (char *)0);
    option_set(OPTION_SILENT, OPTION_LEVEL_EXECUTE, 1);
    option_set(OPTION_ERROK, OPTION_LEVEL_EXECUTE, 0);
    silent = option_test(OPTION_SILENT);
    errok = option_test(OPTION_ERROK);
    if (silent)
        star_bang();
    else
    {
        star_sync();
        error_raw("%s", s->str_text);
    }
    fp = popen(s->str_text, "r");
    str_free(s);
    if (!fp)
    {
        sub_context_ty  *scp;

        scp = sub_context_new();
        sub_errno_set(scp);
        sub_var_set_string(scp, "File_Name", args->string[1]);
        error_with_position(pp, scp, i18n("exec $filename: $errno"));
        sub_context_delete(scp);
        return -1;
    }
    delim = strchr(args->string[0]->str_text, '_') ? "\n" : "\n \t\f";
    for (;;)
    {
        char            buffer[1024];
        char            *cp;
        int             c;

        for (;;)
        {
            c = fgetc(fp);
            if (c == EOF || !strchr(delim, c))
                break;
        }
        if (c == EOF)
            break;
        cp = buffer;
        for (;;)
        {
            *cp++ = c;
            c = fgetc(fp);
            if (c == EOF || strchr(delim, c))
                break;
        }
        s = str_n_from_c(buffer, cp - buffer);
        string_list_append(result, s);
        str_free(s);
        if (c == EOF)
            break;
    }
    if (ferror(fp))
    {
        sub_context_ty  *scp;

        scp = sub_context_new();
        sub_errno_set(scp);
        sub_var_set_string(scp, "File_Name", args->string[1]);
        error_with_position(pp, scp, i18n("read $filename: $errno"));
        sub_context_delete(scp);
        option_undo_level(OPTION_LEVEL_EXECUTE);
        return -1;
    }
    status = pclose(fp);
    status = exit_status(args->string[1]->str_text, status, errok);
    option_undo_level(OPTION_LEVEL_EXECUTE);
    if (status)
        return -1;
    return 0;
}


builtin_ty builtin_collect =
{
    "collect",
    interpret,
    interpret,                  /* script */
};


builtin_ty builtin_collect_lines =
{
    "collect_lines",
    interpret,
    interpret,                  /* script */
};


builtin_ty builtin_shell =
{
    "shell",
    interpret,
    interpret,                  /* script */
};
