/*
 *      cook - file construction tool
 *      Copyright (C) 1997, 1999, 2001, 2006, 2007 Peter Miller;
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
 * MANIFEST: interface definition for common/quit.c
 */

#ifndef COMMON_QUIT_H
#define COMMON_QUIT_H

#include <common/main.h>
#include <common/noreturn.h>

typedef void (*quit_ty)(void);
void quit_handler(quit_ty);
void quit_handler_prio(quit_ty);
void quit(int) NORETURN;

#endif /* COMMON_QUIT_H */
