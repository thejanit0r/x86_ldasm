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
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <inttypes.h>

#include "x86_ldasm.h"

/****************************************************************************

    Shortcuts

****************************************************************************/

#define REX_B               _REX_B(x86_dctx->pfx_rex)
#define REX_X               _REX_X(x86_dctx->pfx_rex)
#define REX_R               _REX_R(x86_dctx->pfx_rex)
#define REX_W               _REX_W(x86_dctx->pfx_rex)

#define VEX_2B_PP           _VEX_2B_PP(x86_dctx->pfx_vex[0])
#define VEX_2B_L            _VEX_2B_L(x86_dctx->pfx_vex[0])
#define VEX_2B_VVVV         _VEX_2B_VVVV(x86_dctx->pfx_vex[0])
#define VEX_2B_R            _VEX_2B_R(x86_dctx->pfx_vex[0])

#define VEX_3B_MMMMM        _VEX_3B_MMMMM(x86_dctx->pfx_vex[0])
#define VEX_3B_B            _VEX_3B_B(x86_dctx->pfx_vex[0])
#define VEX_3B_X            _VEX_3B_X(x86_dctx->pfx_vex[0])
#define VEX_3B_R            _VEX_3B_R(x86_dctx->pfx_vex[0])
#define VEX_3B_PP           _VEX_3B_PP(x86_dctx->pfx_vex[1])
#define VEX_3B_L            _VEX_3B_L(x86_dctx->pfx_vex[1])
#define VEX_3B_VVVV         _VEX_3B_VVVV(x86_dctx->pfx_vex[1])
#define VEX_3B_W            _VEX_3B_W(x86_dctx->pfx_vex[1])

#define XOP_MMMMM           _XOP_MMMMM(x86_dctx->pfx_xop[0])
#define XOP_B               _XOP_B(x86_dctx->pfx_xop[0])
#define XOP_X               _XOP_X(x86_dctx->pfx_xop[0])
#define XOP_R               _XOP_R(x86_dctx->pfx_xop[0])
#define XOP_PP              _XOP_PP(x86_dctx->pfx_xop[1])
#define XOP_L               _XOP_L(x86_dctx->pfx_xop[1])
#define XOP_VVVV            _XOP_VVVV(x86_dctx->pfx_xop[1])
#define XOP_W               _XOP_W(x86_dctx->pfx_xop[1])

/****************************************************************************

    decoding functions

****************************************************************************/

static 
void
/* __attribute__((always_inline)) */
consume_bytes(x86_dasm_context_t* x86_dctx, size_t n)
{
    x86_dctx->pos += n;
}

/***************************************************************************/

static 
uint8_t
get_modrm(x86_dasm_context_t* x86_dctx)
{
    if(!x86_dctx->p_modrm)
    {
        x86_dctx->p_modrm = true;
        x86_dctx->pos_modrm = x86_dctx->pos;
        x86_dctx->modrm = x86_dctx->ip[x86_dctx->pos++];
    }

    return x86_dctx->modrm;
}

static 
uint8_t
get_sib(x86_dasm_context_t* x86_dctx)
{
    if(!x86_dctx->p_sib)
    {
        x86_dctx->p_sib = true;
        x86_dctx->pos_sib = x86_dctx->pos;
        x86_dctx->sib = x86_dctx->ip[x86_dctx->pos++];
    }

    return x86_dctx->sib;
}

static 
void
get_osize(x86_dasm_context_t* x86_dctx, uint16_t flags)
{
    /*
        D (default) field of the code-segment (CS) is assumed to be 32-bit 
        for protected mode / compatibility mode and 16-bit for real mode /
        virtual 8086 mode
    */

    /* operand-size override prefix present */
    uint8_t p = x86_dctx->pfx_p_osize;

    if(x86_dctx->dmode == X86_DMODE_16BIT)
    {
        /* assumed default operand size: 16 bit */
        x86_dctx->osize = (p ? X86_OSIZE_32BIT : X86_OSIZE_16BIT);
    }
    else if (x86_dctx->dmode == X86_DMODE_32BIT)
    {
        /* assumed default operand size: 32 bit */
        x86_dctx->osize = (p ? X86_OSIZE_16BIT : X86_OSIZE_32BIT);
    }
    else // x86_dctx->dmode == X86_DMODE_64BIT
    {
        if(flags & X86_FLAG_F64)
        {
            /* operand size forced to 64-bit */
            x86_dctx->osize = X86_OSIZE_64BIT;
        }
        else
        {
            if( (REX_W) || 
                (x86_dctx->pfx_p_vex3b && VEX_3B_W) ||
                (x86_dctx->pfx_p_xop && XOP_W) )
            {
                /* if rex.w = 1 then prefix 66h is ignored, or vex.w=1 */
                x86_dctx->osize = X86_OSIZE_64BIT;
            }
            else
            {
                if(flags & X86_FLAG_D64)
                {
                    /* 
                        default operand size is 64 bit and cannot encode 
                        32-bit operand size 
                    */  
                    x86_dctx->osize = (p ? X86_OSIZE_16BIT : X86_OSIZE_64BIT);
                }
                else
                {
                    /* default operand size: 32 bit*/
                    x86_dctx->osize = (p ? X86_OSIZE_16BIT : X86_OSIZE_32BIT);
                }
            }
        }
    }
}

static 
void
get_asize(x86_dasm_context_t* x86_dctx)
{
    /*
        D (default) field of the code-segment (CS) is assumed to be 32-bit 
        for protected mode / compatibility mode and 16-bit for real mode /
        virtual 8086 mode
    */

    /* address-size override prefix present */
    uint8_t p = x86_dctx->pfx_p_asize;

    if(x86_dctx->dmode == X86_DMODE_16BIT)
    {
        /* assumed default address size: 16 bit */
        x86_dctx->asize = (p ? X86_ASIZE_32BIT : X86_ASIZE_16BIT);
    }
    else if(x86_dctx->dmode == X86_DMODE_32BIT)
    {
        /* assumed default address size: 32 bit */
        x86_dctx->asize = (p ? X86_ASIZE_16BIT : X86_ASIZE_32BIT);
    }
    else // x86_dctx->dmode == X86_DMODE_64BIT
    {
        /* assumed default address size: 64 bit */
        x86_dctx->asize = (p ? X86_OSIZE_32BIT : X86_OSIZE_64BIT);
    }
}

static 
void
decode_sib(x86_dasm_context_t* x86_dctx, uint8_t* disp_size)
{
    uint8_t base = SIB_BASE(get_sib(x86_dctx));
    uint8_t mod = MODRM_MOD(get_modrm(x86_dctx));

    if(x86_dctx->dmode == X86_DMODE_64BIT)
    {
        /*
            in long mode the REX.X/VEX.X/XOP.X fields extend the SIB.I field, 
            the REX.B/VEX.B/XOP.B fields extend the SIB.B field, and 
            currently there can be no REX prefix if a VEX prefix is 
            present (result is #UD)
        */
        if(x86_dctx->pfx_p_rex)
        {
            base |= (REX_B << 3);
        }
        else
        if(x86_dctx->pfx_p_vex3b)
        {
            base |= (VEX_3B_B << 3);
        }
        else
        if(x86_dctx->pfx_p_xop)
        {
            base |= (XOP_B << 3);
        }
    }

    /* effective address depends on addressing size */
    if( x86_dctx->asize == X86_ASIZE_32BIT ||
        x86_dctx->asize == X86_ASIZE_64BIT ) 
    {
        /* rbp, r13 */
        if(base == 5 || base == 13) 
        {
            if(mod == 1)
            {
                *disp_size = X86_DISP_8;
            }
            else
            {
                *disp_size = X86_DISP_32;
            }
        }
    }
}

static 
void
decode_modrm(x86_dasm_context_t* x86_dctx)
{
    uint8_t mod = MODRM_MOD(get_modrm(x86_dctx));
    uint8_t rm = MODRM_RM(get_modrm(x86_dctx));

    /* register-direct addressing mode */
    if(mod == 3)
    {
        return;
    }

    if(x86_dctx->dmode == X86_DMODE_64BIT)
    {
        /*
            in long mode the REX.B/VEX.B/XOP.B fields extend the MODRM.RM 
            field, and currently there can be no REX prefix if a VEX prefix 
            is present (result is #UD)
        */
        if(x86_dctx->pfx_p_rex)
        {
            rm |= (REX_B << 3);
        }
        else
        if(x86_dctx->pfx_p_vex3b)
        {
            rm |= (VEX_3B_B << 3);
        }
        else
        if(x86_dctx->pfx_p_xop)
        {
            rm |= (XOP_B << 3);
        }
    }
    
    /* mod = !11b, register-indirect addressing */
    uint8_t disp_size = X86_DISP_NONE;

    /* effective address depends on addressing size */
    if(x86_dctx->asize == X86_ASIZE_16BIT)
    {
        /* REX.B/VEX.B/XOP.B is ignored */
        rm &= 7;

        if(mod == 0 && rm == 6)
        {
            disp_size = X86_DISP_16;
        }
        else
        {
            disp_size = (mod == 1 ? X86_DISP_8 : disp_size);
            disp_size = (mod == 2 ? X86_DISP_16 : disp_size);
        }
    }
    else /* X86_ASIZE_32BIT, X86_ASIZE_64BIT */
    {
        /* REX.B/VEX.B/XOP.B is ignored */
        if(mod == 0 && (rm & 7) == 5)
        {
            disp_size = X86_DISP_32;
        }

        /* if EVEX: X86_DISP_8 * N, else... */
        disp_size = (mod == 1 ? X86_DISP_8 : disp_size); 
        disp_size = (mod == 2 ? X86_DISP_32 : disp_size);

        /* REX.B/VEX.B/XOP.B is ignored */
        if((rm & 7) == 4)
        {
            /* SIB byte follows the ModR/M byte */
            decode_sib(x86_dctx, &disp_size);
        } 
    }

    /* consume the displacement */
    if(disp_size != X86_DISP_NONE)
    {
        /*
            X86_DISP_8  = 1
            X86_DISP_16 = 2
            X86_DISP_32 = 3
        */
        x86_dctx->pos_disp = x86_dctx->pos;
        x86_dctx->disp_size = 1 << (disp_size - 1);

        consume_bytes(x86_dctx, x86_dctx->disp_size);
    }
}

static 
int
decode_prefixes(x86_dasm_context_t* x86_dctx)
{
    size_t i;

    uint8_t* p = x86_dctx->ip;
    
    /* loop only until max instruction length */
    for(i = 0; i < MAX_INST_LENGTH; i++)
    {
        /* check for REX prefix separately */
        if(REX_PREFIX(p[i]))
        {
            if(x86_dctx->dmode == X86_DMODE_64BIT)
            {
                x86_dctx->pfx_last = p[i];
                x86_dctx->pfx_rex = p[i];
                x86_dctx->pos_rex = i;
                x86_dctx->pfx_p_rex = true;
            }
            else
            {
                /* 
                    not in long mode, so the opcode must be an inc/dec 
                    instruction and we are done decoding prefixes 
                */
                break;
            }
        }
        else
        {
            /* check for all the other prefixes */
            if(p[i] == PREFIX_OSIZE)
            {
                x86_dctx->pfx_last = p[i];
                x86_dctx->pfx_p_osize = true;
                
                /* 
                    if the prefixes F2h, F3h are present, then it seems 
                    that the prefix 66h is ignored and between F2h and
                    F3h the one that comes later has precedence
                */
                if( x86_dctx->pfx_mandatory != PREFIX_REPNE &&
                    x86_dctx->pfx_mandatory != PREFIX_REP)
                {
                    x86_dctx->pfx_mandatory = p[i];
                }
            }
            else if(p[i] == PREFIX_ASIZE)
            {
                x86_dctx->pfx_last = p[i];
                x86_dctx->pfx_p_asize = true;
            }
            else if(p[i] == PREFIX_SEGOVRD_CS || 
                    p[i] == PREFIX_SEGOVRD_DS ||
                    p[i] == PREFIX_SEGOVRD_ES ||
                    p[i] == PREFIX_SEGOVRD_SS )
            {
                x86_dctx->pfx_seg = p[i];

                /* these segment override pfxs are ignored in long mode */
                if(x86_dctx->dmode != X86_DMODE_64BIT)
                {
                    /* last segment override prefix wins */
                    x86_dctx->pfx_last = p[i];
                    x86_dctx->pfx_p_seg = true;
                }              
            }
            else if(p[i] == PREFIX_SEGOVRD_FS ||
                    p[i] == PREFIX_SEGOVRD_GS )
            {
                x86_dctx->pfx_seg = p[i];

                /* last segment override prefix wins */
                x86_dctx->pfx_last = p[i];
                x86_dctx->pfx_p_seg = true;                
            }
            else if(p[i] == PREFIX_LOCK)
            {
                x86_dctx->pfx_last = p[i];
                x86_dctx->pfx_p_lock = true;
            }
            else if(p[i] == PREFIX_REPNE)
            {
                x86_dctx->pfx_last = p[i];
                x86_dctx->pfx_mandatory = p[i];
                x86_dctx->pfx_p_repne = true;
            }
            else if(p[i] == PREFIX_REP)
            {
                x86_dctx->pfx_last = p[i];
                x86_dctx->pfx_mandatory = p[i];
                x86_dctx->pfx_p_rep = true;
            }
            else
            {
                break;
            }
        }
    }

    /* instruction's size exceeded the limit! */
    if(i == MAX_INST_LENGTH)
    {
        return -1;
    }

    /*
        REX prefix
    */
    if(x86_dctx->dmode == X86_DMODE_64BIT)
    {
        /* 
            REX prefix is only valid in long mode (64-bit mode) and if used, 
            the REX prefix byte must immediately precede the opcode byte or 
            the escape opcode byte (0FH). When a REX prefix is used in 
            conjunction with an instruction containing a mandatory prefix, 
            the mandatory prefix must come before the REX so the REX prefix 
            can be immediately preceding the opcode or the escape byte. Other 
            placements are ignored. The instruction-size limit of 15 bytes 
            still applies to instructions with a REX prefix.
        */
        if(!REX_PREFIX(x86_dctx->pfx_last))
        {
            /* ignore it */
            x86_dctx->pfx_rex = 0;
            x86_dctx->pos_rex = 0;
            x86_dctx->pfx_p_rex = false;
        }
    }

    /*
        VEX, EVEX, XOP prefixes
    */
    const unsigned int vex_xop_tbl_selectors[] = 
    {
        0,
        PREFIX_OSIZE,
        PREFIX_REP,
        PREFIX_REPNE
    };

    if(p[i] == PREFIX_VEX_3B && (x86_dctx->dmode == X86_DMODE_64BIT || 
        VEX_3B_PM(p[i+1])))
    {
        if( i > (MAX_INST_LENGTH - 5) || 
            x86_dctx->pfx_p_osize || x86_dctx->pfx_p_rex ||
            x86_dctx->pfx_p_lock || x86_dctx->pfx_p_rep ||
            x86_dctx->pfx_p_repne )
        {
            /* 
                any VEX-encoded instruction with a REX, LOCK, 66H, F2H, 
                or F3H prefix preceding VEX will #UD
            */
            return -1;
        }
        else
        {
            x86_dctx->pfx_vex[0] = p[i+1]; /* P0 */
            x86_dctx->pfx_vex[1] = p[i+2]; /* P1 */
            x86_dctx->pfx_p_vex3b = true;

            /* check if the m-mmmm value is invalid */
            if(VEX_3B_MMMMM == 0 || VEX_3B_MMMMM > 3)
            {
                return -1;
            }

            x86_dctx->table_index = (
                (VEX_3B_MMMMM) == 0 ? TABLE_INDEX_0F : (
                (VEX_3B_MMMMM) == 1 ? TABLE_INDEX_0F : (
                (VEX_3B_MMMMM) == 2 ? TABLE_INDEX_0F38 : TABLE_INDEX_0F3A)));
            
            x86_dctx->pfx_mandatory = vex_xop_tbl_selectors[VEX_3B_PP];

            /* update the position */
            i += 3;
        }
    }
    else
    if(p[i] == PREFIX_VEX_2B && (x86_dctx->dmode == X86_DMODE_64BIT || VEX_2B_PM(p[i+1])))
    {
        if( i > (MAX_INST_LENGTH - 4) || 
            x86_dctx->pfx_p_osize || x86_dctx->pfx_p_rex ||
            x86_dctx->pfx_p_lock || x86_dctx->pfx_p_rep ||
            x86_dctx->pfx_p_repne )
        {
            /* 
                any VEX-encoded instruction with a REX, LOCK, 66H, F2H, 
                or F3H prefix preceding VEX will #UD
            */
            return -1;
        }
        else
        {
            x86_dctx->pfx_vex[0] = p[i+1]; /* P0 */
            x86_dctx->pfx_p_vex2b = true;

            x86_dctx->table_index = TABLE_INDEX_0F;
            x86_dctx->pfx_mandatory = vex_xop_tbl_selectors[VEX_2B_PP];

            /* update the position */
            i += 2;
        }
    }
    else
    if(p[i] == PREFIX_EVEX && (x86_dctx->dmode == X86_DMODE_64BIT || EVEX_PM(p[i+1])))
    {
        /* 
            currently dont support EVEX prefix until better 
            documentation is released...and someone cares enough to add it
        */
        return -1;
    }
    else
    if(p[i] == PREFIX_XOP && (x86_dctx->dmode == X86_DMODE_64BIT || XOP_PM(p[i+1])) && XOP_VALID(p[i+1]))
    {
        if( i > (MAX_INST_LENGTH - 5) || 
            x86_dctx->pfx_p_osize || x86_dctx->pfx_p_rex ||
            x86_dctx->pfx_p_lock || x86_dctx->pfx_p_rep ||
            x86_dctx->pfx_p_repne )
        {
            /* 
                any XOP-encoded instruction with a REX, LOCK, 66H, F2H, 
                or F3H prefix preceding VEX will #UD
            */
            return -1;
        }
        else
        {
            x86_dctx->pfx_xop[0] = p[i+1]; /* P0 */
            x86_dctx->pfx_xop[1] = p[i+2]; /* P1 */
            x86_dctx->pfx_p_xop = true;

            /* check if the pp value is invalid */
            if(XOP_PP != 0 || (XOP_MMMMM - 8) > 2)
            {
                return -1;
            }

            x86_dctx->table_index = (
                (XOP_MMMMM - 8) == 0 ? TABLE_INDEX_XOP_08 : (
                (XOP_MMMMM - 8) == 1 ? TABLE_INDEX_XOP_09 : TABLE_INDEX_XOP_0A));

            x86_dctx->pfx_mandatory = vex_xop_tbl_selectors[XOP_PP];
            
            /* update the position */
            i += 3;
        }
    }
    else
    if(p[i] == ESCAPE_OPCODE_2B)
    {
        if(p[i+1] == ESCAPE_OPCODE_3B_1)
        {
            x86_dctx->table_index = TABLE_INDEX_0F38;

            /* update the position */
            i += 2;
        }
        else if(p[i+1] == ESCAPE_OPCODE_3B_2)
        {
            x86_dctx->table_index = TABLE_INDEX_0F3A;

            /* update the position */
            i += 2;
        }
        else
        {
            x86_dctx->table_index = TABLE_INDEX_0F;
            
            /* update the position */
            i++;
        }
    }
    else
    {
        /* one-byte table */
        x86_dctx->pfx_mandatory = 0;
        x86_dctx->table_index = TABLE_INDEX_ONEBYTE;
    }

    /* update the position in the buffer */
    x86_dctx->pos = i;
    x86_dctx->pos_opcode = x86_dctx->pos;

    return i;
}

static 
void
decode_flags(x86_dasm_context_t* x86_dctx, const uint32_t flags)
{
    /* decoding has to be sequential, as there may be multiple flags set */
    if(flags == F_NONE)
    {
        return;
    }

    if(flags & F_MODRM)
    {
        decode_modrm(x86_dctx);
    }

    if(flags & F_Z)
    {
        /* data encoded as word for 16-bit osize or dword for 32 or 64-bit osize */
        consume_bytes(x86_dctx, (x86_dctx->osize == X86_OSIZE_16BIT ? 2 : 4));
    }

    if(flags & F_B)
    {
        /* byte, regardless of operand-size attribute */
        consume_bytes(x86_dctx, 1);
    }

    if(flags & F_INT_O)
    {
        /* the offset of the operand is coded as a word or double word (depending on address size) */
        consume_bytes(x86_dctx, (
            x86_dctx->asize == X86_ASIZE_16BIT ? 2 : (
            x86_dctx->asize == X86_ASIZE_32BIT ? 4 : 8)));
    }

    if(flags & F_INT_V)
    {
        /* word, doubleword or quadword (in 64-bit mode), depending on operand-size */
        consume_bytes(x86_dctx, (
            x86_dctx->osize == X86_OSIZE_16BIT ? 2 : (
            x86_dctx->osize == X86_OSIZE_32BIT ? 4 : 8)));
    }

    if(flags & F_INT_W)
    {
        /* word, regardless of operand-size attribute */
        consume_bytes(x86_dctx, 2);
    }

    if(flags & F_INT_D)
    {
        /* doubleword, regardless of operand-size attribute */
        consume_bytes(x86_dctx, 4);
    }

    if(flags & F_INT_AP)
    {
        /* direct address, 32-bit, 48-bit, or 80-bit pointer, depending on operand-size */
        consume_bytes(x86_dctx, (
            x86_dctx->osize == X86_OSIZE_16BIT ? 2 : (
            x86_dctx->osize == X86_OSIZE_32BIT ? 4 : 8)));
        
        consume_bytes(x86_dctx, 2);
    }
}

static 
void
decode_instruction(x86_dasm_context_t* x86_dctx)
{
#if defined(_LDASM_EXT_X86_TABLE)
    
    uint8_t* table_compressed = x86_dctx->table_compressed;
    size_t table_size = x86_dctx->table_size;
    
#else
    
    /* table generated with x86_gen_tables.c */
    volatile uint8_t table_compressed[] = 
    {
        0x41, 0x14, 0x12, 0x20, 0x41, 0x14, 0x12, 0x20, 0x41, 0x14, 0x12, 0x20, 0x41, 0x14, 0x12, 0x20, 
        0x41, 0x14, 0x12, 0x20, 0x41, 0x14, 0x12, 0x20, 0x41, 0x14, 0x12, 0x20, 0x41, 0x14, 0x12, 0xA4, 
        0x00, 0x21, 0x40, 0x12, 0x13, 0x14, 0x15, 0x40, 0x90, 0x04, 0x15, 0x13, 0x25, 0x8C, 0x01, 0x98, 
        0x00, 0x14, 0x12, 0x60, 0x88, 0x04, 0x88, 0x00, 0x25, 0x20, 0x21, 0x15, 0x13, 0x14, 0x40, 0x14, 
        0x20, 0x41, 0x24, 0x20, 0x88, 0x01, 0x88, 0x04, 0x22, 0x10, 0x14, 0x8A, 0x00, 0x21, 0x60, 0x61, 
        0x89, 0x00, 0x11, 0x10, 0x15, 0x94, 0x01, 0x40, 0x88, 0x01, 0x90, 0x00, 0xAC, 0x01, 0x20, 0x21, 
        0x45, 0x31, 0x10, 0x21, 0x20, 0x41, 0x90, 0x02, 0x90, 0x01, 0x30, 0x11, 0x15, 0x11, 0x50, 0x11, 
        0x15, 0x8D, 0x01, 0x15, 0x71, 0x15, 0x11, 0x35, 0x11, 0x88, 0x00, 0xC1, 0x01, 0x20, 0x15, 0x71, 
        0x10, 0x31, 0x10, 0x61, 0x20, 0x9A, 0x01, 0x30, 0x31, 0x90, 0x00, 0x31, 0x9D, 0x00, 0x21, 0x60, 
        0x31, 0x89, 0x00, 0x11, 0x10, 0x11, 0x10, 0x41, 0x20, 0x8A, 0x01, 0x60, 0x8A, 0x01, 0x60, 0x8A, 
        0x01, 0x9B, 0x00, 0x51, 0x90, 0x00, 0x41, 0x10, 0x31, 0x88, 0x00, 0x35, 0x10, 0x35, 0x10, 0x88, 
        0x05, 0x40, 0x65, 0x30, 0x15, 0x20, 0x35, 0x95, 0x00, 0x25, 0x60, 0x35, 0x10, 0x15, 0x10, 0x15, 
        0x30, 0x31, 0x8F, 0x00, 0x41, 0x45, 0x40, 0x88, 0x01, 0x88, 0x00, 0x88, 0x01, 0xDF, 0x00, 0x15, 
        0x90, 0x00, 0x15, 0xFF, 0x00, 0x95, 0x00, 0x31, 0x60, 0x21, 0x50, 0x31, 0x60, 0x21, 0x20, 0x21, 
        0x20, 0x11, 0x8F, 0x00, 0x11, 0x89, 0x00, 0x45, 0x88, 0x00, 0x45, 0x9C, 0x00, 0x45, 0x91, 0x00, 
        0x21, 0x8F, 0x00, 0x11, 0xED, 0x00, 0x41, 0x8C, 0x00, 0x8C, 0x01, 0xA5, 0x00, 0x31, 0x20, 0x21, 
        0x30, 0x11, 0x50, 0x31, 0x20, 0x21, 0x30, 0x11, 0x50, 0x31, 0xAC, 0x00, 0x11, 0x10, 0x11, 0xFF, 
        0x00, 0xEE, 0x00
    };
    
    size_t table_size = sizeof(table_compressed);
    
#endif
    
    /* fetch the opcode and update the position */
    uint8_t opcode = x86_dctx->ip[x86_dctx->pos++];

    uint32_t flags = 0;
    size_t table_pos = x86_dctx->table_index + opcode;

    for(size_t i = 0, j = 0; i < table_size; i++)
    {
        uint8_t d = table_compressed[i];
        uint8_t s = ((d & 0x80) == 0 ? (d >> 4) : (d & ~0x80));
        
        flags = ((d & 0x80) == 0 ? (d & 0x0F) : table_compressed[++i]);

        /* check if the opcode's position falls between the boundary */
        if(table_pos < j + s)
        {
            break;
        }

        j += s;
    }

    /* handle the special cases for which the flags were disabled in favor of a smaller table */
    if(x86_dctx->table_index == TABLE_INDEX_ONEBYTE)
    {
        /* call, jmp */
        if(opcode == 0xE8 || opcode == 0xE9)
        {
            flags = F_Z;

            /* update the operand size */
            get_osize(x86_dctx, X86_FLAG_F64);
        }
        /* mov */
        else if(opcode >= 0xB8 && opcode <= 0xBF)
        {
            flags = F_INT_V;
        }
        /* mov */
        else if(opcode >= 0xA0 && opcode <= 0xA3)
        {
            flags = F_INT_O;
        }
        /* retn, retf */
        else if(opcode == 0xC2 || opcode == 0xCA)
        {
            flags = F_INT_W;
        }
        /* enter */
        else if(opcode == 0xC8)
        {
            flags = F_INT_W | F_B;
        }
        /* push */
        else if(opcode == 0x68)
        {
            flags = F_Z;

            /* update the operand size */
            get_osize(x86_dctx, X86_FLAG_D64);
        }
        /* jmp far, call far */
        else if(opcode == 0xEA || opcode == 0x9A)
        {
            flags = F_INT_AP;
        }
        else if(opcode == 0xF6)
        {
            uint8_t reg = MODRM_REG(get_modrm(x86_dctx));

            if(reg == 0 || reg == 1)
            {
                flags = F_MODRM | F_B;
            }
        }
        else if(opcode == 0xF7)
        {
            uint8_t reg = MODRM_REG(get_modrm(x86_dctx));

            if(reg == 0 || reg == 1)
            {
                flags = F_MODRM | F_Z;
            }
        }
    }
    else if(x86_dctx->table_index == TABLE_INDEX_0F)
    {
        /* jcc */
        if(opcode >= 0x80 && opcode <= 0x8F)
        {
            flags = F_Z;

            /* update the operand size */
            get_osize(x86_dctx, X86_FLAG_F64);
        }
        else if(opcode == 0x78)
        {
            /* insertq, extrq */
            if( x86_dctx->pfx_mandatory == PREFIX_REPNE || 
                x86_dctx->pfx_mandatory == PREFIX_OSIZE )
            {
                /* Vss, Uss, Ib, Ib */
                flags = F_MODRM | F_INT_W;
            }
        }
    }
    else if(x86_dctx->table_index == TABLE_INDEX_XOP_0A)
    {
        /* bextr, lwpins, lwpval */
        if(opcode == 0x10 || opcode == 0x12)
        {
            flags = F_MODRM | F_INT_D;
        }
    }

    decode_flags(x86_dctx, flags);
}

static 
void
decode_clear(x86_dasm_context_t* x86_dctx)
{
    x86_dctx->pos = 0;
    x86_dctx->pos_modrm = 0;
    x86_dctx->pos_sib = 0;
    x86_dctx->pos_rex = 0;
    x86_dctx->pos_opcode = 0;
    x86_dctx->pos_disp = 0;

    x86_dctx->pfx_rex = 0;
    x86_dctx->pfx_last = 0;
    x86_dctx->pfx_seg = 0;
    x86_dctx->pfx_mandatory = 0;

    x86_dctx->pfx_p_rex = false;
    x86_dctx->pfx_p_seg = false;
    x86_dctx->pfx_p_osize = false;
    x86_dctx->pfx_p_asize = false;
    x86_dctx->pfx_p_lock = false;
    x86_dctx->pfx_p_rep = false;
    x86_dctx->pfx_p_repne = false;
    x86_dctx->pfx_p_vex2b = false;
    x86_dctx->pfx_p_vex3b = false;
    x86_dctx->pfx_p_xop = false;
    
    x86_dctx->p_vsib = false;
    x86_dctx->p_modrm = false;
    x86_dctx->p_sib = false;

    x86_dctx->table_index = ~0;
    x86_dctx->disp_size = 0;
}

/****************************************************************************

    entrypoint

****************************************************************************/

/*

    x86-64 legacy instruction format:

         #       0,1   1,2,3      0,1    0,1   0,1,2,4    0,1,2,4
    +----------+-----+--------+--------+-----+----------+---------+
    | prefixes | REX | OPCODE | MODR/M | SIB |   DISP   |   IMM   |
    +----------+-----+--------+--------+-----+----------+---------+

    note: in 64-bit mode, in some cases disp or imm can be 8 bytes
    (for example check mov: A0-A3 and B8)


    VEX/XOP instruction format:
        
         #          2,3          1        1      0,1   0,1,2,4    0,1
    +----------+-------------+--------+--------+-----+----------+-----+
    | SEG, 67h | VEX2B/VEX3B | OPCODE | MODR/M | SIB |   DISP   | IMM |
    +----------+-------------+--------+--------+-----+----------+-----+

    
    
    3DNow! instruction format:

         2            1          1      0,1,2,4           1
    +----------+-------------+--------+----------+----------------+
    | 0Fh 0Fh  |   MODR/M    |  SIB   |   DISP   | 3DNow!_suffix  |
    +----------+-------------+--------+----------+----------------+

*/

int
x86_ldasm(x86_dasm_context_t* x86_dctx, unsigned int dmode, uint8_t* ip)
{
#if !defined(_LDASM_EXT_X86_TABLE)
    
    x86_dasm_context_t x86_dctx_local;

    if(x86_dctx == NULL)
    {
        x86_dctx = &x86_dctx_local;
    }
    
#endif

    /* clear the dasm context */
    decode_clear(x86_dctx);

    x86_dctx->ip = ip;

    if(dmode > X86_DMODE_64BIT)
    {
        x86_dctx->dmode = (
            dmode == 16 ? X86_DMODE_16BIT : (
            dmode == 32 ? X86_DMODE_32BIT : X86_DMODE_64BIT));
    }
    else
    {
        x86_dctx->dmode = dmode;
    }

    /* function parses the prefixes (until opcode, excluded) */
    if(decode_prefixes(x86_dctx) < 0)
    {
        return -1;
    }

    /* determine the addressing and operand size */
    get_asize(x86_dctx);
    get_osize(x86_dctx, 0);

    decode_instruction(x86_dctx);

    return x86_dctx->len;
}

#if defined(_LDASM_EXT_X86_TABLE)

int
__attribute__((stdcall,optimize("O1")))
x86_ldasm_ext_table(x86_dasm_context_t* x86_dctx, unsigned int dmode, uint8_t* ip)
{
    x86_dasm_context_t x86_dctx_local;

    if(x86_dctx == NULL)
    {
        x86_dctx = &x86_dctx_local;
    }
    
    x86_dctx->table_compressed = (uint8_t *)0xDEADC0DE;
    x86_dctx->table_size = 0xBAADF00D;
    
    return x86_ldasm(x86_dctx, dmode, ip);
}

#endif
