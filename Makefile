#
#   This file is part of x86_ldasm.
#
#   x86_ldasm is an x86-64 instruction length disassembler
#   
#   Copyright 2019 / the`janitor / < email: base64dec(dGhlLmphbml0b3JAcHJvdG9ubWFpbC5jb20=) >
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

# To avoid "missing separator" errors when TABs get converted to spaces
ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error Variable .RECIPEPREFIX is unsupported, upgrade to GNU Make 4.0 or later)
endif
.RECIPEPREFIX = >

# Programs
CC = gcc
AS = nasm
CFLAGS = -Wall -Iinclude/ -std=c99 -Os # -m32
LFLAGS = -s # -m32
AFLAGS = -f bin

SRC_DIR = src
BIN_DIR = bin
OBJ_DIR = obj

all: x86_ldasm

x86_gen_tables: $(OBJ_DIR)/x86_gen_tables.o $(OBJ_DIR)/x86_ldasm_tables.o
> $(CC) $(LFLAGS) $^ -o $(BIN_DIR)/$@

x86_ldasm: $(OBJ_DIR)/x86_ldasm.o $(OBJ_DIR)/main.o
> $(CC) $(LFLAGS) $^ -o $(BIN_DIR)/$@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
> $(CC) $(CFLAGS) -c $< -o $@

clean:
> rm -rf $(BIN_DIR)/* $(OBJ_DIR)/*
    
rebuild: clean all

.PHONY : clean
.SILENT : clean

# gcc -Wall -Iinclude/ -std=c99 -Os -c -s -fno-stack-protector -fno-asynchronous-unwind-tables \
#     -mno-sse -fPIC -o obj/x86_ldasm.o src/x86_ldasm.c

# gcc -Wall -Iinclude/ -std=c99 -Os -fno-stack-protector -fno-asynchronous-unwind-tables \
#     -mno-sse -fPIC -masm=intel -o obj/x86_ldasm.asm src/x86_ldasm.c
