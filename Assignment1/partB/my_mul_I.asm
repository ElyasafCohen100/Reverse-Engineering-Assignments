;====================
; Name:Elyasaf Cohen
; Targil I seif B I
;====================

; ================== my_mul_I_**cdecl** ================== ;;

;int __cdecl my_mul(int a, int b){
;  return a*b;
;}

;cdcl => the caller is clean the stack => add esp,x

include 'include\win32a.inc'

format PE console
entry start

;======================================
section '.data' data readable writeable
;======================================
a	dd 3 ;dd -> dfine dword -> int(32bit)
b	dd 5
printf_format  db "%d", 0

;=======================================
section '.text' code readable executable
;=======================================

start:
;entet the "func name" to the stack
	push	dword [b] ;b -> address, dword[b] -> value
	push	dword [a] ;dword -> double word -> take 4 bytes -> int!
	call 	my_mul
	add		esp,8  ; cdecl
	
;===================================================
; the mul func => should use with stack:
; |     ebp      | ebp+0
; |return address| ebp+4
; |      a       | ebp+8
; |      b       | ebp+12
; or by looking the stack like upside down bottle...
;===================================================	
	
;==== print the result(printf) ====;

	push	eax ;the mul result
	push	printf_format
	call 	[printf]
	add		esp,8
	
	push	0
	call	[ExitProcess]

my_mul:
;opening:
	push	ebp
	mov 	ebp,esp ;ebp = esp for starting the jurney	
;func_body:	
	mov 	eax, [ebp+8]  ;a
	imul	eax, [ebp+12] ;b => eax = eax * b => (a*b)
;close:
	pop		ebp
	ret
	
	
section '.idata' import data readable writeable

library msvcrt, 'msvcrt.dll',\
        kernel32, 'kernel32.dll'

import msvcrt,\
       printf, 'printf'
	   
import kernel32,\
       ExitProcess, 'ExitProcess'
