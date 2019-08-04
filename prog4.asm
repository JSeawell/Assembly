; Program 4: Procedural Composites     (prog4.asm)

; Author: Jake Seawell
; Last Modified: 5/11419
; OSU email address: seawellj@oregonstate.edu
; Course number/section: CS271-400
; Project Number: 4                Due Date: 5/12/19
; Description: Procedural Composites prompts the user
; for a number of composites to display, then calculates
; and displays all the composites up to and including
; the nth composite. Composites will be displayed 10
; per line, with 5 spaces between each.

; Note: This program is implemented using procedures.
; Variables are global - no parameter passing.

INCLUDE Irvine32.inc

.data

; Constant (BYTE/string) definitions

	intro_1 BYTE "Welcome to program #4: Procedural Composites! My name is Jake Seawell", 0

	inst_1 BYTE "You tell me how many composite numbers you would like, and I will calculate and display them (10 per line).", 0
	inst_2 BYTE "How many composites would you like to see? ", 0

	prompt_1 BYTE "Enter an integer in the range from 1 --> ", 0
	upper_limit DWORD 400

	error_1 BYTE "Uh oh. The number must be an integer within the required range", 0

	output_quant1 BYTE "The first ", 0
	output_quant2 BYTE " composite numbers are:", 0

	output_space BYTE "     ", 0

	outro_1 BYTE "Have a great day! Farewell :)", 0

; Variable (DWORD/?) Definitions

	user_quantity DWORD 0            ; composite quantity from user
	composite DWORD 4                ; composite (starts at 4)
	divisor DWORD 2                  ; divisor (starts at 2)
	found DWORD 0
	display_count DWORD 0

.code
main PROC
	
	call intro
	call getData
	call calculate
	call outro

; exit to operating system
	exit
main ENDP

; INTRODUCTION
	intro PROC

		; INTRO & GREETING
		call CrLf
		mov edx, OFFSET intro_1
		call WriteString
		call CrLf

		; DISPLAY INSTRUCTIONS
		call CrLf
		mov edx, OFFSET inst_1
		call WriteString
		call CrLf
		mov edx, OFFSET inst_2
		call WriteString
		call CrLf

		ret
	intro ENDP


; GET QUANTITY
	getData PROC

		; DATA PROMPT
		mov edx, OFFSET prompt_1
		call WriteString
		mov eax, upper_limit
		call WriteDec
		call CrLf

		; GET NUMBER
		call ReadInt
	
		; VALIDATE NUMBER
		call validate

		ret
	getData ENDP

; input validation
	validate PROC

		START:
		cmp eax, 1
		jge VALID_ONCE
		mov edx, OFFSET error_1
		call WriteString
		call CrLf
		jmp INVALID

		INVALID:
		; REPROMPT FOR NEW DATA
			mov edx, OFFSET prompt_1
			call WriteString
			mov eax, upper_limit
			call WriteDec
			call CrLf

		; GET NEW NUMBER
			call ReadInt
			jmp START

		; Number is >=1
		VALID_ONCE:
			cmp eax, upper_limit
			jle VALID
			mov edx, OFFSET error_1
			call WriteString
			call CrLf
			jmp INVALID

		; Number is valid
		VALID:
		mov user_quantity, eax

		ret
	validate ENDP
	
	
; CALCULATE COMPOSITES USING SUB-ROUTINE (ISCOMPOSITE)
	calculate PROC
		
		call showResults 
		
		mov ecx, user_quantity
		
		composite_loop:

			call isComposite
			cmp found, 0
			je prime_found
			jmp comp_found
			prime_found:
				inc ecx
			comp_found:
		
		loop composite_loop

		ret
	calculate ENDP	

; FIND COMPOSITES AND PRINT
	isComposite PROC

		mov found, 0
		
		START:
			mov edx, 0
			mov eax, composite
			mov ebx, divisor
			cmp eax, ebx
			jle BREAK
			div ebx
		
			cmp edx, 0
			jne INCREMENT
			inc found
			jmp SHOW_RESULTS

		INCREMENT:
			inc divisor
			jmp START

		SHOW_RESULTS:
			mov eax, composite
			call WriteDec
			inc display_count
			cmp display_count, 10
			jl SPACE
			jmp NEWLINE
			SPACE:
				mov edx, OFFSET output_space
				call WriteString
				jmp ENDDISPLAY
			NEWLINE:
				call CrLf
				mov display_count, 0
			ENDDISPLAY:

		BREAK:
			inc composite
			mov divisor, 2

		ret
	isComposite ENDP

; SHOW COMPOSITES
	showResults PROC
		
		; SHOW QUANTITY CHOSEN
		call CrLf
		mov edx, OFFSET output_quant1
		call WriteString
		mov eax, user_quantity
		call WriteDec
		mov edx, OFFSET output_quant2
		call WriteString
		call CrLf
		call CrLf

		ret
	showResults ENDP
	
	
; GOODBYE & EXIT
	outro PROC

		; GOODBYE AND EXIT
		call CrLf
		call CrLf
		mov edx, OFFSET outro_1
		call WriteString
		call CrLf
		
		ret
	outro ENDP

END main
