/*
 *      cook - file construction tool
 *      Copyright (C) 1990-1994, 1997, 1999, 2006, 2007 Peter Miller;
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
 * MANIFEST: interface definition for common/error.c
 */

#ifndef COMMON_ERROR_H
#define COMMON_ERROR_H

#include <common/format_print.h>
#include <common/main.h>
#include <common/noreturn.h>

/*
 * These were the old names.  Use *_intl instead.
 */
#define error +/+/+/+
#define fatal +/+/+/+
#define nerror +/+/+/+
#define nfatal +/+/+/+

void error_raw(const char *, ...)                  FORMAT_PRINTF(1, 2);
void fatal_raw(const char *, ...)                  FORMAT_PRINTF(1, 2) NORETURN;
void nerror_raw(const char *, ...)                 FORMAT_PRINTF(1, 2);
void nfatal_raw(const char *, ...)                 FORMAT_PRINTF(1, 2) NORETURN;

#endif /* COMMON_ERROR_H */
