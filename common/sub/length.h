/*
 *      cook - file construction tool
 *      Copyright (C) 1997, 1998, 2006, 2007 Peter Miller;
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
 * MANIFEST: interface definition for common/sub/length.c
 */

#ifndef COMMON_SUB_LENGTH_H
#define COMMON_SUB_LENGTH_H

#include <common/main.h>

struct sub_context_ty; /* existence */
struct wstring_list_ty; /* existence */

struct wstring_ty *sub_length(struct sub_context_ty *,
        struct wstring_list_ty *);

#endif /* COMMON_SUB_LENGTH_H */
