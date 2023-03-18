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
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <getopt.h>
#include <errno.h>
#include <inttypes.h>

#include "x86_ldasm.h"

#define align_up(val, alignment) \
    ((val + alignment - 1) - ((val + alignment - 1) % alignment))

/*
    Packs the 4-bit information into a byte
    Table size reduction: 50% for both tables
*/
static
size_t 
table_pack(uint8_t* in, size_t size, uint8_t* out)
{
    size_t i = 0;

    while(i < size)
    {
        /* odd sizes: pad with zero */
        if(i+1 == size) 
            out[i/2] = (in[i] << 4);
        else
            out[i/2] = (in[i] << 4 | in[i+1]);

        i += 2;
    }

    return i/2;
}

/*
    Compresses the 4-bit information by using a simple run-length encoding (RLE) algorithm
    Table size reduction: ~80% for x86_table, ~92% for x86_table_xop
*/
static
size_t
table_compress(uint8_t* in, size_t size, uint8_t* out)
{
    size_t i = 0;
    size_t n = 0;

    while(i < size)
    {
        size_t j;
        uint8_t d = in[i];

        /* consecutive identical values count */
        for(j = 0; (i+j) < size && in[i+j] == d && j < 127; j++);

        /* encode the size as a 3-bit value or 7-bit */
        if(j > 7)
        {
            out[n++] = (1 << 7 | j);
            out[n++] = d;
        }
        else
        {
            out[n++] = (j << 4 | d);
        }

        i += j;
    }

    return n;
}

static
void
table_gen_and_print(uint8_t* in, size_t size, const char* name)
{
    /* output table, either compressed or packed */
    uint8_t out[size];

    /* compress the table */
    size_t n = table_compress(in, size, out);

    printf("uint8_t %s[%lu] = \n{\n", name, n);

    for(size_t i = 0; i < n; i++)
    {
        printf("0x%02X, ", out[i]);

        if((i+1) % 16 == 0)
            printf("\n");
    }

    printf("\n};\n\n");
}

static
void
table_gen_and_print_asm_nodata(uint8_t* in, size_t size)
{
    /* output table, either compressed or packed */
    uint8_t out[size];
    
    memset(out, 0, size);

    /* compress the table */
    int n = (int)table_compress(in, size, out);
    
    /* 32-bit */
    printf("; --- 32-BIT --- TABLE SIZE: %08X\n", n);
    
    for(int i = align_up(n, sizeof(uint32_t)) - sizeof(uint32_t); 
        i >= 0; i -= sizeof(uint32_t))
    {
        printf("push 0%08XH\n", *(uint32_t *)&out[i]);
    }
    
    printf("add esp, 0%XH\n\n", (uint32_t)align_up(n, sizeof(uint32_t)));

    /* 64-bit */
    printf("; --- 64-BIT --- TABLE SIZE: %08X\n", n);
    
    for(int i = align_up(n, sizeof(uint64_t)) - sizeof(uint64_t); 
        i >= 0; i -= sizeof(uint64_t))
    {
        // alt: mov rax, imm64; push rax
        printf("push 0%08XH\n", *(uint32_t *)&out[i]);
        printf("mov dword [rsp+04H], 0%08XH\n", *(uint32_t *)&out[i + sizeof(uint32_t)]);
    }
    
    printf("add rsp, 0%XH\n\n", (uint32_t)align_up(n, sizeof(uint64_t)));
}

int 
main(int argc, char* argv[])
{
    table_gen_and_print(x86_table, countof(x86_table), "x86_table_compressed");
    table_gen_and_print_asm_nodata(x86_table, countof(x86_table));
    
    return EXIT_SUCCESS;
}

/***************************************************************************/




