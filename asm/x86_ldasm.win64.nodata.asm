;
;    This file is part of x86_ldasm.
;
;    x86_ldasm is an x86-64 instruction length disassembler
;    
;    Copyright 2019 / the`janitor / < email: base64dec(dGhlLmphbml0b3JAcHJvdG9ubWFpbC5jb20=) >
;
;    Licensed under the Apache License, Version 2.0 (the "License");
;    you may not use this file except in compliance with the License.
;    You may obtain a copy of the License at
;
;        http://www.apache.org/licenses/LICENSE-2.0
;
;    Unless required by applicable law or agreed to in writing, software
;    distributed under the License is distributed on an "AS IS" BASIS,
;    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;    See the License for the specific language governing permissions and
;    limitations under the License.
;
;
;    x86_ldasm x64 (64 bit, precompiled, position independent) - NASM/YASM
;       - win64, no data (code-only)
;
[BITS 64]

default rel

        jmp x86_ldasm_ext_table ; Entrypoint

get_modrm:
        test    byte [rcx+18H], 04H                     ; 0000 _ F6. 41, 18, 04
        jnz     ?_001                                   ; 0004 _ 75, 35
        mov     r8, qword 0FFFFFFFBFFFFFFF0H            ; 0006 _ 49: B8, FFFFFFFBFFFFFFF0
        movzx   eax, byte [rcx+8H]                      ; 0010 _ 0F B6. 41, 08
        and     r8, qword [rcx+14H]                     ; 0014 _ 4C: 23. 41, 14
        mov     rdx, rax                                ; 0018 _ 48: 89. C2
        and     edx, 0FH                                ; 001B _ 83. E2, 0F
        bts     rdx, 34                                 ; 001E _ 48: 0F BA. EA, 22
        or      rdx, r8                                 ; 0023 _ 4C: 09. C2
        lea     r8d, [rax+1H]                           ; 0026 _ 44: 8D. 40, 01
        mov     qword [rcx+14H], rdx                    ; 002A _ 48: 89. 51, 14
        mov     rdx, qword [rcx]                        ; 002E _ 48: 8B. 11
        mov     byte [rcx+8H], r8b                      ; 0031 _ 44: 88. 41, 08
        mov     al, byte [rdx+rax]                      ; 0035 _ 8A. 04 02
        mov     byte [rcx+0AH], al                      ; 0038 _ 88. 41, 0A
?_001:  mov     al, byte [rcx+0AH]                      ; 003B _ 8A. 41, 0A
        ret                                             ; 003E _ C3

get_osize:
        mov     al, byte [rcx+9H]                       ; 003F _ 8A. 41, 09
        mov     r8d, edx                                ; 0042 _ 41: 89. D0
        mov     dl, byte [rcx+17H]                      ; 0045 _ 8A. 51, 17
        mov     r9d, eax                                ; 0048 _ 41: 89. C1
        shr     dl, 2                                   ; 004B _ C0. EA, 02
        and     edx, 01H                                ; 004E _ 83. E2, 01
        and     r9b, 03H                                ; 0051 _ 41: 80. E1, 03
        jz      ?_007                                   ; 0055 _ 74, 4B
        dec     r9b                                     ; 0057 _ 41: FE. C9
        jz      ?_006                                   ; 005A _ 74, 40
        test    r8b, 01H                                ; 005C _ 41: F6. C0, 01
        jz      ?_003                                   ; 0060 _ 74, 08
?_002:  and     eax, 0FFFFFFF3H                         ; 0062 _ 83. E0, F3
        or      eax, 08H                                ; 0065 _ 83. C8, 08
        jmp     ?_009                                   ; 0068 _ EB, 40

?_003:  test    byte [rcx+0DH], 08H                     ; 006A _ F6. 41, 0D, 08
        jnz     ?_002                                   ; 006E _ 75, F2
        mov     r9b, byte [rcx+18H]                     ; 0070 _ 44: 8A. 49, 18
        test    r9b, 01H                                ; 0074 _ 41: F6. C1, 01
        jz      ?_004                                   ; 0078 _ 74, 06
        cmp     byte [rcx+12H], 0                       ; 007A _ 80. 79, 12, 00
        js      ?_002                                   ; 007E _ 78, E2
?_004:  and     r9b, 02H                                ; 0080 _ 41: 80. E1, 02
        jz      ?_005                                   ; 0084 _ 74, 06
        cmp     byte [rcx+12H], 0                       ; 0086 _ 80. 79, 12, 00
        js      ?_002                                   ; 008A _ 78, D6
?_005:  and     r8b, 02H                                ; 008C _ 41: 80. E0, 02
        jz      ?_006                                   ; 0090 _ 74, 0A
        test    dl, dl                                  ; 0092 _ 84. D2
        sete    dl                                      ; 0094 _ 0F 94. C2
        shl     edx, 3                                  ; 0097 _ C1. E2, 03
        jmp     ?_008                                   ; 009A _ EB, 09

?_006:  xor     edx, 01H                                ; 009C _ 83. F2, 01
        and     edx, 03H                                ; 009F _ 83. E2, 03
?_007:  shl     edx, 2                                  ; 00A2 _ C1. E2, 02
?_008:  and     eax, 0FFFFFFF3H                         ; 00A5 _ 83. E0, F3
        or      eax, edx                                ; 00A8 _ 09. D0
?_009:  mov     byte [rcx+9H], al                       ; 00AA _ 88. 41, 09
        ret                                             ; 00AD _ C3

x86_ldasm:
        push    rdi                                     ; 00AE _ 57
        mov     eax, edx                                ; 00AF _ 89. D0
        mov     edx, 134217727                          ; 00B1 _ BA, 07FFFFFF
        mov     r10, rcx                                ; 00B6 _ 49: 89. CA
        push    rsi                                     ; 00B9 _ 56
        shl     rdx, 37                                 ; 00BA _ 48: C1. E2, 25
        push    rbx                                     ; 00BE _ 53
        sub     rsp, 48                                 ; 00BF _ 48: 83. EC, 30
        and     qword [rcx+14H], rdx                    ; 00C3 _ 48: 21. 51, 14
        cmp     eax, 2                                  ; 00C7 _ 83. F8, 02
        mov     dl, byte [rcx+9H]                       ; 00CA _ 8A. 51, 09
        mov     byte [rcx+8H], 0                        ; 00CD _ C6. 41, 08, 00
        mov     dword [rcx+0DH], 0                      ; 00D1 _ C7. 41, 0D, 00000000
        mov     qword [rcx+20H], -1                     ; 00D8 _ 48: C7. 41, 20, FFFFFFFF
        mov     qword [rcx], r8                         ; 00E0 _ 4C: 89. 01
        jbe     ?_011                                   ; 00E3 _ 76, 16
        xor     ecx, ecx                                ; 00E5 _ 31. C9
        cmp     eax, 16                                 ; 00E7 _ 83. F8, 10
        jz      ?_010                                   ; 00EA _ 74, 08
        cmp     eax, 32                                 ; 00EC _ 83. F8, 20
        setne   cl                                      ; 00EF _ 0F 95. C1
        inc     ecx                                     ; 00F2 _ FF. C1
?_010:  and     edx, 0FFFFFFFCH                         ; 00F4 _ 83. E2, FC
        or      edx, ecx                                ; 00F7 _ 09. CA
        jmp     ?_012                                   ; 00F9 _ EB, 08

?_011:  and     eax, 03H                                ; 00FB _ 83. E0, 03
        and     edx, 0FFFFFFFCH                         ; 00FE _ 83. E2, FC
        or      edx, eax                                ; 0101 _ 09. C2
?_012:  mov     byte [r10+9H], dl                       ; 0103 _ 41: 88. 52, 09
        mov     r9, r8                                  ; 0107 _ 4D: 89. C1
        xor     eax, eax                                ; 010A _ 31. C0
?_013:  mov     dl, byte [r9]                           ; 010C _ 41: 8A. 11
        mov     ecx, edx                                ; 010F _ 89. D1
        shr     cl, 4                                   ; 0111 _ C0. E9, 04
        cmp     cl, 4                                   ; 0114 _ 80. F9, 04
        jnz     ?_014                                   ; 0117 _ 75, 3E
        mov     cl, byte [r10+9H]                       ; 0119 _ 41: 8A. 4A, 09
        and     ecx, 03H                                ; 011D _ 83. E1, 03
        cmp     cl, 2                                   ; 0120 _ 80. F9, 02
        jne     ?_023                                   ; 0123 _ 0F 85, 000000EE
        mov     byte [r10+0EH], dl                      ; 0129 _ 41: 88. 52, 0E
        mov     ecx, dword [r10+14H]                    ; 012D _ 41: 8B. 4A, 14
        mov     byte [r10+0DH], dl                      ; 0131 _ 41: 88. 52, 0D
        mov     edx, eax                                ; 0135 _ 89. C2
        shl     edx, 8                                  ; 0137 _ C1. E2, 08
        and     ecx, 0FEFFF0FFH                         ; 013A _ 81. E1, FEFFF0FF
        or      edx, 1000000H                           ; 0140 _ 81. CA, 01000000
        and     edx, 1000F00H                           ; 0146 _ 81. E2, 01000F00
        or      edx, ecx                                ; 014C _ 09. CA
        mov     dword [r10+14H], edx                    ; 014E _ 41: 89. 52, 14
        jmp     ?_022                                   ; 0152 _ E9, 000000AE

?_014:  cmp     dl, 102                                 ; 0157 _ 80. FA, 66
        jnz     ?_015                                   ; 015A _ 75, 26
        mov     dil, byte [r10+10H]                     ; 015C _ 41: 8A. 7A, 10
        or      byte [r10+17H], 04H                     ; 0160 _ 41: 80. 4A, 17, 04
        mov     byte [r10+0EH], 102                     ; 0165 _ 41: C6. 42, 0E, 66
        lea     edx, [rdi+0EH]                          ; 016A _ 8D. 57, 0E
        cmp     dl, 1                                   ; 016D _ 80. FA, 01
        jbe     ?_022                                   ; 0170 _ 0F 86, 0000008F
        mov     dl, byte [r9]                           ; 0176 _ 41: 8A. 11
        mov     byte [r10+10H], dl                      ; 0179 _ 41: 88. 52, 10
        jmp     ?_022                                   ; 017D _ E9, 00000083

?_015:  cmp     dl, 103                                 ; 0182 _ 80. FA, 67
        jnz     ?_016                                   ; 0185 _ 75, 0C
        or      byte [r10+17H], 08H                     ; 0187 _ 41: 80. 4A, 17, 08
        mov     byte [r10+0EH], 103                     ; 018C _ 41: C6. 42, 0E, 67
        jmp     ?_022                                   ; 0191 _ EB, 72

?_016:  mov     ecx, edx                                ; 0193 _ 89. D1
        and     ecx, 0FFFFFFE7H                         ; 0195 _ 83. E1, E7
        cmp     cl, 38                                  ; 0198 _ 80. F9, 26
        jnz     ?_017                                   ; 019B _ 75, 12
        mov     cl, byte [r10+9H]                       ; 019D _ 41: 8A. 4A, 09
        mov     byte [r10+0FH], dl                      ; 01A1 _ 41: 88. 52, 0F
        and     ecx, 03H                                ; 01A5 _ 83. E1, 03
        cmp     cl, 2                                   ; 01A8 _ 80. F9, 02
        jnz     ?_018                                   ; 01AB _ 75, 0E
        jmp     ?_022                                   ; 01AD _ EB, 56

?_017:  lea     ecx, [rdx-64H]                          ; 01AF _ 8D. 4A, 9C
        cmp     cl, 1                                   ; 01B2 _ 80. F9, 01
        ja      ?_019                                   ; 01B5 _ 77, 0F
        mov     byte [r10+0FH], dl                      ; 01B7 _ 41: 88. 52, 0F
?_018:  or      byte [r10+17H], 02H                     ; 01BB _ 41: 80. 4A, 17, 02
        mov     byte [r10+0EH], dl                      ; 01C0 _ 41: 88. 52, 0E
        jmp     ?_022                                   ; 01C4 _ EB, 3F

?_019:  cmp     dl, -16                                 ; 01C6 _ 80. FA, F0
        jnz     ?_020                                   ; 01C9 _ 75, 0C
        or      byte [r10+17H], 10H                     ; 01CB _ 41: 80. 4A, 17, 10
        mov     byte [r10+0EH], -16                     ; 01D0 _ 41: C6. 42, 0E, F0
        jmp     ?_022                                   ; 01D5 _ EB, 2E

?_020:  cmp     dl, -14                                 ; 01D7 _ 80. FA, F2
        jnz     ?_021                                   ; 01DA _ 75, 13
        mov     byte [r10+0EH], -14                     ; 01DC _ 41: C6. 42, 0E, F2
        mov     dl, byte [r9]                           ; 01E1 _ 41: 8A. 11
        or      byte [r10+17H], 40H                     ; 01E4 _ 41: 80. 4A, 17, 40
        mov     byte [r10+10H], dl                      ; 01E9 _ 41: 88. 52, 10
        jmp     ?_022                                   ; 01ED _ EB, 16

?_021:  cmp     dl, -13                                 ; 01EF _ 80. FA, F3
        jnz     ?_023                                   ; 01F2 _ 75, 23
        mov     byte [r10+0EH], -13                     ; 01F4 _ 41: C6. 42, 0E, F3
        mov     dl, byte [r9]                           ; 01F9 _ 41: 8A. 11
        or      byte [r10+17H], 20H                     ; 01FC _ 41: 80. 4A, 17, 20
        mov     byte [r10+10H], dl                      ; 0201 _ 41: 88. 52, 10
?_022:  inc     rax                                     ; 0205 _ 48: FF. C0
        inc     r9                                      ; 0208 _ 49: FF. C1
        cmp     rax, 15                                 ; 020B _ 48: 83. F8, 0F
        jne     ?_013                                   ; 020F _ 0F 85, FFFFFEF7
        jmp     ?_026                                   ; 0215 _ EB, 59

?_023:  mov     cl, byte [r10+9H]                       ; 0217 _ 41: 8A. 4A, 09
        and     ecx, 03H                                ; 021B _ 83. E1, 03
        cmp     cl, 2                                   ; 021E _ 80. F9, 02
        jnz     ?_024                                   ; 0221 _ 75, 19
        mov     dl, byte [r10+0EH]                      ; 0223 _ 41: 8A. 52, 0E
        shr     dl, 4                                   ; 0227 _ C0. EA, 04
        cmp     dl, 4                                   ; 022A _ 80. FA, 04
        jz      ?_024                                   ; 022D _ 74, 0D
        and     dword [r10+14H], 0FEFFF0FFH             ; 022F _ 41: 81. 62, 14, FEFFF0FF
        mov     byte [r10+0DH], 0                       ; 0237 _ 41: C6. 42, 0D, 00
?_024:  mov     esi, 51                                 ; 023C _ BE, 00000033
        mov     dl, byte [r9]                           ; 0241 _ 41: 8A. 11
        mov     rdi, qword 0F2000000F3H                 ; 0244 _ 48: BF, 000000F2000000F3
        shl     rsi, 33                                 ; 024E _ 48: C1. E6, 21
        mov     qword [rsp+28H], rdi                    ; 0252 _ 48: 89. 7C 24, 28
        mov     qword [rsp+20H], rsi                    ; 0257 _ 48: 89. 74 24, 20
        cmp     dl, -60                                 ; 025C _ 80. FA, C4
        jne     ?_030                                   ; 025F _ 0F 85, 00000087
        cmp     cl, 2                                   ; 0265 _ 80. F9, 02
        jnz     ?_027                                   ; 0268 _ 75, 0E
?_025:  cmp     rax, 10                                 ; 026A _ 48: 83. F8, 0A
        jbe     ?_028                                   ; 026E _ 76, 1B
?_026:  or      eax, 0FFFFFFFFH                         ; 0270 _ 83. C8, FF
        jmp     ?_097                                   ; 0273 _ E9, 0000066A

?_027:  mov     dl, byte [r8+rax+1H]                    ; 0278 _ 41: 8A. 54 00, 01
        shr     dl, 6                                   ; 027D _ C0. EA, 06
        cmp     dl, 3                                   ; 0280 _ 80. FA, 03
        jne     ?_041                                   ; 0283 _ 0F 85, 000001BA
        jmp     ?_025                                   ; 0289 _ EB, DF

?_028:  test    byte [r10+17H], 75H                     ; 028B _ 41: F6. 42, 17, 75
        jnz     ?_026                                   ; 0290 _ 75, DE
        mov     r9b, byte [r8+rax+1H]                   ; 0292 _ 45: 8A. 4C 00, 01
        mov     byte [r10+11H], r9b                     ; 0297 _ 45: 88. 4A, 11
        mov     dl, byte [r8+rax+2H]                    ; 029B _ 41: 8A. 54 00, 02
        mov     r11d, r9d                               ; 02A0 _ 45: 89. CB
        or      byte [r10+18H], 01H                     ; 02A3 _ 41: 80. 4A, 18, 01
        mov     byte [r10+12H], dl                      ; 02A8 _ 41: 88. 52, 12
        and     r11b, 1FH                               ; 02AC _ 41: 80. E3, 1F
        jz      ?_026                                   ; 02B0 _ 74, BE
        and     r9b, 1CH                                ; 02B2 _ 41: 80. E1, 1C
        jnz     ?_026                                   ; 02B6 _ 75, B8
        mov     r8d, 256                                ; 02B8 _ 41: B8, 00000100
        cmp     r11b, 1                                 ; 02BE _ 41: 80. FB, 01
        jz      ?_029                                   ; 02C2 _ 74, 14
        cmp     r11b, 2                                 ; 02C4 _ 41: 80. FB, 02
        mov     r8d, 512                                ; 02C8 _ 41: B8, 00000200
        mov     r9d, 768                                ; 02CE _ 41: B9, 00000300
        cmovne  r8, r9                                  ; 02D4 _ 4D: 0F 45. C1
?_029:  and     edx, 03H                                ; 02D8 _ 83. E2, 03
        mov     qword [r10+20H], r8                     ; 02DB _ 4D: 89. 42, 20
        mov     edx, dword [rsp+rdx*4+20H]              ; 02DF _ 8B. 54 94, 20
        mov     byte [r10+10H], dl                      ; 02E3 _ 41: 88. 52, 10
        jmp     ?_036                                   ; 02E7 _ E9, 00000115

?_030:  cmp     dl, -59                                 ; 02EC _ 80. FA, C5
        jnz     ?_032                                   ; 02EF _ 75, 57
        cmp     cl, 2                                   ; 02F1 _ 80. F9, 02
        jz      ?_031                                   ; 02F4 _ 74, 11
        mov     dl, byte [r8+rax+1H]                    ; 02F6 _ 41: 8A. 54 00, 01
        shr     dl, 6                                   ; 02FB _ C0. EA, 06
        cmp     dl, 3                                   ; 02FE _ 80. FA, 03
        jne     ?_041                                   ; 0301 _ 0F 85, 0000013C
?_031:  cmp     rax, 11                                 ; 0307 _ 48: 83. F8, 0B
        ja      ?_026                                   ; 030B _ 0F 87, FFFFFF5F
        mov     r9b, byte [r10+17H]                     ; 0311 _ 45: 8A. 4A, 17
        test    r9b, 75H                                ; 0315 _ 41: F6. C1, 75
        jne     ?_026                                   ; 0319 _ 0F 85, FFFFFF51
        mov     dl, byte [r8+rax+1H]                    ; 031F _ 41: 8A. 54 00, 01
        or      r9d, 0FFFFFF80H                         ; 0324 _ 41: 83. C9, 80
        mov     qword [r10+20H], 256                    ; 0328 _ 49: C7. 42, 20, 00000100
        mov     byte [r10+17H], r9b                     ; 0330 _ 45: 88. 4A, 17
        mov     byte [r10+11H], dl                      ; 0334 _ 41: 88. 52, 11
        and     edx, 03H                                ; 0338 _ 83. E2, 03
        mov     edx, dword [rsp+rdx*4+20H]              ; 033B _ 8B. 54 94, 20
        mov     byte [r10+10H], dl                      ; 033F _ 41: 88. 52, 10
        jmp     ?_038                                   ; 0343 _ E9, 000000DB

?_032:  cmp     dl, 98                                  ; 0348 _ 80. FA, 62
        jnz     ?_033                                   ; 034B _ 75, 1F
        cmp     cl, 2                                   ; 034D _ 80. F9, 02
        je      ?_026                                   ; 0350 _ 0F 84, FFFFFF1A
        mov     dl, byte [r8+rax+1H]                    ; 0356 _ 41: 8A. 54 00, 01
        shr     dl, 6                                   ; 035B _ C0. EA, 06
        cmp     dl, 3                                   ; 035E _ 80. FA, 03
        jne     ?_041                                   ; 0361 _ 0F 85, 000000DC
        jmp     ?_026                                   ; 0367 _ E9, FFFFFF04

?_033:  cmp     dl, -113                                ; 036C _ 80. FA, 8F
        jne     ?_037                                   ; 036F _ 0F 85, 00000092
        mov     dl, byte [r8+rax+1H]                    ; 0375 _ 41: 8A. 54 00, 01
        cmp     cl, 2                                   ; 037A _ 80. F9, 02
        jz      ?_034                                   ; 037D _ 74, 11
        mov     r9d, edx                                ; 037F _ 41: 89. D1
        shr     r9b, 6                                  ; 0382 _ 41: C0. E9, 06
        cmp     r9b, 3                                  ; 0386 _ 41: 80. F9, 03
        jne     ?_041                                   ; 038A _ 0F 85, 000000B3
?_034:  test    dl, 18H                                 ; 0390 _ F6. C2, 18
        je      ?_041                                   ; 0393 _ 0F 84, 000000AA
        mov     r9d, edx                                ; 0399 _ 41: 89. D1
        and     r9d, 1FH                                ; 039C _ 41: 83. E1, 1F
        cmp     r9b, 10                                 ; 03A0 _ 41: 80. F9, 0A
        ja      ?_041                                   ; 03A4 _ 0F 87, 00000099
        cmp     rax, 10                                 ; 03AA _ 48: 83. F8, 0A
        ja      ?_026                                   ; 03AE _ 0F 87, FFFFFEBC
        test    byte [r10+17H], 75H                     ; 03B4 _ 41: F6. 42, 17, 75
        jne     ?_026                                   ; 03B9 _ 0F 85, FFFFFEB1
        mov     byte [r10+11H], dl                      ; 03BF _ 41: 88. 52, 11
        mov     dl, byte [r8+rax+2H]                    ; 03C3 _ 41: 8A. 54 00, 02
        or      byte [r10+18H], 02H                     ; 03C8 _ 41: 80. 4A, 18, 02
        mov     byte [r10+12H], dl                      ; 03CD _ 41: 88. 52, 12
        and     dl, 03H                                 ; 03D1 _ 80. E2, 03
        jne     ?_026                                   ; 03D4 _ 0F 85, FFFFFE96
        mov     edx, 1024                               ; 03DA _ BA, 00000400
        cmp     r9b, 8                                  ; 03DF _ 41: 80. F9, 08
        jz      ?_035                                   ; 03E3 _ 74, 13
        cmp     r9b, 9                                  ; 03E5 _ 41: 80. F9, 09
        mov     edx, 1280                               ; 03E9 _ BA, 00000500
        mov     r8d, 1536                               ; 03EE _ 41: B8, 00000600
        cmovne  rdx, r8                                 ; 03F4 _ 49: 0F 45. D0
?_035:  mov     qword [r10+20H], rdx                    ; 03F8 _ 49: 89. 52, 20
        mov     byte [r10+10H], 0                       ; 03FC _ 41: C6. 42, 10, 00
?_036:  lea     rdx, [rax+3H]                           ; 0401 _ 48: 8D. 50, 03
        jmp     ?_042                                   ; 0405 _ EB, 4C

?_037:  cmp     dl, 15                                  ; 0407 _ 80. FA, 0F
        jnz     ?_041                                   ; 040A _ 75, 37
        mov     r8b, byte [r8+rax+1H]                   ; 040C _ 45: 8A. 44 00, 01
        lea     rdx, [rax+1H]                           ; 0411 _ 48: 8D. 50, 01
        cmp     r8b, 56                                 ; 0415 _ 41: 80. F8, 38
        jnz     ?_039                                   ; 0419 _ 75, 0E
        mov     qword [r10+20H], 512                    ; 041B _ 49: C7. 42, 20, 00000200
?_038:  lea     rdx, [rax+2H]                           ; 0423 _ 48: 8D. 50, 02
        jmp     ?_042                                   ; 0427 _ EB, 2A

?_039:  cmp     r8b, 58                                 ; 0429 _ 41: 80. F8, 3A
        jnz     ?_040                                   ; 042D _ 75, 0A
        mov     qword [r10+20H], 768                    ; 042F _ 49: C7. 42, 20, 00000300
        jmp     ?_038                                   ; 0437 _ EB, EA

?_040:  mov     qword [r10+20H], 256                    ; 0439 _ 49: C7. 42, 20, 00000100
        jmp     ?_042                                   ; 0441 _ EB, 10

?_041:  mov     byte [r10+10H], 0                       ; 0443 _ 41: C6. 42, 10, 00
        mov     rdx, rax                                ; 0448 _ 48: 89. C2
        mov     qword [r10+20H], 0                      ; 044B _ 49: C7. 42, 20, 00000000
?_042:  mov     al, byte [r10+15H]                      ; 0453 _ 41: 8A. 42, 15
        mov     byte [r10+8H], dl                       ; 0457 _ 41: 88. 52, 08
        shl     edx, 4                                  ; 045B _ C1. E2, 04
        and     eax, 0FH                                ; 045E _ 83. E0, 0F
        or      edx, eax                                ; 0461 _ 09. C2
        mov     al, byte [r10+17H]                      ; 0463 _ 41: 8A. 42, 17
        mov     byte [r10+15H], dl                      ; 0467 _ 41: 88. 52, 15
        mov     dl, byte [r10+9H]                       ; 046B _ 41: 8A. 52, 09
        shr     al, 3                                   ; 046F _ C0. E8, 03
        and     eax, 01H                                ; 0472 _ 83. E0, 01
        test    cl, cl                                  ; 0475 _ 84. C9
        jnz     ?_043                                   ; 0477 _ 75, 0E
        shl     eax, 4                                  ; 0479 _ C1. E0, 04
        and     edx, 0FFFFFFCFH                         ; 047C _ 83. E2, CF
        or      eax, edx                                ; 047F _ 09. D0
        mov     byte [r10+9H], al                       ; 0481 _ 41: 88. 42, 09
        jmp     ?_044                                   ; 0485 _ EB, 2B

?_043:  mov     r8b, 2                                  ; 0487 _ 41: B0, 02
        and     edx, 0FFFFFFCFH                         ; 048A _ 83. E2, CF
        sub     r8d, eax                                ; 048D _ 41: 29. C0
        xor     eax, 01H                                ; 0490 _ 83. F0, 01
        and     r8d, 03H                                ; 0493 _ 41: 83. E0, 03
        and     eax, 03H                                ; 0497 _ 83. E0, 03
        shl     r8d, 4                                  ; 049A _ 41: C1. E0, 04
        shl     eax, 4                                  ; 049E _ C1. E0, 04
        or      r8d, edx                                ; 04A1 _ 41: 09. D0
        or      eax, edx                                ; 04A4 _ 09. D0
        dec     cl                                      ; 04A6 _ FE. C9
        mov     edx, r8d                                ; 04A8 _ 44: 89. C2
        cmove   edx, eax                                ; 04AB _ 0F 44. D0
        mov     byte [r10+9H], dl                       ; 04AE _ 41: 88. 52, 09
?_044:  xor     edx, edx                                ; 04B2 _ 31. D2
        mov     rcx, r10                                ; 04B4 _ 4C: 89. D1
        xor     ebx, ebx                                ; 04B7 _ 31. DB
        call    get_osize                               ; 04B9 _ E8, FFFFFB81
        movzx   eax, byte [r10+8H]                      ; 04BE _ 41: 0F B6. 42, 08
        mov     rdx, qword [r10]                        ; 04C3 _ 49: 8B. 12
        xor     r9d, r9d                                ; 04C6 _ 45: 31. C9
        mov     rsi, qword [r10+28H]                    ; 04C9 _ 49: 8B. 72, 28
        mov     rdi, qword [r10+30H]                    ; 04CD _ 49: 8B. 7A, 30
        lea     ecx, [rax+1H]                           ; 04D1 _ 8D. 48, 01
        mov     byte [r10+8H], cl                       ; 04D4 _ 41: 88. 4A, 08
        mov     rcx, qword [r10+20H]                    ; 04D8 _ 49: 8B. 4A, 20
        movzx   r11d, byte [rdx+rax]                    ; 04DC _ 44: 0F B6. 1C 02
        xor     edx, edx                                ; 04E1 _ 31. D2
        mov     rax, r11                                ; 04E3 _ 4C: 89. D8
        add     r11, rcx                                ; 04E6 _ 49: 01. CB
?_045:  cmp     rdi, rdx                                ; 04E9 _ 48: 39. D7
        jbe     ?_048                                   ; 04EC _ 76, 34
        mov     r9b, byte [rsi+rdx]                     ; 04EE _ 44: 8A. 0C 16
        mov     r8d, r9d                                ; 04F2 _ 45: 89. C8
        test    r9b, r9b                                ; 04F5 _ 45: 84. C9
        js      ?_046                                   ; 04F8 _ 78, 0A
        shr     r8b, 4                                  ; 04FA _ 41: C0. E8, 04
        and     r9d, 0FH                                ; 04FE _ 41: 83. E1, 0F
        jmp     ?_047                                   ; 0502 _ EB, 0D

?_046:  movzx   r9d, byte [rsi+rdx+1H]                  ; 0504 _ 44: 0F B6. 4C 16, 01
        and     r8d, 7FH                                ; 050A _ 41: 83. E0, 7F
        inc     rdx                                     ; 050E _ 48: FF. C2
?_047:  movzx   r8d, r8b                                ; 0511 _ 45: 0F B6. C0
        add     rbx, r8                                 ; 0515 _ 4C: 01. C3
        cmp     r11, rbx                                ; 0518 _ 49: 39. DB
        jc      ?_048                                   ; 051B _ 72, 05
        inc     rdx                                     ; 051D _ 48: FF. C2
        jmp     ?_045                                   ; 0520 _ EB, C7

?_048:  test    rcx, rcx                                ; 0522 _ 48: 85. C9
        jne     ?_055                                   ; 0525 _ 0F 85, 000000A9
        lea     edx, [rax+18H]                          ; 052B _ 8D. 50, 18
        cmp     dl, 1                                   ; 052E _ 80. FA, 01
        ja      ?_050                                   ; 0531 _ 77, 07
?_049:  mov     edx, 1                                  ; 0533 _ BA, 00000001
        jmp     ?_051                                   ; 0538 _ EB, 37

?_050:  lea     edx, [rax+48H]                          ; 053A _ 8D. 50, 48
        cmp     dl, 7                                   ; 053D _ 80. FA, 07
        jbe     ?_057                                   ; 0540 _ 0F 86, 000000CD
        lea     edx, [rax+60H]                          ; 0546 _ 8D. 50, 60
        cmp     dl, 3                                   ; 0549 _ 80. FA, 03
        jbe     ?_058                                   ; 054C _ 0F 86, 000000C9
        mov     edx, eax                                ; 0552 _ 89. C2
        and     edx, 0FFFFFFF7H                         ; 0554 _ 83. E2, F7
        cmp     dl, -62                                 ; 0557 _ 80. FA, C2
        je      ?_059                                   ; 055A _ 0F 84, 000000C3
        cmp     al, -56                                 ; 0560 _ 3C, C8
        je      ?_060                                   ; 0562 _ 0F 84, 000000C3
        cmp     al, 104                                 ; 0568 _ 3C, 68
        jnz     ?_052                                   ; 056A _ 75, 18
        mov     edx, 2                                  ; 056C _ BA, 00000002
?_051:  mov     rcx, r10                                ; 0571 _ 4C: 89. D1
        call    get_osize                               ; 0574 _ E8, FFFFFAC6
        mov     r9d, 2                                  ; 0579 _ 41: B9, 00000002
        jmp     ?_064                                   ; 057F _ E9, 000000C5

?_052:  cmp     al, -22                                 ; 0584 _ 3C, EA
        je      ?_061                                   ; 0586 _ 0F 84, 000000A7
        cmp     al, -102                                ; 058C _ 3C, 9A
        je      ?_061                                   ; 058E _ 0F 84, 0000009F
        cmp     al, -10                                 ; 0594 _ 3C, F6
        jnz     ?_054                                   ; 0596 _ 75, 21
        mov     rcx, r10                                ; 0598 _ 4C: 89. D1
        call    get_modrm                               ; 059B _ E8, FFFFFA60
        shr     al, 3                                   ; 05A0 _ C0. E8, 03
        test    al, 06H                                 ; 05A3 _ A8, 06
        je      ?_062                                   ; 05A5 _ 0F 84, 00000090
?_053:  test    r9d, r9d                                ; 05AB _ 45: 85. C9
        je      ?_089                                   ; 05AE _ 0F 84, 000002C5
        jmp     ?_064                                   ; 05B4 _ E9, 00000090

?_054:  cmp     al, -9                                  ; 05B9 _ 3C, F7
        jnz     ?_053                                   ; 05BB _ 75, EE
        mov     rcx, r10                                ; 05BD _ 4C: 89. D1
        call    get_modrm                               ; 05C0 _ E8, FFFFFA3B
        shr     al, 3                                   ; 05C5 _ C0. E8, 03
        test    al, 06H                                 ; 05C8 _ A8, 06
        jnz     ?_053                                   ; 05CA _ 75, DF
        mov     r9d, 3                                  ; 05CC _ 41: B9, 00000003
        jmp     ?_064                                   ; 05D2 _ EB, 75

?_055:  cmp     rcx, 256                                ; 05D4 _ 48: 81. F9, 00000100
        jnz     ?_056                                   ; 05DB _ 75, 1E
        lea     edx, [rax-80H]                          ; 05DD _ 8D. 50, 80
        cmp     dl, 15                                  ; 05E0 _ 80. FA, 0F
        jbe     ?_049                                   ; 05E3 _ 0F 86, FFFFFF4A
        cmp     al, 120                                 ; 05E9 _ 3C, 78
        jnz     ?_053                                   ; 05EB _ 75, BE
        mov     al, byte [r10+10H]                      ; 05ED _ 41: 8A. 42, 10
        cmp     al, -14                                 ; 05F1 _ 3C, F2
        jz      ?_063                                   ; 05F3 _ 74, 4E
        cmp     al, 102                                 ; 05F5 _ 3C, 66
        jnz     ?_053                                   ; 05F7 _ 75, B2
        jmp     ?_063                                   ; 05F9 _ EB, 48

?_056:  cmp     rcx, 1536                               ; 05FB _ 48: 81. F9, 00000600
        jnz     ?_053                                   ; 0602 _ 75, A7
        and     eax, 0FFFFFFFDH                         ; 0604 _ 83. E0, FD
        cmp     al, 16                                  ; 0607 _ 3C, 10
        jnz     ?_053                                   ; 0609 _ 75, A0
        mov     r9d, 65                                 ; 060B _ 41: B9, 00000041
        jmp     ?_064                                   ; 0611 _ EB, 36

?_057:  mov     r9d, 16                                 ; 0613 _ 41: B9, 00000010
        jmp     ?_064                                   ; 0619 _ EB, 2E

?_058:  mov     r9d, 8                                  ; 061B _ 41: B9, 00000008
        jmp     ?_064                                   ; 0621 _ EB, 26

?_059:  mov     r9d, 32                                 ; 0623 _ 41: B9, 00000020
        jmp     ?_064                                   ; 0629 _ EB, 1E

?_060:  mov     r9d, 36                                 ; 062B _ 41: B9, 00000024
        jmp     ?_064                                   ; 0631 _ EB, 16

?_061:  mov     r9d, 128                                ; 0633 _ 41: B9, 00000080
        jmp     ?_064                                   ; 0639 _ EB, 0E

?_062:  mov     r9d, 5                                  ; 063B _ 41: B9, 00000005
        jmp     ?_064                                   ; 0641 _ EB, 06

?_063:  mov     r9d, 33                                 ; 0643 _ 41: B9, 00000021
?_064:  test    r9b, 01H                                ; 0649 _ 41: F6. C1, 01
        je      ?_079                                   ; 064D _ 0F 84, 00000168
        mov     rcx, r10                                ; 0653 _ 4C: 89. D1
        call    get_modrm                               ; 0656 _ E8, FFFFF9A5
        shr     al, 6                                   ; 065B _ C0. E8, 06
        mov     r11d, eax                               ; 065E _ 41: 89. C3
        call    get_modrm                               ; 0661 _ E8, FFFFF99A
        and     eax, 07H                                ; 0666 _ 83. E0, 07
        cmp     r11b, 3                                 ; 0669 _ 41: 80. FB, 03
        je      ?_079                                   ; 066D _ 0F 84, 00000148
        mov     cl, byte [r10+9H]                       ; 0673 _ 41: 8A. 4A, 09
        mov     edx, ecx                                ; 0677 _ 89. CA
        and     edx, 03H                                ; 0679 _ 83. E2, 03
        cmp     dl, 2                                   ; 067C _ 80. FA, 02
        jnz     ?_068                                   ; 067F _ 75, 2F
        test    byte [r10+17H], 01H                     ; 0681 _ 41: F6. 42, 17, 01
        jz      ?_065                                   ; 0686 _ 74, 0D
        movzx   edx, byte [r10+0DH]                     ; 0688 _ 41: 0F B6. 52, 0D
        shl     edx, 3                                  ; 068D _ C1. E2, 03
        and     edx, 08H                                ; 0690 _ 83. E2, 08
        jmp     ?_067                                   ; 0693 _ EB, 19

?_065:  mov     dl, byte [r10+18H]                      ; 0695 _ 41: 8A. 52, 18
        test    dl, 01H                                 ; 0699 _ F6. C2, 01
        jnz     ?_066                                   ; 069C _ 75, 05
        and     dl, 02H                                 ; 069E _ 80. E2, 02
        jz      ?_068                                   ; 06A1 _ 74, 0D
?_066:  test    byte [r10+11H], 20H                     ; 06A3 _ 41: F6. 42, 11, 20
        sete    dl                                      ; 06A8 _ 0F 94. C2
        shl     edx, 3                                  ; 06AB _ C1. E2, 03
?_067:  or      eax, edx                                ; 06AE _ 09. D0
?_068:  and     eax, 07H                                ; 06B0 _ 83. E0, 07
        and     cl, 30H                                 ; 06B3 _ 80. E1, 30
        jnz     ?_070                                   ; 06B6 _ 75, 1C
        test    r11b, r11b                              ; 06B8 _ 45: 84. DB
        jnz     ?_069                                   ; 06BB _ 75, 08
        cmp     al, 6                                   ; 06BD _ 3C, 06
        je      ?_077                                   ; 06BF _ 0F 84, 000000C9
?_069:  cmp     r11b, 1                                 ; 06C5 _ 41: 80. FB, 01
        jne     ?_090                                   ; 06C9 _ 0F 85, 000001B1
        jmp     ?_076                                   ; 06CF _ E9, 000000B5

?_070:  test    r11b, r11b                              ; 06D4 _ 45: 84. DB
        jnz     ?_071                                   ; 06D7 _ 75, 0C
        cmp     al, 5                                   ; 06D9 _ 3C, 05
        jnz     ?_072                                   ; 06DB _ 75, 1A
        mov     r11b, 3                                 ; 06DD _ 41: B3, 03
        jmp     ?_078                                   ; 06E0 _ E9, 000000AC

?_071:  cmp     r11b, 1                                 ; 06E5 _ 41: 80. FB, 01
        je      ?_096                                   ; 06E9 _ 0F 84, 000001E6
        mov     r11b, 3                                 ; 06EF _ 41: B3, 03
        jmp     ?_096                                   ; 06F2 _ E9, 000001DE

?_072:  cmp     al, 4                                   ; 06F7 _ 3C, 04
        jne     ?_079                                   ; 06F9 _ 0F 85, 000000BC
?_073:  test    byte [r10+18H], 08H                     ; 06FF _ 41: F6. 42, 18, 08
        jnz     ?_074                                   ; 0704 _ 75, 3A
        mov     rcx, qword 0FFFFFFF7FFFFFF0FH           ; 0706 _ 48: B9, FFFFFFF7FFFFFF0F
        movzx   edx, byte [r10+8H]                      ; 0710 _ 41: 0F B6. 52, 08
        and     rcx, qword [r10+14H]                    ; 0715 _ 49: 23. 4A, 14
        mov     rax, rdx                                ; 0719 _ 48: 89. D0
        and     eax, 0FH                                ; 071C _ 83. E0, 0F
        shl     rax, 4                                  ; 071F _ 48: C1. E0, 04
        bts     rax, 35                                 ; 0723 _ 48: 0F BA. E8, 23
        or      rax, rcx                                ; 0728 _ 48: 09. C8
        lea     ecx, [rdx+1H]                           ; 072B _ 8D. 4A, 01
        mov     qword [r10+14H], rax                    ; 072E _ 49: 89. 42, 14
        mov     rax, qword [r10]                        ; 0732 _ 49: 8B. 02
        mov     byte [r10+8H], cl                       ; 0735 _ 41: 88. 4A, 08
        mov     al, byte [rax+rdx]                      ; 0739 _ 8A. 04 10
        mov     byte [r10+0BH], al                      ; 073C _ 41: 88. 42, 0B
?_074:  mov     rcx, r10                                ; 0740 _ 4C: 89. D1
        mov     bl, byte [r10+0BH]                      ; 0743 _ 41: 8A. 5A, 0B
        call    get_modrm                               ; 0747 _ E8, FFFFF8B4
        mov     ecx, eax                                ; 074C _ 89. C1
        mov     al, byte [r10+9H]                       ; 074E _ 41: 8A. 42, 09
        and     ebx, 07H                                ; 0752 _ 83. E3, 07
        mov     edx, eax                                ; 0755 _ 89. C2
        and     edx, 03H                                ; 0757 _ 83. E2, 03
        cmp     dl, 2                                   ; 075A _ 80. FA, 02
        je      ?_091                                   ; 075D _ 0F 84, 0000012C
?_075:  and     eax, 30H                                ; 0763 _ 83. E0, 30
        sub     eax, 16                                 ; 0766 _ 83. E8, 10
        test    al, 0FFFFFFE0H                          ; 0769 _ A8, E0
        jne     ?_095                                   ; 076B _ 0F 85, 00000156
        and     ebx, 0FFFFFFF7H                         ; 0771 _ 83. E3, F7
        cmp     bl, 5                                   ; 0774 _ 80. FB, 05
        jne     ?_095                                   ; 0777 _ 0F 85, 0000014A
        mov     eax, ecx                                ; 077D _ 89. C8
        mov     r11b, 3                                 ; 077F _ 41: B3, 03
        shr     al, 6                                   ; 0782 _ C0. E8, 06
        dec     al                                      ; 0785 _ FE. C8
        jnz     ?_078                                   ; 0787 _ 75, 08
?_076:  mov     r11b, 1                                 ; 0789 _ 41: B3, 01
        jmp     ?_078                                   ; 078C _ EB, 03

?_077:  mov     r11b, 2                                 ; 078E _ 41: B3, 02
?_078:  movzx   ecx, r11b                               ; 0791 _ 41: 0F B6. CB
        mov     dl, byte [r10+8H]                       ; 0795 _ 41: 8A. 52, 08
        mov     eax, 1                                  ; 0799 _ B8, 00000001
        dec     ecx                                     ; 079E _ FF. C9
        shl     eax, cl                                 ; 07A0 _ D3. E0
        mov     r8d, edx                                ; 07A2 _ 41: 89. D0
        mov     ecx, eax                                ; 07A5 _ 89. C1
        and     r8d, 0FH                                ; 07A7 _ 41: 83. E0, 0F
        add     edx, eax                                ; 07AB _ 01. C2
        shl     ecx, 4                                  ; 07AD _ C1. E1, 04
        mov     byte [r10+8H], dl                       ; 07B0 _ 41: 88. 52, 08
        or      ecx, r8d                                ; 07B4 _ 44: 09. C1
        mov     byte [r10+16H], cl                      ; 07B7 _ 41: 88. 4A, 16
?_079:  test    r9b, 02H                                ; 07BB _ 41: F6. C1, 02
        jz      ?_080                                   ; 07BF _ 74, 18
        mov     al, byte [r10+9H]                       ; 07C1 _ 41: 8A. 42, 09
        and     eax, 0CH                                ; 07C5 _ 83. E0, 0C
        cmp     al, 1                                   ; 07C8 _ 3C, 01
        sbb     rax, rax                                ; 07CA _ 48: 19. C0
        and     rax, 0FFFFFFFFFFFFFFFEH                 ; 07CD _ 48: 83. E0, FE
        add     rax, 4                                  ; 07D1 _ 48: 83. C0, 04
        add     byte [r10+8H], al                       ; 07D5 _ 41: 00. 42, 08
?_080:  test    r9b, 04H                                ; 07D9 _ 41: F6. C1, 04
        jz      ?_081                                   ; 07DD _ 74, 04
        inc     byte [r10+8H]                           ; 07DF _ 41: FE. 42, 08
?_081:  test    r9b, 08H                                ; 07E3 _ 41: F6. C1, 08
        jz      ?_083                                   ; 07E7 _ 74, 22
        mov     dl, byte [r10+9H]                       ; 07E9 _ 41: 8A. 52, 09
        mov     eax, 2                                  ; 07ED _ B8, 00000002
        and     dl, 30H                                 ; 07F2 _ 80. E2, 30
        jz      ?_082                                   ; 07F5 _ 74, 10
        xor     eax, eax                                ; 07F7 _ 31. C0
        cmp     dl, 16                                  ; 07F9 _ 80. FA, 10
        setne   al                                      ; 07FC _ 0F 95. C0
        lea     rax, [rax*4+4H]                         ; 07FF _ 48: 8D. 04 85, 00000004
?_082:  add     byte [r10+8H], al                       ; 0807 _ 41: 00. 42, 08
?_083:  test    r9b, 10H                                ; 080B _ 41: F6. C1, 10
        jz      ?_085                                   ; 080F _ 74, 22
        mov     dl, byte [r10+9H]                       ; 0811 _ 41: 8A. 52, 09
        mov     eax, 2                                  ; 0815 _ B8, 00000002
        and     dl, 0CH                                 ; 081A _ 80. E2, 0C
        jz      ?_084                                   ; 081D _ 74, 10
        xor     eax, eax                                ; 081F _ 31. C0
        cmp     dl, 4                                   ; 0821 _ 80. FA, 04
        setne   al                                      ; 0824 _ 0F 95. C0
        lea     rax, [rax*4+4H]                         ; 0827 _ 48: 8D. 04 85, 00000004
?_084:  add     byte [r10+8H], al                       ; 082F _ 41: 00. 42, 08
?_085:  test    r9b, 20H                                ; 0833 _ 41: F6. C1, 20
        jz      ?_086                                   ; 0837 _ 74, 05
        add     byte [r10+8H], 2                        ; 0839 _ 41: 80. 42, 08, 02
?_086:  test    r9b, 40H                                ; 083E _ 41: F6. C1, 40
        jz      ?_087                                   ; 0842 _ 74, 05
        add     byte [r10+8H], 4                        ; 0844 _ 41: 80. 42, 08, 04
?_087:  and     r9b, 0FFFFFF80H                         ; 0849 _ 41: 80. E1, 80
        jz      ?_089                                   ; 084D _ 74, 2A
        mov     dl, byte [r10+9H]                       ; 084F _ 41: 8A. 52, 09
        mov     eax, 2                                  ; 0853 _ B8, 00000002
        and     dl, 0CH                                 ; 0858 _ 80. E2, 0C
        jz      ?_088                                   ; 085B _ 74, 10
        xor     eax, eax                                ; 085D _ 31. C0
        cmp     dl, 4                                   ; 085F _ 80. FA, 04
        setne   al                                      ; 0862 _ 0F 95. C0
        lea     rax, [rax*4+4H]                         ; 0865 _ 48: 8D. 04 85, 00000004
?_088:  mov     dl, byte [r10+8H]                       ; 086D _ 41: 8A. 52, 08
        lea     eax, [rdx+rax+2H]                       ; 0871 _ 8D. 44 02, 02
        mov     byte [r10+8H], al                       ; 0875 _ 41: 88. 42, 08
?_089:  movzx   eax, byte [r10+8H]                      ; 0879 _ 41: 0F B6. 42, 08
        jmp     ?_097                                   ; 087E _ EB, 62

?_090:  cmp     r11b, 2                                 ; 0880 _ 41: 80. FB, 02
        jne     ?_079                                   ; 0884 _ 0F 85, FFFFFF31
        jmp     ?_078                                   ; 088A _ E9, FFFFFF02

?_091:  test    byte [r10+17H], 01H                     ; 088F _ 41: F6. 42, 17, 01
        jz      ?_092                                   ; 0894 _ 74, 0D
        movzx   edx, byte [r10+0DH]                     ; 0896 _ 41: 0F B6. 52, 0D
        shl     edx, 3                                  ; 089B _ C1. E2, 03
        and     edx, 08H                                ; 089E _ 83. E2, 08
        jmp     ?_094                                   ; 08A1 _ EB, 1D

?_092:  mov     dl, byte [r10+18H]                      ; 08A3 _ 41: 8A. 52, 18
        test    dl, 01H                                 ; 08A7 _ F6. C2, 01
        jnz     ?_093                                   ; 08AA _ 75, 09
        and     dl, 02H                                 ; 08AC _ 80. E2, 02
        je      ?_075                                   ; 08AF _ 0F 84, FFFFFEAE
?_093:  test    byte [r10+11H], 20H                     ; 08B5 _ 41: F6. 42, 11, 20
        sete    dl                                      ; 08BA _ 0F 94. C2
        shl     edx, 3                                  ; 08BD _ C1. E2, 03
?_094:  or      ebx, edx                                ; 08C0 _ 09. D3
        jmp     ?_075                                   ; 08C2 _ E9, FFFFFE9C

?_095:  test    r11b, r11b                              ; 08C7 _ 45: 84. DB
        je      ?_079                                   ; 08CA _ 0F 84, FFFFFEEB
        jmp     ?_078                                   ; 08D0 _ E9, FFFFFEBC

?_096:  cmp     al, 4                                   ; 08D5 _ 3C, 04
        je      ?_073                                   ; 08D7 _ 0F 84, FFFFFE22
        jmp     ?_078                                   ; 08DD _ E9, FFFFFEAF

?_097:
        add     rsp, 48                                 ; 08E2 _ 48: 83. C4, 30
        pop     rbx                                     ; 08E6 _ 5B
        pop     rsi                                     ; 08E7 _ 5E
        pop     rdi                                     ; 08E8 _ 5F
        ret                                             ; 08E9 _ C3

x86_ldasm_ext_table:
        sub     rsp, 104                                ; 08EA _ 48: 83. EC, 68
        lea     rax, [rsp+28H]                          ; 08EE _ 48: 8D. 44 24, 28
        test    rcx, rcx                                ; 08F3 _ 48: 85. C9
        cmove   rcx, rax                                ; 08F6 _ 48: 0F 44. C8
        
        push 00000EE00H
        mov dword [rsp+04H], 000000000H
        push 000AC3150H
        mov dword [rsp+04H], 0FF111011H
        push 031501130H
        mov dword [rsp+04H], 011302120H
        push 0A5018C00H
        mov dword [rsp+04H], 021203100H
        push 011008F21H
        mov dword [rsp+04H], 08C4100EDH
        push 09C450088H
        mov dword [rsp+04H], 000914500H
        push 0008F1120H
        mov dword [rsp+04H], 045008911H
        push 031502160H
        mov dword [rsp+04H], 021202160H
        push 0FF150090H
        mov dword [rsp+04H], 031009500H
        push 088008801H
        mov dword [rsp+04H], 01500DF01H
        push 0008F3130H
        mov dword [rsp+04H], 088404541H
        push 035602500H
        mov dword [rsp+04H], 015101510H
        push 030654005H
        mov dword [rsp+04H], 095352015H
        push 035008831H
        mov dword [rsp+04H], 088103510H
        push 051009B01H
        mov dword [rsp+04H], 010410090H
        push 060018A20H
        mov dword [rsp+04H], 08A60018AH
        push 011008931H
        mov dword [rsp+04H], 041101110H
        push 031009031H
        mov dword [rsp+04H], 06021009DH
        push 061103110H
        mov dword [rsp+04H], 030019A20H
        push 0C1008811H
        mov dword [rsp+04H], 071152001H
        push 015018D15H
        mov dword [rsp+04H], 035111571H
        push 011300190H
        mov dword [rsp+04H], 011501115H
        push 021103145H
        mov dword [rsp+04H], 002904120H
        push 000900188H
        mov dword [rsp+04H], 0212001ACH
        push 010110089H
        mov dword [rsp+04H], 040019415H
        push 08A141022H
        mov dword [rsp+04H], 061602100H
        push 020244120H
        mov dword [rsp+04H], 004880188H
        push 015212025H
        mov dword [rsp+04H], 014401413H
        push 060121400H
        mov dword [rsp+04H], 000880488H
        push 013150490H
        mov dword [rsp+04H], 098018C25H
        push 012402100H
        mov dword [rsp+04H], 040151413H
        push 020121441H
        mov dword [rsp+04H], 0A4121441H
        push 020121441H
        mov dword [rsp+04H], 020121441H
        push 020121441H
        mov dword [rsp+04H], 020121441H
        push 020121441H
        mov dword [rsp+04H], 020121441H
        
        mov     qword [rcx+28H], rsp                    
        mov     qword [rcx+30H], 113H
        call    x86_ldasm                               ; 090E _ E8, 00000000(PLT r)
        
        add     rsp, 180H
        ret                                             ; 0917 _ C3
