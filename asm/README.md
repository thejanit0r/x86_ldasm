# Precompiled `x86_ldasm`

This folder contains the 32- and 64-bit disassembled precompiled `x86_ldasm` binaries with some manual modifications, e.g. entrypoint jump, relative addressing for code position independence, etc.

The precompiled binaries have been compiled with GCC as follows: 

```bash
# Add -m32 when compiling for 32-bit
# Add -mabi=ms when compiling for Microsoft Windows x64 ABI (or consider using __attribute__((ms_abi)))
# Add -D_LDASM_EXT_X86_TABLE to enable external x86 table usage
# Tweak the optimization flag in order to achieve the desired output
gcc -Wall -Iinclude/ -std=c99 -Os -c -s -fno-stack-protector -fno-asynchronous-unwind-tables \
    -mno-sse -fno-exceptions -fPIC -o obj/x86_ldasm.o src/x86_ldasm.c
```

After manual modification, they can be recompiled with YASM/NASM:

```bash
nasm -f bin -o <output.bin> <input.asm>
```

# Notes

- Calling conventions (https://wiki.osdev.org/Calling_Conventions)
    - Linux (64-bit): `rdi`, `rsi`, `rdx`, `rcx`, `r8`, `r9`, `stack`
    - Windows (64-bit): `rcx`, `rdx`, `r8`, `r9`, `stack`

# License

`x86_ldasm` is licensed under the Apache License, Version 2.0
