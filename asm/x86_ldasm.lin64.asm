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
;
[BITS 64]

default rel

        jmp x86_ldasm ; Entrypoint

get_modrm:
        test    byte [rdi+18H], 04H                     ; 0000 _ F6. 47, 18, 04
        jnz     ?_001                                   ; 0004 _ 75, 33
        mov     rcx, qword 0FFFFFFFBFFFFFFF0H           ; 0006 _ 48: B9, FFFFFFFBFFFFFFF0
        movzx   eax, byte [rdi+8H]                      ; 0010 _ 0F B6. 47, 08
        and     rcx, qword [rdi+14H]                    ; 0014 _ 48: 23. 4F, 14
        mov     rdx, rax                                ; 0018 _ 48: 89. C2
        and     edx, 0FH                                ; 001B _ 83. E2, 0F
        bts     rdx, 34                                 ; 001E _ 48: 0F BA. EA, 22
        or      rdx, rcx                                ; 0023 _ 48: 09. CA
        lea     ecx, [rax+1H]                           ; 0026 _ 8D. 48, 01
        mov     qword [rdi+14H], rdx                    ; 0029 _ 48: 89. 57, 14
        mov     rdx, qword [rdi]                        ; 002D _ 48: 8B. 17
        mov     byte [rdi+8H], cl                       ; 0030 _ 88. 4F, 08
        mov     al, byte [rdx+rax]                      ; 0033 _ 8A. 04 02
        mov     byte [rdi+0AH], al                      ; 0036 _ 88. 47, 0A
?_001:  mov     al, byte [rdi+0AH]                      ; 0039 _ 8A. 47, 0A
        ret                                             ; 003C _ C3

get_osize:
        mov     dl, byte [rdi+17H]                      ; 003D _ 8A. 57, 17
        mov     al, byte [rdi+9H]                       ; 0040 _ 8A. 47, 09
        shr     dl, 2                                   ; 0043 _ C0. EA, 02
        mov     ecx, eax                                ; 0046 _ 89. C1
        and     edx, 01H                                ; 0048 _ 83. E2, 01
        and     cl, 03H                                 ; 004B _ 80. E1, 03
        jz      ?_007                                   ; 004E _ 74, 47
        dec     cl                                      ; 0050 _ FE. C9
        jz      ?_006                                   ; 0052 _ 74, 3D
        test    sil, 01H                                ; 0054 _ 40: F6. C6, 01
        jz      ?_003                                   ; 0058 _ 74, 08
?_002:  and     eax, 0FFFFFFF3H                         ; 005A _ 83. E0, F3
        or      eax, 08H                                ; 005D _ 83. C8, 08
        jmp     ?_009                                   ; 0060 _ EB, 3D

?_003:  test    byte [rdi+0DH], 08H                     ; 0062 _ F6. 47, 0D, 08
        jnz     ?_002                                   ; 0066 _ 75, F2
        mov     cl, byte [rdi+18H]                      ; 0068 _ 8A. 4F, 18
        test    cl, 01H                                 ; 006B _ F6. C1, 01
        jz      ?_004                                   ; 006E _ 74, 06
        cmp     byte [rdi+12H], 0                       ; 0070 _ 80. 7F, 12, 00
        js      ?_002                                   ; 0074 _ 78, E4
?_004:  and     cl, 02H                                 ; 0076 _ 80. E1, 02
        jz      ?_005                                   ; 0079 _ 74, 06
        cmp     byte [rdi+12H], 0                       ; 007B _ 80. 7F, 12, 00
        js      ?_002                                   ; 007F _ 78, D9
?_005:  and     sil, 02H                                ; 0081 _ 40: 80. E6, 02
        jz      ?_006                                   ; 0085 _ 74, 0A
        test    dl, dl                                  ; 0087 _ 84. D2
        sete    dl                                      ; 0089 _ 0F 94. C2
        shl     edx, 3                                  ; 008C _ C1. E2, 03
        jmp     ?_008                                   ; 008F _ EB, 09

?_006:  xor     edx, 01H                                ; 0091 _ 83. F2, 01
        and     edx, 03H                                ; 0094 _ 83. E2, 03
?_007:  shl     edx, 2                                  ; 0097 _ C1. E2, 02
?_008:  and     eax, 0FFFFFFF3H                         ; 009A _ 83. E0, F3
        or      eax, edx                                ; 009D _ 09. D0
?_009:  mov     byte [rdi+9H], al                       ; 009F _ 88. 47, 09
        ret                                             ; 00A2 _ C3

x86_ldasm:
        sub     rsp, 320                                ; 00A3 _ 48: 81. EC, 00000140
        mov     eax, esi                                ; 00AA _ 89. F0
        mov     rcx, rdx                                ; 00AC _ 48: 89. D1
        mov     r8, rsp                                 ; 00AF _ 49: 89. E0
        test    rdi, rdi                                ; 00B2 _ 48: 85. FF
        jz      ?_010                                   ; 00B5 _ 74, 03
        mov     r8, rdi                                 ; 00B7 _ 49: 89. F8
?_010:  mov     edx, 134217727                          ; 00BA _ BA, 07FFFFFF
        mov     qword [r8], rcx                         ; 00BF _ 49: 89. 08
        mov     sil, byte [r8+9H]                       ; 00C2 _ 41: 8A. 70, 09
        shl     rdx, 37                                 ; 00C6 _ 48: C1. E2, 25
        and     qword [r8+14H], rdx                     ; 00CA _ 49: 21. 50, 14
        cmp     eax, 2                                  ; 00CE _ 83. F8, 02
        mov     byte [r8+8H], 0                         ; 00D1 _ 41: C6. 40, 08, 00
        mov     dword [r8+0DH], 0                       ; 00D6 _ 41: C7. 40, 0D, 00000000
        mov     qword [r8+20H], -1                      ; 00DE _ 49: C7. 40, 20, FFFFFFFF
        jbe     ?_012                                   ; 00E6 _ 76, 16
        xor     edx, edx                                ; 00E8 _ 31. D2
        cmp     eax, 16                                 ; 00EA _ 83. F8, 10
        jz      ?_011                                   ; 00ED _ 74, 08
        cmp     eax, 32                                 ; 00EF _ 83. F8, 20
        setne   dl                                      ; 00F2 _ 0F 95. C2
        inc     edx                                     ; 00F5 _ FF. C2
?_011:  and     esi, 0FFFFFFFCH                         ; 00F7 _ 83. E6, FC
        or      esi, edx                                ; 00FA _ 09. D6
        jmp     ?_013                                   ; 00FC _ EB, 08

?_012:  and     eax, 03H                                ; 00FE _ 83. E0, 03
        and     esi, 0FFFFFFFCH                         ; 0101 _ 83. E6, FC
        or      esi, eax                                ; 0104 _ 09. C6
?_013:  mov     byte [r8+9H], sil                       ; 0106 _ 41: 88. 70, 09
        mov     rdi, rcx                                ; 010A _ 48: 89. CF
        xor     eax, eax                                ; 010D _ 31. C0
?_014:  mov     dl, byte [rdi]                          ; 010F _ 8A. 17
        mov     esi, edx                                ; 0111 _ 89. D6
        shr     sil, 4                                  ; 0113 _ 40: C0. EE, 04
        cmp     sil, 4                                  ; 0117 _ 40: 80. FE, 04
        jnz     ?_015                                   ; 011B _ 75, 3F
        mov     sil, byte [r8+9H]                       ; 011D _ 41: 8A. 70, 09
        and     esi, 03H                                ; 0121 _ 83. E6, 03
        cmp     sil, 2                                  ; 0124 _ 40: 80. FE, 02
        jne     ?_024                                   ; 0128 _ 0F 85, 000000EE
        mov     byte [r8+0EH], dl                       ; 012E _ 41: 88. 50, 0E
        mov     esi, dword [r8+14H]                     ; 0132 _ 41: 8B. 70, 14
        mov     byte [r8+0DH], dl                       ; 0136 _ 41: 88. 50, 0D
        mov     edx, eax                                ; 013A _ 89. C2
        shl     edx, 8                                  ; 013C _ C1. E2, 08
        and     esi, 0FEFFF0FFH                         ; 013F _ 81. E6, FEFFF0FF
        or      edx, 1000000H                           ; 0145 _ 81. CA, 01000000
        and     edx, 1000F00H                           ; 014B _ 81. E2, 01000F00
        or      edx, esi                                ; 0151 _ 09. F2
        mov     dword [r8+14H], edx                     ; 0153 _ 41: 89. 50, 14
        jmp     ?_023                                   ; 0157 _ E9, 000000AE

?_015:  cmp     dl, 102                                 ; 015C _ 80. FA, 66
        jnz     ?_016                                   ; 015F _ 75, 25
        mov     sil, byte [r8+10H]                      ; 0161 _ 41: 8A. 70, 10
        or      byte [r8+17H], 04H                      ; 0165 _ 41: 80. 48, 17, 04
        mov     byte [r8+0EH], 102                      ; 016A _ 41: C6. 40, 0E, 66
        lea     edx, [rsi+0EH]                          ; 016F _ 8D. 56, 0E
        cmp     dl, 1                                   ; 0172 _ 80. FA, 01
        jbe     ?_023                                   ; 0175 _ 0F 86, 0000008F
        mov     dl, byte [rdi]                          ; 017B _ 8A. 17
        mov     byte [r8+10H], dl                       ; 017D _ 41: 88. 50, 10
        jmp     ?_023                                   ; 0181 _ E9, 00000084

?_016:  cmp     dl, 103                                 ; 0186 _ 80. FA, 67
        jnz     ?_017                                   ; 0189 _ 75, 0C
        or      byte [r8+17H], 08H                      ; 018B _ 41: 80. 48, 17, 08
        mov     byte [r8+0EH], 103                      ; 0190 _ 41: C6. 40, 0E, 67
        jmp     ?_023                                   ; 0195 _ EB, 73

?_017:  mov     esi, edx                                ; 0197 _ 89. D6
        and     esi, 0FFFFFFE7H                         ; 0199 _ 83. E6, E7
        cmp     sil, 38                                 ; 019C _ 40: 80. FE, 26
        jnz     ?_018                                   ; 01A0 _ 75, 13
        mov     sil, byte [r8+9H]                       ; 01A2 _ 41: 8A. 70, 09
        mov     byte [r8+0FH], dl                       ; 01A6 _ 41: 88. 50, 0F
        and     esi, 03H                                ; 01AA _ 83. E6, 03
        cmp     sil, 2                                  ; 01AD _ 40: 80. FE, 02
        jnz     ?_019                                   ; 01B1 _ 75, 0F
        jmp     ?_023                                   ; 01B3 _ EB, 55

?_018:  lea     esi, [rdx-64H]                          ; 01B5 _ 8D. 72, 9C
        cmp     sil, 1                                  ; 01B8 _ 40: 80. FE, 01
        ja      ?_020                                   ; 01BC _ 77, 0F
        mov     byte [r8+0FH], dl                       ; 01BE _ 41: 88. 50, 0F
?_019:  or      byte [r8+17H], 02H                      ; 01C2 _ 41: 80. 48, 17, 02
        mov     byte [r8+0EH], dl                       ; 01C7 _ 41: 88. 50, 0E
        jmp     ?_023                                   ; 01CB _ EB, 3D

?_020:  cmp     dl, -16                                 ; 01CD _ 80. FA, F0
        jnz     ?_021                                   ; 01D0 _ 75, 0C
        or      byte [r8+17H], 10H                      ; 01D2 _ 41: 80. 48, 17, 10
        mov     byte [r8+0EH], -16                      ; 01D7 _ 41: C6. 40, 0E, F0
        jmp     ?_023                                   ; 01DC _ EB, 2C

?_021:  cmp     dl, -14                                 ; 01DE _ 80. FA, F2
        jnz     ?_022                                   ; 01E1 _ 75, 12
        mov     byte [r8+0EH], -14                      ; 01E3 _ 41: C6. 40, 0E, F2
        mov     dl, byte [rdi]                          ; 01E8 _ 8A. 17
        or      byte [r8+17H], 40H                      ; 01EA _ 41: 80. 48, 17, 40
        mov     byte [r8+10H], dl                       ; 01EF _ 41: 88. 50, 10
        jmp     ?_023                                   ; 01F3 _ EB, 15

?_022:  cmp     dl, -13                                 ; 01F5 _ 80. FA, F3
        jnz     ?_024                                   ; 01F8 _ 75, 22
        mov     byte [r8+0EH], -13                      ; 01FA _ 41: C6. 40, 0E, F3
        mov     dl, byte [rdi]                          ; 01FF _ 8A. 17
        or      byte [r8+17H], 20H                      ; 0201 _ 41: 80. 48, 17, 20
        mov     byte [r8+10H], dl                       ; 0206 _ 41: 88. 50, 10
?_023:  inc     rax                                     ; 020A _ 48: FF. C0
        inc     rdi                                     ; 020D _ 48: FF. C7
        cmp     rax, 15                                 ; 0210 _ 48: 83. F8, 0F
        jne     ?_014                                   ; 0214 _ 0F 85, FFFFFEF5
        jmp     ?_027                                   ; 021A _ EB, 5A

?_024:  mov     sil, byte [r8+9H]                       ; 021C _ 41: 8A. 70, 09
        and     esi, 03H                                ; 0220 _ 83. E6, 03
        cmp     sil, 2                                  ; 0223 _ 40: 80. FE, 02
        jnz     ?_025                                   ; 0227 _ 75, 19
        mov     dl, byte [r8+0EH]                       ; 0229 _ 41: 8A. 50, 0E
        shr     dl, 4                                   ; 022D _ C0. EA, 04
        cmp     dl, 4                                   ; 0230 _ 80. FA, 04
        jz      ?_025                                   ; 0233 _ 74, 0D
        and     dword [r8+14H], 0FEFFF0FFH              ; 0235 _ 41: 81. 60, 14, FEFFF0FF
        mov     byte [r8+0DH], 0                        ; 023D _ 41: C6. 40, 0D, 00
?_025:  mov     edx, 51                                 ; 0242 _ BA, 00000033
        shl     rdx, 33                                 ; 0247 _ 48: C1. E2, 21
        mov     qword [rsp+2CH], rdx                    ; 024B _ 48: 89. 54 24, 2C
        mov     rdx, qword 0F2000000F3H                 ; 0250 _ 48: BA, 000000F2000000F3
        mov     qword [rsp+34H], rdx                    ; 025A _ 48: 89. 54 24, 34
        mov     dl, byte [rdi]                          ; 025F _ 8A. 17
        cmp     dl, -60                                 ; 0261 _ 80. FA, C4
        jne     ?_031                                   ; 0264 _ 0F 85, 00000083
        cmp     sil, 2                                  ; 026A _ 40: 80. FE, 02
        jnz     ?_028                                   ; 026E _ 75, 0E
?_026:  cmp     rax, 10                                 ; 0270 _ 48: 83. F8, 0A
        jbe     ?_029                                   ; 0274 _ 76, 1A
?_027:  or      eax, 0FFFFFFFFH                         ; 0276 _ 83. C8, FF
        jmp     ?_098                                   ; 0279 _ E9, 00000650

?_028:  mov     dl, byte [rcx+rax+1H]                   ; 027E _ 8A. 54 01, 01
        shr     dl, 6                                   ; 0282 _ C0. EA, 06
        cmp     dl, 3                                   ; 0285 _ 80. FA, 03
        jne     ?_042                                   ; 0288 _ 0F 85, 000001AC
        jmp     ?_026                                   ; 028E _ EB, E0

?_029:  test    byte [r8+17H], 75H                      ; 0290 _ 41: F6. 40, 17, 75
        jnz     ?_027                                   ; 0295 _ 75, DF
        mov     dil, byte [rcx+rax+1H]                  ; 0297 _ 40: 8A. 7C 01, 01
        mov     byte [r8+11H], dil                      ; 029C _ 41: 88. 78, 11
        mov     dl, byte [rcx+rax+2H]                   ; 02A0 _ 8A. 54 01, 02
        mov     r9d, edi                                ; 02A4 _ 41: 89. F9
        or      byte [r8+18H], 01H                      ; 02A7 _ 41: 80. 48, 18, 01
        mov     byte [r8+12H], dl                       ; 02AC _ 41: 88. 50, 12
        and     r9b, 1FH                                ; 02B0 _ 41: 80. E1, 1F
        jz      ?_027                                   ; 02B4 _ 74, C0
        and     dil, 1CH                                ; 02B6 _ 40: 80. E7, 1C
        jnz     ?_027                                   ; 02BA _ 75, BA
        mov     ecx, 256                                ; 02BC _ B9, 00000100
        cmp     r9b, 1                                  ; 02C1 _ 41: 80. F9, 01
        jz      ?_030                                   ; 02C5 _ 74, 12
        cmp     r9b, 2                                  ; 02C7 _ 41: 80. F9, 02
        mov     ecx, 512                                ; 02CB _ B9, 00000200
        mov     edi, 768                                ; 02D0 _ BF, 00000300
        cmovne  rcx, rdi                                ; 02D5 _ 48: 0F 45. CF
?_030:  and     edx, 03H                                ; 02D9 _ 83. E2, 03
        mov     qword [r8+20H], rcx                     ; 02DC _ 49: 89. 48, 20
        mov     edx, dword [rsp+rdx*4+2CH]              ; 02E0 _ 8B. 54 94, 2C
        mov     byte [r8+10H], dl                       ; 02E4 _ 41: 88. 50, 10
        jmp     ?_037                                   ; 02E8 _ E9, 0000010E

?_031:  cmp     dl, -59                                 ; 02ED _ 80. FA, C5
        jnz     ?_033                                   ; 02F0 _ 75, 55
        cmp     sil, 2                                  ; 02F2 _ 40: 80. FE, 02
        jz      ?_032                                   ; 02F6 _ 74, 10
        mov     dl, byte [rcx+rax+1H]                   ; 02F8 _ 8A. 54 01, 01
        shr     dl, 6                                   ; 02FC _ C0. EA, 06
        cmp     dl, 3                                   ; 02FF _ 80. FA, 03
        jne     ?_042                                   ; 0302 _ 0F 85, 00000132
?_032:  cmp     rax, 11                                 ; 0308 _ 48: 83. F8, 0B
        ja      ?_027                                   ; 030C _ 0F 87, FFFFFF64
        mov     dil, byte [r8+17H]                      ; 0312 _ 41: 8A. 78, 17
        test    dil, 75H                                ; 0316 _ 40: F6. C7, 75
        jne     ?_027                                   ; 031A _ 0F 85, FFFFFF56
        mov     dl, byte [rcx+rax+1H]                   ; 0320 _ 8A. 54 01, 01
        or      edi, 0FFFFFF80H                         ; 0324 _ 83. CF, 80
        mov     qword [r8+20H], 256                     ; 0327 _ 49: C7. 40, 20, 00000100
        mov     byte [r8+17H], dil                      ; 032F _ 41: 88. 78, 17
        mov     byte [r8+11H], dl                       ; 0333 _ 41: 88. 50, 11
        and     edx, 03H                                ; 0337 _ 83. E2, 03
        mov     edx, dword [rsp+rdx*4+2CH]              ; 033A _ 8B. 54 94, 2C
        mov     byte [r8+10H], dl                       ; 033E _ 41: 88. 50, 10
        jmp     ?_039                                   ; 0342 _ E9, 000000D4

?_033:  cmp     dl, 98                                  ; 0347 _ 80. FA, 62
        jnz     ?_034                                   ; 034A _ 75, 1F
        cmp     sil, 2                                  ; 034C _ 40: 80. FE, 02
        je      ?_027                                   ; 0350 _ 0F 84, FFFFFF20
        mov     dl, byte [rcx+rax+1H]                   ; 0356 _ 8A. 54 01, 01
        shr     dl, 6                                   ; 035A _ C0. EA, 06
        cmp     dl, 3                                   ; 035D _ 80. FA, 03
        jne     ?_042                                   ; 0360 _ 0F 85, 000000D4
        jmp     ?_027                                   ; 0366 _ E9, FFFFFF0B

?_034:  cmp     dl, -113                                ; 036B _ 80. FA, 8F
        jne     ?_038                                   ; 036E _ 0F 85, 0000008D
        mov     dl, byte [rcx+rax+1H]                   ; 0374 _ 8A. 54 01, 01
        cmp     sil, 2                                  ; 0378 _ 40: 80. FE, 02
        jz      ?_035                                   ; 037C _ 74, 10
        mov     edi, edx                                ; 037E _ 89. D7
        shr     dil, 6                                  ; 0380 _ 40: C0. EF, 06
        cmp     dil, 3                                  ; 0384 _ 40: 80. FF, 03
        jne     ?_042                                   ; 0388 _ 0F 85, 000000AC
?_035:  test    dl, 18H                                 ; 038E _ F6. C2, 18
        je      ?_042                                   ; 0391 _ 0F 84, 000000A3
        mov     edi, edx                                ; 0397 _ 89. D7
        and     edi, 1FH                                ; 0399 _ 83. E7, 1F
        cmp     dil, 10                                 ; 039C _ 40: 80. FF, 0A
        ja      ?_042                                   ; 03A0 _ 0F 87, 00000094
        cmp     rax, 10                                 ; 03A6 _ 48: 83. F8, 0A
        ja      ?_027                                   ; 03AA _ 0F 87, FFFFFEC6
        test    byte [r8+17H], 75H                      ; 03B0 _ 41: F6. 40, 17, 75
        jne     ?_027                                   ; 03B5 _ 0F 85, FFFFFEBB
        mov     byte [r8+11H], dl                       ; 03BB _ 41: 88. 50, 11
        mov     dl, byte [rcx+rax+2H]                   ; 03BF _ 8A. 54 01, 02
        or      byte [r8+18H], 02H                      ; 03C3 _ 41: 80. 48, 18, 02
        mov     byte [r8+12H], dl                       ; 03C8 _ 41: 88. 50, 12
        and     dl, 03H                                 ; 03CC _ 80. E2, 03
        jne     ?_027                                   ; 03CF _ 0F 85, FFFFFEA1
        mov     edx, 1024                               ; 03D5 _ BA, 00000400
        cmp     dil, 8                                  ; 03DA _ 40: 80. FF, 08
        jz      ?_036                                   ; 03DE _ 74, 12
        cmp     dil, 9                                  ; 03E0 _ 40: 80. FF, 09
        mov     edx, 1280                               ; 03E4 _ BA, 00000500
        mov     ecx, 1536                               ; 03E9 _ B9, 00000600
        cmovne  rdx, rcx                                ; 03EE _ 48: 0F 45. D1
?_036:  mov     qword [r8+20H], rdx                     ; 03F2 _ 49: 89. 50, 20
        mov     byte [r8+10H], 0                        ; 03F6 _ 41: C6. 40, 10, 00
?_037:  lea     rdx, [rax+3H]                           ; 03FB _ 48: 8D. 50, 03
        jmp     ?_043                                   ; 03FF _ EB, 49

?_038:  cmp     dl, 15                                  ; 0401 _ 80. FA, 0F
        jnz     ?_042                                   ; 0404 _ 75, 34
        mov     cl, byte [rcx+rax+1H]                   ; 0406 _ 8A. 4C 01, 01
        lea     rdx, [rax+1H]                           ; 040A _ 48: 8D. 50, 01
        cmp     cl, 56                                  ; 040E _ 80. F9, 38
        jnz     ?_040                                   ; 0411 _ 75, 0E
        mov     qword [r8+20H], 512                     ; 0413 _ 49: C7. 40, 20, 00000200
?_039:  lea     rdx, [rax+2H]                           ; 041B _ 48: 8D. 50, 02
        jmp     ?_043                                   ; 041F _ EB, 29

?_040:  cmp     cl, 58                                  ; 0421 _ 80. F9, 3A
        jnz     ?_041                                   ; 0424 _ 75, 0A
        mov     qword [r8+20H], 768                     ; 0426 _ 49: C7. 40, 20, 00000300
        jmp     ?_039                                   ; 042E _ EB, EB

?_041:  mov     qword [r8+20H], 256                     ; 0430 _ 49: C7. 40, 20, 00000100
        jmp     ?_043                                   ; 0438 _ EB, 10

?_042:  mov     byte [r8+10H], 0                        ; 043A _ 41: C6. 40, 10, 00
        mov     rdx, rax                                ; 043F _ 48: 89. C2
        mov     qword [r8+20H], 0                       ; 0442 _ 49: C7. 40, 20, 00000000
?_043:  mov     al, byte [r8+15H]                       ; 044A _ 41: 8A. 40, 15
        mov     byte [r8+8H], dl                        ; 044E _ 41: 88. 50, 08
        shl     edx, 4                                  ; 0452 _ C1. E2, 04
        and     eax, 0FH                                ; 0455 _ 83. E0, 0F
        or      edx, eax                                ; 0458 _ 09. C2
        mov     al, byte [r8+17H]                       ; 045A _ 41: 8A. 40, 17
        mov     byte [r8+15H], dl                       ; 045E _ 41: 88. 50, 15
        mov     dl, byte [r8+9H]                        ; 0462 _ 41: 8A. 50, 09
        shr     al, 3                                   ; 0466 _ C0. E8, 03
        and     eax, 01H                                ; 0469 _ 83. E0, 01
        test    sil, sil                                ; 046C _ 40: 84. F6
        jnz     ?_044                                   ; 046F _ 75, 0E
        shl     eax, 4                                  ; 0471 _ C1. E0, 04
        and     edx, 0FFFFFFCFH                         ; 0474 _ 83. E2, CF
        or      eax, edx                                ; 0477 _ 09. D0
        mov     byte [r8+9H], al                        ; 0479 _ 41: 88. 40, 09
        jmp     ?_045                                   ; 047D _ EB, 24

?_044:  mov     cl, 2                                   ; 047F _ B1, 02
        and     edx, 0FFFFFFCFH                         ; 0481 _ 83. E2, CF
        sub     ecx, eax                                ; 0484 _ 29. C1
        xor     eax, 01H                                ; 0486 _ 83. F0, 01
        and     ecx, 03H                                ; 0489 _ 83. E1, 03
        and     eax, 03H                                ; 048C _ 83. E0, 03
        shl     ecx, 4                                  ; 048F _ C1. E1, 04
        shl     eax, 4                                  ; 0492 _ C1. E0, 04
        or      ecx, edx                                ; 0495 _ 09. D1
        or      eax, edx                                ; 0497 _ 09. D0
        dec     sil                                     ; 0499 _ 40: FE. CE
        cmove   ecx, eax                                ; 049C _ 0F 44. C8
        mov     byte [r8+9H], cl                        ; 049F _ 41: 88. 48, 09
?_045:  xor     esi, esi                                ; 04A3 _ 31. F6
        mov     rdi, r8                                 ; 04A5 _ 4C: 89. C7
        xor     r10d, r10d                              ; 04A8 _ 45: 31. D2
        call    get_osize                               ; 04AB _ E8, FFFFFB8D
        movzx   eax, byte [r8+8H]                       ; 04B0 _ 41: 0F B6. 40, 08
        mov     rdx, qword [r8]                         ; 04B5 _ 49: 8B. 10
        lea     rdi, [rsp+2CH]                          ; 04B8 _ 48: 8D. 7C 24, 2C
        lea     rsi, [rel ?_099]                        ; 04BD _ 48: 8D. 35, 00000000(rel)
        mov     ecx, 275                                ; 04C4 _ B9, 00000113
        rep movsb                                       ; 04C9 _ F3: A4
        lea     ecx, [rax+1H]                           ; 04CB _ 8D. 48, 01
        mov     byte [r8+8H], cl                        ; 04CE _ 41: 88. 48, 08
        mov     rcx, qword [r8+20H]                     ; 04D2 _ 49: 8B. 48, 20
        movzx   r9d, byte [rdx+rax]                     ; 04D6 _ 44: 0F B6. 0C 02
        xor     edx, edx                                ; 04DB _ 31. D2
        mov     rax, r9                                 ; 04DD _ 4C: 89. C8
        add     r9, rcx                                 ; 04E0 _ 49: 01. C9
?_046:  mov     sil, byte [rsp+rdx+2CH]                 ; 04E3 _ 40: 8A. 74 14, 2C
        mov     edi, esi                                ; 04E8 _ 89. F7
        test    sil, sil                                ; 04EA _ 40: 84. F6
        js      ?_047                                   ; 04ED _ 78, 09
        shr     dil, 4                                  ; 04EF _ 40: C0. EF, 04
        and     esi, 0FH                                ; 04F3 _ 83. E6, 0F
        jmp     ?_048                                   ; 04F6 _ EB, 0B

?_047:  movzx   esi, byte [rsp+rdx+2DH]                 ; 04F8 _ 0F B6. 74 14, 2D
        and     edi, 7FH                                ; 04FD _ 83. E7, 7F
        inc     rdx                                     ; 0500 _ 48: FF. C2
?_048:  movzx   edi, dil                                ; 0503 _ 40: 0F B6. FF
        add     r10, rdi                                ; 0507 _ 49: 01. FA
        cmp     r9, r10                                 ; 050A _ 4D: 39. D1
        jc      ?_049                                   ; 050D _ 72, 0C
        inc     rdx                                     ; 050F _ 48: FF. C2
        cmp     rdx, 274                                ; 0512 _ 48: 81. FA, 00000112
        jbe     ?_046                                   ; 0519 _ 76, C8
?_049:  test    rcx, rcx                                ; 051B _ 48: 85. C9
        jne     ?_053                                   ; 051E _ 0F 85, 00000093
        lea     edx, [rax+18H]                          ; 0524 _ 8D. 50, 18
        cmp     dl, 1                                   ; 0527 _ 80. FA, 01
        jbe     ?_054                                   ; 052A _ 0F 86, 00000098
        lea     edx, [rax+48H]                          ; 0530 _ 8D. 50, 48
        cmp     dl, 7                                   ; 0533 _ 80. FA, 07
        jbe     ?_058                                   ; 0536 _ 0F 86, 000000C9
        lea     edx, [rax+60H]                          ; 053C _ 8D. 50, 60
        cmp     dl, 3                                   ; 053F _ 80. FA, 03
        jbe     ?_059                                   ; 0542 _ 0F 86, 000000C4
        mov     edx, eax                                ; 0548 _ 89. C2
        and     edx, 0FFFFFFF7H                         ; 054A _ 83. E2, F7
        cmp     dl, -62                                 ; 054D _ 80. FA, C2
        je      ?_060                                   ; 0550 _ 0F 84, 000000BD
        cmp     al, -56                                 ; 0556 _ 3C, C8
        je      ?_061                                   ; 0558 _ 0F 84, 000000BC
        cmp     al, 104                                 ; 055E _ 3C, 68
        jnz     ?_050                                   ; 0560 _ 75, 07
        mov     esi, 2                                  ; 0562 _ BE, 00000002
        jmp     ?_055                                   ; 0567 _ EB, 64

?_050:  cmp     al, -22                                 ; 0569 _ 3C, EA
        je      ?_062                                   ; 056B _ 0F 84, 000000B0
        cmp     al, -102                                ; 0571 _ 3C, 9A
        je      ?_062                                   ; 0573 _ 0F 84, 000000A8
        cmp     al, -10                                 ; 0579 _ 3C, F6
        jnz     ?_052                                   ; 057B _ 75, 20
        mov     rdi, r8                                 ; 057D _ 4C: 89. C7
        call    get_modrm                               ; 0580 _ E8, FFFFFA7B
        shr     al, 3                                   ; 0585 _ C0. E8, 03
        test    al, 06H                                 ; 0588 _ A8, 06
        je      ?_063                                   ; 058A _ 0F 84, 00000098
?_051:  test    esi, esi                                ; 0590 _ 85. F6
        je      ?_090                                   ; 0592 _ 0F 84, 000002CC
        jmp     ?_065                                   ; 0598 _ E9, 00000097

?_052:  cmp     al, -9                                  ; 059D _ 3C, F7
        jnz     ?_051                                   ; 059F _ 75, EF
        mov     rdi, r8                                 ; 05A1 _ 4C: 89. C7
        call    get_modrm                               ; 05A4 _ E8, FFFFFA57
        shr     al, 3                                   ; 05A9 _ C0. E8, 03
        test    al, 06H                                 ; 05AC _ A8, 06
        jnz     ?_051                                   ; 05AE _ 75, E0
        mov     esi, 3                                  ; 05B0 _ BE, 00000003
        jmp     ?_065                                   ; 05B5 _ EB, 7D

?_053:  cmp     rcx, 256                                ; 05B7 _ 48: 81. F9, 00000100
        jnz     ?_057                                   ; 05BE _ 75, 2E
        lea     edx, [rax-80H]                          ; 05C0 _ 8D. 50, 80
        cmp     dl, 15                                  ; 05C3 _ 80. FA, 0F
        ja      ?_056                                   ; 05C6 _ 77, 14
?_054:  mov     esi, 1                                  ; 05C8 _ BE, 00000001
?_055:  mov     rdi, r8                                 ; 05CD _ 4C: 89. C7
        call    get_osize                               ; 05D0 _ E8, FFFFFA68
        mov     esi, 2                                  ; 05D5 _ BE, 00000002
        jmp     ?_065                                   ; 05DA _ EB, 58

?_056:  cmp     al, 120                                 ; 05DC _ 3C, 78
        jnz     ?_051                                   ; 05DE _ 75, B0
        mov     al, byte [r8+10H]                       ; 05E0 _ 41: 8A. 40, 10
        cmp     al, -14                                 ; 05E4 _ 3C, F2
        jz      ?_064                                   ; 05E6 _ 74, 47
        cmp     al, 102                                 ; 05E8 _ 3C, 66
        jnz     ?_051                                   ; 05EA _ 75, A4
        jmp     ?_064                                   ; 05EC _ EB, 41

?_057:  cmp     rcx, 1536                               ; 05EE _ 48: 81. F9, 00000600
        jnz     ?_051                                   ; 05F5 _ 75, 99
        and     eax, 0FFFFFFFDH                         ; 05F7 _ 83. E0, FD
        cmp     al, 16                                  ; 05FA _ 3C, 10
        jnz     ?_051                                   ; 05FC _ 75, 92
        mov     esi, 65                                 ; 05FE _ BE, 00000041
        jmp     ?_065                                   ; 0603 _ EB, 2F

?_058:  mov     esi, 16                                 ; 0605 _ BE, 00000010
        jmp     ?_065                                   ; 060A _ EB, 28

?_059:  mov     esi, 8                                  ; 060C _ BE, 00000008
        jmp     ?_065                                   ; 0611 _ EB, 21

?_060:  mov     esi, 32                                 ; 0613 _ BE, 00000020
        jmp     ?_065                                   ; 0618 _ EB, 1A

?_061:  mov     esi, 36                                 ; 061A _ BE, 00000024
        jmp     ?_065                                   ; 061F _ EB, 13

?_062:  mov     esi, 128                                ; 0621 _ BE, 00000080
        jmp     ?_065                                   ; 0626 _ EB, 0C

?_063:  mov     esi, 5                                  ; 0628 _ BE, 00000005
        jmp     ?_065                                   ; 062D _ EB, 05

?_064:  mov     esi, 33                                 ; 062F _ BE, 00000021
?_065:  test    sil, 01H                                ; 0634 _ 40: F6. C6, 01
        je      ?_080                                   ; 0638 _ 0F 84, 00000168
        mov     rdi, r8                                 ; 063E _ 4C: 89. C7
        call    get_modrm                               ; 0641 _ E8, FFFFF9BA
        shr     al, 6                                   ; 0646 _ C0. E8, 06
        mov     r9d, eax                                ; 0649 _ 41: 89. C1
        call    get_modrm                               ; 064C _ E8, FFFFF9AF
        and     eax, 07H                                ; 0651 _ 83. E0, 07
        cmp     r9b, 3                                  ; 0654 _ 41: 80. F9, 03
        je      ?_080                                   ; 0658 _ 0F 84, 00000148
        mov     cl, byte [r8+9H]                        ; 065E _ 41: 8A. 48, 09
        mov     edx, ecx                                ; 0662 _ 89. CA
        and     edx, 03H                                ; 0664 _ 83. E2, 03
        cmp     dl, 2                                   ; 0667 _ 80. FA, 02
        jnz     ?_069                                   ; 066A _ 75, 2F
        test    byte [r8+17H], 01H                      ; 066C _ 41: F6. 40, 17, 01
        jz      ?_066                                   ; 0671 _ 74, 0D
        movzx   edx, byte [r8+0DH]                      ; 0673 _ 41: 0F B6. 50, 0D
        shl     edx, 3                                  ; 0678 _ C1. E2, 03
        and     edx, 08H                                ; 067B _ 83. E2, 08
        jmp     ?_068                                   ; 067E _ EB, 19

?_066:  mov     dl, byte [r8+18H]                       ; 0680 _ 41: 8A. 50, 18
        test    dl, 01H                                 ; 0684 _ F6. C2, 01
        jnz     ?_067                                   ; 0687 _ 75, 05
        and     dl, 02H                                 ; 0689 _ 80. E2, 02
        jz      ?_069                                   ; 068C _ 74, 0D
?_067:  test    byte [r8+11H], 20H                      ; 068E _ 41: F6. 40, 11, 20
        sete    dl                                      ; 0693 _ 0F 94. C2
        shl     edx, 3                                  ; 0696 _ C1. E2, 03
?_068:  or      eax, edx                                ; 0699 _ 09. D0
?_069:  and     eax, 07H                                ; 069B _ 83. E0, 07
        and     cl, 30H                                 ; 069E _ 80. E1, 30
        jnz     ?_071                                   ; 06A1 _ 75, 1C
        test    r9b, r9b                                ; 06A3 _ 45: 84. C9
        jnz     ?_070                                   ; 06A6 _ 75, 08
        cmp     al, 6                                   ; 06A8 _ 3C, 06
        je      ?_078                                   ; 06AA _ 0F 84, 000000CC
?_070:  cmp     r9b, 1                                  ; 06B0 _ 41: 80. F9, 01
        jne     ?_091                                   ; 06B4 _ 0F 85, 000001B1
        jmp     ?_077                                   ; 06BA _ E9, 000000B8

?_071:  test    r9b, r9b                                ; 06BF _ 45: 84. C9
        jnz     ?_072                                   ; 06C2 _ 75, 0C
        cmp     al, 5                                   ; 06C4 _ 3C, 05
        jnz     ?_073                                   ; 06C6 _ 75, 1A
        mov     r9b, 3                                  ; 06C8 _ 41: B1, 03
        jmp     ?_079                                   ; 06CB _ E9, 000000AF

?_072:  cmp     r9b, 1                                  ; 06D0 _ 41: 80. F9, 01
        je      ?_097                                   ; 06D4 _ 0F 84, 000001E7
        mov     r9b, 3                                  ; 06DA _ 41: B1, 03
        jmp     ?_097                                   ; 06DD _ E9, 000001DF

?_073:  cmp     al, 4                                   ; 06E2 _ 3C, 04
        jne     ?_080                                   ; 06E4 _ 0F 85, 000000BC
?_074:  test    byte [r8+18H], 08H                      ; 06EA _ 41: F6. 40, 18, 08
        jnz     ?_075                                   ; 06EF _ 75, 3A
        mov     rcx, qword 0FFFFFFF7FFFFFF0FH           ; 06F1 _ 48: B9, FFFFFFF7FFFFFF0F
        movzx   edx, byte [r8+8H]                       ; 06FB _ 41: 0F B6. 50, 08
        and     rcx, qword [r8+14H]                     ; 0700 _ 49: 23. 48, 14
        mov     rax, rdx                                ; 0704 _ 48: 89. D0
        and     eax, 0FH                                ; 0707 _ 83. E0, 0F
        shl     rax, 4                                  ; 070A _ 48: C1. E0, 04
        bts     rax, 35                                 ; 070E _ 48: 0F BA. E8, 23
        or      rax, rcx                                ; 0713 _ 48: 09. C8
        lea     ecx, [rdx+1H]                           ; 0716 _ 8D. 4A, 01
        mov     qword [r8+14H], rax                     ; 0719 _ 49: 89. 40, 14
        mov     rax, qword [r8]                         ; 071D _ 49: 8B. 00
        mov     byte [r8+8H], cl                        ; 0720 _ 41: 88. 48, 08
        mov     al, byte [rax+rdx]                      ; 0724 _ 8A. 04 10
        mov     byte [r8+0BH], al                       ; 0727 _ 41: 88. 40, 0B
?_075:  mov     rdi, r8                                 ; 072B _ 4C: 89. C7
        mov     r10b, byte [r8+0BH]                     ; 072E _ 45: 8A. 50, 0B
        call    get_modrm                               ; 0732 _ E8, FFFFF8C9
        mov     ecx, eax                                ; 0737 _ 89. C1
        mov     al, byte [r8+9H]                        ; 0739 _ 41: 8A. 40, 09
        and     r10d, 07H                               ; 073D _ 41: 83. E2, 07
        mov     edx, eax                                ; 0741 _ 89. C2
        and     edx, 03H                                ; 0743 _ 83. E2, 03
        cmp     dl, 2                                   ; 0746 _ 80. FA, 02
        je      ?_092                                   ; 0749 _ 0F 84, 0000012B
?_076:  and     eax, 30H                                ; 074F _ 83. E0, 30
        sub     eax, 16                                 ; 0752 _ 83. E8, 10
        test    al, 0E0H                                ; 0755 _ A8, E0
        jne     ?_096                                   ; 0757 _ 0F 85, 00000156
        and     r10d, 0FFFFFFF7H                        ; 075D _ 41: 83. E2, F7
        cmp     r10b, 5                                 ; 0761 _ 41: 80. FA, 05
        jne     ?_096                                   ; 0765 _ 0F 85, 00000148
        mov     eax, ecx                                ; 076B _ 89. C8
        mov     r9b, 3                                  ; 076D _ 41: B1, 03
        shr     al, 6                                   ; 0770 _ C0. E8, 06
        dec     al                                      ; 0773 _ FE. C8
        jnz     ?_079                                   ; 0775 _ 75, 08
?_077:  mov     r9b, 1                                  ; 0777 _ 41: B1, 01
        jmp     ?_079                                   ; 077A _ EB, 03

?_078:  mov     r9b, 2                                  ; 077C _ 41: B1, 02
?_079:  movzx   ecx, r9b                                ; 077F _ 41: 0F B6. C9
        mov     dl, byte [r8+8H]                        ; 0783 _ 41: 8A. 50, 08
        mov     eax, 1                                  ; 0787 _ B8, 00000001
        dec     ecx                                     ; 078C _ FF. C9
        shl     eax, cl                                 ; 078E _ D3. E0
        mov     edi, edx                                ; 0790 _ 89. D7
        mov     ecx, eax                                ; 0792 _ 89. C1
        and     edi, 0FH                                ; 0794 _ 83. E7, 0F
        add     edx, eax                                ; 0797 _ 01. C2
        shl     ecx, 4                                  ; 0799 _ C1. E1, 04
        mov     byte [r8+8H], dl                        ; 079C _ 41: 88. 50, 08
        or      ecx, edi                                ; 07A0 _ 09. F9
        mov     byte [r8+16H], cl                       ; 07A2 _ 41: 88. 48, 16
?_080:  test    sil, 02H                                ; 07A6 _ 40: F6. C6, 02
        jz      ?_081                                   ; 07AA _ 74, 18
        mov     al, byte [r8+9H]                        ; 07AC _ 41: 8A. 40, 09
        and     eax, 0CH                                ; 07B0 _ 83. E0, 0C
        cmp     al, 1                                   ; 07B3 _ 3C, 01
        sbb     rax, rax                                ; 07B5 _ 48: 19. C0
        and     rax, 0FFFFFFFFFFFFFFFEH                 ; 07B8 _ 48: 83. E0, FE
        add     rax, 4                                  ; 07BC _ 48: 83. C0, 04
        add     byte [r8+8H], al                        ; 07C0 _ 41: 00. 40, 08
?_081:  test    sil, 04H                                ; 07C4 _ 40: F6. C6, 04
        jz      ?_082                                   ; 07C8 _ 74, 04
        inc     byte [r8+8H]                            ; 07CA _ 41: FE. 40, 08
?_082:  test    sil, 08H                                ; 07CE _ 40: F6. C6, 08
        jz      ?_084                                   ; 07D2 _ 74, 22
        mov     dl, byte [r8+9H]                        ; 07D4 _ 41: 8A. 50, 09
        mov     eax, 2                                  ; 07D8 _ B8, 00000002
        and     dl, 30H                                 ; 07DD _ 80. E2, 30
        jz      ?_083                                   ; 07E0 _ 74, 10
        xor     eax, eax                                ; 07E2 _ 31. C0
        cmp     dl, 16                                  ; 07E4 _ 80. FA, 10
        setne   al                                      ; 07E7 _ 0F 95. C0
        lea     rax, [rax*4+4H]                         ; 07EA _ 48: 8D. 04 85, 00000004
?_083:  add     byte [r8+8H], al                        ; 07F2 _ 41: 00. 40, 08
?_084:  test    sil, 10H                                ; 07F6 _ 40: F6. C6, 10
        jz      ?_086                                   ; 07FA _ 74, 22
        mov     dl, byte [r8+9H]                        ; 07FC _ 41: 8A. 50, 09
        mov     eax, 2                                  ; 0800 _ B8, 00000002
        and     dl, 0CH                                 ; 0805 _ 80. E2, 0C
        jz      ?_085                                   ; 0808 _ 74, 10
        xor     eax, eax                                ; 080A _ 31. C0
        cmp     dl, 4                                   ; 080C _ 80. FA, 04
        setne   al                                      ; 080F _ 0F 95. C0
        lea     rax, [rax*4+4H]                         ; 0812 _ 48: 8D. 04 85, 00000004
?_085:  add     byte [r8+8H], al                        ; 081A _ 41: 00. 40, 08
?_086:  test    sil, 20H                                ; 081E _ 40: F6. C6, 20
        jz      ?_087                                   ; 0822 _ 74, 05
        add     byte [r8+8H], 2                         ; 0824 _ 41: 80. 40, 08, 02
?_087:  test    sil, 40H                                ; 0829 _ 40: F6. C6, 40
        jz      ?_088                                   ; 082D _ 74, 05
        add     byte [r8+8H], 4                         ; 082F _ 41: 80. 40, 08, 04
?_088:  and     sil, 80H                                ; 0834 _ 40: 80. E6, 80
        jz      ?_090                                   ; 0838 _ 74, 2A
        mov     dl, byte [r8+9H]                        ; 083A _ 41: 8A. 50, 09
        mov     eax, 2                                  ; 083E _ B8, 00000002
        and     dl, 0CH                                 ; 0843 _ 80. E2, 0C
        jz      ?_089                                   ; 0846 _ 74, 10
        xor     eax, eax                                ; 0848 _ 31. C0
        cmp     dl, 4                                   ; 084A _ 80. FA, 04
        setne   al                                      ; 084D _ 0F 95. C0
        lea     rax, [rax*4+4H]                         ; 0850 _ 48: 8D. 04 85, 00000004
?_089:  mov     dl, byte [r8+8H]                        ; 0858 _ 41: 8A. 50, 08
        lea     eax, [rdx+rax+2H]                       ; 085C _ 8D. 44 02, 02
        mov     byte [r8+8H], al                        ; 0860 _ 41: 88. 40, 08
?_090:  movzx   eax, byte [r8+8H]                       ; 0864 _ 41: 0F B6. 40, 08
        jmp     ?_098                                   ; 0869 _ EB, 63

?_091:  cmp     r9b, 2                                  ; 086B _ 41: 80. F9, 02
        jne     ?_080                                   ; 086F _ 0F 85, FFFFFF31
        jmp     ?_079                                   ; 0875 _ E9, FFFFFF05

?_092:  test    byte [r8+17H], 01H                      ; 087A _ 41: F6. 40, 17, 01
        jz      ?_093                                   ; 087F _ 74, 0D
        movzx   edx, byte [r8+0DH]                      ; 0881 _ 41: 0F B6. 50, 0D
        shl     edx, 3                                  ; 0886 _ C1. E2, 03
        and     edx, 08H                                ; 0889 _ 83. E2, 08
        jmp     ?_095                                   ; 088C _ EB, 1D

?_093:  mov     dl, byte [r8+18H]                       ; 088E _ 41: 8A. 50, 18
        test    dl, 01H                                 ; 0892 _ F6. C2, 01
        jnz     ?_094                                   ; 0895 _ 75, 09
        and     dl, 02H                                 ; 0897 _ 80. E2, 02
        je      ?_076                                   ; 089A _ 0F 84, FFFFFEAF
?_094:  test    byte [r8+11H], 20H                      ; 08A0 _ 41: F6. 40, 11, 20
        sete    dl                                      ; 08A5 _ 0F 94. C2
        shl     edx, 3                                  ; 08A8 _ C1. E2, 03
?_095:  or      r10d, edx                               ; 08AB _ 41: 09. D2
        jmp     ?_076                                   ; 08AE _ E9, FFFFFE9C

?_096:  test    r9b, r9b                                ; 08B3 _ 45: 84. C9
        je      ?_080                                   ; 08B6 _ 0F 84, FFFFFEEA
        jmp     ?_079                                   ; 08BC _ E9, FFFFFEBE

?_097:  cmp     al, 4                                   ; 08C1 _ 3C, 04
        je      ?_074                                   ; 08C3 _ 0F 84, FFFFFE21
        jmp     ?_079                                   ; 08C9 _ E9, FFFFFEB1

?_098:
        add     rsp, 320                                ; 08CE _ 48: 81. C4, 00000140
        ret                                             ; 08D5 _ C3

?_099:                                                  ; byte
        db 41H, 14H, 12H, 20H, 41H, 14H, 12H, 20H       ; 0000 _ A.. A.. 
        db 41H, 14H, 12H, 20H, 41H, 14H, 12H, 20H       ; 0008 _ A.. A.. 
        db 41H, 14H, 12H, 20H, 41H, 14H, 12H, 20H       ; 0010 _ A.. A.. 
        db 41H, 14H, 12H, 20H, 41H, 14H, 12H, 0A4H      ; 0018 _ A.. A...
        db 00H, 21H, 40H, 12H, 13H, 14H, 15H, 40H       ; 0020 _ .!@....@
        db 90H, 04H, 15H, 13H, 25H, 8CH, 01H, 98H       ; 0028 _ ....%...
        db 00H, 14H, 12H, 60H, 88H, 04H, 88H, 00H       ; 0030 _ ...`....
        db 25H, 20H, 21H, 15H, 13H, 14H, 40H, 14H       ; 0038 _ % !...@.
        db 20H, 41H, 24H, 20H, 88H, 01H, 88H, 04H       ; 0040 _  A$ ....
        db 22H, 10H, 14H, 8AH, 00H, 21H, 60H, 61H       ; 0048 _ "....!`a
        db 89H, 00H, 11H, 10H, 15H, 94H, 01H, 40H       ; 0050 _ .......@
        db 88H, 01H, 90H, 00H, 0ACH, 01H, 20H, 21H      ; 0058 _ ...... !
        db 45H, 31H, 10H, 21H, 20H, 41H, 90H, 02H       ; 0060 _ E1.! A..
        db 90H, 01H, 30H, 11H, 15H, 11H, 50H, 11H       ; 0068 _ ..0...P.
        db 15H, 8DH, 01H, 15H, 71H, 15H, 11H, 35H       ; 0070 _ ....q..5
        db 11H, 88H, 00H, 0C1H, 01H, 20H, 15H, 71H      ; 0078 _ ..... .q
        db 10H, 31H, 10H, 61H, 20H, 9AH, 01H, 30H       ; 0080 _ .1.a ..0
        db 31H, 90H, 00H, 31H, 9DH, 00H, 21H, 60H       ; 0088 _ 1..1..!`
        db 31H, 89H, 00H, 11H, 10H, 11H, 10H, 41H       ; 0090 _ 1......A
        db 20H, 8AH, 01H, 60H, 8AH, 01H, 60H, 8AH       ; 0098 _  ..`..`.
        db 01H, 9BH, 00H, 51H, 90H, 00H, 41H, 10H       ; 00A0 _ ...Q..A.
        db 31H, 88H, 00H, 35H, 10H, 35H, 10H, 88H       ; 00A8 _ 1..5.5..
        db 05H, 40H, 65H, 30H, 15H, 20H, 35H, 95H       ; 00B0 _ .@e0. 5.
        db 00H, 25H, 60H, 35H, 10H, 15H, 10H, 15H       ; 00B8 _ .%`5....
        db 30H, 31H, 8FH, 00H, 41H, 45H, 40H, 88H       ; 00C0 _ 01..AE@.
        db 01H, 88H, 00H, 88H, 01H, 0DFH, 00H, 15H      ; 00C8 _ ........
        db 90H, 00H, 15H, 0FFH, 00H, 95H, 00H, 31H      ; 00D0 _ .......1
        db 60H, 21H, 50H, 31H, 60H, 21H, 20H, 21H       ; 00D8 _ `!P1`! !
        db 20H, 11H, 8FH, 00H, 11H, 89H, 00H, 45H       ; 00E0 _  ......E
        db 88H, 00H, 45H, 9CH, 00H, 45H, 91H, 00H       ; 00E8 _ ..E..E..
        db 21H, 8FH, 00H, 11H, 0EDH, 00H, 41H, 8CH      ; 00F0 _ !.....A.
        db 00H, 8CH, 01H, 0A5H, 00H, 31H, 20H, 21H      ; 00F8 _ .....1 !
        db 30H, 11H, 50H, 31H, 20H, 21H, 30H, 11H       ; 0100 _ 0.P1 !0.
        db 50H, 31H, 0ACH, 00H, 11H, 10H, 11H, 0FFH     ; 0108 _ P1......
        db 00H, 0EEH, 00H                               ; 0110 _ ...