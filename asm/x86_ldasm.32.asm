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
;
[BITS 32]

	jmp x86_ldasm ; Entrypoint

get_pc_thunk:
        mov     eax, dword [esp]                        ; 0000 _ 8B. 04 24
        ret                                             ; 0003 _ C3
		
get_modrm:
        mov     dl, byte [eax+14H]                      ; 0000 _ 8A. 50, 14
        test    dl, 04H                                 ; 0003 _ F6. C2, 04
        jnz     ?_001                                   ; 0006 _ 75, 32
        push    ebp                                     ; 0008 _ 55
        or      edx, 04H                                ; 0009 _ 83. CA, 04
        mov     ebp, esp                                ; 000C _ 89. E5
        push    ebx                                     ; 000E _ 53
        mov     cl, byte [eax+10H]                      ; 000F _ 8A. 48, 10
        mov     byte [eax+14H], dl                      ; 0012 _ 88. 50, 14
        movzx   edx, byte [eax+4H]                      ; 0015 _ 0F B6. 50, 04
        and     ecx, 0FFFFFFF0H                         ; 0019 _ 83. E1, F0
        mov     ebx, edx                                ; 001C _ 89. D3
        and     ebx, 0FH                                ; 001E _ 83. E3, 0F
        or      ecx, ebx                                ; 0021 _ 09. D9
        lea     ebx, [edx+1H]                           ; 0023 _ 8D. 5A, 01
        mov     byte [eax+10H], cl                      ; 0026 _ 88. 48, 10
        mov     ecx, dword [eax]                        ; 0029 _ 8B. 08
        mov     byte [eax+4H], bl                       ; 002B _ 88. 58, 04
        mov     dl, byte [ecx+edx]                      ; 002E _ 8A. 14 11
        mov     byte [eax+6H], dl                       ; 0031 _ 88. 50, 06
        mov     al, byte [eax+6H]                       ; 0034 _ 8A. 40, 06
        pop     ebx                                     ; 0037 _ 5B
        pop     ebp                                     ; 0038 _ 5D
        ret                                             ; 0039 _ C3

?_001:
        mov     al, byte [eax+6H]                       ; 003A _ 8A. 40, 06
        ret                                             ; 003D _ C3

get_osize:
        push    ebp                                     ; 003E _ 55
        mov     ecx, eax                                ; 003F _ 89. C1
        mov     ebp, esp                                ; 0041 _ 89. E5
        push    edi                                     ; 0043 _ 57
        mov     edi, edx                                ; 0044 _ 89. D7
        push    esi                                     ; 0046 _ 56
        push    ebx                                     ; 0047 _ 53
        mov     dl, byte [eax+13H]                      ; 0048 _ 8A. 50, 13
        mov     al, byte [eax+5H]                       ; 004B _ 8A. 40, 05
        shr     dl, 2                                   ; 004E _ C0. EA, 02
        mov     esi, eax                                ; 0051 _ 89. C6
        and     edx, 01H                                ; 0053 _ 83. E2, 01
        and     esi, 03H                                ; 0056 _ 83. E6, 03
        jz      ?_008                                   ; 0059 _ 74, 55
        mov     ebx, esi                                ; 005B _ 89. F3
        dec     bl                                      ; 005D _ FE. CB
        jz      ?_007                                   ; 005F _ 74, 49
        test    edi, 1H                                 ; 0061 _ F7. C7, 00000001
        jz      ?_003                                   ; 0067 _ 74, 08
?_002:  and     eax, 0FFFFFFF3H                         ; 0069 _ 83. E0, F3
        or      eax, 08H                                ; 006C _ 83. C8, 08
        jmp     ?_006                                   ; 006F _ EB, 34

?_003:  test    byte [ecx+9H], 08H                      ; 0071 _ F6. 41, 09, 08
        jnz     ?_002                                   ; 0075 _ 75, F2
        mov     esi, dword [ecx+14H]                    ; 0077 _ 8B. 71, 14
        test    esi, 1H                                 ; 007A _ F7. C6, 00000001
        jz      ?_004                                   ; 0080 _ 74, 06
        cmp     byte [ecx+0EH], 0                       ; 0082 _ 80. 79, 0E, 00
        js      ?_002                                   ; 0086 _ 78, E1
?_004:  and     esi, 02H                                ; 0088 _ 83. E6, 02
        jz      ?_005                                   ; 008B _ 74, 06
        cmp     byte [ecx+0EH], 0                       ; 008D _ 80. 79, 0E, 00
        js      ?_002                                   ; 0091 _ 78, D6
?_005:  and     edi, 02H                                ; 0093 _ 83. E7, 02
        jz      ?_007                                   ; 0096 _ 74, 12
        test    dl, dl                                  ; 0098 _ 84. D2
        sete    dl                                      ; 009A _ 0F 94. C2
        and     eax, 0FFFFFFF3H                         ; 009D _ 83. E0, F3
        shl     edx, 3                                  ; 00A0 _ C1. E2, 03
        or      eax, edx                                ; 00A3 _ 09. D0
?_006:  mov     byte [ecx+5H], al                       ; 00A5 _ 88. 41, 05
        jmp     ?_009                                   ; 00A8 _ EB, 11

?_007:  xor     edx, 01H                                ; 00AA _ 83. F2, 01
        and     edx, 03H                                ; 00AD _ 83. E2, 03
?_008:  shl     edx, 2                                  ; 00B0 _ C1. E2, 02
        and     eax, 0FFFFFFF3H                         ; 00B3 _ 83. E0, F3
        or      edx, eax                                ; 00B6 _ 09. C2
        mov     byte [ecx+5H], dl                       ; 00B8 _ 88. 51, 05
?_009:  pop     ebx                                     ; 00BB _ 5B
        pop     esi                                     ; 00BC _ 5E
        pop     edi                                     ; 00BD _ 5F
        pop     ebp                                     ; 00BE _ 5D
        ret                                             ; 00BF _ C3

x86_ldasm:
        call    get_pc_thunk                            ; 00C0 _ E8, FFFFFFFC(rel)
x86_ldasm_pic:
        push    ebp                                     ; 00CA _ 55
        mov     ebp, esp                                ; 00CB _ 89. E5
        push    edi                                     ; 00CD _ 57
        push    esi                                     ; 00CE _ 56
        push    ebx                                     ; 00CF _ 53
        sub     esp, 332                                ; 00D0 _ 81. EC, 0000014C
        mov     ebx, dword [ebp+8H]                     ; 00D6 _ 8B. 5D, 08
        mov     dword [ebp-154H], eax                   ; 00D9 _ 89. 85, FFFFFEAC
        mov     edx, dword [ebp+0CH]                    ; 00DF _ 8B. 55, 0C
        test    ebx, ebx                                ; 00E2 _ 85. DB
        jnz     ?_010                                   ; 00E4 _ 75, 06
        lea     ebx, [ebp-148H]                         ; 00E6 _ 8D. 9D, FFFFFEB8
?_010:  mov     eax, dword [ebp+10H]                    ; 00EC _ 8B. 45, 10
        and     byte [ebx+14H], 0E0H                    ; 00EF _ 80. 63, 14, E0
        cmp     edx, 2                                  ; 00F3 _ 83. FA, 02
        mov     byte [ebx+4H], 0                        ; 00F6 _ C6. 43, 04, 00
        mov     dword [ebx], eax                        ; 00FA _ 89. 03
        mov     al, byte [ebx+5H]                       ; 00FC _ 8A. 43, 05
        mov     dword [ebx+9H], 0                       ; 00FF _ C7. 43, 09, 00000000
        mov     dword [ebx+10H], 0                      ; 0106 _ C7. 43, 10, 00000000
        mov     dword [ebx+18H], -1                     ; 010D _ C7. 43, 18, FFFFFFFF
        jbe     ?_012                                   ; 0114 _ 76, 18
        xor     ecx, ecx                                ; 0116 _ 31. C9
        cmp     edx, 16                                 ; 0118 _ 83. FA, 10
        jz      ?_011                                   ; 011B _ 74, 07
        cmp     edx, 32                                 ; 011D _ 83. FA, 20
        setne   cl                                      ; 0120 _ 0F 95. C1
        inc     ecx                                     ; 0123 _ 41
?_011:  and     eax, 0FFFFFFFCH                         ; 0124 _ 83. E0, FC
        or      ecx, eax                                ; 0127 _ 09. C1
        mov     byte [ebx+5H], cl                       ; 0129 _ 88. 4B, 05
        jmp     ?_013                                   ; 012C _ EB, 0B

?_012:  and     edx, 03H                                ; 012E _ 83. E2, 03
        and     eax, 0FFFFFFFCH                         ; 0131 _ 83. E0, FC
        or      eax, edx                                ; 0134 _ 09. D0
        mov     byte [ebx+5H], al                       ; 0136 _ 88. 43, 05
?_013:  mov     eax, dword [ebp+10H]                    ; 0139 _ 8B. 45, 10
        mov     dword [ebp-150H], eax                   ; 013C _ 89. 85, FFFFFEB0
        xor     eax, eax                                ; 0142 _ 31. C0
?_014:  mov     esi, dword [ebp-150H]                   ; 0144 _ 8B. B5, FFFFFEB0
        mov     cl, byte [esi]                          ; 014A _ 8A. 0E
        mov     edx, ecx                                ; 014C _ 89. CA
        shr     dl, 4                                   ; 014E _ C0. EA, 04
        cmp     dl, 4                                   ; 0151 _ 80. FA, 04
        jnz     ?_015                                   ; 0154 _ 75, 3C
        movzx   esi, byte [ebx+5H]                      ; 0156 _ 0F B6. 73, 05
        and     esi, 03H                                ; 015A _ 83. E6, 03
        mov     edx, esi                                ; 015D _ 89. F2
        cmp     dl, 2                                   ; 015F _ 80. FA, 02
        jne     ?_024                                   ; 0162 _ 0F 85, 000000ED
        mov     byte [ebx+0AH], cl                      ; 0168 _ 88. 4B, 0A
        mov     esi, dword [ebx+10H]                    ; 016B _ 8B. 73, 10
        mov     byte [ebx+9H], cl                       ; 016E _ 88. 4B, 09
        mov     ecx, eax                                ; 0171 _ 89. C1
        shl     ecx, 8                                  ; 0173 _ C1. E1, 08
        and     esi, 0FEFFF0FFH                         ; 0176 _ 81. E6, FEFFF0FF
        or      ecx, 1000000H                           ; 017C _ 81. C9, 01000000
        and     ecx, 1000F00H                           ; 0182 _ 81. E1, 01000F00
        or      ecx, esi                                ; 0188 _ 09. F1
        mov     dword [ebx+10H], ecx                    ; 018A _ 89. 4B, 10
        jmp     ?_023                                   ; 018D _ E9, 000000B1

?_015:  cmp     cl, 102                                 ; 0192 _ 80. F9, 66
        jnz     ?_016                                   ; 0195 _ 75, 27
        mov     edi, dword [ebx+0CH]                    ; 0197 _ 8B. 7B, 0C
        or      byte [ebx+13H], 04H                     ; 019A _ 80. 4B, 13, 04
        mov     byte [ebx+0AH], 102                     ; 019E _ C6. 43, 0A, 66
        lea     ecx, [edi+0EH]                          ; 01A2 _ 8D. 4F, 0E
        cmp     cl, 1                                   ; 01A5 _ 80. F9, 01
        jbe     ?_023                                   ; 01A8 _ 0F 86, 00000095
        mov     edi, dword [ebp-150H]                   ; 01AE _ 8B. BD, FFFFFEB0
        mov     cl, byte [edi]                          ; 01B4 _ 8A. 0F
        mov     byte [ebx+0CH], cl                      ; 01B6 _ 88. 4B, 0C
        jmp     ?_023                                   ; 01B9 _ E9, 00000085

?_016:  cmp     cl, 103                                 ; 01BE _ 80. F9, 67
        jnz     ?_017                                   ; 01C1 _ 75, 0A
        or      byte [ebx+13H], 08H                     ; 01C3 _ 80. 4B, 13, 08
        mov     byte [ebx+0AH], 103                     ; 01C7 _ C6. 43, 0A, 67
        jmp     ?_023                                   ; 01CB _ EB, 76

?_017:  mov     esi, ecx                                ; 01CD _ 89. CE
        and     esi, 0FFFFFFE7H                         ; 01CF _ 83. E6, E7
        mov     edx, esi                                ; 01D2 _ 89. F2
        cmp     dl, 38                                  ; 01D4 _ 80. FA, 26
        jnz     ?_018                                   ; 01D7 _ 75, 13
        movzx   esi, byte [ebx+5H]                      ; 01D9 _ 0F B6. 73, 05
        mov     byte [ebx+0BH], cl                      ; 01DD _ 88. 4B, 0B
        and     esi, 03H                                ; 01E0 _ 83. E6, 03
        mov     edx, esi                                ; 01E3 _ 89. F2
        cmp     dl, 2                                   ; 01E5 _ 80. FA, 02
        jnz     ?_019                                   ; 01E8 _ 75, 0F
        jmp     ?_023                                   ; 01EA _ EB, 57

?_018:  lea     esi, [ecx-64H]                          ; 01EC _ 8D. 71, 9C
        mov     edx, esi                                ; 01EF _ 89. F2
        cmp     dl, 1                                   ; 01F1 _ 80. FA, 01
        ja      ?_020                                   ; 01F4 _ 77, 0C
        mov     byte [ebx+0BH], cl                      ; 01F6 _ 88. 4B, 0B
?_019:  or      byte [ebx+13H], 02H                     ; 01F9 _ 80. 4B, 13, 02
        mov     byte [ebx+0AH], cl                      ; 01FD _ 88. 4B, 0A
        jmp     ?_023                                   ; 0200 _ EB, 41

?_020:  cmp     cl, -16                                 ; 0202 _ 80. F9, F0
        jnz     ?_021                                   ; 0205 _ 75, 0A
        or      byte [ebx+13H], 10H                     ; 0207 _ 80. 4B, 13, 10
        mov     byte [ebx+0AH], -16                     ; 020B _ C6. 43, 0A, F0
        jmp     ?_023                                   ; 020F _ EB, 32

?_021:  cmp     cl, -14                                 ; 0211 _ 80. F9, F2
        jnz     ?_022                                   ; 0214 _ 75, 15
        mov     esi, dword [ebp-150H]                   ; 0216 _ 8B. B5, FFFFFEB0
        mov     byte [ebx+0AH], -14                     ; 021C _ C6. 43, 0A, F2
        mov     cl, byte [esi]                          ; 0220 _ 8A. 0E
        or      byte [ebx+13H], 40H                     ; 0222 _ 80. 4B, 13, 40
        mov     byte [ebx+0CH], cl                      ; 0226 _ 88. 4B, 0C
        jmp     ?_023                                   ; 0229 _ EB, 18

?_022:  cmp     cl, -13                                 ; 022B _ 80. F9, F3
        jnz     ?_024                                   ; 022E _ 75, 25
        mov     edi, dword [ebp-150H]                   ; 0230 _ 8B. BD, FFFFFEB0
        mov     byte [ebx+0AH], -13                     ; 0236 _ C6. 43, 0A, F3
        mov     cl, byte [edi]                          ; 023A _ 8A. 0F
        or      byte [ebx+13H], 20H                     ; 023C _ 80. 4B, 13, 20
        mov     byte [ebx+0CH], cl                      ; 0240 _ 88. 4B, 0C
?_023:  inc     eax                                     ; 0243 _ 40
        inc     dword [ebp-150H]                        ; 0244 _ FF. 85, FFFFFEB0
        cmp     eax, 15                                 ; 024A _ 83. F8, 0F
        jne     ?_014                                   ; 024D _ 0F 85, FFFFFEF1
        jmp     ?_027                                   ; 0253 _ EB, 5F

?_024:  mov     cl, byte [ebx+5H]                       ; 0255 _ 8A. 4B, 05
        and     ecx, 03H                                ; 0258 _ 83. E1, 03
        mov     byte [ebp-14CH], cl                     ; 025B _ 88. 8D, FFFFFEB4
        cmp     cl, 2                                   ; 0261 _ 80. F9, 02
        jnz     ?_025                                   ; 0264 _ 75, 16
        mov     cl, byte [ebx+0AH]                      ; 0266 _ 8A. 4B, 0A
        shr     cl, 4                                   ; 0269 _ C0. E9, 04
        cmp     cl, 4                                   ; 026C _ 80. F9, 04
        jz      ?_025                                   ; 026F _ 74, 0B
        and     dword [ebx+10H], 0FEFFF0FFH             ; 0271 _ 81. 63, 10, FEFFF0FF
        mov     byte [ebx+9H], 0                        ; 0278 _ C6. 43, 09, 00
?_025:  mov     esi, dword [ebp-154H]                   ; 027C _ 8B. B5, FFFFFEAC
        lea     edi, [ebp-12CH]                         ; 0282 _ 8D. BD, FFFFFED4
        mov     ecx, 4                                  ; 0288 _ B9, 00000004	
		lea     esi, [?_098-x86_ldasm_pic+esi]          ; 0524 _ 8D. B0, 00000010(GOT)
        rep movsd                                       ; 0293 _ F3: A5
        mov     esi, dword [ebp-150H]                   ; 0295 _ 8B. B5, FFFFFEB0
        mov     dl, byte [esi]                          ; 029B _ 8A. 16
        cmp     dl, -60                                 ; 029D _ 80. FA, C4
        jne     ?_031                                   ; 02A0 _ 0F 85, 0000008E
        cmp     byte [ebp-14CH], 2                      ; 02A6 _ 80. BD, FFFFFEB4, 02
        jnz     ?_028                                   ; 02AD _ 75, 0D
?_026:  cmp     eax, 10                                 ; 02AF _ 83. F8, 0A
        jbe     ?_029                                   ; 02B2 _ 76, 25
?_027:  or      eax, 0FFFFFFFFH                         ; 02B4 _ 83. C8, FF
        jmp     ?_097                                   ; 02B7 _ E9, 000006AA

?_028:  mov     edi, dword [ebp+10H]                    ; 02BC _ 8B. 7D, 10
        mov     cl, byte [edi+eax+1H]                   ; 02BF _ 8A. 4C 07, 01
        mov     edx, ecx                                ; 02C3 _ 89. CA
        mov     byte [ebp-150H], cl                     ; 02C5 _ 88. 8D, FFFFFEB0
        shr     dl, 6                                   ; 02CB _ C0. EA, 06
        cmp     dl, 3                                   ; 02CE _ 80. FA, 03
        jne     ?_042                                   ; 02D1 _ 0F 85, 000001B6
        jmp     ?_026                                   ; 02D7 _ EB, D6

?_029:  test    byte [ebx+13H], 75H                     ; 02D9 _ F6. 43, 13, 75
        jnz     ?_027                                   ; 02DD _ 75, D5
        mov     edi, dword [ebp+10H]                    ; 02DF _ 8B. 7D, 10
        mov     dl, byte [edi+eax+1H]                   ; 02E2 _ 8A. 54 07, 01
        mov     byte [ebx+0DH], dl                      ; 02E6 _ 88. 53, 0D
        movzx   edi, byte [edi+eax+2H]                  ; 02E9 _ 0F B6. 7C 07, 02
        or      byte [ebx+14H], 01H                     ; 02EE _ 80. 4B, 14, 01
        mov     ecx, edi                                ; 02F2 _ 89. F9
        mov     byte [ebx+0EH], cl                      ; 02F4 _ 88. 4B, 0E
        mov     ecx, edx                                ; 02F7 _ 89. D1
        and     cl, 1FH                                 ; 02F9 _ 80. E1, 1F
        jz      ?_027                                   ; 02FC _ 74, B6
        and     dl, 1CH                                 ; 02FE _ 80. E2, 1C
        jnz     ?_027                                   ; 0301 _ 75, B1
        mov     esi, 256                                ; 0303 _ BE, 00000100
        cmp     cl, 1                                   ; 0308 _ 80. F9, 01
        jz      ?_030                                   ; 030B _ 74, 10
        cmp     cl, 2                                   ; 030D _ 80. F9, 02
        mov     esi, 512                                ; 0310 _ BE, 00000200
        mov     edx, 768                                ; 0315 _ BA, 00000300
        cmovne  esi, edx                                ; 031A _ 0F 45. F2
?_030:  mov     ecx, edi                                ; 031D _ 89. F9
        mov     dword [ebx+18H], esi                    ; 031F _ 89. 73, 18
        and     ecx, 03H                                ; 0322 _ 83. E1, 03
        mov     edx, dword [ebp+ecx*4-12CH]             ; 0325 _ 8B. 94 8D, FFFFFED4
        mov     byte [ebx+0CH], dl                      ; 032C _ 88. 53, 0C
        jmp     ?_037                                   ; 032F _ E9, 0000011D

?_031:  cmp     dl, -59                                 ; 0334 _ 80. FA, C5
        jnz     ?_033                                   ; 0337 _ 75, 62
        cmp     byte [ebp-14CH], 2                      ; 0339 _ 80. BD, FFFFFEB4, 02
        jz      ?_032                                   ; 0340 _ 74, 1B
        mov     edi, dword [ebp+10H]                    ; 0342 _ 8B. 7D, 10
        mov     cl, byte [edi+eax+1H]                   ; 0345 _ 8A. 4C 07, 01
        mov     edx, ecx                                ; 0349 _ 89. CA
        mov     byte [ebp-150H], cl                     ; 034B _ 88. 8D, FFFFFEB0
        shr     dl, 6                                   ; 0351 _ C0. EA, 06
        cmp     dl, 3                                   ; 0354 _ 80. FA, 03
        jne     ?_042                                   ; 0357 _ 0F 85, 00000130
?_032:  cmp     eax, 11                                 ; 035D _ 83. F8, 0B
        ja      ?_027                                   ; 0360 _ 0F 87, FFFFFF4E
        mov     cl, byte [ebx+13H]                      ; 0366 _ 8A. 4B, 13
        test    cl, 75H                                 ; 0369 _ F6. C1, 75
        jne     ?_027                                   ; 036C _ 0F 85, FFFFFF42
        mov     edi, dword [ebp+10H]                    ; 0372 _ 8B. 7D, 10
        or      ecx, 0FFFFFF80H                         ; 0375 _ 83. C9, 80
        mov     dl, byte [edi+eax+1H]                   ; 0378 _ 8A. 54 07, 01
        mov     byte [ebx+13H], cl                      ; 037C _ 88. 4B, 13
        mov     dword [ebx+18H], 256                    ; 037F _ C7. 43, 18, 00000100
        mov     byte [ebx+0DH], dl                      ; 0386 _ 88. 53, 0D
        and     edx, 03H                                ; 0389 _ 83. E2, 03
        mov     edx, dword [ebp+edx*4-12CH]             ; 038C _ 8B. 94 95, FFFFFED4
        mov     byte [ebx+0CH], dl                      ; 0393 _ 88. 53, 0C
        jmp     ?_039                                   ; 0396 _ E9, 000000D6

?_033:  cmp     dl, 98                                  ; 039B _ 80. FA, 62
        jnz     ?_034                                   ; 039E _ 75, 25
        cmp     byte [ebp-14CH], 2                      ; 03A0 _ 80. BD, FFFFFEB4, 02
        je      ?_027                                   ; 03A7 _ 0F 84, FFFFFF07
        mov     esi, dword [ebp+10H]                    ; 03AD _ 8B. 75, 10
        mov     dl, byte [esi+eax+1H]                   ; 03B0 _ 8A. 54 06, 01
        shr     dl, 6                                   ; 03B4 _ C0. EA, 06
        cmp     dl, 3                                   ; 03B7 _ 80. FA, 03
        jne     ?_042                                   ; 03BA _ 0F 85, 000000CD
        jmp     ?_027                                   ; 03C0 _ E9, FFFFFEEF

?_034:  cmp     dl, -113                                ; 03C5 _ 80. FA, 8F
        jne     ?_038                                   ; 03C8 _ 0F 85, 00000088
        mov     edi, dword [ebp+10H]                    ; 03CE _ 8B. 7D, 10
        cmp     byte [ebp-14CH], 2                      ; 03D1 _ 80. BD, FFFFFEB4, 02
        mov     cl, byte [edi+eax+1H]                   ; 03D8 _ 8A. 4C 07, 01
        jz      ?_035                                   ; 03DC _ 74, 0E
        mov     edx, ecx                                ; 03DE _ 89. CA
        shr     dl, 6                                   ; 03E0 _ C0. EA, 06
        cmp     dl, 3                                   ; 03E3 _ 80. FA, 03
        jne     ?_042                                   ; 03E6 _ 0F 85, 000000A1
?_035:  test    cl, 18H                                 ; 03EC _ F6. C1, 18
        je      ?_042                                   ; 03EF _ 0F 84, 00000098
        mov     edx, ecx                                ; 03F5 _ 89. CA
        and     edx, 1FH                                ; 03F7 _ 83. E2, 1F
        cmp     dl, 10                                  ; 03FA _ 80. FA, 0A
        ja      ?_042                                   ; 03FD _ 0F 87, 0000008A
        cmp     eax, 10                                 ; 0403 _ 83. F8, 0A
        ja      ?_027                                   ; 0406 _ 0F 87, FFFFFEA8
        test    byte [ebx+13H], 75H                     ; 040C _ F6. 43, 13, 75
        jne     ?_027                                   ; 0410 _ 0F 85, FFFFFE9E
        mov     esi, dword [ebp+10H]                    ; 0416 _ 8B. 75, 10
        mov     byte [ebx+0DH], cl                      ; 0419 _ 88. 4B, 0D
        mov     cl, byte [esi+eax+2H]                   ; 041C _ 8A. 4C 06, 02
        or      byte [ebx+14H], 02H                     ; 0420 _ 80. 4B, 14, 02
        mov     byte [ebx+0EH], cl                      ; 0424 _ 88. 4B, 0E
        and     cl, 03H                                 ; 0427 _ 80. E1, 03
        jne     ?_027                                   ; 042A _ 0F 85, FFFFFE84
        mov     ecx, 1024                               ; 0430 _ B9, 00000400
        cmp     dl, 8                                   ; 0435 _ 80. FA, 08
        jz      ?_036                                   ; 0438 _ 74, 10
        cmp     dl, 9                                   ; 043A _ 80. FA, 09
        mov     ecx, 1280                               ; 043D _ B9, 00000500
        mov     edx, 1536                               ; 0442 _ BA, 00000600
        cmovne  ecx, edx                                ; 0447 _ 0F 45. CA
?_036:  mov     dword [ebx+18H], ecx                    ; 044A _ 89. 4B, 18
        mov     byte [ebx+0CH], 0                       ; 044D _ C6. 43, 0C, 00
?_037:  lea     ecx, [eax+3H]                           ; 0451 _ 8D. 48, 03
        jmp     ?_043                                   ; 0454 _ EB, 44

?_038:  cmp     dl, 15                                  ; 0456 _ 80. FA, 0F
        jnz     ?_042                                   ; 0459 _ 75, 32
        mov     edi, dword [ebp+10H]                    ; 045B _ 8B. 7D, 10
        lea     ecx, [eax+1H]                           ; 045E _ 8D. 48, 01
        mov     dl, byte [edi+eax+1H]                   ; 0461 _ 8A. 54 07, 01
        cmp     dl, 56                                  ; 0465 _ 80. FA, 38
        jnz     ?_040                                   ; 0468 _ 75, 0C
        mov     dword [ebx+18H], 512                    ; 046A _ C7. 43, 18, 00000200
?_039:  lea     ecx, [eax+2H]                           ; 0471 _ 8D. 48, 02
        jmp     ?_043                                   ; 0474 _ EB, 24

?_040:  cmp     dl, 58                                  ; 0476 _ 80. FA, 3A
        jnz     ?_041                                   ; 0479 _ 75, 09
        mov     dword [ebx+18H], 768                    ; 047B _ C7. 43, 18, 00000300
        jmp     ?_039                                   ; 0482 _ EB, ED

?_041:  mov     dword [ebx+18H], 256                    ; 0484 _ C7. 43, 18, 00000100
        jmp     ?_043                                   ; 048B _ EB, 0D

?_042:  mov     byte [ebx+0CH], 0                       ; 048D _ C6. 43, 0C, 00
        mov     ecx, eax                                ; 0491 _ 89. C1
        mov     dword [ebx+18H], 0                      ; 0493 _ C7. 43, 18, 00000000
?_043:  mov     al, byte [ebx+11H]                      ; 049A _ 8A. 43, 11
        mov     dl, byte [ebx+5H]                       ; 049D _ 8A. 53, 05
        mov     byte [ebx+4H], cl                       ; 04A0 _ 88. 4B, 04
        shl     ecx, 4                                  ; 04A3 _ C1. E1, 04
        and     eax, 0FH                                ; 04A6 _ 83. E0, 0F
        or      ecx, eax                                ; 04A9 _ 09. C1
        mov     al, byte [ebx+13H]                      ; 04AB _ 8A. 43, 13
        mov     byte [ebx+11H], cl                      ; 04AE _ 88. 4B, 11
        shr     al, 3                                   ; 04B1 _ C0. E8, 03
        and     eax, 01H                                ; 04B4 _ 83. E0, 01
        cmp     byte [ebp-14CH], 0                      ; 04B7 _ 80. BD, FFFFFEB4, 00
        jnz     ?_044                                   ; 04BE _ 75, 0D
        shl     eax, 4                                  ; 04C0 _ C1. E0, 04
        and     edx, 0FFFFFFCFH                         ; 04C3 _ 83. E2, CF
        or      edx, eax                                ; 04C6 _ 09. C2
        mov     byte [ebx+5H], dl                       ; 04C8 _ 88. 53, 05
        jmp     ?_045                                   ; 04CB _ EB, 27

?_044:  mov     cl, 2                                   ; 04CD _ B1, 02
        and     edx, 0FFFFFFCFH                         ; 04CF _ 83. E2, CF
        sub     ecx, eax                                ; 04D2 _ 29. C1
        xor     eax, 01H                                ; 04D4 _ 83. F0, 01
        and     ecx, 03H                                ; 04D7 _ 83. E1, 03
        and     eax, 03H                                ; 04DA _ 83. E0, 03
        shl     ecx, 4                                  ; 04DD _ C1. E1, 04
        shl     eax, 4                                  ; 04E0 _ C1. E0, 04
        or      ecx, edx                                ; 04E3 _ 09. D1
        or      eax, edx                                ; 04E5 _ 09. D0
        cmp     byte [ebp-14CH], 1                      ; 04E7 _ 80. BD, FFFFFEB4, 01
        cmove   ecx, eax                                ; 04EE _ 0F 44. C8
        mov     byte [ebx+5H], cl                       ; 04F1 _ 88. 4B, 05
?_045:  xor     edx, edx                                ; 04F4 _ 31. D2
        mov     eax, ebx                                ; 04F6 _ 89. D8
        lea     edi, [ebp-12CH]                         ; 04F8 _ 8D. BD, FFFFFED4
        call    get_osize                               ; 04FE _ E8, FFFFFB3B
        mov     eax, dword [ebp-154H]                   ; 0503 _ 8B. 85, FFFFFEAC
        mov     edx, dword [ebx]                        ; 0509 _ 8B. 13
        mov     ecx, 275                                ; 050B _ B9, 00000113
        mov     dword [ebp-150H], 0                     ; 0510 _ C7. 85, FFFFFEB0, 00000000
        mov     dword [ebp-14CH], 0                     ; 051A _ C7. 85, FFFFFEB4, 00000000
        lea     esi, [?_099-x86_ldasm_pic+eax]          ; 0524 _ 8D. B0, 00000010(GOT)
        movzx   eax, byte [ebx+4H]                      ; 052A _ 0F B6. 43, 04
        rep movsb                                       ; 052E _ F3: A4
        mov     edi, dword [ebx+18H]                    ; 0530 _ 8B. 7B, 18
        lea     ecx, [eax+1H]                           ; 0533 _ 8D. 48, 01
        mov     byte [ebx+4H], cl                       ; 0536 _ 88. 4B, 04
        movzx   edx, byte [edx+eax]                     ; 0539 _ 0F B6. 14 02
        lea     esi, [edx+edi]                          ; 053D _ 8D. 34 3A
        mov     eax, edx                                ; 0540 _ 89. D0
        mov     dword [ebp-154H], esi                   ; 0542 _ 89. B5, FFFFFEAC
?_046:  mov     esi, dword [ebp-14CH]                   ; 0548 _ 8B. B5, FFFFFEB4
        mov     dl, byte [ebp+esi-12CH]                 ; 054E _ 8A. 94 35, FFFFFED4
        mov     ecx, edx                                ; 0555 _ 89. D1
        test    dl, dl                                  ; 0557 _ 84. D2
        js      ?_047                                   ; 0559 _ 78, 0A
        mov     esi, edx                                ; 055B _ 89. D6
        shr     cl, 4                                   ; 055D _ C0. E9, 04
        and     esi, 0FH                                ; 0560 _ 83. E6, 0F
        jmp     ?_048                                   ; 0563 _ EB, 17

?_047:  inc     dword [ebp-14CH]                        ; 0565 _ FF. 85, FFFFFEB4
        mov     esi, dword [ebp-14CH]                   ; 056B _ 8B. B5, FFFFFEB4
        and     ecx, 7FH                                ; 0571 _ 83. E1, 7F
        movzx   esi, byte [ebp+esi-12CH]                ; 0574 _ 0F B6. B4 35, FFFFFED4
?_048:  movzx   edx, cl                                 ; 057C _ 0F B6. D1
        add     dword [ebp-150H], edx                   ; 057F _ 01. 95, FFFFFEB0
        mov     edx, dword [ebp-150H]                   ; 0585 _ 8B. 95, FFFFFEB0
        cmp     dword [ebp-154H], edx                   ; 058B _ 39. 95, FFFFFEAC
        jc      ?_049                                   ; 0591 _ 72, 12
        inc     dword [ebp-14CH]                        ; 0593 _ FF. 85, FFFFFEB4
        cmp     dword [ebp-14CH], 274                   ; 0599 _ 81. BD, FFFFFEB4, 00000112
        jbe     ?_046                                   ; 05A3 _ 76, A3
?_049:  test    edi, edi                                ; 05A5 _ 85. FF
        jne     ?_052                                   ; 05A7 _ 0F 85, 0000008F
        lea     edx, [eax+18H]                          ; 05AD _ 8D. 50, 18
        cmp     dl, 1                                   ; 05B0 _ 80. FA, 01
        jbe     ?_053                                   ; 05B3 _ 0F 86, 00000093
        lea     edx, [eax+48H]                          ; 05B9 _ 8D. 50, 48
        cmp     dl, 7                                   ; 05BC _ 80. FA, 07
        jbe     ?_057                                   ; 05BF _ 0F 86, 000000C1
        lea     edx, [eax+60H]                          ; 05C5 _ 8D. 50, 60
        cmp     dl, 3                                   ; 05C8 _ 80. FA, 03
        jbe     ?_058                                   ; 05CB _ 0F 86, 000000BC
        mov     edx, eax                                ; 05D1 _ 89. C2
        and     edx, 0FFFFFFF7H                         ; 05D3 _ 83. E2, F7
        cmp     dl, -62                                 ; 05D6 _ 80. FA, C2
        je      ?_059                                   ; 05D9 _ 0F 84, 000000B5
        cmp     al, -56                                 ; 05DF _ 3C, C8
        je      ?_060                                   ; 05E1 _ 0F 84, 000000B4
        mov     edx, 2                                  ; 05E7 _ BA, 00000002
        cmp     al, 104                                 ; 05EC _ 3C, 68
        jz      ?_054                                   ; 05EE _ 74, 61
        cmp     al, -22                                 ; 05F0 _ 3C, EA
        je      ?_061                                   ; 05F2 _ 0F 84, 000000AA
        cmp     al, -102                                ; 05F8 _ 3C, 9A
        je      ?_061                                   ; 05FA _ 0F 84, 000000A2
        cmp     al, -10                                 ; 0600 _ 3C, F6
        jnz     ?_051                                   ; 0602 _ 75, 1F
        mov     eax, ebx                                ; 0604 _ 89. D8
        call    get_modrm                               ; 0606 _ E8, FFFFF9F5
        shr     al, 3                                   ; 060B _ C0. E8, 03
        test    al, 06H                                 ; 060E _ A8, 06
        je      ?_062                                   ; 0610 _ 0F 84, 00000093
?_050:  test    esi, esi                                ; 0616 _ 85. F6
        je      ?_089                                   ; 0618 _ 0F 84, 000002E6
        jmp     ?_064                                   ; 061E _ E9, 00000092

?_051:  cmp     al, -9                                  ; 0623 _ 3C, F7
        jnz     ?_050                                   ; 0625 _ 75, EF
        mov     eax, ebx                                ; 0627 _ 89. D8
        call    get_modrm                               ; 0629 _ E8, FFFFF9D2
        shr     al, 3                                   ; 062E _ C0. E8, 03
        test    al, 06H                                 ; 0631 _ A8, 06
        jnz     ?_050                                   ; 0633 _ 75, E1
        mov     esi, 3                                  ; 0635 _ BE, 00000003
        jmp     ?_064                                   ; 063A _ EB, 79

?_052:  cmp     edi, 256                                ; 063C _ 81. FF, 00000100
        jnz     ?_056                                   ; 0642 _ 75, 2C
        lea     edx, [eax-80H]                          ; 0644 _ 8D. 50, 80
        cmp     dl, 15                                  ; 0647 _ 80. FA, 0F
        ja      ?_055                                   ; 064A _ 77, 13
?_053:  mov     edx, 1                                  ; 064C _ BA, 00000001
?_054:  mov     eax, ebx                                ; 0651 _ 89. D8
        mov     esi, 2                                  ; 0653 _ BE, 00000002
        call    get_osize                               ; 0658 _ E8, FFFFF9E1
        jmp     ?_064                                   ; 065D _ EB, 56

?_055:  cmp     al, 120                                 ; 065F _ 3C, 78
        jnz     ?_050                                   ; 0661 _ 75, B3
        mov     al, byte [ebx+0CH]                      ; 0663 _ 8A. 43, 0C
        cmp     al, -14                                 ; 0666 _ 3C, F2
        jz      ?_063                                   ; 0668 _ 74, 46
        cmp     al, 102                                 ; 066A _ 3C, 66
        jnz     ?_050                                   ; 066C _ 75, A8
        jmp     ?_063                                   ; 066E _ EB, 40

?_056:  cmp     edi, 1536                               ; 0670 _ 81. FF, 00000600
        jnz     ?_050                                   ; 0676 _ 75, 9E
        and     eax, 0FFFFFFFDH                         ; 0678 _ 83. E0, FD
        cmp     al, 16                                  ; 067B _ 3C, 10
        jnz     ?_050                                   ; 067D _ 75, 97
        mov     esi, 65                                 ; 067F _ BE, 00000041
        jmp     ?_064                                   ; 0684 _ EB, 2F

?_057:  mov     esi, 16                                 ; 0686 _ BE, 00000010
        jmp     ?_064                                   ; 068B _ EB, 28

?_058:  mov     esi, 8                                  ; 068D _ BE, 00000008
        jmp     ?_064                                   ; 0692 _ EB, 21

?_059:  mov     esi, 32                                 ; 0694 _ BE, 00000020
        jmp     ?_064                                   ; 0699 _ EB, 1A

?_060:  mov     esi, 36                                 ; 069B _ BE, 00000024
        jmp     ?_064                                   ; 06A0 _ EB, 13

?_061:  mov     esi, 128                                ; 06A2 _ BE, 00000080
        jmp     ?_064                                   ; 06A7 _ EB, 0C

?_062:  mov     esi, 5                                  ; 06A9 _ BE, 00000005
        jmp     ?_064                                   ; 06AE _ EB, 05

?_063:  mov     esi, 33                                 ; 06B0 _ BE, 00000021
?_064:  test    esi, 1H                                 ; 06B5 _ F7. C6, 00000001
        je      ?_079                                   ; 06BB _ 0F 84, 00000189
        mov     eax, ebx                                ; 06C1 _ 89. D8
        call    get_modrm                               ; 06C3 _ E8, FFFFF938
        shr     al, 6                                   ; 06C8 _ C0. E8, 06
        mov     byte [ebp-14CH], al                     ; 06CB _ 88. 85, FFFFFEB4
        mov     eax, ebx                                ; 06D1 _ 89. D8
        call    get_modrm                               ; 06D3 _ E8, FFFFF928
        movzx   ecx, byte [ebp-14CH]                    ; 06D8 _ 0F B6. 8D, FFFFFEB4
        and     eax, 07H                                ; 06DF _ 83. E0, 07
        cmp     cl, 3                                   ; 06E2 _ 80. F9, 03
        je      ?_079                                   ; 06E5 _ 0F 84, 0000015F
        mov     dl, byte [ebx+5H]                       ; 06EB _ 8A. 53, 05
        mov     edi, edx                                ; 06EE _ 89. D7
        mov     byte [ebp-14CH], dl                     ; 06F0 _ 88. 95, FFFFFEB4
        and     edi, 03H                                ; 06F6 _ 83. E7, 03
        mov     edx, edi                                ; 06F9 _ 89. FA
        cmp     dl, 2                                   ; 06FB _ 80. FA, 02
        jnz     ?_068                                   ; 06FE _ 75, 30
        test    byte [ebx+13H], 01H                     ; 0700 _ F6. 43, 13, 01
        jz      ?_065                                   ; 0704 _ 74, 0C
        movzx   edi, byte [ebx+9H]                      ; 0706 _ 0F B6. 7B, 09
        shl     edi, 3                                  ; 070A _ C1. E7, 03
        and     edi, 08H                                ; 070D _ 83. E7, 08
        jmp     ?_067                                   ; 0710 _ EB, 1C

?_065:  mov     edi, dword [ebx+14H]                    ; 0712 _ 8B. 7B, 14
        test    edi, 1H                                 ; 0715 _ F7. C7, 00000001
        jnz     ?_066                                   ; 071B _ 75, 05
        and     edi, 02H                                ; 071D _ 83. E7, 02
        jz      ?_068                                   ; 0720 _ 74, 0E
?_066:  test    byte [ebx+0DH], 20H                     ; 0722 _ F6. 43, 0D, 20
        sete    dl                                      ; 0726 _ 0F 94. C2
        mov     edi, edx                                ; 0729 _ 89. D7
        shl     edi, 3                                  ; 072B _ C1. E7, 03
?_067:  or      eax, edi                                ; 072E _ 09. F8
?_068:  and     eax, 07H                                ; 0730 _ 83. E0, 07
        test    byte [ebp-14CH], 30H                    ; 0733 _ F6. 85, FFFFFEB4, 30
        jnz     ?_070                                   ; 073A _ 75, 1A
        test    cl, cl                                  ; 073C _ 84. C9
        jnz     ?_069                                   ; 073E _ 75, 08
        cmp     al, 6                                   ; 0740 _ 3C, 06
        je      ?_077                                   ; 0742 _ 0F 84, 000000DE
?_069:  cmp     cl, 1                                   ; 0748 _ 80. F9, 01
        jne     ?_090                                   ; 074B _ 0F 85, 000001B9
        jmp     ?_076                                   ; 0751 _ E9, 000000C9

?_070:  test    cl, cl                                  ; 0756 _ 84. C9
        jnz     ?_071                                   ; 0758 _ 75, 0E
        cmp     al, 5                                   ; 075A _ 3C, 05
        jnz     ?_072                                   ; 075C _ 75, 1D
        mov     ecx, 3                                  ; 075E _ B9, 00000003
        jmp     ?_078                                   ; 0763 _ E9, 000000C3

?_071:  cmp     cl, 1                                   ; 0768 _ 80. F9, 01
        je      ?_096                                   ; 076B _ 0F 84, 000001E8
        mov     ecx, 3                                  ; 0771 _ B9, 00000003
        jmp     ?_096                                   ; 0776 _ E9, 000001DE

?_072:  cmp     al, 4                                   ; 077B _ 3C, 04
        jne     ?_079                                   ; 077D _ 0F 85, 000000C7
?_073:  mov     al, byte [ebx+14H]                      ; 0783 _ 8A. 43, 14
        test    al, 08H                                 ; 0786 _ A8, 08
        jnz     ?_074                                   ; 0788 _ 75, 36
        or      eax, 08H                                ; 078A _ 83. C8, 08
        mov     dl, byte [ebx+10H]                      ; 078D _ 8A. 53, 10
        mov     byte [ebx+14H], al                      ; 0790 _ 88. 43, 14
        movzx   eax, byte [ebx+4H]                      ; 0793 _ 0F B6. 43, 04
        and     edx, 0FH                                ; 0797 _ 83. E2, 0F
        mov     edi, eax                                ; 079A _ 89. C7
        shl     edi, 4                                  ; 079C _ C1. E7, 04
        or      edx, edi                                ; 079F _ 09. FA
        mov     edi, dword [ebx]                        ; 07A1 _ 8B. 3B
        mov     byte [ebx+10H], dl                      ; 07A3 _ 88. 53, 10
        mov     dword [ebp-14CH], edi                   ; 07A6 _ 89. BD, FFFFFEB4
        lea     edi, [eax+1H]                           ; 07AC _ 8D. 78, 01
        mov     edx, edi                                ; 07AF _ 89. FA
        mov     edi, dword [ebp-14CH]                   ; 07B1 _ 8B. BD, FFFFFEB4
        mov     byte [ebx+4H], dl                       ; 07B7 _ 88. 53, 04
        mov     al, byte [edi+eax]                      ; 07BA _ 8A. 04 07
        mov     byte [ebx+7H], al                       ; 07BD _ 88. 43, 07
?_074:  mov     eax, ebx                                ; 07C0 _ 89. D8
        mov     byte [ebp-150H], cl                     ; 07C2 _ 88. 8D, FFFFFEB0
        movzx   edi, byte [ebx+7H]                      ; 07C8 _ 0F B6. 7B, 07
        call    get_modrm                               ; 07CC _ E8, FFFFF82F
        movzx   ecx, byte [ebp-150H]                    ; 07D1 _ 0F B6. 8D, FFFFFEB0
        mov     byte [ebp-14CH], al                     ; 07D8 _ 88. 85, FFFFFEB4
        mov     al, byte [ebx+5H]                       ; 07DE _ 8A. 43, 05
        and     edi, 07H                                ; 07E1 _ 83. E7, 07
        mov     edx, eax                                ; 07E4 _ 89. C2
        and     edx, 03H                                ; 07E6 _ 83. E2, 03
        cmp     dl, 2                                   ; 07E9 _ 80. FA, 02
        je      ?_091                                   ; 07EC _ 0F 84, 00000126
?_075:  and     eax, 30H                                ; 07F2 _ 83. E0, 30
        sub     eax, 16                                 ; 07F5 _ 83. E8, 10
        test    al, 0E0H                                ; 07F8 _ A8, E0
        jne     ?_095                                   ; 07FA _ 0F 85, 0000014C
        mov     eax, edi                                ; 0800 _ 89. F8
        and     eax, 0FFFFFFF7H                         ; 0802 _ 83. E0, F7
        cmp     al, 5                                   ; 0805 _ 3C, 05
        jne     ?_095                                   ; 0807 _ 0F 85, 0000013F
        mov     al, byte [ebp-14CH]                     ; 080D _ 8A. 85, FFFFFEB4
        mov     ecx, 3                                  ; 0813 _ B9, 00000003
        shr     al, 6                                   ; 0818 _ C0. E8, 06
        dec     al                                      ; 081B _ FE. C8
        jnz     ?_078                                   ; 081D _ 75, 0C
?_076:  mov     ecx, 1                                  ; 081F _ B9, 00000001
        jmp     ?_078                                   ; 0824 _ EB, 05

?_077:  mov     ecx, 2                                  ; 0826 _ B9, 00000002
?_078:  mov     dl, byte [ebx+4H]                       ; 082B _ 8A. 53, 04
        dec     ecx                                     ; 082E _ 49
        mov     eax, 1                                  ; 082F _ B8, 00000001
        shl     eax, cl                                 ; 0834 _ D3. E0
        mov     edi, edx                                ; 0836 _ 89. D7
        mov     ecx, eax                                ; 0838 _ 89. C1
        add     edx, eax                                ; 083A _ 01. C2
        shl     ecx, 4                                  ; 083C _ C1. E1, 04
        and     edi, 0FH                                ; 083F _ 83. E7, 0F
        mov     byte [ebx+4H], dl                       ; 0842 _ 88. 53, 04
        or      ecx, edi                                ; 0845 _ 09. F9
        mov     byte [ebx+12H], cl                      ; 0847 _ 88. 4B, 12
?_079:  test    esi, 2H                                 ; 084A _ F7. C6, 00000002
        jz      ?_080                                   ; 0850 _ 74, 13
        mov     al, byte [ebx+5H]                       ; 0852 _ 8A. 43, 05
        and     eax, 0CH                                ; 0855 _ 83. E0, 0C
        cmp     al, 1                                   ; 0858 _ 3C, 01
        sbb     eax, eax                                ; 085A _ 19. C0
        and     eax, 0FFFFFFFEH                         ; 085C _ 83. E0, FE
        add     eax, 4                                  ; 085F _ 83. C0, 04
        add     byte [ebx+4H], al                       ; 0862 _ 00. 43, 04
?_080:  test    esi, 4H                                 ; 0865 _ F7. C6, 00000004
        jz      ?_081                                   ; 086B _ 74, 03
        inc     byte [ebx+4H]                           ; 086D _ FE. 43, 04
?_081:  test    esi, 8H                                 ; 0870 _ F7. C6, 00000008
        jz      ?_083                                   ; 0876 _ 74, 1F
        mov     dl, byte [ebx+5H]                       ; 0878 _ 8A. 53, 05
        mov     eax, 2                                  ; 087B _ B8, 00000002
        and     dl, 30H                                 ; 0880 _ 80. E2, 30
        jz      ?_082                                   ; 0883 _ 74, 0F
        xor     eax, eax                                ; 0885 _ 31. C0
        cmp     dl, 16                                  ; 0887 _ 80. FA, 10
        setne   al                                      ; 088A _ 0F 95. C0
        lea     eax, [eax*4+4H]                         ; 088D _ 8D. 04 85, 00000004
?_082:  add     byte [ebx+4H], al                       ; 0894 _ 00. 43, 04
?_083:  test    esi, 10H                                ; 0897 _ F7. C6, 00000010
        jz      ?_085                                   ; 089D _ 74, 1F
        mov     dl, byte [ebx+5H]                       ; 089F _ 8A. 53, 05
        mov     eax, 2                                  ; 08A2 _ B8, 00000002
        and     dl, 0CH                                 ; 08A7 _ 80. E2, 0C
        jz      ?_084                                   ; 08AA _ 74, 0F
        xor     eax, eax                                ; 08AC _ 31. C0
        cmp     dl, 4                                   ; 08AE _ 80. FA, 04
        setne   al                                      ; 08B1 _ 0F 95. C0
        lea     eax, [eax*4+4H]                         ; 08B4 _ 8D. 04 85, 00000004
?_084:  add     byte [ebx+4H], al                       ; 08BB _ 00. 43, 04
?_085:  test    esi, 20H                                ; 08BE _ F7. C6, 00000020
        jz      ?_086                                   ; 08C4 _ 74, 04
        add     byte [ebx+4H], 2                        ; 08C6 _ 80. 43, 04, 02
?_086:  test    esi, 40H                                ; 08CA _ F7. C6, 00000040
        jz      ?_087                                   ; 08D0 _ 74, 04
        add     byte [ebx+4H], 4                        ; 08D2 _ 80. 43, 04, 04
?_087:  and     esi, 80H                                ; 08D6 _ 81. E6, 00000080
        jz      ?_089                                   ; 08DC _ 74, 26
        mov     dl, byte [ebx+5H]                       ; 08DE _ 8A. 53, 05
        mov     eax, 2                                  ; 08E1 _ B8, 00000002
        and     dl, 0CH                                 ; 08E6 _ 80. E2, 0C
        jz      ?_088                                   ; 08E9 _ 74, 0F
        xor     eax, eax                                ; 08EB _ 31. C0
        cmp     dl, 4                                   ; 08ED _ 80. FA, 04
        setne   al                                      ; 08F0 _ 0F 95. C0
        lea     eax, [eax*4+4H]                         ; 08F3 _ 8D. 04 85, 00000004
?_088:  mov     dl, byte [ebx+4H]                       ; 08FA _ 8A. 53, 04
        lea     eax, [edx+eax+2H]                       ; 08FD _ 8D. 44 02, 02
        mov     byte [ebx+4H], al                       ; 0901 _ 88. 43, 04
?_089:  movzx   eax, byte [ebx+4H]                      ; 0904 _ 0F B6. 43, 04
        jmp     ?_097                                   ; 0908 _ EB, 5C

?_090:  cmp     cl, 2                                   ; 090A _ 80. F9, 02
        jne     ?_079                                   ; 090D _ 0F 85, FFFFFF37
        jmp     ?_078                                   ; 0913 _ E9, FFFFFF13

?_091:  test    byte [ebx+13H], 01H                     ; 0918 _ F6. 43, 13, 01
        jz      ?_092                                   ; 091C _ 74, 0C
        movzx   edx, byte [ebx+9H]                      ; 091E _ 0F B6. 53, 09
        shl     edx, 3                                  ; 0922 _ C1. E2, 03
        and     edx, 08H                                ; 0925 _ 83. E2, 08
        jmp     ?_094                                   ; 0928 _ EB, 1B

?_092:  mov     dl, byte [ebx+14H]                      ; 092A _ 8A. 53, 14
        test    dl, 01H                                 ; 092D _ F6. C2, 01
        jnz     ?_093                                   ; 0930 _ 75, 09
        and     dl, 02H                                 ; 0932 _ 80. E2, 02
        je      ?_075                                   ; 0935 _ 0F 84, FFFFFEB7
?_093:  test    byte [ebx+0DH], 20H                     ; 093B _ F6. 43, 0D, 20
        sete    dl                                      ; 093F _ 0F 94. C2
        shl     edx, 3                                  ; 0942 _ C1. E2, 03
?_094:  or      edi, edx                                ; 0945 _ 09. D7
        jmp     ?_075                                   ; 0947 _ E9, FFFFFEA6

?_095:  test    cl, cl                                  ; 094C _ 84. C9
        je      ?_079                                   ; 094E _ 0F 84, FFFFFEF6
        jmp     ?_078                                   ; 0954 _ E9, FFFFFED2

?_096:  cmp     al, 4                                   ; 0959 _ 3C, 04
        je      ?_073                                   ; 095B _ 0F 84, FFFFFE22
        jmp     ?_078                                   ; 0961 _ E9, FFFFFEC5

?_097:
        add     esp, 332                                ; 0966 _ 81. C4, 0000014C
        pop     ebx                                     ; 096C _ 5B
        pop     esi                                     ; 096D _ 5E
        pop     edi                                     ; 096E _ 5F
        pop     ebp                                     ; 096F _ 5D
        ret                                             ; 0970 _ C3

?_098:                                                  ; byte
        db 00H, 00H, 00H, 00H, 66H, 00H, 00H, 00H       ; 0000 _ ....f...
        db 0F3H, 00H, 00H, 00H, 0F2H, 00H, 00H, 00H     ; 0008 _ ........

?_099:                                                  ; byte
        db 41H, 14H, 12H, 20H, 41H, 14H, 12H, 20H       ; 0010 _ A.. A.. 
        db 41H, 14H, 12H, 20H, 41H, 14H, 12H, 20H       ; 0018 _ A.. A.. 
        db 41H, 14H, 12H, 20H, 41H, 14H, 12H, 20H       ; 0020 _ A.. A.. 
        db 41H, 14H, 12H, 20H, 41H, 14H, 12H, 0A4H      ; 0028 _ A.. A...
        db 00H, 21H, 40H, 12H, 13H, 14H, 15H, 40H       ; 0030 _ .!@....@
        db 90H, 04H, 15H, 13H, 25H, 8CH, 01H, 98H       ; 0038 _ ....%...
        db 00H, 14H, 12H, 60H, 88H, 04H, 88H, 00H       ; 0040 _ ...`....
        db 25H, 20H, 21H, 15H, 13H, 14H, 40H, 14H       ; 0048 _ % !...@.
        db 20H, 41H, 24H, 20H, 88H, 01H, 88H, 04H       ; 0050 _  A$ ....
        db 22H, 10H, 14H, 8AH, 00H, 21H, 60H, 61H       ; 0058 _ "....!`a
        db 89H, 00H, 11H, 10H, 15H, 94H, 01H, 40H       ; 0060 _ .......@
        db 88H, 01H, 90H, 00H, 0ACH, 01H, 20H, 21H      ; 0068 _ ...... !
        db 45H, 31H, 10H, 21H, 20H, 41H, 90H, 02H       ; 0070 _ E1.! A..
        db 90H, 01H, 30H, 11H, 15H, 11H, 50H, 11H       ; 0078 _ ..0...P.
        db 15H, 8DH, 01H, 15H, 71H, 15H, 11H, 35H       ; 0080 _ ....q..5
        db 11H, 88H, 00H, 0C1H, 01H, 20H, 15H, 71H      ; 0088 _ ..... .q
        db 10H, 31H, 10H, 61H, 20H, 9AH, 01H, 30H       ; 0090 _ .1.a ..0
        db 31H, 90H, 00H, 31H, 9DH, 00H, 21H, 60H       ; 0098 _ 1..1..!`
        db 31H, 89H, 00H, 11H, 10H, 11H, 10H, 41H       ; 00A0 _ 1......A
        db 20H, 8AH, 01H, 60H, 8AH, 01H, 60H, 8AH       ; 00A8 _  ..`..`.
        db 01H, 9BH, 00H, 51H, 90H, 00H, 41H, 10H       ; 00B0 _ ...Q..A.
        db 31H, 88H, 00H, 35H, 10H, 35H, 10H, 88H       ; 00B8 _ 1..5.5..
        db 05H, 40H, 65H, 30H, 15H, 20H, 35H, 95H       ; 00C0 _ .@e0. 5.
        db 00H, 25H, 60H, 35H, 10H, 15H, 10H, 15H       ; 00C8 _ .%`5....
        db 30H, 31H, 8FH, 00H, 41H, 45H, 40H, 88H       ; 00D0 _ 01..AE@.
        db 01H, 88H, 00H, 88H, 01H, 0DFH, 00H, 15H      ; 00D8 _ ........
        db 90H, 00H, 15H, 0FFH, 00H, 95H, 00H, 31H      ; 00E0 _ .......1
        db 60H, 21H, 50H, 31H, 60H, 21H, 20H, 21H       ; 00E8 _ `!P1`! !
        db 20H, 11H, 8FH, 00H, 11H, 89H, 00H, 45H       ; 00F0 _  ......E
        db 88H, 00H, 45H, 9CH, 00H, 45H, 91H, 00H       ; 00F8 _ ..E..E..
        db 21H, 8FH, 00H, 11H, 0EDH, 00H, 41H, 8CH      ; 0100 _ !.....A.
        db 00H, 8CH, 01H, 0A5H, 00H, 31H, 20H, 21H      ; 0108 _ .....1 !
        db 30H, 11H, 50H, 31H, 20H, 21H, 30H, 11H       ; 0110 _ 0.P1 !0.
        db 50H, 31H, 0ACH, 00H, 11H, 10H, 11H, 0FFH     ; 0118 _ P1......
        db 00H, 0EEH, 00H                               ; 0120 _ ...
