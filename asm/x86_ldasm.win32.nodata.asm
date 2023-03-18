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
;    x86_ldasm x86 (32 bit, precompiled, position independent) - NASM/YASM
;       - win32, no data (code-only)
;
[BITS 32]

        jmp x86_ldasm_ext_table ; Entrypoint

get_modrm:
        test    byte [eax+14H], 04H                     ; 0000 _ F6. 40, 14, 04
        jnz     ?_001                                   ; 0004 _ 75, 32
        push    ebx                                     ; 0006 _ 53
        or      byte [eax+14H], 04H                     ; 0007 _ 80. 48, 14, 04
        movzx   edx, byte [eax+4H]                      ; 000B _ 0F B6. 50, 04
        mov     ebx, edx                                ; 000F _ 89. D3
        and     ebx, 0FH                                ; 0011 _ 83. E3, 0F
        movzx   ecx, byte [eax+10H]                     ; 0014 _ 0F B6. 48, 10
        and     ecx, 0FFFFFFF0H                         ; 0018 _ 83. E1, F0
        or      ecx, ebx                                ; 001B _ 09. D9
        mov     byte [eax+10H], cl                      ; 001D _ 88. 48, 10
        mov     ecx, dword [eax]                        ; 0020 _ 8B. 08
        lea     ebx, [edx+1H]                           ; 0022 _ 8D. 5A, 01
        mov     byte [eax+4H], bl                       ; 0025 _ 88. 58, 04
        movzx   edx, dl                                 ; 0028 _ 0F B6. D2
        movzx   edx, byte [ecx+edx]                     ; 002B _ 0F B6. 14 11
        mov     byte [eax+6H], dl                       ; 002F _ 88. 50, 06
        movzx   eax, byte [eax+6H]                      ; 0032 _ 0F B6. 40, 06
        pop     ebx                                     ; 0036 _ 5B
        ret                                             ; 0037 _ C3

?_001:
        movzx   eax, byte [eax+6H]                      ; 0038 _ 0F B6. 40, 06
        ret                                             ; 003C _ C3

get_osize:
        push    ebx                                     ; 003D _ 53
        mov     ebx, edx                                ; 003E _ 89. D3
        movzx   edx, byte [eax+13H]                     ; 0040 _ 0F B6. 50, 13
        shr     dl, 2                                   ; 0044 _ C0. EA, 02
        and     edx, 01H                                ; 0047 _ 83. E2, 01
        movzx   ecx, byte [eax+5H]                      ; 004A _ 0F B6. 48, 05
        and     ecx, 03H                                ; 004E _ 83. E1, 03
        jnz     ?_003                                   ; 0051 _ 75, 11
        shl     edx, 2                                  ; 0053 _ C1. E2, 02
        movzx   ecx, byte [eax+5H]                      ; 0056 _ 0F B6. 48, 05
        and     ecx, 0FFFFFFF3H                         ; 005A _ 83. E1, F3
        or      edx, ecx                                ; 005D _ 09. CA
        mov     byte [eax+5H], dl                       ; 005F _ 88. 50, 05
?_002:  pop     ebx                                     ; 0062 _ 5B
        ret                                             ; 0063 _ C3

?_003:
        cmp     cl, 1                                   ; 0064 _ 80. F9, 01
        jz      ?_004                                   ; 0067 _ 74, 14
        test    bl, 01H                                 ; 0069 _ F6. C3, 01
        jz      ?_005                                   ; 006C _ 74, 25
        movzx   edx, byte [eax+5H]                      ; 006E _ 0F B6. 50, 05
        and     edx, 0FFFFFFF3H                         ; 0072 _ 83. E2, F3
        or      edx, 08H                                ; 0075 _ 83. CA, 08
        mov     byte [eax+5H], dl                       ; 0078 _ 88. 50, 05
        jmp     ?_002                                   ; 007B _ EB, E5

?_004:  test    dl, dl                                  ; 007D _ 84. D2
        sete    cl                                      ; 007F _ 0F 94. C1
        shl     ecx, 2                                  ; 0082 _ C1. E1, 02
        movzx   edx, byte [eax+5H]                      ; 0085 _ 0F B6. 50, 05
        and     edx, 0FFFFFFF3H                         ; 0089 _ 83. E2, F3
        or      edx, ecx                                ; 008C _ 09. CA
        mov     byte [eax+5H], dl                       ; 008E _ 88. 50, 05
        jmp     ?_002                                   ; 0091 _ EB, CF

?_005:
        test    byte [eax+9H], 08H                      ; 0093 _ F6. 40, 09, 08
        jnz     ?_008                                   ; 0097 _ 75, 35
        movzx   ecx, byte [eax+14H]                     ; 0099 _ 0F B6. 48, 14
        test    cl, 01H                                 ; 009D _ F6. C1, 01
        jz      ?_007                                   ; 00A0 _ 74, 21
        cmp     byte [eax+0EH], 0                       ; 00A2 _ 80. 78, 0E, 00
        js      ?_008                                   ; 00A6 _ 78, 26
?_006:  test    bl, 02H                                 ; 00A8 _ F6. C3, 02
        jz      ?_009                                   ; 00AB _ 74, 30
        test    dl, dl                                  ; 00AD _ 84. D2
        sete    cl                                      ; 00AF _ 0F 94. C1
        shl     ecx, 3                                  ; 00B2 _ C1. E1, 03
        movzx   edx, byte [eax+5H]                      ; 00B5 _ 0F B6. 50, 05
        and     edx, 0FFFFFFF3H                         ; 00B9 _ 83. E2, F3
        or      edx, ecx                                ; 00BC _ 09. CA
        mov     byte [eax+5H], dl                       ; 00BE _ 88. 50, 05
        jmp     ?_002                                   ; 00C1 _ EB, 9F

?_007:  test    cl, 02H                                 ; 00C3 _ F6. C1, 02
        jz      ?_006                                   ; 00C6 _ 74, E0
        cmp     byte [eax+0EH], 0                       ; 00C8 _ 80. 78, 0E, 00
        jns     ?_006                                   ; 00CC _ 79, DA
?_008:  movzx   edx, byte [eax+5H]                      ; 00CE _ 0F B6. 50, 05
        and     edx, 0FFFFFFF3H                         ; 00D2 _ 83. E2, F3
        or      edx, 08H                                ; 00D5 _ 83. CA, 08
        mov     byte [eax+5H], dl                       ; 00D8 _ 88. 50, 05
        jmp     ?_002                                   ; 00DB _ EB, 85

?_009:
        test    dl, dl                                  ; 00DD _ 84. D2
        sete    cl                                      ; 00DF _ 0F 94. C1
        shl     ecx, 2                                  ; 00E2 _ C1. E1, 02
        movzx   edx, byte [eax+5H]                      ; 00E5 _ 0F B6. 50, 05
        and     edx, 0FFFFFFF3H                         ; 00E9 _ 83. E2, F3
        or      edx, ecx                                ; 00EC _ 09. CA
        mov     byte [eax+5H], dl                       ; 00EE _ 88. 50, 05
        jmp     ?_002                                   ; 00F1 _ E9, FFFFFF6C

x86_ldasm:
        push    ebp                                     ; 00F6 _ 55
        push    edi                                     ; 00F7 _ 57
        push    esi                                     ; 00F8 _ 56
        push    ebx                                     ; 00F9 _ 53
        sub     esp, 24                                 ; 00FA _ 83. EC, 18
        mov     ebx, dword [esp+2CH]                    ; 00FD _ 8B. 5C 24, 2C
        mov     eax, dword [esp+30H]                    ; 0101 _ 8B. 44 24, 30
        mov     esi, dword [esp+34H]                    ; 0105 _ 8B. 74 24, 34
        mov     byte [ebx+4H], 0                        ; 0109 _ C6. 43, 04, 00
        mov     byte [ebx+10H], 0                       ; 010D _ C6. 43, 10, 00
        mov     byte [ebx+11H], 0                       ; 0111 _ C6. 43, 11, 00
        mov     byte [ebx+9H], 0                        ; 0115 _ C6. 43, 09, 00
        mov     byte [ebx+0AH], 0                       ; 0119 _ C6. 43, 0A, 00
        mov     byte [ebx+0BH], 0                       ; 011D _ C6. 43, 0B, 00
        mov     byte [ebx+0CH], 0                       ; 0121 _ C6. 43, 0C, 00
        mov     byte [ebx+13H], 0                       ; 0125 _ C6. 43, 13, 00
        and     byte [ebx+14H], 0FFFFFFE0H              ; 0129 _ 80. 63, 14, E0
        mov     dword [ebx+18H], -1                     ; 012D _ C7. 43, 18, FFFFFFFF
        mov     byte [ebx+12H], 0                       ; 0134 _ C6. 43, 12, 00
        mov     dword [ebx], esi                        ; 0138 _ 89. 33
        cmp     eax, 2                                  ; 013A _ 83. F8, 02
        jbe     ?_012                                   ; 013D _ 76, 26
        mov     edx, 0                                  ; 013F _ BA, 00000000
        cmp     eax, 16                                 ; 0144 _ 83. F8, 10
        jz      ?_010                                   ; 0147 _ 74, 09
        cmp     eax, 32                                 ; 0149 _ 83. F8, 20
        setne   dl                                      ; 014C _ 0F 95. C2
        add     edx, 1                                  ; 014F _ 83. C2, 01
?_010:  movzx   eax, byte [ebx+5H]                      ; 0152 _ 0F B6. 43, 05
        and     eax, 0FFFFFFFCH                         ; 0156 _ 83. E0, FC
        or      edx, eax                                ; 0159 _ 09. C2
        mov     byte [ebx+5H], dl                       ; 015B _ 88. 53, 05
?_011:  mov     eax, 0                                  ; 015E _ B8, 00000000
        jmp     ?_015                                   ; 0163 _ EB, 48

?_012:  and     eax, 03H                                ; 0165 _ 83. E0, 03
        movzx   edx, byte [ebx+5H]                      ; 0168 _ 0F B6. 53, 05
        and     edx, 0FFFFFFFCH                         ; 016C _ 83. E2, FC
        or      eax, edx                                ; 016F _ 09. D0
        mov     byte [ebx+5H], al                       ; 0171 _ 88. 43, 05
        jmp     ?_011                                   ; 0174 _ EB, E8

?_013:  movzx   ecx, byte [ebx+5H]                      ; 0176 _ 0F B6. 4B, 05
        and     ecx, 03H                                ; 017A _ 83. E1, 03
        cmp     cl, 2                                   ; 017D _ 80. F9, 02
        jne     ?_028                                   ; 0180 _ 0F 85, 000001C9
        mov     byte [ebx+0AH], dl                      ; 0186 _ 88. 53, 0A
        mov     byte [ebx+9H], dl                       ; 0189 _ 88. 53, 09
        mov     ecx, eax                                ; 018C _ 89. C1
        and     ecx, 0FH                                ; 018E _ 83. E1, 0F
        movzx   edx, byte [ebx+11H]                     ; 0191 _ 0F B6. 53, 11
        and     edx, 0FFFFFFF0H                         ; 0195 _ 83. E2, F0
        or      edx, ecx                                ; 0198 _ 09. CA
        mov     byte [ebx+11H], dl                      ; 019A _ 88. 53, 11
        or      byte [ebx+13H], 01H                     ; 019D _ 80. 4B, 13, 01
?_014:  add     eax, 1                                  ; 01A1 _ 83. C0, 01
        cmp     eax, 15                                 ; 01A4 _ 83. F8, 0F
        je      ?_090                                   ; 01A7 _ 0F 84, 0000079B
?_015:  movzx   edx, byte [esi+eax]                     ; 01AD _ 0F B6. 14 06
        mov     ecx, edx                                ; 01B1 _ 89. D1
        shr     cl, 4                                   ; 01B3 _ C0. E9, 04
        cmp     cl, 4                                   ; 01B6 _ 80. F9, 04
        jz      ?_013                                   ; 01B9 _ 74, BB
        cmp     dl, 102                                 ; 01BB _ 80. FA, 66
        jz      ?_017                                   ; 01BE _ 74, 2C
        cmp     dl, 103                                 ; 01C0 _ 80. FA, 67
        jz      ?_018                                   ; 01C3 _ 74, 44
        mov     ecx, edx                                ; 01C5 _ 89. D1
        and     ecx, 0FFFFFFF7H                         ; 01C7 _ 83. E1, F7
        cmp     cl, 54                                  ; 01CA _ 80. F9, 36
        jz      ?_016                                   ; 01CD _ 74, 05
        cmp     cl, 38                                  ; 01CF _ 80. F9, 26
        jnz     ?_019                                   ; 01D2 _ 75, 3F
?_016:  mov     byte [ebx+0BH], dl                      ; 01D4 _ 88. 53, 0B
        movzx   ecx, byte [ebx+5H]                      ; 01D7 _ 0F B6. 4B, 05
        and     ecx, 03H                                ; 01DB _ 83. E1, 03
        cmp     cl, 2                                   ; 01DE _ 80. F9, 02
        jz      ?_014                                   ; 01E1 _ 74, BE
        mov     byte [ebx+0AH], dl                      ; 01E3 _ 88. 53, 0A
        or      byte [ebx+13H], 02H                     ; 01E6 _ 80. 4B, 13, 02
        jmp     ?_014                                   ; 01EA _ EB, B5

?_017:  mov     byte [ebx+0AH], 102                     ; 01EC _ C6. 43, 0A, 66
        or      byte [ebx+13H], 04H                     ; 01F0 _ 80. 4B, 13, 04
        movzx   edi, byte [ebx+0CH]                     ; 01F4 _ 0F B6. 7B, 0C
        lea     edx, [edi+0EH]                          ; 01F8 _ 8D. 57, 0E
        cmp     dl, 1                                   ; 01FB _ 80. FA, 01
        jbe     ?_014                                   ; 01FE _ 76, A1
        movzx   edx, byte [esi+eax]                     ; 0200 _ 0F B6. 14 06
        mov     byte [ebx+0CH], dl                      ; 0204 _ 88. 53, 0C
        jmp     ?_014                                   ; 0207 _ EB, 98

?_018:  mov     byte [ebx+0AH], 103                     ; 0209 _ C6. 43, 0A, 67
        or      byte [ebx+13H], 08H                     ; 020D _ 80. 4B, 13, 08
        jmp     ?_014                                   ; 0211 _ EB, 8E

?_019:  lea     ecx, [edx-64H]                          ; 0213 _ 8D. 4A, 9C
        cmp     cl, 1                                   ; 0216 _ 80. F9, 01
        jbe     ?_020                                   ; 0219 _ 76, 20
        cmp     dl, -16                                 ; 021B _ 80. FA, F0
        jz      ?_021                                   ; 021E _ 74, 2A
        cmp     dl, -14                                 ; 0220 _ 80. FA, F2
        jz      ?_022                                   ; 0223 _ 74, 32
        cmp     dl, -13                                 ; 0225 _ 80. FA, F3
        jnz     ?_023                                   ; 0228 _ 75, 3E
        mov     byte [ebx+0AH], -13                     ; 022A _ C6. 43, 0A, F3
        mov     byte [ebx+0CH], -13                     ; 022E _ C6. 43, 0C, F3
        or      byte [ebx+13H], 20H                     ; 0232 _ 80. 4B, 13, 20
        jmp     ?_014                                   ; 0236 _ E9, FFFFFF66

?_020:  mov     byte [ebx+0BH], dl                      ; 023B _ 88. 53, 0B
        mov     byte [ebx+0AH], dl                      ; 023E _ 88. 53, 0A
        or      byte [ebx+13H], 02H                     ; 0241 _ 80. 4B, 13, 02
        jmp     ?_014                                   ; 0245 _ E9, FFFFFF57

?_021:  mov     byte [ebx+0AH], -16                     ; 024A _ C6. 43, 0A, F0
        or      byte [ebx+13H], 10H                     ; 024E _ 80. 4B, 13, 10
        jmp     ?_014                                   ; 0252 _ E9, FFFFFF4A

?_022:  mov     byte [ebx+0AH], -14                     ; 0257 _ C6. 43, 0A, F2
        mov     byte [ebx+0CH], -14                     ; 025B _ C6. 43, 0C, F2
        or      byte [ebx+13H], 40H                     ; 025F _ 80. 4B, 13, 40
        jmp     ?_014                                   ; 0263 _ E9, FFFFFF39

?_023:  cmp     eax, 15                                 ; 0268 _ 83. F8, 0F
        je      ?_090                                   ; 026B _ 0F 84, 000006D7
        movzx   edx, byte [ebx+5H]                      ; 0271 _ 0F B6. 53, 05
        and     edx, 03H                                ; 0275 _ 83. E2, 03
        cmp     dl, 2                                   ; 0278 _ 80. FA, 02
        je      ?_029                                   ; 027B _ 0F 84, 000000E3
?_024:  mov     dword [esp+8H], 0                       ; 0281 _ C7. 44 24, 08, 00000000
        mov     dword [esp+0CH], 102                    ; 0289 _ C7. 44 24, 0C, 00000066
        mov     dword [esp+10H], 243                    ; 0291 _ C7. 44 24, 10, 000000F3
        mov     dword [esp+14H], 242                    ; 0299 _ C7. 44 24, 14, 000000F2
        movzx   ecx, byte [esi+eax]                     ; 02A1 _ 0F B6. 0C 06
        cmp     cl, -60                                 ; 02A5 _ 80. F9, C4
        je      ?_032                                   ; 02A8 _ 0F 84, 00000135
        cmp     cl, -59                                 ; 02AE _ 80. F9, C5
        je      ?_036                                   ; 02B1 _ 0F 84, 000001BC
?_025:  cmp     cl, 98                                  ; 02B7 _ 80. F9, 62
        je      ?_037                                   ; 02BA _ 0F 84, 000001C5
        cmp     cl, -113                                ; 02C0 _ 80. F9, 8F
        jne     ?_042                                   ; 02C3 _ 0F 85, 00000276
        cmp     dl, 2                                   ; 02C9 _ 80. FA, 02
        jz      ?_026                                   ; 02CC _ 74, 11
        movzx   edx, byte [esi+eax+1H]                  ; 02CE _ 0F B6. 54 06, 01
        shr     dl, 6                                   ; 02D3 _ C0. EA, 06
        cmp     dl, 3                                   ; 02D6 _ 80. FA, 03
        jne     ?_038                                   ; 02D9 _ 0F 85, 000001C0
?_026:  movzx   edx, byte [esi+eax+1H]                  ; 02DF _ 0F B6. 54 06, 01
        test    dl, 18H                                 ; 02E4 _ F6. C2, 18
        je      ?_038                                   ; 02E7 _ 0F 84, 000001B2
        mov     ecx, edx                                ; 02ED _ 89. D1
        and     ecx, 1FH                                ; 02EF _ 83. E1, 1F
        cmp     cl, 10                                  ; 02F2 _ 80. F9, 0A
        ja      ?_038                                   ; 02F5 _ 0F 87, 000001A4
        cmp     eax, 10                                 ; 02FB _ 83. F8, 0A
        ja      ?_090                                   ; 02FE _ 0F 87, 00000644
        test    byte [ebx+13H], 75H                     ; 0304 _ F6. 43, 13, 75
        jne     ?_090                                   ; 0308 _ 0F 85, 0000063A
        mov     byte [ebx+0DH], dl                      ; 030E _ 88. 53, 0D
        movzx   edx, byte [esi+eax+2H]                  ; 0311 _ 0F B6. 54 06, 02
        mov     byte [ebx+0EH], dl                      ; 0316 _ 88. 53, 0E
        or      byte [ebx+14H], 02H                     ; 0319 _ 80. 4B, 14, 02
        test    dl, 03H                                 ; 031D _ F6. C2, 03
        jne     ?_090                                   ; 0320 _ 0F 85, 00000622
        mov     edx, 1024                               ; 0326 _ BA, 00000400
        cmp     cl, 8                                   ; 032B _ 80. F9, 08
        jz      ?_027                                   ; 032E _ 74, 10
        cmp     cl, 9                                   ; 0330 _ 80. F9, 09
        mov     edx, 1280                               ; 0333 _ BA, 00000500
        mov     ecx, 1536                               ; 0338 _ B9, 00000600
        cmovne  edx, ecx                                ; 033D _ 0F 45. D1
?_027:  mov     dword [ebx+18H], edx                    ; 0340 _ 89. 53, 18
        mov     byte [ebx+0CH], 0                       ; 0343 _ C6. 43, 0C, 00
        lea     edx, [eax+3H]                           ; 0347 _ 8D. 50, 03
        jmp     ?_035                                   ; 034A _ E9, 00000110

?_028:  cmp     eax, 15                                 ; 034F _ 83. F8, 0F
        je      ?_090                                   ; 0352 _ 0F 84, 000005F0
        movzx   edx, byte [ebx+5H]                      ; 0358 _ 0F B6. 53, 05
        and     edx, 03H                                ; 035C _ 83. E2, 03
        jmp     ?_024                                   ; 035F _ E9, FFFFFF1D

?_029:  movzx   ecx, byte [ebx+0AH]                     ; 0364 _ 0F B6. 4B, 0A
        shr     cl, 4                                   ; 0368 _ C0. E9, 04
        cmp     cl, 4                                   ; 036B _ 80. F9, 04
        jz      ?_030                                   ; 036E _ 74, 0C
        mov     byte [ebx+9H], 0                        ; 0370 _ C6. 43, 09, 00
        and     byte [ebx+11H], 0FFFFFFF0H              ; 0374 _ 80. 63, 11, F0
        and     byte [ebx+13H], 0FFFFFFFEH              ; 0378 _ 80. 63, 13, FE
?_030:  mov     dword [esp+8H], 0                       ; 037C _ C7. 44 24, 08, 00000000
        mov     dword [esp+0CH], 102                    ; 0384 _ C7. 44 24, 0C, 00000066
        mov     dword [esp+10H], 243                    ; 038C _ C7. 44 24, 10, 000000F3
        mov     dword [esp+14H], 242                    ; 0394 _ C7. 44 24, 14, 000000F2
        movzx   ecx, byte [esi+eax]                     ; 039C _ 0F B6. 0C 06
        cmp     cl, -60                                 ; 03A0 _ 80. F9, C4
        jz      ?_033                                   ; 03A3 _ 74, 4F
        cmp     cl, -59                                 ; 03A5 _ 80. F9, C5
        jne     ?_025                                   ; 03A8 _ 0F 85, FFFFFF09
?_031:  cmp     eax, 11                                 ; 03AE _ 83. F8, 0B
        ja      ?_090                                   ; 03B1 _ 0F 87, 00000591
        test    byte [ebx+13H], 75H                     ; 03B7 _ F6. 43, 13, 75
        jne     ?_090                                   ; 03BB _ 0F 85, 00000587
        movzx   edx, byte [esi+eax+1H]                  ; 03C1 _ 0F B6. 54 06, 01
        mov     byte [ebx+0DH], dl                      ; 03C6 _ 88. 53, 0D
        or      byte [ebx+13H], 0FFFFFF80H              ; 03C9 _ 80. 4B, 13, 80
        mov     dword [ebx+18H], 256                    ; 03CD _ C7. 43, 18, 00000100
        and     edx, 03H                                ; 03D4 _ 83. E2, 03
        mov     edx, dword [esp+edx*4+8H]               ; 03D7 _ 8B. 54 94, 08
        mov     byte [ebx+0CH], dl                      ; 03DB _ 88. 53, 0C
        lea     edx, [eax+2H]                           ; 03DE _ 8D. 50, 02
        jmp     ?_035                                   ; 03E1 _ EB, 7C

?_032:  movzx   edx, byte [esi+eax+1H]                  ; 03E3 _ 0F B6. 54 06, 01
        shr     dl, 6                                   ; 03E8 _ C0. EA, 06
        cmp     dl, 3                                   ; 03EB _ 80. FA, 03
        jne     ?_038                                   ; 03EE _ 0F 85, 000000AB
?_033:  cmp     eax, 10                                 ; 03F4 _ 83. F8, 0A
        ja      ?_090                                   ; 03F7 _ 0F 87, 0000054B
        test    byte [ebx+13H], 75H                     ; 03FD _ F6. 43, 13, 75
        jne     ?_090                                   ; 0401 _ 0F 85, 00000541
        movzx   edx, byte [esi+eax+1H]                  ; 0407 _ 0F B6. 54 06, 01
        mov     byte [ebx+0DH], dl                      ; 040C _ 88. 53, 0D
        movzx   edi, byte [esi+eax+2H]                  ; 040F _ 0F B6. 7C 06, 02
        mov     ecx, edi                                ; 0414 _ 89. F9
        mov     byte [ebx+0EH], cl                      ; 0416 _ 88. 4B, 0E
        or      byte [ebx+14H], 01H                     ; 0419 _ 80. 4B, 14, 01
        mov     esi, edx                                ; 041D _ 89. D6
        and     esi, 1FH                                ; 041F _ 83. E6, 1F
        je      ?_090                                   ; 0422 _ 0F 84, 00000520
        test    dl, 1CH                                 ; 0428 _ F6. C2, 1C
        jne     ?_090                                   ; 042B _ 0F 85, 00000517
        mov     ecx, 256                                ; 0431 _ B9, 00000100
        mov     edx, esi                                ; 0436 _ 89. F2
        cmp     dl, 1                                   ; 0438 _ 80. FA, 01
        jz      ?_034                                   ; 043B _ 74, 10
        cmp     dl, 2                                   ; 043D _ 80. FA, 02
        mov     ecx, 512                                ; 0440 _ B9, 00000200
        mov     edx, 768                                ; 0445 _ BA, 00000300
        cmovne  ecx, edx                                ; 044A _ 0F 45. CA
?_034:  mov     dword [ebx+18H], ecx                    ; 044D _ 89. 4B, 18
        mov     edx, edi                                ; 0450 _ 89. FA
        and     edx, 03H                                ; 0452 _ 83. E2, 03
        mov     edx, dword [esp+edx*4+8H]               ; 0455 _ 8B. 54 94, 08
        mov     byte [ebx+0CH], dl                      ; 0459 _ 88. 53, 0C
        lea     edx, [eax+3H]                           ; 045C _ 8D. 50, 03
?_035:  mov     byte [ebx+4H], dl                       ; 045F _ 88. 53, 04
        shl     edx, 4                                  ; 0462 _ C1. E2, 04
        movzx   eax, byte [ebx+11H]                     ; 0465 _ 0F B6. 43, 11
        and     eax, 0FH                                ; 0469 _ 83. E0, 0F
        or      eax, edx                                ; 046C _ 09. D0
        mov     byte [ebx+11H], al                      ; 046E _ 88. 43, 11
        jmp     ?_040                                   ; 0471 _ EB, 53

?_036:  movzx   edx, byte [esi+eax+1H]                  ; 0473 _ 0F B6. 54 06, 01
        shr     dl, 6                                   ; 0478 _ C0. EA, 06
        cmp     dl, 3                                   ; 047B _ 80. FA, 03
        jnz     ?_038                                   ; 047E _ 75, 1F
        jmp     ?_031                                   ; 0480 _ E9, FFFFFF29

?_037:  cmp     dl, 2                                   ; 0485 _ 80. FA, 02
        je      ?_090                                   ; 0488 _ 0F 84, 000004BA
        movzx   edx, byte [esi+eax+1H]                  ; 048E _ 0F B6. 54 06, 01
        shr     dl, 6                                   ; 0493 _ C0. EA, 06
        cmp     dl, 3                                   ; 0496 _ 80. FA, 03
        je      ?_090                                   ; 0499 _ 0F 84, 000004A9
?_038:  mov     byte [ebx+0CH], 0                       ; 049F _ C6. 43, 0C, 00
        mov     dword [ebx+18H], 0                      ; 04A3 _ C7. 43, 18, 00000000
?_039:  mov     byte [ebx+4H], al                       ; 04AA _ 88. 43, 04
        mov     ecx, eax                                ; 04AD _ 89. C1
        shl     ecx, 4                                  ; 04AF _ C1. E1, 04
        movzx   edx, byte [ebx+11H]                     ; 04B2 _ 0F B6. 53, 11
        and     edx, 0FH                                ; 04B6 _ 83. E2, 0F
        or      edx, ecx                                ; 04B9 _ 09. CA
        mov     byte [ebx+11H], dl                      ; 04BB _ 88. 53, 11
        test    eax, eax                                ; 04BE _ 85. C0
        js      ?_088                                   ; 04C0 _ 0F 88, 0000046E
?_040:  movzx   eax, byte [ebx+13H]                     ; 04C6 _ 0F B6. 43, 13
        shr     al, 3                                   ; 04CA _ C0. E8, 03
        and     eax, 01H                                ; 04CD _ 83. E0, 01
        movzx   edx, byte [ebx+5H]                      ; 04D0 _ 0F B6. 53, 05
        and     edx, 03H                                ; 04D4 _ 83. E2, 03
        jne     ?_045                                   ; 04D7 _ 0F 85, 000000A9
        shl     eax, 4                                  ; 04DD _ C1. E0, 04
        movzx   edx, byte [ebx+5H]                      ; 04E0 _ 0F B6. 53, 05
        and     edx, 0FFFFFFCFH                         ; 04E4 _ 83. E2, CF
        or      eax, edx                                ; 04E7 _ 09. D0
        mov     byte [ebx+5H], al                       ; 04E9 _ 88. 43, 05
?_041:  mov     edx, 0                                  ; 04EC _ BA, 00000000
        mov     eax, ebx                                ; 04F1 _ 89. D8
        call    get_osize                               ; 04F3 _ E8, FFFFFB45
        mov     edi, dword [ebx+1CH]                    ; 04F8 _ 8B. 7B, 1C
        mov     ebp, dword [ebx+20H]                    ; 04FB _ 8B. 6B, 20
        mov     edx, dword [ebx]                        ; 04FE _ 8B. 13
        movzx   eax, byte [ebx+4H]                      ; 0500 _ 0F B6. 43, 04
        lea     ecx, [eax+1H]                           ; 0504 _ 8D. 48, 01
        mov     byte [ebx+4H], cl                       ; 0507 _ 88. 4B, 04
        movzx   eax, al                                 ; 050A _ 0F B6. C0
        movzx   eax, byte [edx+eax]                     ; 050D _ 0F B6. 04 02
        mov     byte [esp+7H], al                       ; 0511 _ 88. 44 24, 07
        mov     esi, dword [ebx+18H]                    ; 0515 _ 8B. 73, 18
        mov     dword [esp], esi                        ; 0518 _ 89. 34 24
        movzx   eax, al                                 ; 051B _ 0F B6. C0
        add     eax, esi                                ; 051E _ 01. F0
        mov     esi, eax                                ; 0520 _ 89. C6
        test    ebp, ebp                                ; 0522 _ 85. ED
        je      ?_051                                   ; 0524 _ 0F 84, 000000CD
        mov     ecx, 0                                  ; 052A _ B9, 00000000
        mov     eax, 0                                  ; 052F _ B8, 00000000
        mov     dword [esp+2CH], ebx                    ; 0534 _ 89. 5C 24, 2C
        mov     ebx, esi                                ; 0538 _ 89. F3
        jmp     ?_049                                   ; 053A _ E9, 000000A0

?_042:  cmp     cl, 15                                  ; 053F _ 80. F9, 0F
        jne     ?_038                                   ; 0542 _ 0F 85, FFFFFF57
        lea     ecx, [eax+1H]                           ; 0548 _ 8D. 48, 01
        movzx   edx, byte [esi+eax+1H]                  ; 054B _ 0F B6. 54 06, 01
        cmp     dl, 56                                  ; 0550 _ 80. FA, 38
        jz      ?_043                                   ; 0553 _ 74, 13
        cmp     dl, 58                                  ; 0555 _ 80. FA, 3A
        jz      ?_044                                   ; 0558 _ 74, 1D
        mov     dword [ebx+18H], 256                    ; 055A _ C7. 43, 18, 00000100
        mov     eax, ecx                                ; 0561 _ 89. C8
        jmp     ?_039                                   ; 0563 _ E9, FFFFFF42

?_043:  mov     dword [ebx+18H], 512                    ; 0568 _ C7. 43, 18, 00000200
        add     eax, 2                                  ; 056F _ 83. C0, 02
        jmp     ?_039                                   ; 0572 _ E9, FFFFFF33

?_044:  mov     dword [ebx+18H], 768                    ; 0577 _ C7. 43, 18, 00000300
        add     eax, 2                                  ; 057E _ 83. C0, 02
        jmp     ?_039                                   ; 0581 _ E9, FFFFFF24

?_045:  cmp     dl, 1                                   ; 0586 _ 80. FA, 01
        jz      ?_046                                   ; 0589 _ 74, 20
        mov     edx, 2                                  ; 058B _ BA, 00000002
        sub     edx, eax                                ; 0590 _ 29. C2
        mov     eax, edx                                ; 0592 _ 89. D0
        and     eax, 03H                                ; 0594 _ 83. E0, 03
        shl     eax, 4                                  ; 0597 _ C1. E0, 04
        movzx   edx, byte [ebx+5H]                      ; 059A _ 0F B6. 53, 05
        and     edx, 0FFFFFFCFH                         ; 059E _ 83. E2, CF
        or      eax, edx                                ; 05A1 _ 09. D0
        mov     byte [ebx+5H], al                       ; 05A3 _ 88. 43, 05
        jmp     ?_041                                   ; 05A6 _ E9, FFFFFF41

?_046:  test    al, al                                  ; 05AB _ 84. C0
        sete    dl                                      ; 05AD _ 0F 94. C2
        shl     edx, 4                                  ; 05B0 _ C1. E2, 04
        movzx   eax, byte [ebx+5H]                      ; 05B3 _ 0F B6. 43, 05
        and     eax, 0FFFFFFCFH                         ; 05B7 _ 83. E0, CF
        or      eax, edx                                ; 05BA _ 09. D0
        mov     byte [ebx+5H], al                       ; 05BC _ 88. 43, 05
        jmp     ?_041                                   ; 05BF _ E9, FFFFFF28

?_047:  and     edx, 7FH                                ; 05C4 _ 83. E2, 7F
        movzx   esi, byte [edi+eax+1H]                  ; 05C7 _ 0F B6. 74 07, 01
        add     eax, 1                                  ; 05CC _ 83. C0, 01
?_048:  movzx   edx, dl                                 ; 05CF _ 0F B6. D2
        add     ecx, edx                                ; 05D2 _ 01. D1
        cmp     ebx, ecx                                ; 05D4 _ 39. CB
        jc      ?_052                                   ; 05D6 _ 72, 23
        add     eax, 1                                  ; 05D8 _ 83. C0, 01
        cmp     ebp, eax                                ; 05DB _ 39. C5
        jbe     ?_050                                   ; 05DD _ 76, 12
?_049:  movzx   esi, byte [edi+eax]                     ; 05DF _ 0F B6. 34 07
        mov     edx, esi                                ; 05E3 _ 89. F2
        test    dl, dl                                  ; 05E5 _ 84. D2
        js      ?_047                                   ; 05E7 _ 78, DB
        shr     dl, 4                                   ; 05E9 _ C0. EA, 04
        and     esi, 0FH                                ; 05EC _ 83. E6, 0F
        jmp     ?_048                                   ; 05EF _ EB, DE

?_050:  mov     ebx, dword [esp+2CH]                    ; 05F1 _ 8B. 5C 24, 2C
        jmp     ?_053                                   ; 05F5 _ EB, 08

?_051:  mov     esi, ebp                                ; 05F7 _ 89. EE
        jmp     ?_053                                   ; 05F9 _ EB, 04

?_052:  mov     ebx, dword [esp+2CH]                    ; 05FB _ 8B. 5C 24, 2C
?_053:  cmp     dword [esp], 0                          ; 05FF _ 83. 3C 24, 00
        jne     ?_057                                   ; 0603 _ 0F 85, 000000BB
        movzx   eax, byte [esp+7H]                      ; 0609 _ 0F B6. 44 24, 07
        add     eax, 24                                 ; 060E _ 83. C0, 18
        cmp     al, 1                                   ; 0611 _ 3C, 01
        jbe     ?_054                                   ; 0613 _ 76, 6E
        movzx   ecx, byte [esp+7H]                      ; 0615 _ 0F B6. 4C 24, 07
        lea     eax, [ecx+48H]                          ; 061A _ 8D. 41, 48
        cmp     al, 7                                   ; 061D _ 3C, 07
        jbe     ?_091                                   ; 061F _ 0F 86, 0000032D
        lea     eax, [ecx+60H]                          ; 0625 _ 8D. 41, 60
        cmp     al, 3                                   ; 0628 _ 3C, 03
        jbe     ?_102                                   ; 062A _ 0F 86, 000003EC
        mov     eax, ecx                                ; 0630 _ 89. C8
        and     eax, 0FFFFFFF7H                         ; 0632 _ 83. E0, F7
        cmp     al, -62                                 ; 0635 _ 3C, C2
        je      ?_103                                   ; 0637 _ 0F 84, 000003E9
        cmp     cl, -56                                 ; 063D _ 80. F9, C8
        je      ?_104                                   ; 0640 _ 0F 84, 000003EA
        cmp     cl, 104                                 ; 0646 _ 80. F9, 68
        jz      ?_055                                   ; 0649 _ 74, 4E
        movzx   eax, byte [esp+7H]                      ; 064B _ 0F B6. 44 24, 07
        cmp     al, -22                                 ; 0650 _ 3C, EA
        je      ?_105                                   ; 0652 _ 0F 84, 000003E2
        cmp     al, -102                                ; 0658 _ 3C, 9A
        je      ?_105                                   ; 065A _ 0F 84, 000003DA
        cmp     al, -10                                 ; 0660 _ 3C, F6
        jz      ?_056                                   ; 0662 _ 74, 4B
        cmp     byte [esp+7H], -9                       ; 0664 _ 80. 7C 24, 07, F7
        jnz     ?_058                                   ; 0669 _ 75, 6B
        mov     eax, ebx                                ; 066B _ 89. D8
        call    get_modrm                               ; 066D _ E8, FFFFF98E
        shr     al, 3                                   ; 0672 _ C0. E8, 03
        test    al, 06H                                 ; 0675 _ A8, 06
        jnz     ?_058                                   ; 0677 _ 75, 5D
        mov     esi, 3                                  ; 0679 _ BE, 00000003
        jmp     ?_066                                   ; 067E _ E9, 000000BE

?_054:  mov     edx, 1                                  ; 0683 _ BA, 00000001
        mov     eax, ebx                                ; 0688 _ 89. D8
        call    get_osize                               ; 068A _ E8, FFFFF9AE
        mov     esi, 2                                  ; 068F _ BE, 00000002
        jmp     ?_092                                   ; 0694 _ E9, 000002BE

?_055:  mov     edx, 2                                  ; 0699 _ BA, 00000002
        mov     eax, ebx                                ; 069E _ 89. D8
        call    get_osize                               ; 06A0 _ E8, FFFFF998
        mov     esi, 2                                  ; 06A5 _ BE, 00000002
        jmp     ?_092                                   ; 06AA _ E9, 000002A8

?_056:  mov     eax, ebx                                ; 06AF _ 89. D8
        call    get_modrm                               ; 06B1 _ E8, FFFFF94A
        shr     al, 3                                   ; 06B6 _ C0. E8, 03
        test    al, 06H                                 ; 06B9 _ A8, 06
        jnz     ?_058                                   ; 06BB _ 75, 19
        mov     esi, 5                                  ; 06BD _ BE, 00000005
        jmp     ?_066                                   ; 06C2 _ EB, 7D

?_057:  cmp     dword [esp], 256                        ; 06C4 _ 81. 3C 24, 00000100
        jz      ?_061                                   ; 06CB _ 74, 19
        cmp     dword [esp], 1536                       ; 06CD _ 81. 3C 24, 00000600
        jz      ?_064                                   ; 06D4 _ 74, 4C
?_058:  test    esi, esi                                ; 06D6 _ 85. F6
        jnz     ?_065                                   ; 06D8 _ 75, 5B
?_059:  movzx   eax, byte [ebx+4H]                      ; 06DA _ 0F B6. 43, 04
?_060:  add     esp, 24                                 ; 06DE _ 83. C4, 18
        pop     ebx                                     ; 06E1 _ 5B
        pop     esi                                     ; 06E2 _ 5E
        pop     edi                                     ; 06E3 _ 5F
        pop     ebp                                     ; 06E4 _ 5D
        ret                                             ; 06E5 _ C3

?_061:  movzx   eax, byte [esp+7H]                      ; 06E6 _ 0F B6. 44 24, 07
        add     eax, -128                               ; 06EB _ 83. C0, 80
        cmp     al, 15                                  ; 06EE _ 3C, 0F
        jbe     ?_063                                   ; 06F0 _ 76, 1A
        cmp     byte [esp+7H], 120                      ; 06F2 _ 80. 7C 24, 07, 78
        jnz     ?_058                                   ; 06F7 _ 75, DD
        movzx   eax, byte [ebx+0CH]                     ; 06F9 _ 0F B6. 43, 0C
        cmp     al, -14                                 ; 06FD _ 3C, F2
        jz      ?_062                                   ; 06FF _ 74, 04
        cmp     al, 102                                 ; 0701 _ 3C, 66
        jnz     ?_058                                   ; 0703 _ 75, D1
?_062:  mov     esi, 33                                 ; 0705 _ BE, 00000021
        jmp     ?_066                                   ; 070A _ EB, 35

?_063:  mov     edx, 1                                  ; 070C _ BA, 00000001
        mov     eax, ebx                                ; 0711 _ 89. D8
        call    get_osize                               ; 0713 _ E8, FFFFF925
        mov     esi, 2                                  ; 0718 _ BE, 00000002
        jmp     ?_092                                   ; 071D _ E9, 00000235

?_064:  movzx   eax, byte [esp+7H]                      ; 0722 _ 0F B6. 44 24, 07
        and     eax, 0FFFFFFFDH                         ; 0727 _ 83. E0, FD
        cmp     al, 16                                  ; 072A _ 3C, 10
        jnz     ?_058                                   ; 072C _ 75, A8
        mov     esi, 65                                 ; 072E _ BE, 00000041
        jmp     ?_066                                   ; 0733 _ EB, 0C

?_065:  test    esi, 1H                                 ; 0735 _ F7. C6, 00000001
        je      ?_092                                   ; 073B _ 0F 84, 00000216
?_066:  mov     eax, ebx                                ; 0741 _ 89. D8
        call    get_modrm                               ; 0743 _ E8, FFFFF8B8
        shr     al, 6                                   ; 0748 _ C0. E8, 06
        mov     edi, eax                                ; 074B _ 89. C7
        mov     eax, ebx                                ; 074D _ 89. D8
        call    get_modrm                               ; 074F _ E8, FFFFF8AC
        and     eax, 07H                                ; 0754 _ 83. E0, 07
        mov     ecx, edi                                ; 0757 _ 89. F9
        cmp     cl, 3                                   ; 0759 _ 80. F9, 03
        je      ?_092                                   ; 075C _ 0F 84, 000001F5
        movzx   ecx, byte [ebx+5H]                      ; 0762 _ 0F B6. 4B, 05
        mov     edx, ecx                                ; 0766 _ 89. CA
        and     edx, 03H                                ; 0768 _ 83. E2, 03
        cmp     dl, 2                                   ; 076B _ 80. FA, 02
        jz      ?_069                                   ; 076E _ 74, 41
?_067:  test    cl, 30H                                 ; 0770 _ F6. C1, 30
        jne     ?_073                                   ; 0773 _ 0F 85, 00000086
        and     eax, 07H                                ; 0779 _ 83. E0, 07
        cmp     al, 6                                   ; 077C _ 3C, 06
        jnz     ?_072                                   ; 077E _ 75, 6F
        mov     eax, edi                                ; 0780 _ 89. F8
        test    al, al                                  ; 0782 _ 84. C0
        jnz     ?_072                                   ; 0784 _ 75, 69
        mov     edi, 2                                  ; 0786 _ BF, 00000002
?_068:  lea     ecx, [edi-1H]                           ; 078B _ 8D. 4F, FF
        mov     eax, 1                                  ; 078E _ B8, 00000001
        shl     eax, cl                                 ; 0793 _ D3. E0
        mov     ecx, eax                                ; 0795 _ 89. C1
        shl     ecx, 4                                  ; 0797 _ C1. E1, 04
        movzx   edx, byte [ebx+4H]                      ; 079A _ 0F B6. 53, 04
        and     edx, 0FH                                ; 079E _ 83. E2, 0F
        or      edx, ecx                                ; 07A1 _ 09. CA
        mov     byte [ebx+12H], dl                      ; 07A3 _ 88. 53, 12
        add     al, byte [ebx+4H]                       ; 07A6 _ 02. 43, 04
        mov     byte [ebx+4H], al                       ; 07A9 _ 88. 43, 04
        jmp     ?_092                                   ; 07AC _ E9, 000001A6

?_069:  test    byte [ebx+13H], 01H                     ; 07B1 _ F6. 43, 13, 01
        jz      ?_070                                   ; 07B5 _ 74, 0E
        movzx   edx, byte [ebx+9H]                      ; 07B7 _ 0F B6. 53, 09
        shl     edx, 3                                  ; 07BB _ C1. E2, 03
        and     edx, 08H                                ; 07BE _ 83. E2, 08
        or      eax, edx                                ; 07C1 _ 09. D0
        jmp     ?_067                                   ; 07C3 _ EB, AB

?_070:  movzx   edx, byte [ebx+14H]                     ; 07C5 _ 0F B6. 53, 14
        test    dl, 01H                                 ; 07C9 _ F6. C2, 01
        jz      ?_071                                   ; 07CC _ 74, 0E
        test    byte [ebx+0DH], 20H                     ; 07CE _ F6. 43, 0D, 20
        sete    dl                                      ; 07D2 _ 0F 94. C2
        shl     edx, 3                                  ; 07D5 _ C1. E2, 03
        or      eax, edx                                ; 07D8 _ 09. D0
        jmp     ?_067                                   ; 07DA _ EB, 94

?_071:  test    dl, 02H                                 ; 07DC _ F6. C2, 02
        jz      ?_067                                   ; 07DF _ 74, 8F
        test    byte [ebx+0DH], 20H                     ; 07E1 _ F6. 43, 0D, 20
        sete    dl                                      ; 07E5 _ 0F 94. C2
        shl     edx, 3                                  ; 07E8 _ C1. E2, 03
        or      eax, edx                                ; 07EB _ 09. D0
        jmp     ?_067                                   ; 07ED _ EB, 81

?_072:  mov     eax, edi                                ; 07EF _ 89. F8
        cmp     al, 2                                   ; 07F1 _ 3C, 02
        jz      ?_068                                   ; 07F3 _ 74, 96
        cmp     al, 1                                   ; 07F5 _ 3C, 01
        jne     ?_092                                   ; 07F7 _ 0F 85, 0000015A
        jmp     ?_068                                   ; 07FD _ EB, 8C

?_073:  mov     ecx, edi                                ; 07FF _ 89. F9
        test    cl, cl                                  ; 0801 _ 84. C9
        jnz     ?_076                                   ; 0803 _ 75, 26
        mov     edx, eax                                ; 0805 _ 89. C2
        and     edx, 07H                                ; 0807 _ 83. E2, 07
        cmp     dl, 5                                   ; 080A _ 80. FA, 05
        mov     edx, 3                                  ; 080D _ BA, 00000003
        cmove   edi, edx                                ; 0812 _ 0F 44. FA
?_074:  and     eax, 07H                                ; 0815 _ 83. E0, 07
        cmp     al, 4                                   ; 0818 _ 3C, 04
        jz      ?_078                                   ; 081A _ 74, 39
?_075:  mov     eax, edi                                ; 081C _ 89. F8
        test    al, al                                  ; 081E _ 84. C0
        je      ?_092                                   ; 0820 _ 0F 84, 00000131
        jmp     ?_068                                   ; 0826 _ E9, FFFFFF60

?_076:  cmp     cl, 1                                   ; 082B _ 80. F9, 01
        jnz     ?_077                                   ; 082E _ 75, 0C
        and     eax, 07H                                ; 0830 _ 83. E0, 07
        cmp     al, 4                                   ; 0833 _ 3C, 04
        jz      ?_078                                   ; 0835 _ 74, 1E
        jmp     ?_068                                   ; 0837 _ E9, FFFFFF4F

?_077:  cmp     cl, 2                                   ; 083C _ 80. F9, 02
        jne     ?_081                                   ; 083F _ 0F 85, 0000008F
        and     eax, 07H                                ; 0845 _ 83. E0, 07
        cmp     al, 4                                   ; 0848 _ 3C, 04
        jne     ?_089                                   ; 084A _ 0F 85, 000000EE
        mov     edi, 3                                  ; 0850 _ BF, 00000003
?_078:  test    byte [ebx+14H], 08H                     ; 0855 _ F6. 43, 14, 08
        jnz     ?_079                                   ; 0859 _ 75, 2B
        or      byte [ebx+14H], 08H                     ; 085B _ 80. 4B, 14, 08
        movzx   eax, byte [ebx+4H]                      ; 085F _ 0F B6. 43, 04
        mov     ecx, eax                                ; 0863 _ 89. C1
        shl     ecx, 4                                  ; 0865 _ C1. E1, 04
        movzx   edx, byte [ebx+10H]                     ; 0868 _ 0F B6. 53, 10
        and     edx, 0FH                                ; 086C _ 83. E2, 0F
        or      edx, ecx                                ; 086F _ 09. CA
        mov     byte [ebx+10H], dl                      ; 0871 _ 88. 53, 10
        mov     edx, dword [ebx]                        ; 0874 _ 8B. 13
        lea     ecx, [eax+1H]                           ; 0876 _ 8D. 48, 01
        mov     byte [ebx+4H], cl                       ; 0879 _ 88. 4B, 04
        movzx   eax, al                                 ; 087C _ 0F B6. C0
        movzx   eax, byte [edx+eax]                     ; 087F _ 0F B6. 04 02
        mov     byte [ebx+7H], al                       ; 0883 _ 88. 43, 07
?_079:  movzx   ebp, byte [ebx+7H]                      ; 0886 _ 0F B6. 6B, 07
        and     ebp, 07H                                ; 088A _ 83. E5, 07
        mov     eax, ebx                                ; 088D _ 89. D8
        call    get_modrm                               ; 088F _ E8, FFFFF76C
        mov     edx, eax                                ; 0894 _ 89. C2
        movzx   eax, byte [ebx+5H]                      ; 0896 _ 0F B6. 43, 05
        mov     ecx, eax                                ; 089A _ 89. C1
        and     ecx, 03H                                ; 089C _ 83. E1, 03
        cmp     cl, 2                                   ; 089F _ 80. F9, 02
        jz      ?_082                                   ; 08A2 _ 74, 3A
?_080:  and     eax, 30H                                ; 08A4 _ 83. E0, 30
        sub     eax, 16                                 ; 08A7 _ 83. E8, 10
        test    al, 0FFFFFFEFH                          ; 08AA _ A8, EF
        jne     ?_075                                   ; 08AC _ 0F 85, FFFFFF6A
        mov     eax, ebp                                ; 08B2 _ 89. E8
        and     eax, 0FFFFFFF7H                         ; 08B4 _ 83. E0, F7
        cmp     al, 5                                   ; 08B7 _ 3C, 05
        jne     ?_075                                   ; 08B9 _ 0F 85, FFFFFF5D
        shr     dl, 6                                   ; 08BF _ C0. EA, 06
        mov     edi, edx                                ; 08C2 _ 89. D7
        cmp     dl, 1                                   ; 08C4 _ 80. FA, 01
        mov     eax, 3                                  ; 08C7 _ B8, 00000003
        cmovne  edi, eax                                ; 08CC _ 0F 45. F8
        jmp     ?_068                                   ; 08CF _ E9, FFFFFEB7

?_081:  mov     edi, 0                                  ; 08D4 _ BF, 00000000
        jmp     ?_074                                   ; 08D9 _ E9, FFFFFF37

?_082:  test    byte [ebx+13H], 01H                     ; 08DE _ F6. 43, 13, 01
        jz      ?_083                                   ; 08E2 _ 74, 0E
        movzx   ecx, byte [ebx+9H]                      ; 08E4 _ 0F B6. 4B, 09
        shl     ecx, 3                                  ; 08E8 _ C1. E1, 03
        and     ecx, 08H                                ; 08EB _ 83. E1, 08
        or      ebp, ecx                                ; 08EE _ 09. CD
        jmp     ?_080                                   ; 08F0 _ EB, B2

?_083:  movzx   ecx, byte [ebx+14H]                     ; 08F2 _ 0F B6. 4B, 14
        test    cl, 01H                                 ; 08F6 _ F6. C1, 01
        jz      ?_084                                   ; 08F9 _ 74, 0E
        test    byte [ebx+0DH], 20H                     ; 08FB _ F6. 43, 0D, 20
        sete    cl                                      ; 08FF _ 0F 94. C1
        shl     ecx, 3                                  ; 0902 _ C1. E1, 03
        or      ebp, ecx                                ; 0905 _ 09. CD
        jmp     ?_080                                   ; 0907 _ EB, 9B

?_084:  test    cl, 02H                                 ; 0909 _ F6. C1, 02
        jz      ?_080                                   ; 090C _ 74, 96
        test    byte [ebx+0DH], 20H                     ; 090E _ F6. 43, 0D, 20
        sete    cl                                      ; 0912 _ 0F 94. C1
        shl     ecx, 3                                  ; 0915 _ C1. E1, 03
        or      ebp, ecx                                ; 0918 _ 09. CD
        jmp     ?_080                                   ; 091A _ EB, 88

?_085:  add     byte [ebx+4H], 1                        ; 091C _ 80. 43, 04, 01
        jmp     ?_094                                   ; 0920 _ EB, 59

?_086:  add     byte [ebx+4H], 2                        ; 0922 _ 80. 43, 04, 02
        jmp     ?_099                                   ; 0926 _ E9, 000000AC

?_087:  add     byte [ebx+4H], 4                        ; 092B _ 80. 43, 04, 04
        jmp     ?_100                                   ; 092F _ E9, 000000AF

?_088:  mov     eax, 4294967295                         ; 0934 _ B8, FFFFFFFF
        jmp     ?_060                                   ; 0939 _ E9, FFFFFDA0

?_089:  mov     edi, 3                                  ; 093E _ BF, 00000003
        jmp     ?_068                                   ; 0943 _ E9, FFFFFE43

?_090:  mov     eax, 4294967295                         ; 0948 _ B8, FFFFFFFF
        jmp     ?_060                                   ; 094D _ E9, FFFFFD8C

?_091:  mov     esi, 16                                 ; 0952 _ BE, 00000010
?_092:  test    esi, 2H                                 ; 0957 _ F7. C6, 00000002
        jz      ?_093                                   ; 095D _ 74, 14
        movzx   eax, byte [ebx+5H]                      ; 095F _ 0F B6. 43, 05
        and     eax, 0CH                                ; 0963 _ 83. E0, 0C
        cmp     al, 1                                   ; 0966 _ 3C, 01
        sbb     eax, eax                                ; 0968 _ 19. C0
        and     eax, 0FFFFFFFEH                         ; 096A _ 83. E0, FE
        add     eax, 4                                  ; 096D _ 83. C0, 04
        add     byte [ebx+4H], al                       ; 0970 _ 00. 43, 04
?_093:  test    esi, 4H                                 ; 0973 _ F7. C6, 00000004
        jnz     ?_085                                   ; 0979 _ 75, A1
?_094:  test    esi, 8H                                 ; 097B _ F7. C6, 00000008
        jz      ?_096                                   ; 0981 _ 74, 20
        mov     edx, 2                                  ; 0983 _ BA, 00000002
        movzx   eax, byte [ebx+5H]                      ; 0988 _ 0F B6. 43, 05
        and     eax, 30H                                ; 098C _ 83. E0, 30
        jz      ?_095                                   ; 098F _ 74, 0F
        cmp     al, 16                                  ; 0991 _ 3C, 10
        setne   dl                                      ; 0993 _ 0F 95. C2
        movzx   edx, dl                                 ; 0996 _ 0F B6. D2
        lea     edx, [edx*4+4H]                         ; 0999 _ 8D. 14 95, 00000004
?_095:  add     byte [ebx+4H], dl                       ; 09A0 _ 00. 53, 04
?_096:  test    esi, 10H                                ; 09A3 _ F7. C6, 00000010
        jz      ?_098                                   ; 09A9 _ 74, 20
        mov     edx, 2                                  ; 09AB _ BA, 00000002
        movzx   eax, byte [ebx+5H]                      ; 09B0 _ 0F B6. 43, 05
        and     eax, 0CH                                ; 09B4 _ 83. E0, 0C
        jz      ?_097                                   ; 09B7 _ 74, 0F
        cmp     al, 4                                   ; 09B9 _ 3C, 04
        setne   dl                                      ; 09BB _ 0F 95. C2
        movzx   edx, dl                                 ; 09BE _ 0F B6. D2
        lea     edx, [edx*4+4H]                         ; 09C1 _ 8D. 14 95, 00000004
?_097:  add     byte [ebx+4H], dl                       ; 09C8 _ 00. 53, 04
?_098:  test    esi, 20H                                ; 09CB _ F7. C6, 00000020
        jne     ?_086                                   ; 09D1 _ 0F 85, FFFFFF4B
?_099:  test    esi, 40H                                ; 09D7 _ F7. C6, 00000040
        jne     ?_087                                   ; 09DD _ 0F 85, FFFFFF48
?_100:  test    esi, 80H                                ; 09E3 _ F7. C6, 00000080
        je      ?_059                                   ; 09E9 _ 0F 84, FFFFFCEB
        mov     edx, 2                                  ; 09EF _ BA, 00000002
        movzx   eax, byte [ebx+5H]                      ; 09F4 _ 0F B6. 43, 05
        and     eax, 0CH                                ; 09F8 _ 83. E0, 0C
        jz      ?_101                                   ; 09FB _ 74, 0F
        cmp     al, 4                                   ; 09FD _ 3C, 04
        setne   dl                                      ; 09FF _ 0F 95. C2
        movzx   edx, dl                                 ; 0A02 _ 0F B6. D2
        lea     edx, [edx*4+4H]                         ; 0A05 _ 8D. 14 95, 00000004
?_101:  movzx   eax, byte [ebx+4H]                      ; 0A0C _ 0F B6. 43, 04
        lea     eax, [eax+edx+2H]                       ; 0A10 _ 8D. 44 10, 02
        mov     byte [ebx+4H], al                       ; 0A14 _ 88. 43, 04
        jmp     ?_059                                   ; 0A17 _ E9, FFFFFCBE

?_102:  mov     esi, 8                                  ; 0A1C _ BE, 00000008
        jmp     ?_092                                   ; 0A21 _ E9, FFFFFF31

?_103:  mov     esi, 32                                 ; 0A26 _ BE, 00000020
        jmp     ?_092                                   ; 0A2B _ E9, FFFFFF27

?_104:  mov     esi, 36                                 ; 0A30 _ BE, 00000024
        jmp     ?_092                                   ; 0A35 _ E9, FFFFFF1D

?_105:
        mov     esi, 128                                ; 0A3A _ BE, 00000080
        jmp     ?_092                                   ; 0A3F _ E9, FFFFFF13

x86_ldasm_ext_table:
        push    ebx                                     ; 0A44 _ 53
        sub     esp, 56                                 ; 0A45 _ 83. EC, 38
        mov     eax, dword [esp+40H]                    ; 0A53 _ 8B. 44 24, 40
        lea     edx, [esp+0CH]                          ; 0A57 _ 8D. 54 24, 0C
        test    eax, eax                                ; 0A5B _ 85. C0
        cmove   eax, edx                                ; 0A5D _ 0F 44. C2
        
        push 00000EE00H
        push 0FF111011H
        push 000AC3150H
        push 011302120H
        push 031501130H
        push 021203100H
        push 0A5018C00H
        push 08C4100EDH
        push 011008F21H
        push 000914500H
        push 09C450088H
        push 045008911H
        push 0008F1120H
        push 021202160H
        push 031502160H
        push 031009500H
        push 0FF150090H
        push 01500DF01H
        push 088008801H
        push 088404541H
        push 0008F3130H
        push 015101510H
        push 035602500H
        push 095352015H
        push 030654005H
        push 088103510H
        push 035008831H
        push 010410090H
        push 051009B01H
        push 08A60018AH
        push 060018A20H
        push 041101110H
        push 011008931H
        push 06021009DH
        push 031009031H
        push 030019A20H
        push 061103110H
        push 071152001H
        push 0C1008811H
        push 035111571H
        push 015018D15H
        push 011501115H
        push 011300190H
        push 002904120H
        push 021103145H
        push 0212001ACH
        push 000900188H
        push 040019415H
        push 010110089H
        push 061602100H
        push 08A141022H
        push 004880188H
        push 020244120H
        push 014401413H
        push 015212025H
        push 000880488H
        push 060121400H
        push 098018C25H
        push 013150490H
        push 040151413H
        push 012402100H
        push 0A4121441H
        push 020121441H
        push 020121441H
        push 020121441H
        push 020121441H
        push 020121441H
        push 020121441H
        push 020121441H
        
        mov     dword [eax+1CH], esp
        mov     dword [eax+20H], 113H
        sub     esp, 4                                  ; 0A6E _ 83. EC, 04
        push    dword [esp+4CH+0114H]
        push    dword [esp+4CH+0114H]
        push    eax                                     ; 0A79 _ 50
        call    x86_ldasm                               ; 0A7A _ E8, FFFFFFFC(PLT r)
        add     esp, 15CH
        pop     ebx                                     ; 0A82 _ 5B
        ret     12                                      ; 0A83 _ C2, 000C
