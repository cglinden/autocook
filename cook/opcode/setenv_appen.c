/*
 *      cook - file construction tool
 *      Copyright (C) 1998, 2001, 2006, 2007 Peter Miller;
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
 * MANIFEST: functions to manipulate setenv_append opcodes
 */

#include <common/ac/stdio.h>
#include <common/ac/stdlib.h>

#include <common/env.h>
#include <common/error_intl.h>
#include <cook/expr/position.h>
#include <cook/opcode/context.h>
#include <cook/opcode/private.h>
#include <cook/opcode/setenv_appen.h>
#include <common/str_list.h>
#include <common/trace.h>


typedef struct opcode_setenv_append_ty opcode_setenv_append_ty;
struct opcode_setenv_append_ty
{
    opcode_ty       inherited;
    expr_position_ty pos;
};


/*
 * NAME
 *      destructor
 *
 * SYNOPSIS
 *      void destructor(opcode_ty *);
 *
 * DESCRIPTION
 *      The destructor function is used to release resources held by
 *      this opcode.  Do not free the opcode itself, this is done by the
 *      base class.
 */

static void
destructor(opcode_ty *op)
{
    opcode_setenv_append_ty *this;

    trace(("opcode_setenv_append::destructor()\n{\n"));
    this = (opcode_setenv_append_ty *) op;
    expr_position_destructor(&this->pos);
    trace(("}\n"));
}


/*
 * NAME
 *      execute
 *
 * SYNOPSIS
 *      opcode_status_ty execute(opcode_ty *, opcode_context_ty *);
 *
 * DESCRIPTION
 *      The execute function is used to execute the given opcode within
 *      the given interpretation context.
 *
 * RETURNS
 *      opcode_status_ty to indicate the result of the execution
 */

static opcode_status_ty
execute(const opcode_ty *op, opcode_context_ty *icp)
{
    opcode_status_ty status;
    const opcode_setenv_append_ty *this;
    string_list_ty  *name;
    string_list_ty  *value;
    string_ty       *s;
    char            *tmp;

    trace(("opcode_setenv_append::execute()\n{\n"));
    status = opcode_status_success;
    this = (const opcode_setenv_append_ty *)op;

    value = opcode_context_string_list_pop(icp);
    name = opcode_context_string_list_pop(icp);

    switch (name->nstrings)
    {
    case 0:
        error_with_position
        (
            &this->pos,
            0,
            i18n("lefthand side of assignment is empty")
        );
        status = opcode_status_error;
        break;

    case 1:
        /*
         * If the environment variable is already set, prepend
         * its existing value to the value list the user gave us.
         */
        tmp = getenv(name->string[0]->str_text);
        if (tmp)
        {
            string_ty       *tmp2;

            tmp2 = str_from_c(tmp);
            string_list_prepend(value, tmp2);
            str_free(tmp2);
        }
        s = wl2str(value, 0, value->nstrings, " ");
        env_set(name->string[0]->str_text, s->str_text);
        str_free(s);
        break;

    default:
        error_with_position
        (
            &this->pos,
            0,
            i18n("lefthand side of assignment is more than one word")
        );
        status = opcode_status_error;
        break;
    }

    string_list_delete(name);
    string_list_delete(value);
    trace(("return %s;\n", opcode_status_name(status)));
    trace(("}\n"));
    return status;
}


/*
 * NAME
 *      script
 *
 * SYNOPSIS
 *      opcode_status_ty script(opcode_ty *, opcode_context_ty *);
 *
 * DESCRIPTION
 *      The script function is used to script the given opcode within
 *      the given interpretation context.
 *
 * RETURNS
 *      opcode_status_ty to indicate the result
 */

static opcode_status_ty
script(const opcode_ty *op, opcode_context_ty *icp)
{
    opcode_status_ty status;
    const opcode_setenv_append_ty *this;
    string_list_ty  *name;
    string_list_ty  *value;
    string_ty       *name1;
    string_ty       *name2;
    string_ty       *value1;
    string_ty       *value2;

    trace(("opcode_setenv_append::script()\n{\n"));
    status = opcode_status_success;
    this = (const opcode_setenv_append_ty *)op;

    value = opcode_context_string_list_pop(icp);
    name = opcode_context_string_list_pop(icp);

    switch (name->nstrings)
    {
    case 0:
        error_with_position
        (
            &this->pos,
            0,
            i18n("lefthand side of assignment is empty")
        );
        status = opcode_status_error;
        break;

    case 1:
        name1 = wl2str(name, 0, name->nstrings, " ");
        name2 = str_quote_shell(name1);
        str_free(name1);

        value1 = wl2str(value, 0, value->nstrings, " ");
        value2 = str_quote_shell(value1);
        str_free(value1);

        printf("%s=%s\n", name2->str_text, value2->str_text);
        printf("export %s\n", name2->str_text);
        str_free(name1);
        str_free(value2);
        break;

    default:
        error_with_position
        (
            &this->pos,
            0,
            i18n("lefthand side of assignment is more than one word")
        );
        status = opcode_status_error;
        break;
    }

    string_list_delete(name);
    string_list_delete(value);
    trace(("return %s;\n", opcode_status_name(status)));
    trace(("}\n"));
    return status;
}


/*
 * NAME
 *      disassemble
 *
 * SYNOPSIS
 *      void disassemble(opcode_ty *);
 *
 * DESCRIPTION
 *      The disassemble function is used to disassemble the copdode and
 *      its arguments onto the standard output.  Don't worry about the
 *      location or a trailing newline.
 */

static void
disassemble(const opcode_ty *op)
{
    const opcode_setenv_append_ty *this;

    trace(("opcode_setenv_append::disassemle()\n{\n"));
    this = (const opcode_setenv_append_ty *)op;
    if (this->pos.pos_name && this->pos.pos_name->str_length)
    {
        printf("# %s:%d", this->pos.pos_name->str_text, this->pos.pos_line);
    }
    trace(("}\n"));
}


/*
 * NAME
 *      method
 *
 * DESCRIPTION
 *      The method variable describes this class.
 *
 * CAVEAT
 *      This symbol is not exported from this file.
 */

static opcode_method_ty method =
{
    "setenv_append",
    sizeof(opcode_setenv_append_ty),
    destructor,
    execute,
    script,
    disassemble,
};


/*
 * NAME
 *      opcode_setenv_append_new
 *
 * SYNOPSIS
 *      opcode_ty *opcode_setenv_append_new(void);
 *
 * DESCRIPTION
 *      The opcode_setenv_append_new function is used to allocate a new instance
 *      of a setenv_append opcode.
 *
 * RETURNS
 *      opcode_ty *; use opcode_delete when you are finished with it.
 */

opcode_ty *
opcode_setenv_append_new(expr_position_ty *pp)
{
    opcode_ty       *op;
    opcode_setenv_append_ty *this;

    trace(("opcode_setenv_append_new()\n{\n"));
    op = opcode_new(&method);
    this = (opcode_setenv_append_ty *)op;
    expr_position_copy_constructor(&this->pos, pp);
    trace(("return %08lX;\n", (long)op));
    trace(("}\n"));
    return op;
}
