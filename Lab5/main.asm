; Author : Matthew Romleski
; Tech ID: 12676184
; Program that gets the dot product the matrices A*B.
; Stores the result in the data memory at 0x2000 to 0x2003.

		.include <atxmega128a1udef.inc>

		.dseg
		.def	mulRes		= r0
		.def	A1_1		= r2
		.def	A1_2		= r3
		.def	A2_1		= r4
		.def	A2_2		= r5
		.def	B1_1		= r6
		.def	B1_2		= r7
		.def	B2_1		= r8
		.def	B2_2		= r9
		.def	tempRow1	= r10
		.def	tempRow2	= r11
		.def	tempCol1	= r12
		.def	tempCol2	= r13
		.def	tempRes		= r14

		.macro ldVal
		mov		tempRow1, @0 ; Loads the array values into temp regs.
		mov		tempRow2, @1 ; ^^
		mov		tempCol1, @2 ; ^^
		mov		tempCol2, @3 ; ^^
		.endm

		.macro ldAry
		lpm		@0, Z+ ; Loads the array values into the registers.
		lpm		@1, Z+ ; ^^
		lpm		@2, Z+ ; ^^
		lpm		@3, Z+ ; ^^
		.endm

		.cseg
		.org	0x00
		rjmp	start
		.org	0xF6


start:	ldi		ZL, low(ArrayA << 1) ; Loads the memory location of array A into the Z pointer.
		ldi		ZH, high(ArrayA << 1) ; ^^
		
		ldAry	A1_1, A1_2, A2_1, A2_2 ; Loads the 2x2 array into the specified registers.
		
		ldi		ZL, low(ArrayB << 1) ; Loads the memory location of array B into the Z pointer.
		ldi		ZH, high(ArrayB << 1) ; ^^

		ldAry	B1_1, B1_2, B2_1, B2_2 ; Loads the 2x2 array into the specified registers.

		ldi		XL, 0x00 ; Loads the data memory location that's being used into the X pointer.
		ldi		XH, 0x20 ; ^^

		ldVal	A1_1, A1_2, B1_1, B2_1 ; Loads the needed values into the registers for the subroutine.
		call	calcStore ; Preforms the calculation.

		ldVal	A1_1, A1_2, B1_2, B2_2 ; ^^
		call	calcStore ; ^^

		ldVal	A2_1, A2_2, B1_1, B2_1 ; ^^
		call	calcStore ; ^^
		
		ldVal	A2_1, A2_2, B1_2, B2_2 ; ^^
		call	calcStore ; ^^

done:		rjmp	done

calcStore:	mul		tempRow1, tempCol1
			mov		tempRes, mulRes
			mul		tempRow2, tempCol2
			add		tempRes, mulRes
			st		X+, tempRes ; Stores the value.
			ret

ArrayA:		.db		2,  3,  4,  5
ArrayB:		.db		7,  8,  9, 10