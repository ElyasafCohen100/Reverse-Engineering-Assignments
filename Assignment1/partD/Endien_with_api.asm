;==================== ;
; Name:Elyasaf Cohen  ;
; ID: 311557227		  ;
; Targil I seif D	  ;
;==================== ;

; ========================= Endien_with_api ========================= ;

include 'include\win32a.inc'

format PE console
entry start

include 'training.inc'

FILE_SHARE_READ = 1
INPUT_SIZE_LIMIT = 100h
;==========================================================
section '.data' data readable writeable
;==========================================================
file_name		db 'input.txt' ,0
bytes_read		dd 0 ;how mach bytes was reading
buffer_for_read db 100h dup (0) ; 256 characters

reg_error db 'registry error',13,10,0
error_msg 	 	db 'the file handle is invalid' ,13 ,10 ,0

hKey 			dd 0
registry_path	db 'Software\\Assembly' ,0

value_name 		db 'input',0
value      		dd 0
value_type 		dd 0
value_size 		dd 4

;==========================================================
section '.text' code readable executable
;==========================================================

;========== part I ==========;
start:
	call 	read_hex  ;read hex number → result in eax
	bswap 	eax 	  ;endian conversion
	call 	print_eax ;print result

;========== part II ==========;
	
;CreateFileA(filename,access,share,security,creation,flags,template);
;(open the file and give me a handle) the handle will be in eax
	push 	0			 	;template
	push	0			 	;flags
	push	OPEN_EXISTING	;creation (we want to open the file)
	push	0			 	;security
	push 	FILE_SHARE_READ ;share
	push	GENERIC_READ 	;access (we want to read)
	push	file_name	 	;filename	
	call 	[CreateFileA]	;the func itself
	
;input validation
	cmp 	eax, INVALID_HANDLE_VALUE ;handle = -1 means error
	je		file_error
	mov		ebx,eax		 ;save the handle in ebx cause eax is gonna change
	jmp 	continue_execution
	
	
file_error:
;printf(str):
	push 	error_msg
	call	[printf]
	add		esp, 4

	push	0
	call	[ExitProcess]

continue_execution:
;ReadFile(ebx, buffer_for_read, INPUT_SIZE_LIMIT, &bytes_read, NULL)
	push	0
	push 	bytes_read
	push	INPUT_SIZE_LIMIT  
	push	buffer_for_read
	push	ebx
	call	[ReadFile];stdcall
	
;input validation
	cmp eax, 0
	je part3_start
	
	cmp dword [bytes_read], 0
	je part3_start
	
;add 0 to the str's end	
	mov ecx, [bytes_read]
	cmp ecx, INPUT_SIZE_LIMIT
	jae skip_null
	mov byte [buffer_for_read + ecx], 0

skip_null:
;casting the str in "buffer_for_read" ("7856AB12") to hex number 0x7856AB12
;long strtol(const char *str, char **endptr, int base);
	push	16				;the base
	push	0				;ptr to where we stop to read(NULL)
	push	buffer_for_read ;the str to cast "7856AB12"
	call	[strtol]
	add		esp,12 ;cdecl

	bswap 	eax
	call 	print_eax
	
;close the file
	push 	ebx
	call 	[CloseHandle]
	
part3_start:
;========== part III ==========;
;HKCU\Software\Assembly
;RegOpenKeyEx(HKEY, "path", 0, access, &handle)
	
	push 	hKey               ; &handle
	push 	KEY_READ           ; access
	push 	0                  ; reserved
	push 	registry_path      ; "Software\\Assembly"
	push 	HKEY_CURRENT_USER  ; root
	call 	[RegOpenKeyEx]	   ;stdcall
	
;input validation
	cmp     eax, 0
	jne     reg_error_label
	
;take the input value
;RegQueryValueEx(hKey, "input", 0, &type, &data, &size)

	push    value_size
	push    value
	push    value_type
	push    0
	push    value_name
	mov     eax, [hKey]
	push    eax 
	call    [RegQueryValueEx]
	
;input validation
	cmp     eax, 0
	jne     reg_error_label
	
	mov     eax, [value] ;move value to eax
	bswap   eax ;endian conversion
	call    print_eax ;print result
	
;close registry key
	mov     eax, [hKey]
	push    eax   
	call    [RegCloseKey]
	jmp end_program
	
	
reg_error_label:
    push reg_error
    call [printf]
    add esp, 4


end_program:
    push 0
    call [ExitProcess]


section '.idata' import data readable

library kernel32, 'kernel32.dll',\
		msvcrt, 'msvcrt.dll'
		
import 	kernel32,\
		ExitProcess, 'ExitProcess',\
		GetStdHandle, 'GetStdHandle',\
		ReadFile, 'ReadFile',\
		CreateFileA, 'CreateFileA',\
		CloseHandle, 'CloseHandle',\
		RegOpenKeyEx, 'RegOpenKeyExA',\
		RegQueryValueEx, 'RegQueryValueExA',\
		RegCloseKey, 'RegCloseKey'
		
import 	msvcrt,\
		printf, 'printf',\
		strlen, 'strlen',\
		strtol, 'strtol',\
		strtoul, 'strtoul'
		