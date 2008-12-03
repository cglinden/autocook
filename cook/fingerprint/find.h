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
 * MANIFEST: interface definition for cook/fingerprint/find.c
 */

#ifndef COOK_FINGERPRINT_FIND_H
#define COOK_FINGERPRINT_FIND_H

#include <common/main.h>

struct string_ty; /* existence */
struct fp_subdir_ty; /* existence */
struct fp_value_ty; /* existence */

struct fp_record_ty *fp_find_record(struct string_ty *);
void fp_find_update(struct fp_subdir_ty *, struct string_ty *,
        struct fp_value_ty *);
void fp_find_flush(void);
struct fp_subdir_ty *fp_find_subdir(struct string_ty *, int);

void fp_find_main_write(void *);

#endif /* COOK_FINGERPRINT_FIND_H */
