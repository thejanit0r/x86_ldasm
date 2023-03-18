/*

    This file is part of x86_ldasm.

    x86_ldasm is an x86-64 instruction length disassembler
    
    Copyright 2019 / the`janitor / < email: base64dec(dGhlLmphbml0b3JAcHJvdG9ubWFpbC5jb20=) >

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

*/
#ifndef _LDASM_H_
#define _LDASM_H_

#include "types.h"
#include "x86_ldasm_tables.h"

#include <limits.h>

#ifdef __cplusplus
    extern "C" {
#endif

/***************************************************************************/

enum
{
    /* flags */
    X86_FLAG_F64 = (1 << 0),
    X86_FLAG_D64 = (1 << 1),

    /* dasm mode */
    X86_DMODE_16BIT = 0,    /* real mode / virtual 8086 mode (16-bit) */
    X86_DMODE_32BIT,        /* protected mode / long compatibility mode (32-bit) */
    X86_DMODE_64BIT,        /* long mode (64-bit) */

    /* operand size */
    X86_OSIZE_16BIT = 0,
    X86_OSIZE_32BIT,
    X86_OSIZE_64BIT,

    /* addressing size */
    X86_ASIZE_16BIT = 0,
    X86_ASIZE_32BIT,
    X86_ASIZE_64BIT,

    /* displacement size */
    X86_DISP_NONE = 0,      /* no displacement */
    X86_DISP_8,             /* byte displacement */
    X86_DISP_16,            /* word displacement */
    X86_DISP_32             /* dword displacement */
};

typedef struct
{
    uint8_t* ip;        /* instruction pointer */

    union 
    {
        uint8_t pos;    /* position in buffer (cursor) */
        uint8_t len;    /* instruction length */
    };
    
    uint8_t dmode : 2;  /* X86_DMODE_ */
    uint8_t osize : 2;  /* X86_OSIZE_ */
    uint8_t asize : 2;  /* X86_ASIZE_ */

    uint8_t modrm;
    uint8_t sib;
    uint8_t vsib_base;

    /* prefixes */
    uint8_t pfx_rex;
    uint8_t pfx_last;
    uint8_t pfx_seg;
    uint8_t pfx_mandatory;

    union 
    {
        uint8_t pfx_vex[3];
        uint8_t pfx_xop[3];
    };

    /* positions in buffer */
    uint8_t pos_modrm : 4;
    uint8_t pos_sib : 4;
    uint8_t pos_rex : 4;
    uint8_t pos_opcode : 4;
    uint8_t pos_disp : 4;

    uint8_t disp_size : 4; /* displacement size in bytes */

    /* prefixes present */
    uint8_t pfx_p_rex : 1;
    uint8_t pfx_p_seg : 1;
    uint8_t pfx_p_osize : 1;
    uint8_t pfx_p_asize : 1;
    uint8_t pfx_p_lock : 1;
    uint8_t pfx_p_rep : 1;
    uint8_t pfx_p_repne : 1;
    uint8_t pfx_p_vex2b : 1;
    uint8_t pfx_p_vex3b : 1;
    uint8_t pfx_p_xop : 1;

    /* bytes present */
    uint8_t p_modrm : 1;
    uint8_t p_sib : 1;
    uint8_t p_vsib : 1;

    size_t table_index;
    
#if defined(_LDASM_EXT_X86_TABLE)
    
    uint8_t* table_compressed;
    size_t table_size;
    
#endif

} x86_dasm_context_t;

/* instruction length disassembling function */
int x86_ldasm(x86_dasm_context_t* x86_dctx, unsigned int dmode, uint8_t* ip);

#ifdef __cplusplus
    }
#endif

#endif //_LDASM_H_
