; Program 5: Random Numbers     (prog5.asm)

; Author: Jake Seawell
; Last Modified: 5/21/19
; OSU email address: seawellj@oregonstate.edu
; Course number/section: CS271-400
; Project Number: 5                Due Date: 5/26/19

; Description: This program will get a user request 
; in the range [min = 10 .. max = 200], generate 
; request random integers in the range [lo = 100 .. hi = 999], 
; storing them in consecutive elements of an array.
; It will then display the list of integers before sorting, 
; 10 numbers per line, sort the list in descending order (i.e., largest first),
; calculate and display the median value, rounded to the nearest integer, and 
; display the sorted list, 10 numbers per line.
 

; Note: This program is implemented using procedures.

INCLUDE Irvine32.inc

.data

; Constant (BYTE/string) definitions

	intro_1 BYTE "Welcome to program #5: Random Numbers! My name is Jake Seawell", 0

	inst_2 BYTE "How many random numbers would you like to generate?", 0
	inst_1 BYTE "I will show you a list of random numbers, first unsorted, then sorted, as well as the median value.", 0

	prompt_1 BYTE "Enter an integer in the range from ", 0
	prompt_2 BYTE " --> ", 0
	
	; number or results range
	min DWORD 10
	max DWORD 200

	; random number range
	lo DWORD 100
	hi DWORD 999
	output_count DWORD 0

	error_1 BYTE "Uh oh. The number must be an integer within the required range.", 0

	title1 BYTE "Your unsorted list:", 0
	title2 BYTE "Your sorted list:", 0
	
	output_median BYTE "The median value of the list is: ", 0

	spaces BYTE "     ", 0

	outro_1 BYTE "Have a great day! Farewell :)", 0

; Variable (DWORD/?) Definitions

	randArray DWORD	200 DUP(?)       ;array holding random numbers
	user_quantity DWORD ?            ; quantity of randoms from user
	
	median_offset_1 DWORD 0
	median_offset_2 DWORD 0
	median DWORD 0                   ; median value of list


;*****************************************
.code
main PROC
	
	call Randomize          ;Seed random number
	
	call intro
	
		push min
		push max
	call getData

		push user_quantity
		push OFFSET randArray
	call fillArray
	
	;display unsorted list
	
		push OFFSET title1
		push user_quantity
		push OFFSET randArray
	call displayList
	
		push user_quantity
		push OFFSET randArray
	call sortList
	
		push user_quantity
		push OFFSET randArray
		push OFFSET median
 		push OFFSET median_offset_1
		push OFFSET median_offset_2
	call displayMedian
	
	;display sorted list
		
		push OFFSET title2
		push user_quantity
		push OFFSET randArray
	call displayList
	
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

               ; getData
;*****************************************
; Procedure to get and validate (called) user input
; Receives: min (value), max (value)
; Returns: None
; Pre-conditions: None
; Registers changed: eax, edx

	getData PROC

		push ebp
		mov ebp, esp
		
		; Data prompts
		call CrLf
		mov edx, OFFSET prompt_1
		call WriteString
		mov eax, [ebp+12]
		call WriteDec
		mov edx, OFFSET prompt_2
		call WriteString
		mov eax, [ebp+8]
		call WriteDec
		call CrLf

		; GET NUMBER
		call CrLf
		call ReadInt
		call CrLf
	
		; VALIDATE NUMBER
		call validate

		pop ebp

		ret 8
	getData ENDP
;*****************************************

               ; Validate
;*****************************************
; Procedure to validate that user input is in given range
; Receives: None
; Returns: user_quantity
; Pre-conditions: max>min
; Registers changed: eax, edx

	validate PROC

		push ebp
		mov ebp, esp
		
		START:
		cmp eax, [ebp+20]
		jge VALID_ONCE
		mov edx, OFFSET error_1
		call WriteString
		call CrLf
		jmp INVALID

		INVALID:
		; REPROMPT FOR NEW DATA
			call CrLf
			mov edx, OFFSET prompt_1
			call WriteString
			mov eax, [ebp+20]
			call WriteDec
			mov edx, OFFSET prompt_2
			call WriteString
			mov eax, max
			call WriteDec
			call CrLf

		; GET NEW NUMBER
			call CrLf
			call ReadInt
			call CrLf
			jmp START

		; Number is >=min
		VALID_ONCE:
			cmp eax, [ebp+16]
			jle VALID
			mov edx, OFFSET error_1
			call WriteString
			call CrLf
			jmp INVALID

		; Number is valid
		VALID:
		mov user_quantity, eax

		pop ebp

		ret
	validate ENDP
;*****************************************

              ; fillArray
;*****************************************
; Procedure to fill an array with random values
; Receives: user_quantity (value), randArray
; Returns: randArray (filled with randoms)
; Pre-conditions: sizeof(randArray)>=user_quantity
; Registers changed: eax, ecx

; fill array with random numbers
	fillArray PROC
		
		push ebp
		mov ebp, esp
		
		mov ecx, [ebp+12]
		mov eax, 0
		
		;get array from memory
		mov esi, [ebp+8]

		fill_loop:
			
			;get random number
			push hi
			push lo
			call getRand
			
			;move that number into array at current index
			mov [esi], eax
			
			;move index to next element
			add esi, 4		
		
		loop fill_loop
		
		pop ebp

		ret 8
	fillArray ENDP	
;*****************************************

               ; getRand
;*****************************************
; Procedure to get a psudo-random integer in a certain range
; Receives: hi(value), lo(value)
; Returns: Random # (stored in eax)
; Pre-conditions: Random # has been seeded once "call Randomize"
; Registers changed: eax

; Get psudo-random number
	getRand PROC

		push ebp
		mov ebp, esp

		;set random range as hi-lo
		mov eax, [ebp+12]
		sub eax, [ebp+8]
		
		call RandomRange
		add eax, [ebp+8]

		pop ebp
	
		ret 8
	getRand ENDP
;*****************************************

             ; display_List
;*****************************************
; Procedure to display an array of values, 10 per line
; Receives: title, user_quantity (value), randArray
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
			inc output_count

			mov eax, output_count
			cmp eax, 10
			jge NEW_LINE
			jmp NO_NEW_LINE

			;10 elements reached - new line
			NEW_LINE:
				call CrLf
				mov output_count, 0

			NO_NEW_LINE:
		loop read_loop
		mov output_count, 0
		call CrLf

		pop ebp

		ret 12
	displayList ENDP
;*****************************************

               ; sortList
;*****************************************
; Procedure to sort an array of values in ascending order
; Receives: user_quantity (value), randArray
; Returns: randArray (sorted)
; Pre-conditions: None
; Registers changed: eax, ebx, ecx

	sortList PROC
	
	push ebp
	mov ebp, esp

	mov ecx, [ebp+12]
	dec ecx
	
	sort_loop1:	
		
		;save original ecx
		push ecx

		mov ecx, [ebp+12]
		dec ecx
		
		;get array from memory
		mov esi, [ebp+8]
		sort_loop2:	
			
			;selection sort - swaps elements one by one
			mov eax,[esi]
			cmp eax, [esi+4]
			jle noSWAP
			jmp SWAP

			SWAP:
			mov eax, [esi]
			mov ebx, [esi+4]
			mov [esi], ebx
			mov [esi+4], eax

			noSWAP:

			;move to next element
			add esi, 4

		loop sort_loop2

		;get original ecx
		pop ecx

		loop sort_loop1

		pop ebp
		
		ret 8
	sortList ENDP
;*****************************************	

            ; displayMedian
;*****************************************
; Procedure to calculate & display the median of a list
; Receives: user_quantity (value), randArray
;      median, median_offest_1, median_offset_2
; Returns: median
; Pre-conditions: None
; Registers changed: eax, ebx, ecx, edx

	displayMedian PROC

		push ebp
		mov ebp, esp
		
		;calculate
		
		;Even or Odd?
		mov edx, 0
		mov eax, [ebp+24]
		mov ebx, 2
		div ebx
		cmp edx, 0
		je EVEN_CASE
		jmp ODD_CASE
		
		; get address offset of 2 median indices
		EVEN_CASE:
		dec eax
		mov ecx, 4
		mov edx, 0
		mul ecx
		mov ebx, eax
		add ebx, 4

		mov [ebp+12], eax
		mov [ebp+8], ebx
		
		;get the value at randArray[median_offset_1]
			mov esi, [ebp+20]
			mov ebx, [ebp+12]
			add esi, ebx
			mov eax,[esi]
		
		;get the value at randArray[median_offset_2]
			mov esi, [ebp+20]
			mov ebx, [ebp+8]
			add esi, ebx
			mov ebx, [esi]

		; calculate avg
			add eax, ebx
			mov edx, 0
			mov ebx, 2
			div ebx
			cmp edx, 0
			je Round_Down
			jmp Round_Up
		
		Round_Up:
			inc eax
		Round_Down:
		
		mov [ebp+16], eax
		jmp DONE

		ODD_CASE:
			mov ecx, 4
			mov edx, 0
			mul ecx
			mov [ebp+12], eax
			
			;get the value at randArray[median_offset_1]
			mov esi, [ebp+20]
			add esi, [ebp+12]
			mov eax,[esi]
			mov [ebp+16], eax

		DONE:

		;display median
		mov edx, OFFSET output_median
		call WriteString
		mov eax, [ebp+16]
		call WriteDec
		call CrLf
		call CrLf

		pop ebp
		
		ret 16
	displayMedian ENDP
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

END main
;*****************************************
