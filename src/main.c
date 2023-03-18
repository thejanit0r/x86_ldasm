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
#include "x86_ldasm_precompiled.h"

void
usage(char* progname)
{
    printf("\n"
        "****************************************************\n"
        "*                                                  *\n"
        "*      x86-64 instruction length disassembler      *\n"
        "*               *********************              *\n"
        "*                    the`janitor                   *\n"
        "*                                                  *\n"
        "****************************************************\n\n");

    printf("Usage: %s -f <filename> -m <16|32|64> [-h]\n", progname);
}

int 
main(int argc, char* argv[])
{
    /* file path to disasm */
    char* filename = NULL;

    /* disasm mode */
    ulong_t dmode = 0;

    x86_dasm_context_t x86_dctx;

    /* clear the dasm context */
    memset(&x86_dctx, 0, sizeof(x86_dctx));

    for(int c; (c = getopt(argc, argv, "f:m:i:h")) != -1; )
    {
        switch(c)
        {
            case 'h':
                usage(argv[0]);
                return EXIT_SUCCESS;
            case 'f':
                filename = optarg;
                break;
            case 'm':
                dmode = strtoul(optarg, NULL, 10);
                break;
            case '?':
                printf("Option -%c requires an argument\n", optopt);
                return EXIT_FAILURE;
            default:
                break;
        }

        /* exit on bad arguments */
        if(errno != 0)
        {
            printf("Bad argument for option -%c\n", c);
            return EXIT_FAILURE;
        }
    }

    /* check that the file path was provided */
    if(filename == NULL)
    {
        printf("No file name provided\n");
        usage(argv[0]);
        return EXIT_FAILURE;
    }

    /* check that the disasm mode was provided */
    switch(dmode)
    {
        case 16: x86_dctx.dmode = X86_DMODE_16BIT; break;
        case 32: x86_dctx.dmode = X86_DMODE_32BIT; break;
        case 64: x86_dctx.dmode = X86_DMODE_64BIT; break;
        default:
            printf("Invalid disasm mode\n");
            usage(argv[0]);
            return EXIT_FAILURE;
    }

    FILE* fd;
    size_t fsize;
    size_t j = 0;

    /* open the raw binary file */
    if((fd = fopen(filename, "rb")) == NULL)
    {
        printf("Failed to open %s\n", filename);
        return EXIT_FAILURE;
    }

    /* get the file size */
    fseek(fd, 0, SEEK_END); fsize = ftell(fd);
    rewind(fd);

    /* allocate enough memory */
    uint8_t* code = (uint8_t *)malloc(fsize * sizeof(uint8_t));

    if(code == NULL)
    {
        printf("Failed to allocate memory\n");
        return EXIT_FAILURE;
    }

    /* read the binary file into memory */
    fread(code, 1, fsize, fd);
    fclose(fd);

    /* disassemble the code */
    while(j < fsize)
    {
        int len = x86_ldasm(&x86_dctx, x86_dctx.dmode, &code[j]);

#if defined(_LDASM_PRECOMPILED_H_)

        /* test the pre-compiled version */
        x86_ldasm_t x86_ldasm_pre = (x86_ldasm_t)x86_ldasm_lin64_bin;

        if(x86_ldasm_pre(&x86_dctx, x86_dctx.dmode, &code[j]) != len)
        {
            printf("%04" PRIX32 " | ", j);
            printf("Critical error: length mismatch!\n");

            return EXIT_FAILURE;
        }

#endif

        if(len < 0)
        {
            printf("Failed to disasm\n");

            return EXIT_FAILURE;
        }
        else
        {
            printf("%04" PRIX32 " | ", j);

            /* print the bytes */

            for(int i = 0; i < 16 - x86_dctx.len; i++)
                printf("   ");

            for(int i = 0; i < x86_dctx.len; i++)
                printf("%02X ", code[j+i]);

            /* print some info about the instruction */

            printf(" | LEN: %02i | OPCODE: %02X", 
                x86_dctx.len, code[j+x86_dctx.pos_opcode]);

            if(x86_dctx.p_modrm)
            {
                printf(" | MODRM: %02X", x86_dctx.modrm);
            }

            if(x86_dctx.p_sib)
            {
                printf(" | SIB: %02X", x86_dctx.sib);
            }

            if(x86_dctx.disp_size > 0)
            {
                printf(" | DISP: %X", 
                    (x86_dctx.disp_size == 1 ? *(uint8_t *)&code[j+x86_dctx.pos_disp] : (
                    (x86_dctx.disp_size == 2 ? *(uint16_t *)&code[j+x86_dctx.pos_disp] : 
                                                *(uint32_t *)&code[j+x86_dctx.pos_disp]))));
            }

            printf("\n");

            j += x86_dctx.len;
        }
    }

    free(code);

    return EXIT_SUCCESS;
}

/***************************************************************************/




