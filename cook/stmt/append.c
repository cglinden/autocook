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
 * MANIFEST: functions to manipulate assign-append statement nodes
 */

#include <cook/expr.h>
#include <cook/expr/constant.h>
#include <cook/expr/list.h>
#include <cook/opcode/assign_appen.h>
#include <cook/opcode/cascade.h>
#include <cook/opcode/setenv_appen.h>
#include <cook/opcode/list.h>
#include <cook/opcode/push.h>
#include <cook/stmt.h>
#include <cook/stmt/append.h>
#include <common/str.h>
#include <common/trace.h>


typedef struct stmt_append_ty stmt_append_ty;
struct stmt_append_ty
{
    stmt_ty         inherited;
    expr_list_ty    name;
    expr_list_ty    value;
};


/*
 *  NAME
 *      destructor - free a append statement node
 *
 *  SYNOPSIS
 *      void destructor(stmt_ty *sp);
 *
 *  DESCRIPTION
 *      The destructor function releases the resources held by a append
 *      statement instance after it is finished with.
 *
 *  CAVEAT
 *      Do not free the node itself, this the the destructor, not
 *      delete.
 */

static void
destructor(stmt_ty *sp)
{
    stmt_append_ty  *this;

    trace(("destructor(sp = %08X)\n{\n", sp));
    assert(sp);
    /* assert(sp->method == &method); */
    this = (stmt_append_ty *)sp;
    expr_list_destructor(&this->name);
    expr_list_destructor(&this->value);
    trace(("}\n"));
}


/*
 * NAME
 *      code_generate
 *
 * SYNOPSIS
 *      stmt_result_ty code_generate(stmt_ty *sp, opcode_list_ty *olp);
 *
 * DESCRIPTION
 *      The code_generate function is used to generate the opcodes for
 *      this statement node.
 *
 * RETURNS
 *      The value returned indicates why the code generation terminated.
 */

static stmt_result_ty
code_generate(stmt_ty *sp, opcode_list_ty *olp)
{
    stmt_append_ty  *this;
    static expr_ty  *setenv_expr;
    static expr_ty  *cascade_expr;
    static expr_ty  *cascade_for_expr;
    expr_position_ty *pp;

    trace(("code_generate(sp = %08X)\n{\n", sp));
    assert(sp);
    this = (stmt_append_ty *)sp;

    /*
     * If the first expression is ``setenv'' then it is a
     * setenv-append, not an assign-append.
     */
    if (!setenv_expr)
    {
        string_ty       *s;

        s = str_from_c("setenv");
        setenv_expr = expr_constant_new(s, 0);
        str_free(s);
    }
    if (!cascade_expr)
    {
        string_ty       *s;

        s = str_from_c("cascade");
        cascade_expr = expr_constant_new(s, 0);
        str_free(s);
    }
    if (!cascade_for_expr)
    {
        string_ty       *s;

        s = str_from_c("cascade-for");
        cascade_for_expr = expr_constant_new(s, 0);
        str_free(s);
    }

    pp = expr_list_position(&this->name);
    if (!pp)
        pp = expr_list_position(&this->value);

    if
    (
        this->name.el_nexprs == 2
    &&
        expr_equal(setenv_expr, this->name.el_expr[0])
    )
    {
        opcode_list_append(olp, opcode_push_new());
        expr_code_generate(this->name.el_expr[1], olp);
        opcode_list_append(olp, opcode_push_new());
        expr_list_code_generate(&this->value, olp);
        opcode_list_append(olp, opcode_setenv_append_new(pp));
    }
    else if
    (
        this->name.el_nexprs >= 1
    &&
        (
            expr_equal(cascade_expr, this->name.el_expr[0])
        ||
            expr_equal(cascade_for_expr, this->name.el_expr[0])
        )
    )
    {
        size_t          j;

        opcode_list_append(olp, opcode_push_new());
        expr_list_code_generate(&this->value, olp);
        opcode_list_append(olp, opcode_push_new());
        for (j = 1; j < this->name.el_nexprs; ++j)
            expr_code_generate(this->name.el_expr[j], olp);
        opcode_list_append(olp, opcode_cascade_new(pp));
    }
    else
    {
        opcode_list_append(olp, opcode_push_new());
        expr_list_code_generate(&this->name, olp);
        opcode_list_append(olp, opcode_push_new());
        expr_list_code_generate(&this->value, olp);
        opcode_list_append(olp, opcode_assign_append_new(pp));
    }
    trace(("}\n"));
    return STMT_OK;
}


/*
 * NAME
 *      method - class method table
 *
 * DESCRIPTION
 *      This is the class method table.  It contains a description of
 *      the class, its name, size and pointers to its virtual methods.
 *
 * CAVEAT
 *      This symbol is NOT to be exported from this file scope.
 */

static stmt_method_ty method =
{
    "append",
    sizeof(stmt_append_ty),
    destructor,
    code_generate,
};


/*
 * NAME
 *      stmt_append_new - create a new append statement node
 *
 * SYNOPSIS
 *      stmt_ty *stmt_append_new(string_ty *);
 *
 * DESCRIPTION
 *      The stmt_append_new function is used to create a new instance
 *      of a append statement node.
 *
 * RETURNS
 *      stmt_ty *; pointer to polymorphic statement instance.
 *
 * CAVEAT
 *      This function allocates data in dynamic memory.  It is the
 *      caller's responsibility to free this data, using stmt_delete,
 *      when it is no longer required.
 */

stmt_ty *
stmt_append_new(expr_list_ty *name, expr_list_ty *value)
{
    stmt_ty         *sp;
    stmt_append_ty  *this;

    trace(("stmt_append_new()\n{\n"));
    sp = stmt_private_new(&method);
    this = (stmt_append_ty *)sp;
    expr_list_copy_constructor(&this->name, name);
    expr_list_copy_constructor(&this->value, value);
    trace(("return %8.8lX;\n", (long)sp));
    trace(("}\n"));
    return sp;
}
