; *****************************************************************
;  Name: Sarah Johnson
;  NSHE ID: 1000285116
;  Section: 1003
;  Assignment: 8
;  Description: a program that uses shell sort to sort, then find
;  min, max, ave, sum. median then finds the linear regression of 2 
;  data sets

; -----------------------------------------------------------------
;  Write some assembly language functions.

;  The function, shellSort(), sorts the numbers into descending
;  order (large to small).  Uses the shell sort algorithm from
;  assignment #7 (modified to sort in descending order).

;  The function, basicStats(), finds the minimum, median, and maximum,
;  sum, and average for a list of numbers.
;  Note, the median is determined after the list is sorted.
;	This function must call the lstSum() and lstAvergae()
;	functions to get the corresponding values.
;	The lstAvergae() function must call the lstSum() function.

;  The function, linearRegression(), computes the linear regression of
;  the two data sets.  Summation and division performed as integer.

; *****************************************************************

section	.data

; -----
;  Define constants.

TRUE		equ	1
FALSE		equ	0

; -----
;  Local variables for shellSort() function (if any).


min	dd	0
med	dd	0
max	dd	0
sum	dd	0
avg	dd	0


; -----
;  Misc. data definitions (if any).

h		dd	0
i		dd	0
j		dd	0
tmp		dd	0

;sarah added variables
one     dd  1
two     dd  2
three   dd  3
temp    dd  0
; -----

; -----
;  Local variables for basicStats() function (if any).


; -----------------------------------------------------------------

section	.bss

; -----
;  Local variables for linearRegression() function (if any).

qSum		resq	1
dSum		resd	1


; *****************************************************************

section	.text

; --------------------------------------------------------
;  Shell sort function (form asst #7).
;	Updated to sort in descending order.

; -----
;  HLL Call:
;	call shellSort(list, len)

;  Arguments Passed:
;	1) list, addr - rdi
;	2) length, value - rsi

;  Returns:
;	sorted list (list passed by reference)

global	shellSort
shellSort:


;	YOUR CODE GOES HERE

; Shell Sort
push rbp
mov rbp, rsp
push r12
push rbx

;initalize registers
;mov rsi , 0         ; source index register

;	h = 1;
    mov dword[h], 1
	
	;while eax = h*3+1 < a.length
    
	sortLoop1:	
    ;h*3+1
	mov eax, dword[h]
	cdq
	mul dword[three]
	inc eax
    ;cmp eax, a.length
    cmp eax, esi
	jge exitLooph
      mov dword[h],eax
	  jmp sortLoop1
    exitLooph:

	; while( h > 0 ) {
	sortLoop2:
	cmp dword[h], 0
	jle exitLooph2      
		
        ;for (i = h-1; i < a.length; i++) {

		;i = h-1
		mov eax, dword[h]	
		dec eax
        mov dword[i],eax
		forLoop1:
		    ; i < a.length
		    mov eax, dword[i]
			cmp eax, esi
			jge exitLoopi 
		    
			;tmp = a[i]
			mov r12d, dword[i]
			mov ebx, dword[rdi+r12*4]
			mov dword[tmp], ebx

			;for( j = i; (j >= h) && (a[j-h] <= tmp); j -= h)
;			{
;			(			
			;j = i
			 mov ecx, dword[i]
			 mov dword[j],ecx
		    
			loopj:
			;(j >= h)
			mov eax, dword[h]
			cmp dword[j], eax
            jl forLoopExitj

;			a[j-h] > tmp
            
			;r12d(index)= j-h
			mov r12d, dword[j]
			sub r12d, dword[h]
			
			
			mov eax, dword[tmp]
            cmp dword[rdi+r12*4], eax         
			jg forLoopExitj
				
;        		a[j] = a[j-h];
				mov r12d, dword[j]
            	sub r12d, dword[h]
				mov ebx, dword[rdi+r12*4]
                mov r12d, dword[j]
				mov dword[rdi+r12*4], ebx

;			j -= h
            mov ecx, dword[j]
			sub ecx, dword[h]
			mov dword[j],ecx 

;			
;}
			jmp loopj
			forLoopExitj:
;   	    

			;a[j]=tmp        	 
            mov eax, dword[tmp]
			mov r12d, dword[j]
            mov dword[rdi+r12*4], eax 

			;i++
			inc dword[i]
			jmp forLoop1	
;        }
		exitLoopi:
;    }
    ;h = h / 3;
     mov eax, dword[h]
	 cdq
	 div dword[three]
	 mov dword[h], eax
	 jmp sortLoop2
;   }
	 exitLooph2:

	pop rbx
	pop r12
    pop rbp 

	ret

; --------------------------------------------------------
;  Find basic statistical information for a list of integers:
;	minimum, median, maximum, sum, and average

;  Note, for an odd number of items, the median value is defined as
;  the middle value.  For an even number of values, it is the integer
;  average of the two middle values.

;  This function must call the lstSum() and lstAvergae() functions
;  to get the corresponding values.

;  Note, assumes the list is already sorted.

; -----
;  Call:
;	call basicStats(list, len, min, med, max, sum, ave)

;  Arguments Passed:
;	1) list, addr - rdi
;	2) length, value - rsi
;	3) minimum, addr - rdx
;	4) median, addr - rcx
;	5) maximum, addr - r8
;	6) sum, addr - r9
;	7) ave, addr - stack, rbp+16

;  Returns:
;	minimum, median, maximum, sum, and average
;	via pass-by-reference (addresses on stack)

global basicStats
basicStats:

;	YOUR CODE GOES HERE

	push rbp 
	mov rbp, rsp
	push r12

;======== Sum ==============
call lstSum
	mov dword[r9], eax


;====== Ave ================
;save rdx across function call
push rdx
;****************************
call lstAve
;save rdx across function call
pop rdx
;****************************
	mov r12, qword[rbp+16]
    mov dword[r12], eax




;list
; mov eax, dword[rdi+rsi*4]


; ;=======  max  ===========
 	mov eax, dword[rdi+0*4]
 	mov dword[r8], eax


; =======  min  ===========  
 	mov r12, rsi
  	dec r12
  	mov eax, dword[rdi+r12*4]
 	mov dword[rdx], eax

; ===========find med even============
    ;moving length into rax
	mov rax, rsi
	cqo
	div dword[two]
	;eax = len/2
 	cmp edx, 1
	je oddMedian
	;evenMedian
	mov r12d, eax
	;settin index to len/2
	mov eax, dword[rdi+r12*4]
	dec r12	
	;setting index to len/2-1
	add eax, dword[rdi+r12*4]
    div dword[two]
	;moving results into place
	mov dword[rcx], eax
	jmp medianExit
;  ====== find med odd ================
    oddMedian:
		;mov len/2 into r12
		mov r12d, eax 
		;moving l/2 index into eax
		mov eax, dword[rdi+r12*4]
		;mov results into place
		mov dword[rcx], eax
	medianExit:

	pop r12
	pop rbp


	ret

; --------------------------------------------------------
;  Function to calculate the sum of a list.

; -----
;  Call:
;	ans = lstSum(lst, len)

;  Arguments Passed:
;	1) list, address - rdi
;	1) length, value - rsi

;  Returns:
;	sum (in eax)


global	lstSum
lstSum:
push r12

;	YOUR CODE GOES HERE

;   ;==== find sum ========   
	mov r12, 0
	mov eax, 0
	sumLoop:
	add eax, [rdi+r12*4]
    inc r12
	cmp r12, rsi
    je exitsumLoop
    jmp sumLoop
	exitsumLoop:

pop r12
	ret

; --------------------------------------------------------
;  Function to calculate the average of a list.
;  Note, must call the rdiSum() fucntion.

; -----
;  Call:
;	ans = lstAve(lst, len)

;  Arguments Passed:
;	1) list, address - rdi
;	1) length, value - rsi

;  Returns:
;	average (in eax)


global	lstAve

lstAve:

	push rdx

;	YOUR CODE GOES HERE
	;put sum into eax
	
     call lstSum
    ; sum/length
     cdq
     idiv rsi

    pop rdx
	ret

; --------------------------------------------------------
;  Function to calculate the linear regression
;  between two lists (of equal size).
;  Due to the data sizes, the summation for the dividend (top)
;  MUST be performed as a quad-word.

; -----
;  Call:
;	linearRegression(xList, yList, len, xAve, yAve, b0, b1)

;  Arguments Passed:
;	1) xList, address - rdi
;	2) yList, address - rsi
;	3) length, value - edx
;	4) xList average, value - ecx
;	5) yList average, value - r8d
;	6) b0, address - r9
;	7) b1, address - stack, rpb+16

;  Returns:
;	b0 and b1 via reference

global linearRegression
linearRegression:
;	YOUR CODE GOES HERE
push rbp 
mov  rbp, rsp
push r15
push r14
push r13
push r12

;r15  index
;r14  top sum
;r13  bot sum
;eax   top
;r12  x - xHat
;eax  y - yHat
; (x - xhat)^2

;b0_1: 425439
;b1_1: 85




;initialize index
mov r15, 0
;initialize topsum 
mov r14, 0
;initalize botsum 
mov r13, 0 
;save copy of rdx to be clobbered by imul/idiv
mov r11, rdx
; loop form index is 0 to rdx-1
	regressLoop:
		cmp r15, r11
		je exitRegressLoop
		; var1 = x at list - xave
		; var 1(r12) =  x - xHat
		mov r12d, dword[rdi+r15*4] 
		;sign extends r12d into r12
		movsxd r12, r12d
		sub r12, rcx

		; var 2 (eax) = y list - y ave
		; var 2(eax) = y - yHat(r8d)
		mov eax, dword[rsi+r15*4]  
		movsxd rax, eax
		sub rax, r8

		; var 3 = top (x-xHat * y-yHat)
		; var 3(eax) = multipy var1 x var2
		imul r12

		;add r14(topsum), add var 3 to sum
		add r14, rax
		
		; var 4 = bot (x - xhat)^2
		mov rax, r12
		imul rax
		;answer in eax = eax^2


		;add botsum temp, var 4
		add r13, rax

		inc r15 
	jmp regressLoop
	;exitLoop
	exitRegressLoop:

	;b1
	;var 6(top/bot) = divide r14/r13
	mov rax, r14
	cqo
	idiv r13
	;mov dword[stack], eax
	mov r12, qword[rbp+16]
    mov dword [r12], eax


;b sub 0
	imul ecx
	movsxd r8, r8d
	sub r8, rax
	mov dword[r9], r8d
	;var 7 = b1 (var6) imul xave (ecx)
    ;sub y ave, var 7
	
	;mov result into dowrd[r9]

pop r12
pop r13
pop r14
pop r15
pop rbp
	ret

; ********************************************************************************
