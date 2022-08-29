# Precompiled `x86_ldasm`

This folder contains the 32- and 64-bit disassembled precompiled `x86_ldasm` binaries with some manual modifications, e.g. entrypoint jump, relative addressing for code position independence, etc.

The precompiled binaries have been compiled with GCC as follows: 

```bash
# when compiling for 32-bit, add: -m32
gcc -Wall -Iinclude/ -std=c99 -Os -c -s -fno-stack-protector -fno-asynchronous-unwind-tables \
    -mno-sse -fPIC -o obj/x86_ldasm.o src/x86_ldasm.c
```

After manual modification, they can be recompiled with YASM/NASM:

```bash
nasm -f bin -o <output.bin> <input.asm>
```

# License

`x86_ldasm` is licensed under the Apache License, Version 2.0
