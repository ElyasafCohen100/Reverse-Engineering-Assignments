;====================
; Name:Elyasaf Cohen
; ID: 311557227
; Targil I seif B IV
;====================

; ================== void_my_mul ================== ;;

;void my_mul(int a, int b, int* result){
; *result = a*b;
; print (*result);
;}

include 'include\win32a.inc'

format PE console
entry start

;======================================
section '.data' data readable writeable
;======================================
a	dd 3
b	dd 5
result	dd 0
printf_format 	db "%d", 0

;=======================================
section '.text' code readable executable
;=======================================

start:
	push	result
	push	dword [b]
	push	dword [a]
	call	my_mul
	add		esp,12
	
;===================================================
; the mul func => should use with stack:

; |     ebp      | ebp+0
; |return address| ebp+4
; |      a       | ebp+8
; |      b       | ebp+12
; |    result    | ebp+16
; or by looking the stack like upside down bottle...
;===================================================	

	
;==== print the result(printf) ==== ;
	push	dword [result]
	push	printf_format
	call	[printf]
	add		esp,8 ;cdecl from msvcrt.dll
	
	push	0
	call	[ExitProcess]
	
;===== my_mul_func ===== ;
my_mul:
;opening:
	push	ebp
	mov		ebp,esp
;func_body:
	mov		eax, [ebp+8]  ;a
	imul	eax, [ebp+12] ;b => eax = eax * b => (a*b)
	mov		ebx, [ebp+16] ;"result"'s address
	mov		[ebx], eax 	  ;*result = eax(a*b)
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