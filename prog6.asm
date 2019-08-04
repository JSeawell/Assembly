; Program 6: Random Numbers     (prog6.asm)

; Author: Jake Seawell
; Last Modified: 6/9/19
; OSU email address: seawellj@oregonstate.edu
; Course number/section: CS271-400
; Project Number: 6                Due Date: 6/9/19

; Description: This program will prompt the user for 10
; unsigned integers, validate them, then find their 
; sum & avarage and display those on the console screen.
 

; Note: This program is implemented using procedures. It
; will also make use of Macros.

INCLUDE Irvine32.inc

.data

; Constant (BYTE/string) definitions

	intro_1 BYTE "Welcome to program #6: Macro Assembly! My name is Jake Seawell", 0

	inst_1 BYTE "I will show you the sum and average of a list of 10 unsigned integers.", 0
	inst_2 BYTE "Each number entered needs to fit into a 32-bit register.", 0

	prompt_1 BYTE "Enter an unsigned integer: ", 0
	
	; number or results range
	min DWORD 0
	max DWORD 400000000
	quantity DWORD 10            ; quantity of ints

	error_1 BYTE "Uh oh. The number must be an integer within the required range.", 0
	spaces BYTE "     ", 0
	
	output_sum BYTE "The sum of your numbers is: ", 0
	output_avg BYTE "The average of your numbers is: ", 0

	outro_1 BYTE "Have a great day! Farewell :)", 0
	title1 BYTE "Your numbers: ", 0
	
	promptStr BYTE "Enter a string: ", 0
	Count = 100
	string1 BYTE Count DUP(?)
	string2 BYTE Count DUP(?)

; Variable (DWORD/?) Definitions

	numArray DWORD	10 DUP(?)       ; array holding 10 ints
	sum DWORD 0                      ; sum of ints
	avg DWORD 0                      ; avg of ints
	sLength DWORD 0
	num DWORD 0


;*****************************************
.code


mGetString MACRO prompt1, memLoc

	push ecx
	push edx

	mov edx, OFFSET prompt1
	call WriteString
	call CrLf

	mov edx, OFFSET memLoc
	mov ecx, Count
	call ReadString
	call CrLf

	pop edx
	pop ecx

ENDM

mDisplayString MACRO memLoc

	push edx
		
	mov edx, OFFSET memLoc
	call WriteString
	call CrLf
		
	pop edx

ENDM

mDisplayError MACRO error, prompt

	push edx

	mov edx, OFFSET error
	call WriteString
	call CrLf
	mov edx, OFFSET prompt
	call WriteString
	call CrLf

	pop edx

ENDM



main PROC
	
	call intro

		push quantity
		push OFFSET numArray
	call fillArray
	
		push OFFSET title1
		push quantity
		push OFFSET numArray
	call displayList
	
	call calcSumAvg

	call outro

; exit to operating system
	exit
main ENDP
;*****************************************



              ;SUB-PROCEDURES:

			    ; Intro
;******************************************
; Procedure to display intro & instructions
; Receives: None
; Returns: None
; Pre-conditions: None
; Registers changed: edx

	intro PROC

		; Intro & Greeting
		call CrLf
		mov edx, OFFSET intro_1
		call WriteString
		call CrLf

		; Display instructions
		call CrLf
		mov edx, OFFSET inst_1
		call WriteString
		call CrLf
		mov edx, OFFSET inst_2
		call WriteString
		call CrLf

		ret
	intro ENDP
;*****************************************


               ; readVal
;*****************************************
; Procedure to validate user string input as int
; Receives: none
; Returns: none
; Pre-conditions: none
; Registers changed: eax, ebx, ecx, edx

	readVal PROC

		push ebp
		mov ebp, esp
		
		do_again:
		mGetString promptStr, string1

		mov sLength, eax
		mov ecx, eax
		mov esi, OFFSET string1
		mov edi, OFFSET string2

	counter:
		cld
		lodsb
		cmp eax, 48
		jge greater
		jmp error1

		greater:
		cmp eax, 57
		jle valid
		jmp error1

		error1:
		mov edx, OFFSET error_1
		call WriteString
		call CrLf
		mov edx, 0
		jmp do_again

		valid:
		stosb
		mov ebx, 48
		sub eax, ebx
		mov ebx, num
		add eax, num
		cmp ecx, 0
		jg next
		jmp done
		next:
		mov ebx, 10
		mul ebx
		mov num, eax
		done:
		div ebx
		
		loop counter

		leave1:

		pop ebp

		ret
	readVal ENDP
;*****************************************

              ; fillArray
;*****************************************
; Procedure to fill an array with values
; Receives: quantity (value), numArray
; Returns: numArray (filled with ints)
; Pre-conditions: sizeof(numArray)>=quantity
; Registers changed: eax, ecx

; fill array with integers
	fillArray PROC
		
		push ebp
		mov ebp, esp
		
		mov ecx, [ebp+12]
		
		;get array from memory
		mov esi, [ebp+8]

		fill_loop:

			push ecx
			push esi
			
			mov num, 0
			call readVal
			
			pop esi

			mov [esi], eax

			;increase sum by amount
			add sum, eax;
			
			;move index to next element
			add esi, 4		

			pop ecx

		loop fill_loop

		pop ebp

		ret 8
	fillArray ENDP	
;*****************************************


             ; display_List
;*****************************************
; Procedure to display an array of values
; Receives: title, quantity (value), numArray
; Returns: None
; Pre-conditions: None
; Registers changed: eax, ecx, edx

	displayList PROC
	
		push ebp
		mov ebp, esp

		mov edx, [ebp+16]
		call WriteString
		call CrLf 
		
		mov ecx, [ebp+12]
		
		;get array from memory
		mov esi, [ebp+8]
		
		;for each element, print it, followed by spaces, 10 per line
		read_loop:	
			mov eax,[esi]
			call WriteDec
			mov edx, OFFSET spaces
			call WriteString
			add esi, 4
		loop read_loop
		call CrLf

		pop ebp

		ret 12
	displayList ENDP
;*****************************************


;*****************************************
; Procedure writes a string value to the screen
; Receives: None
; Returns: None
; Pre-conditions: None
; Registers changed: edx

WriteVal PROC

	mDisplayString string2
	ret

WriteVal ENDP
;*****************************************



                ; Outro
;*****************************************
; Procedure to display a farewell message
; Receives: None
; Returns: None
; Pre-conditions: None
; Registers changed: edx

	outro PROC

		; Goodbye and Exit
		mov edx, OFFSET outro_1
		call WriteString
		call CrLf
		
		ret
	outro ENDP


				;CalcSum
;*****************************************
; Procedure to calculate sum and average
; Receives: None
; Returns: None
; Pre-conditions: None
; Registers changed: eax, ebx, edx
	
	calcSumAvg PROC

		mov edx, OFFSET output_sum
		call WriteString
		mov eax, sum
		call WriteDec
		call CrLf

		mov edx, OFFSET output_avg
		call WriteString
	
		mov edx, 0
		mov ebx, 10
		div ebx
		call WriteDec
		call CrLf

		ret
	calcSumAvg ENDP


END main
;*****************************************
