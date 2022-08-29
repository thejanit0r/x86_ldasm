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
#ifndef _LDASM_TABLES_H_
#define _LDASM_TABLES_H_

#include "types.h"

#ifdef __cplusplus
    extern "C" {
#endif

/****************************************************************************

    Instruction format

****************************************************************************/

/* 
    the total number of bytes in an instruction encoding must be less than
    or equal to 15
*/
#define MAX_INST_LENGTH 15

#define ESCAPE_OPCODE_2B    0x0f
#define ESCAPE_OPCODE_3B_1  0x38
#define ESCAPE_OPCODE_3B_2  0x3a

/*
    MODRM byte

    bits 0-2: rm  (rex.b, vex.b, xop.b extend this field to 4 bits)
    bits 3-5: reg (rex.r, vex.r, xop.r extend this field to 4 bits)
    bits 6-7: mod
*/
#define MODRM_RM(b)         ((b >> 0) & 7)
#define MODRM_REG(b)        ((b >> 3) & 7)
#define MODRM_MOD(b)        ((b >> 6) & 3)

/*
    SIB byte

    bits 0-2: base  (rex.b extends this field to 4 bits)
    bits 3-5: index (rex.x extends this field to 4 bits)
    bits 6-7: scale (00 = 1, 01 = 2, 10 = 4, 11 = 8)

    effective_address = scale * index + base + disp8/16/32
*/
#define SIB_BASE(b)         ((b >> 0) & 7)
#define SIB_INDEX(b)        ((b >> 3) & 7)
#define SIB_SCALE(b)        ((b >> 6) & 3)

/*
    REX byte

    bit 0: b (msb extension of modrm.rm or sib.base or opcode reg field)
    bit 1: x (msb extension of sib.index)
    bit 2: r (msb extension of modrm.reg)
    bit 3: w (0 = default operand size, 1 = 64-bit operand size)
*/
#define REX_PREFIX(b)       (((b >> 4) & 0x0f) == 4)
#define _REX_B(b)           ((b >> 0) & 1)
#define _REX_X(b)           ((b >> 1) & 1)
#define _REX_R(b)           ((b >> 2) & 1)
#define _REX_W(b)           ((b >> 3) & 1)

/*
    VEX 2-byte
*/
#define _VEX_2B_PP(b)       ((b >> 0) & 3)
#define _VEX_2B_L(b)        ((b >> 2) & 1)
#define _VEX_2B_VVVV(b)     ((~(b >> 3)) & 0x0f)
#define _VEX_2B_R(b)        ((~(b >> 7)) & 1)

#define VEX_2B_PM(b)        (MODRM_MOD(b) == 3) /* LDS must have modrm.mod = !11b */

/*
    VEX 3-byte
*/
#define _VEX_3B_MMMMM(b)    ((b >> 0) & 0x1f)
#define _VEX_3B_B(b)        ((~(b >> 5)) & 1)
#define _VEX_3B_X(b)        ((~(b >> 6)) & 1)
#define _VEX_3B_R(b)        ((~(b >> 7)) & 1)

#define _VEX_3B_PP(b)       ((b >> 0) & 3)
#define _VEX_3B_L(b)        ((b >> 2) & 1)
#define _VEX_3B_VVVV(b)     ((~(b >> 3)) & 0x0f)
#define _VEX_3B_W(b)        ((b >> 7) & 1)

#define VEX_3B_PM(b)        (MODRM_MOD(b) == 3) /* LES must have modrm.mod = !11b */

/*
    XOP
*/
#define _XOP_MMMMM(b)       ((b >> 0) & 0x1f)
#define _XOP_B(b)           ((~(b >> 5)) & 1)
#define _XOP_X(b)           ((~(b >> 6)) & 1)
#define _XOP_R(b)           ((~(b >> 7)) & 1)

#define _XOP_PP(b)          ((b >> 0) & 3)
#define _XOP_L(b)           ((b >> 2) & 1)
#define _XOP_VVVV(b)        ((~(b >> 3)) & 0x0f)
#define _XOP_W(b)           ((b >> 7) & 1)

#define XOP_PM(b)           (MODRM_MOD(b) == 3)
#define XOP_VALID(b)        (_XOP_MMMMM(b) > 7 && _XOP_MMMMM(b) < 11)

/*
    EVEX
*/
#define _EVEX_B(b)          ((~(b >> 5)) & 1)
#define _EVEX_X(b)          ((~(b >> 6)) & 1) 
#define _EVEX_R(b)          ((~(b >> 7)) & 1)
#define _EVEX_RR(b)         ((~(b >> 4)) & 1) /* R' */
#define _EVEX_MM(b)         ((b >> 0) & 3)

#define _EVEX_PP(b)         ((b >> 0) & 3)
#define _EVEX_W(b)          ((b >> 7) & 1)
#define _EVEX_VVVV(b)       ((~(b >> 3)) & 0x0f)

#define _EVEX_Z(b)          ((b >> 7) & 1) 
#define _EVEX_LL(b)         ((b >> 6) & 1) /* L' */
#define _EVEX_L(b)          ((b >> 5) & 1) 
#define _EVEX_BB(b)         ((b >> 4) & 1)
#define _EVEX_VV(b)         ((~(b >> 3)) & 1) /* V' */
#define _EVEX_AAA(b)        ((b >> 0) & 7)

#define EVEX_P0(b)          (((b >> 2) & 3) == 0) /* check on P0, else #UD */
#define EVEX_P1(b)          (((b >> 2) & 1) == 1) /* check on P1, else #UD */
#define EVEX_PM(b)          (MODRM_MOD(b) == 3) /* BOUND must have modrm.mod = !11b */


/*
    Prefixes
*/
#define PREFIX_OSIZE        0x66 /* operand-size override */
#define PREFIX_ASIZE        0x67 /* address-size override */
#define PREFIX_SEGOVRD_CS   0x2e /* segment override, ignored in 64-bit mode */
#define PREFIX_SEGOVRD_DS   0x3e /* segment override, ignored in 64-bit mode */
#define PREFIX_SEGOVRD_ES   0x26 /* segment override, ignored in 64-bit mode */
#define PREFIX_SEGOVRD_FS   0x64 /* segment override */
#define PREFIX_SEGOVRD_GS   0x65 /* segment override */
#define PREFIX_SEGOVRD_SS   0x36 /* segment override, ignored in 64-bit mode */
#define PREFIX_LOCK         0xf0 /* lock rw atomically */
#define PREFIX_REPNE        0xf2
#define PREFIX_REP          0xf3
#define PREFIX_BRT          0x2e /* branch taken (hint), only with jcc */
#define PREFIX_BRNT         0x3e /* branch not taken (hint), only with jcc */
#define PREFIX_VEX_3B       0xc4
#define PREFIX_VEX_2B       0xc5
#define PREFIX_EVEX         0x62
#define PREFIX_XOP          0x8f

/****************************************************************************

    Flags

    NB: in order to reduce the amount of information neededas much as reasonable, 
    some flags have been disabled; these will have to be handled in code.

    Reasonable means that the vast majority of the entries use the 
    enabled flags, i.e. F_NONE, F_MODRM, F_B and F_Z

    It is possible to further reduce the amount of information at 
    the cost of added logic.

****************************************************************************/

enum
{
    F_NONE = 0,

/*
    the operand size is forced to a 64-bit operand size when in 64-bit mode 
    (prefixes that change operand size are ignored for this instruction in 
    64-bit mode).
*/
    F_F64 = F_NONE, /* disabled, will be handled in code */

/*
    when in 64-bit mode, instruction defaults to 64-bit operand size and 
    cannot encode 32-bit operand size.
*/
    F_D64 = F_NONE, /* disabled, will be handled in code */

/*
    AM_C: the reg field of the ModR/M byte selects a control register
    AM_D: the reg field of the ModR/M byte selects a debug register
    AM_G: the reg field of the ModR/M byte selects a general register
    AM_P: the reg field of the ModR/M byte selects a packed quadword
    AM_S: the reg field of the ModR/M byte selects a segment register
    AM_V: the reg field of the ModR/M byte selects a 128-bit XMM register or a 256-bit YMM register
    
    AM_E: the ModR/M byte follows the opcode and specifies the operand (reg or mem)
    AM_M: the ModR/M byte may refer only to memory
    AM_N: the R/M field of the ModR/M byte selects a packed-quadword
    AM_Q: the ModR/M byte follows the opcode and specifies the operand (mmx or mem)
    AM_R: the R/M field of the ModR/M byte may refer only to a general register
    AM_U: the R/M field of the ModR/M byte selects a 128-bit XMM register or a 256-bit YMM register
    AM_W: the ModR/M byte follows the opcode and specifies the operand (xmm, ymm or mem)
*/
    F_MODRM = (1 << 0),

/*
    the following flags indicate that data is encoded in the instruction

    AM_I: the instruction contains immediate data
    AM_J: the instruction contains a relative offset
    AM_O: the offset of the operand is coded as a word or double word in the instruction
*/
    F_Z = (1 << 1), /* word for 16-bit operand-size or doubleword for 32 or 64-bit operand-size */
    F_B = (1 << 2), /* byte, regardless of operand-size attribute */
    
    /* disabled flags, will be handled in code with internal flags */

    F_O = F_NONE, /* the offset of the operand is coded as a word or double word (depending on address size) */
    F_V = F_NONE, /* word, doubleword or quadword (in 64-bit mode), depending on operand-size */
    F_W = F_NONE, /* word, regardless of operand-size attribute */
    F_D = F_NONE, /* doubleword, regardless of operand-size attribute */
    F_AP = F_NONE, /* direct address, 32-bit, 48-bit, or 80-bit pointer, depending on operand-size */

    /* internal flags */

    F_INT_O = (1 << 3),
    F_INT_V = (1 << 4),
    F_INT_W = (1 << 5),
    F_INT_D = (1 << 6),
    F_INT_AP = (1 << 7)
};

#define TABLE_INDEX_ONEBYTE     (0 * 256)
#define TABLE_INDEX_0F          (1 * 256)
#define TABLE_INDEX_0F38        (2 * 256)
#define TABLE_INDEX_0F3A        (3 * 256)
#define TABLE_INDEX_XOP_08      (4 * 256)
#define TABLE_INDEX_XOP_09      (5 * 256)
#define TABLE_INDEX_XOP_0A      (6 * 256)

/****************************************************************************

    Declarations / exports

****************************************************************************/

extern uint8_t x86_table[7 * 256];

#ifdef __cplusplus
    }
#endif

#endif //_LDASM_TABLES_H_