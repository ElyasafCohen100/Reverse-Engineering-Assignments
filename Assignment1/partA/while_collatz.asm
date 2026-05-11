;====================
; Name:Elyasaf Cohen
; ID: 311557227
; Targil I seif A
;====================

include 'include\win32a.inc'

format PE console
entry start

;======================================
section '.data' data readable writeable
;======================================
n                dd 0
prompt           db "Please enter a number:",10,0
input_format     db "%d",0
output_format    db "%d",0

;======================================
section '.text' code readable executable
;======================================

;===========================
;  ecx=i, eax=n, ebx=tmp  ;
;===========================

start:
; ==== input from user (the "cin" part in CPP) ==== ;
    push    prompt
    call    [printf]
    add     esp,4

; ==== input from user (scanf func): ==== ;
    push    n
    push    input_format
    call    [scanf]
    add     esp, 8

    mov     ecx, 0      ;initialize ecx (i)
    mov     eax,[n]

; ====== the code itself ====== ;
while_loop:
    cmp     eax ,1
    je      finish

    mov     ebx,eax
    and     ebx,1       ;mod
    cmp     ebx,0       ;if(n%2==0)
    je      if_even
    jmp     if_odd

if_even:
    shr     eax,1       ;n=n/2
    inc     ecx         ;i++
    jmp     while_loop  ;return to while

if_odd:
    mov     ebx,eax
    imul    ebx,3       ;n*3
    inc     ebx         ;ans+1
    mov     eax,ebx     ;n=ans+1
    inc     ecx         ;i++
    jmp     while_loop  ;return to while

; the print func => should use with stack:
; | format |
; |   i    |

finish:
    push    ecx            ;the value is first
    push    output_format  ;the hex format string from printf "%x"
    call    [printf]       ;then the call func
    add     esp,8          ;clean the stack

    push    0
    call    [ExitProcess]


section '.idata' import data readable writeable

library msvcrt, 'msvcrt.dll',\
        kernel32, 'kernel32.dll'

import msvcrt,\
       scanf, 'scanf',\
       printf, 'printf'

import kernel32,\
       ExitProcess, 'ExitProcess'