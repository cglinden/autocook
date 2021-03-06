/*
 *      cook - file construction tool
 *      Copyright (C) 1997, 2006, 2007 Peter Miller;
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
 * MANIFEST: interface definition for cook/stmt/command.c
 */

#ifndef COOK_STMT_COMMAND_H
#define COOK_STMT_COMMAND_H

#include <common/main.h>

struct stmt_ty; /* existence */
struct expr_ty; /* existence */
struct expr_list_ty; /* existence */
struct expr_position_ty; /* existence */

struct stmt_ty *stmt_command_new(struct expr_list_ty *,
        struct expr_list_ty *, struct expr_ty *, struct expr_position_ty *);

#endif /* COOK_STMT_COMMAND_H */
