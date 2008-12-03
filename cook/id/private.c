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
 * MANIFEST: functions to manipulate private ID innards
 */

#include <cook/id/private.h>
#include <common/mem.h>
#include <common/trace.h>


id_ty *
id_instance_new(id_method_ty *mp)
{
    id_ty           *idp;

    trace(("id_new()\n{\n"));
    assert(mp);
    trace(("is a %s\n", mp->name));
    idp = mem_alloc(mp->size);
    idp->method = mp;
    trace(("return %08lX;\n", (long)idp));
    trace(("}\n"));
    return idp;
}


void
id_instance_delete(id_ty *idp)
{
    assert(idp);
    assert(idp->method);
    assert(idp->method->destructor);
    idp->method->destructor(idp);
    idp->method = 0; /* paranoia */
    mem_free(idp);
}
