/*
 *      cook - file construction tool
 *      Copyright (C) 1993-1997, 1999, 2001, 2006, 2007 Peter Miller;
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
 * MANIFEST: interface definition for cook/cook.c
 */

#ifndef COOK_COOK_H
#define COOK_COOK_H

#include <common/ac/time.h>

#include <common/main.h>

struct opcode_context_ty; /* existence */
struct recipe_ty; /* existence */
struct string_ty; /* existence */
struct string_list_ty; /* existence */

int cook(struct string_list_ty *);
int cook_pairs(struct string_list_ty *);
int cook_script(struct string_list_ty *);
int cook_web(struct string_list_ty *);

time_t cook_mtime_oldest(const struct opcode_context_ty *,
        struct string_ty *, long *, long);
time_t cook_mtime_newest(const struct opcode_context_ty *,
        struct string_ty *, long *, long);
int cook_mtime_resolve(const struct opcode_context_ty *,
        struct string_list_ty *, const struct string_list_ty *, int);

void cook_auto(struct string_list_ty *);
int cook_auto_required(void);
void cook_reset(void);
void cook_find_default(struct string_list_ty *);
void cook_search_list(const struct opcode_context_ty *,
        struct string_list_ty *slp);

void cook_explicit_append(struct recipe_ty *);
const struct recipe_list_ty *cook_explicit_by_name(struct string_ty *);
void cook_implicit_append(struct recipe_ty *);
struct recipe_ty *cook_implicit_nth(long);
struct recipe_ty *cook_implicit_nth_by_name(long, struct string_ty *);

#endif /* COOK_COOK_H */
