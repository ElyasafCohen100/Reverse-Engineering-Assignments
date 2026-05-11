;====================
; Name:Elyasaf Cohen
; ID: 311557227
; Targil I seif B III
;====================

; ================== my_mul_III_**fastcall** ================== ;;

;int __fastcall my_mul(int a, int b){
;  return a*b;
;}

;fastcall => first arguments go in registers (ECX, EDX) for speed,
			;remaining ones go on the stack

include 'include\win32a.inc'

format PE console
entry start

;======================================
section '.data' data readable writeable
;======================================
a	dd 3
b	dd 5
printf_format 	db "%d", 0

;=======================================
section '.text' code readable executable
;=======================================

start:
	mov		ecx,[a]
	mov		edx,[b]
	call 	my_mul
		
;==== print the result(printf) ====;
	push	eax ;the mul result
	push	printf_format
	call 	[printf]
	add		esp,8 ;cdecl from msvcrt.dll
	
	push	0
	call	[ExitProcess]

my_mul:	
	mov 	eax, ecx ;a
	imul	eax, edx ;b => eax = eax * b => (a*b)
	ret
	
	
section '.idata' import data readable writeable

library msvcrt, 'msvcrt.dll',\
        kernel32, 'kernel32.dll'

import msvcrt,\
       printf, 'printf'
	   
import kernel32,\
       ExitProcess, 'ExitProcess'