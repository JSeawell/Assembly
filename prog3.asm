; Program 3: Negative Average     (prog3.asm)

; Author: Jake Seawell
; Last Modified: 4/30/19
; OSU email address: seawellj@oregonstate.edu
; Course number/section: CS271-400
; Project Number: 3                Due Date: 5/5/19
; Description: Negative Average prompts the user for
; negative integers between -100 & -1 until a positive
; number is entered, then displays that # of integers,
; the sum of those integers, and the average of those
; integers.

; I also did the extra credit and #'d my input lines

INCLUDE Irvine32.inc

.data

; Constant (BYTE/string) definitions

	max_str_len DWORD 19

	intro_1 BYTE "Welcome to program #3: Negative Average!", 0
	intro_2 BYTE "What is your name?", 0
	intro_3 BYTE "Hello, ", 0
	intro_4 BYTE ", my name is Jake Seawell ", 0

	inst_1 BYTE "Enter a series of negative integers in the range of ", 0
	inst_2 BYTE " --> ", 0
	inst_3 BYTE "As soon as a non-negative # is entered, I will give you the sum and average of your negative entries", 0

	prompt_1 BYTE ": Enter a negative integer from ", 0
	prompt_2 BYTE " --> -1", 0

	error_1 BYTE "The number must be an integer within the required range", 0
	error_2 BYTE "You didn't enter any negative integers.", 0

	output_quant1 BYTE "You entered ", 0
	output_quant2 BYTE " negative numbers", 0

	output_sum BYTE "The sum of those numbers is: ", 0
	output_avg BYTE "The rounded average of those numbers is: ", 0

	ec BYTE "BTW, I numbered my user input lines for extra credit ;)", 0

	outro_1 BYTE "Have a great day, ", 0
	outro_2 BYTE ". Farewell :)", 0

; Variable (DWORD/?) Definitions

	user_name db 20 DUP(0)      ; name from user
	user_num DWORD 0            ; number from user

	upper_limit DWORD -1
	lower_limit DWORD -100

	sum DWORD 0
	avg DWORD 1
	remainder DWORD 0
	count DWORD 0

.code
main PROC

; Introduction: Display the intro message

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


; user instructions

	call CrLf
	mov edx, OFFSET inst_1
	call WriteString
	mov eax, lower_limit
	call WriteInt
	mov edx, OFFSET inst_2
	call WriteString
	mov eax, upper_limit
	call WriteInt
	call CrLf
	mov edx, OFFSET inst_3
	call WriteString
	call CrLf
	call CrLf


; Get data (number) from user, validate input so that user will be
; reprompted until their input is in the correct range

	INPUT_LOOP:
		mov eax, count
		inc eax
		call WriteDec
		mov edx, OFFSET prompt_1
		call WriteString
		mov eax, lower_limit
		call WriteInt
		mov edx, OFFSET prompt_2
		call WriteString
		call CrLf

; if number is negative, jmp to valid_once,
; otherwise end program
		call ReadInt
		js VALID_ONCE
		jmp DONE

; invalid number, display error and re-prompt
	INVALID:
		mov edx, OFFSET error_1
		call WriteString
		call CrLf
		jmp INPUT_LOOP

; number is greater than upper limit, otherwise jump to invalid
	VALID_ONCE:
		cmp eax, lower_limit
		jge VALID
		jmp INVALID

; number is in valid range
	VALID:
		mov user_num, eax
		mov eax, sum
		mov ebx, user_num
		add eax, ebx
		mov sum, eax
		inc count
		call CrLf
		loop INPUT_LOOP

; end of program
	DONE:
		cmp count, 1
		jge CALCULATE
		mov edx, OFFSET error_2
		call WriteString
		jmp EXIT_PROG

; Calculate avg
	CALCULATE:
		mov eax, sum
		mov ebx, count
		mov edx, 0
		cdq
		idiv ebx
		mov avg, eax
		mov remainder, edx

;rounding average up or down
	mov eax, remainder
	imul eax, 10
	mov ebx, count
	cdq
	idiv ebx
	neg eax
	cmp eax, 6
	jge ROUND_UP
	jmp ROUNDED

	ROUND_UP:
		dec avg
	ROUNDED:

; Display sum and avg
	call CrLf
	mov edx, OFFSET output_quant1
	call WriteString
	mov eax, count
	call WriteDec
	mov edx, OFFSET output_quant2
	call WriteString
	call CrLf
	call CrLf

	mov edx, OFFSET output_sum
	call WriteString
	mov eax, sum
	call WriteInt
	call CrLf

	mov edx, OFFSET output_avg
	call WriteString
	mov eax, avg
	call WriteInt
	call CrLf

; display farewell and exit
	EXIT_PROG:
		call CrLf
		call CrLf

		mov edx, OFFSET ec
		call WriteString
		call CrLf
		call CrLf

		mov edx, OFFSET outro_1
		call WriteString

		mov edx, OFFSET user_name
		call WriteString

		mov edx, OFFSET outro_2
		call WriteString
		call CrLf

; exit to operating system
	exit
main ENDP

END main
