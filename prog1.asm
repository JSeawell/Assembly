; Program 1: Integer OPS     (prog1.asm)

; Author: Jake Seawell
; Last Modified: 4/6/19
; OSU email address: seawellj@oregonstate.edu
; Course number/section: CS271-400
; Project Number: 1                Due Date: 4/14/19
; Description: Integer OPS prompts the user for 2 
; positive numbers, then calculates their sum, difference,
; product, and quotient (including remainder), and
; displays the results to the user.

INCLUDE Irvine32.inc

.data

; Constant (BYTE/string) definitions

intro_1 BYTE "Welcome to program #1: Integer OPS, my name is Jake Seawell ", 0
intro_2 BYTE "Enter 2 positive numbers, and I will tell you their sum, difference, product, and quotient (including remainder)", 0

prompt_1 BYTE "Enter your first number (positive): ", 0
prompt_2 BYTE "Enter your second number (positive): ", 0

error_1 BYTE "The second number must be smaller than the first.", 0
success_1 BYTE "The second number is less than the first. Nice!", 0

output_sum BYTE "Sum: ", 0
output_diff BYTE "Difference: ", 0
output_prod BYTE "Product: ", 0
output_quo BYTE "Quotient: ", 0
output_rem BYTE "Remainder: ", 0

exit_prompt BYTE "Enter 0 to quit, or any other number to continue:", 0

outro BYTE "Have a great day! Byeeeee ", 0

; Variable (DWORD/?) Definitions

intNum1 DWORD ?     ;number 1 from user
intNum2 DWORD ?     ;number 2 from user

sum DWORD ?
difference DWORD ?
product DWORD ?
quotient DWORD ?
remainder DWORD ?

.code
main PROC

; Introduction: Display the 2 intro messages
	call CrLf
	mov edx, OFFSET intro_1
	call WriteString
	call CrLf
	call CrLf
	mov edx, OFFSET intro_2
	call WriteString
	call CrLf
	call CrLf

; Loop until user quits
loop_strt:
; Get two numbers from user
	mov edx, OFFSET prompt_1
	call WriteString
	call ReadInt
	mov intNum1, eax
	call CrLf

	mov edx, OFFSET prompt_2
	call WriteString
	call ReadInt
	mov intNum2, eax
	call CrLf

	mov eax, intNum1
	mov ebx, intNum2
	cmp ebx, eax
	jle CONTINUE
	call CrLf
	mov edx, OFFSET error_1
	call WriteString
	call CrLf
	call CrLf
	jmp loop_strt

CONTINUE:

call CrLf
mov edx, OFFSET success_1
call WriteString
call CrLf
call CrLf	

; Calculate the sum, difference, product, and quotient

	; Sum
	mov eax, intNum1
	mov ebx, intNum2
	add eax, ebx
	mov sum, eax

	; Difference: subtract 2 from 1
	mov eax, intNum1
	mov ebx, intNum2
	sub eax, ebx
	mov difference, eax

	; Product
	mov eax, intNum1
	mov ebx, intNum2
	mul ebx
	mov product, eax

	; Quotient: divide 1 by 2
	mov eax, intNum1
	mov ebx, intNum2
	mov edx, 0
	idiv ebx
	mov quotient, eax
	mov remainder, edx


; Display results
	
	; Sum
	mov edx, OFFSET output_sum
	call WriteString
	mov eax, sum
	call WriteDec
	call CrLf
	call CrLf
	
	; Difference
	mov edx, OFFSET output_diff
	call WriteString
	mov eax, difference
	call WriteDec
	call CrLf
	call CrLf
	
	; Product
	mov edx, OFFSET output_prod
	call WriteString
	mov eax, product
	call WriteDec
	call CrLf
	call CrLf
	
	; Division quotient
	mov edx, OFFSET output_quo
	call WriteString
	mov eax, quotient
	call WriteDec
	call CrLf
	
	; Division remainder
	mov edx, OFFSET output_rem
	call WriteString
	mov eax, remainder
	call WriteDec
	call CrLf
	call CrLf

; end of loop

call CrLf
mov edx, OFFSET exit_prompt
call WriteString
call CrLf
call CrLf

call ReadInt
mov ebx, 0
cmp eax, ebx
jle BYE
jmp loop_strt

BYE:
; Say goodbye and exit
	mov edx, OFFSET outro
	call WriteString
	call CrLf

	exit	; exit to operating system
main ENDP

END main
