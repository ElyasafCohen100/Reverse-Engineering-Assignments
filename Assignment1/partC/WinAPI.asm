;==================== ;
; Name:Elyasaf Cohen  ;
; Targil I seif C	  ;
;==================== ;

; ============================= WinApi ============================= ;

; Program receives a string from console, 
; calculates length and prints message to console
; Implementing syscalls GetStdHandle, ReadFile, printf
; Author - Barak Gonen

include 'include\win32a.inc'

format PE console
entry start

INPUT_SIZE_LIMIT = 100h

;==================================================================
section '.data' data readable writeable
;==================================================================
    prompt_string	db	'Please enter text', 13, 10, 0
	bytes_read		dd	?
	user_string		db	INPUT_SIZE_LIMIT dup (?), 0 ;buffer
	result_string   db 'User entered: %s',13,10,'Length: %d',13,10,0
	
;==================================================================
section '.text' code readable executable
;==================================================================

start:
	; Show prompt message
	push	prompt_string
	call	[printf]
	add		esp,4 ;cdecl
	
	; Get console input handle - returned in EAX
	push 	STD_INPUT_HANDLE	; from win32a.inc, default is console
	call	[GetStdHandle]
	
	; ===== Read from the device pointed by EAX ===== ;
	;ReadFile(handle, buffer, size, &bytes_read, NULL);	
	push	0
	push	bytes_read ;addres
	push 	INPUT_SIZE_LIMIT
	push	user_string
	push	eax
	call	[ReadFile]
	;stdcall
	
	;=======================================================
	;the call [ReadFile] read the "Enter(↵) which mean \r\n" 
	;and the strlen will read this too so we need to fix it
	;=======================================================
	
	; ==== clean the "\r\n" before the "strlen func" ==== ;
	mov eax, [bytes_read] 	;how mach characters was getting
	cmp eax, 0
	je skip_trim
	
	dec eax 	;point to the last char ("\n") 
	mov byte [user_string + eax], 0 ;change the '\n' to 0 
	
	dec eax     ;point to the "last char -1" ('\r') 
	cmp eax, 0
	jl skip_trim ;check you're not coming to a negativ index
	mov byte [user_string + eax], 0 ;change the '\r' to 0
	
	
	skip_trim:
	; ===== Get string length, pointed by EAX ===== ;
	;strlen(char* str)	
	push	user_string ;address
	call	[strlen]
	add		esp,4 ;cdecl
	
	; ===== print string to console ===== ;
	;printf(format, str, number) 
	push 	eax			;the str's lendth value from "strlen"
	push	user_string ;the str (user prompt itself) 
	push 	result_string
	call	[printf]
	add 	esp,12 ;cdecl

	push	0
	call	[ExitProcess]



section '.idata' import data readable

library kernel32, 'kernel32.dll',\
		msvcrt, 'msvcrt.dll'
		
import	kernel32,\
		ExitProcess, 'ExitProcess',\
		GetStdHandle, 'GetStdHandle',\
		ReadFile, 'ReadFile'
		
import	msvcrt,\
		printf, 'printf',\
		strlen, 'strlen'
		

