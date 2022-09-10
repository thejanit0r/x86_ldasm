# x86_ldasm

`x86_ldasm` is a relatively compact x86-64 **instruction length** disassembler based on a stripped down and heavily modified version of [`x86_dasm`](https://github.com/thejanit0r/x86_dasm). It is fully C99 compliant.

- No external library dependencies
- No dynamic memory allocation
- Supports all x86 and x86-64/AMD64 instructions and most ISA extensions
- Extended information such as PREFIXES (incl. VEX/XOP), OPCODE, MODRM, SIB, DISP
- **Single-header precompiled position independent code (32/64 bit)**
    - @`include/x86_ldasm_precompiled.h`

NB: This library is not particularly well-suited for disassembling "hostile" code (malformed, invalid, undefined behavior, etc.) since most of the error detection logic has been stripped out in favor of a smaller size. It should have no problems in correctly disassembling regular compiler-generated code.

# Build

```bash
make clean && make all
```

# Usage example

```c
x86_dasm_context_t x86_dctx = {0};

uint8_t code[] = {
    0xeb, 0xfe
};

// Use the regular C library

// disassemble 32-bit code
int len = x86_ldasm(&x86_dctx, X86_DMODE_32BIT, code);

if(len > 0)
{
    printf("Instruction's length: %02i", len);
    
    //
    // print additional info such as:
    //      OPCODE, MODRM, SIB, DISP (see main.c)
    //
}

// Use the single-header precompiled library

#include "x86_ldasm_precompiled.h"

x86_ldasm_t x86_ldasm_pre = (x86_ldasm_t)x86_ldasm_bin;

// disassemble 64-bit code, don't provide any dasm context struct
int len = x86_ldasm_pre(NULL, 64, code);

if(len > 0)
{
    printf("Instruction's length: %02i", len);
}
```

# Output example

```
0000 |          6A 60  | LEN: 02 | OPCODE: 6A
0002 |             5A  | LEN: 01 | OPCODE: 5A
0003 | 68 63 61 6C 63  | LEN: 05 | OPCODE: 68
0008 |             54  | LEN: 01 | OPCODE: 54
0009 |             59  | LEN: 01 | OPCODE: 59
000A |       48 29 D4  | LEN: 03 | OPCODE: 29 | MODRM: D4
000D |    65 48 8B 32  | LEN: 04 | OPCODE: 8B | MODRM: 32
0011 |    48 8B 76 18  | LEN: 04 | OPCODE: 8B | MODRM: 76 | DISP: 18
0015 |    48 8B 76 10  | LEN: 04 | OPCODE: 8B | MODRM: 76 | DISP: 10
0019 |          48 AD  | LEN: 02 | OPCODE: AD
001B |       48 8B 30  | LEN: 03 | OPCODE: 8B | MODRM: 30
001E |    48 8B 7E 30  | LEN: 04 | OPCODE: 8B | MODRM: 7E | DISP: 30
0022 |       03 57 3C  | LEN: 03 | OPCODE: 03 | MODRM: 57 | DISP: 3C
0025 |    8B 5C 17 28  | LEN: 04 | OPCODE: 8B | MODRM: 5C | SIB: 17 | DISP: 28
0029 |    8B 74 1F 20  | LEN: 04 | OPCODE: 8B | MODRM: 74 | SIB: 1F | DISP: 20
```

# License

`x86_ldasm` is licensed under the Apache License, Version 2.0
