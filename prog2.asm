; Program 2: Fibonacci     (prog2.asm)

; Author: Jake Seawell
; Last Modified: 4/16/19
; OSU email address: seawellj@oregonstate.edu
; Course number/section: CS271-400
; Project Number: 2                Due Date: 4/21/19
; Description: Fibonacci prompts the user for an
; integer between 1 & 46, and displays that # of
; fibonacci numbers to the screen

INCLUDE Irvine32.inc

.data

; Constant (BYTE/string) definitions

	upper_limit DWORD 46
	max_str_len DWORD 19

	intro_1 BYTE "Welcome to program #2: Fibonacci!", 0
	intro_2 BYTE "What is your name?", 0
	intro_3 BYTE "Hello, ", 0
	intro_4 BYTE ", my name is Jake Seawell ", 0

	inst_1 BYTE "Enter a positive numbers in the range of [1...", 0
	inst_2 BYTE "] and I will give you that number of fibonacci numbers", 0

	prompt_1 BYTE "Enter a number (1...", 0
	prompt_2 BYTE "): ", 0

	error_1 BYTE "The number must be in the range [1...",0
	error_2 BYTE "]", 0

	output_fib BYTE "Fibonacci Numbers: ", 0

	output_spaces BYTE "     ", 0

	outro_1 BYTE "Have a great day, ", 0
	outro_2 BYTE ". Farewell :)", 0

; Variable (DWORD/?) Definitions

	user_name db 20 DUP(0)      ; name from user
	intNum DWORD ?              ; number from user

	fibNum DWORD ?
	one DWORD 1
	two DWORD 0
	term_count DWORD 0

.code
main PROC

; Introduction: Display the intro message,
; get the user's name, and greet him/her by name

	call CrLf
	mov edx, OFFSET intro_1
	call WriteString
	call CrLf
	mov edx, OFFSET intro_2
	call WriteString
	call CrLf

	;read string "user_name" from user
	mov edx, OFFSET user_name
	mov ecx, max_str_len
	call ReadString


	mov edx, OFFSET intro_3
	call WriteString

	mov edx, OFFSET user_name
	call WriteString

	mov edx, OFFSET intro_4
	call WriteString
	call CrLf


; user instructions on what the program does

	call CrLf
	mov edx, OFFSET inst_1
	call WriteString
	mov eax, 0
	mov eax, upper_limit
	call WriteDec
	mov edx, OFFSET inst_2
	call WriteString
	call CrLf
	call CrLf


; Get data (number) from user, then validate
; to make sure it is greater than 0, and less
; than the upper limit (defined above)

	INPUT_LOOP:
		mov edx, OFFSET prompt_1
		call WriteString
		mov eax, 0
		mov eax, upper_limit
		call WriteDec
		mov edx, OFFSET prompt_2
		call WriteString
		call ReadInt
		cmp eax, upper_limit
		jle VALID_ONCE
		jmp INVALID

	; invalid number, display error and re-prompt
	INVALID:
		mov edx, OFFSET error_1
		call WriteString
		mov eax, 0
		mov eax, upper_limit
		call WriteDec
		mov edx, OFFSET error_2
		call WriteString
		call CrLf
		jmp INPUT_LOOP

	; number is less that 46, otherwise jump to invalid
	VALID_ONCE:
		cmp eax, 1
		jge VALID
		jmp INVALID

	; number is >= 1 and <= 46
	VALID:
		mov intNum, eax
		call CrLf


; Display fib #s to the console, with 5 per line

	; print label to console
	mov edx, OFFSET output_fib
	call WriteString
	call CrLf

	; make user's num into loop counter
	mov ecx, intNum

	; loop through fib numbers and print to screen
	fib_loop:
		mov eax, one
		mov ebx, two
		add eax, ebx
		mov fibNum, eax

	; if term is not 5, increment it, otherwise set it to 1
		cmp term_count, 5
		jne INCREMENT
		mov term_count, 1
		jmp SET_TO_ONE
	INCREMENT:
		inc term_count
	SET_TO_ONE:

	; print number
		mov eax, fibNum
		call WriteDec

	; update previous two numbers
		mov one, ebx
		mov two, eax

	; print 5 spaces between numbers
		mov edx, OFFSET output_spaces
		call WriteString

	; 5 #'s per line
		cmp term_count, 5
		jne CONTINUE
		call CrLf

	CONTINUE:
		loop fib_loop


; farewell and exit
	call CrLf
	call CrLf
	mov edx, OFFSET outro_1
	call WriteString

	mov edx, OFFSET user_name
	call WriteString

	mov edx, OFFSET outro_2
	call WriteString
	call CrLf

	exit	; exit to operating system
main ENDP

END main
