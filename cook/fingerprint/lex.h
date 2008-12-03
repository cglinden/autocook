/*
 *      cook - file construction tool
 *      Copyright (C) 1994, 1997, 1999, 2006, 2007 Peter Miller;
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
 * MANIFEST: interface definition for cook/fingerprint/lex.c
 */

#ifndef COOK_FNGRPRNT_LEX_H
#define COOK_FNGRPRNT_LEX_H

#include <common/main.h>

struct string_ty; /* existence */

void fingerprint_lex_open(struct string_ty *);
void fingerprint_lex_close(void);
int fingerprint_gram_lex(void);
void fingerprint_gram_error(char *);

#endif /* COOK_FNGRPRNT_LEX_H */
