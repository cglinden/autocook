/*
 *      cook - file construction tool
 *      Copyright (C) 1999, 2006, 2007 Peter Miller;
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
 * MANIFEST: interface definition for common/gmatch.c
 */

#ifndef COMMON_GMATCH_H
#define COMMON_GMATCH_H

#include <common/main.h>

struct string_ty;
typedef void (*gmatch_fp)(void *, struct string_ty *);
void gmatch_error_handler(gmatch_fp, void *);
int gmatch(const char *formal, const char *actual);
int gmatch2(const char *formal, const char *formal_end, const char *actual);

#endif /* COMMON_GMATCH_H */
