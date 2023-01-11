###########################################################
#	Name: Michael Strand
#	Date: 3/14/21 (pi day!)

###########################################################
#		Program Description
#	This program with create a dynamic array between 5 and
#	15 in length. Subprograms will be used to create, 
#	allocate, read, and print the array as well as get the 
#	sum of all even integers in the array and calculate 
#	and print the average of that sum.

###########################################################
#		Register Usage
#	$t0 base address
#	$t1 length
#	$t2 sum
#	$t3 count
#	$t4 
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9
###########################################################
		.data

###########################################################
		.text
main:
	
	addi $sp, $sp, -12			#allocting space on stack
	sw $ra, 8,($sp)				#storing $ra at offset 8

	jal create_array			#jump to create_array Subprogram

	lw $t0, 0($sp)				#$t0=base address
	lw $t1, 4($sp)				#$t1=length
	lw $ra, 8($sp)
	addi $sp, $sp, 12

	print_array_stack_setup:
		addi $sp, $sp, -12		#allocate for print_array
		sw $t0, 0($sp)			#base address in offset 0
		sw $t1, 4($sp)			#length in offset 4
		sw $ra, 8($sp)			

		jal print_array			#jump to print_array

		lw $t0, 0($sp)
		lw $t1, 4($sp)
		lw $ra, 8($sp)
		addi $sp, $sp, 12

	sum_even_values_stack_setup:
		addi $sp, $sp, -20
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		sw $ra, 16($sp)

		jal sum_even_values

		lw $t0, 0($sp)
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $t3, 12($sp)
		lw $ra, 16($sp)
		addi $sp, $sp 20

	print_sum_average_stack_setup:
		addi $sp, $sp, -12
		sw $t2, 0($sp)
		sw $t3, 4($sp)
		sw $ra, 8($sp)

		jal print_sum_average

		addi $sp, $sp 12

	li $v0, 10		#End Program
	syscall
###########################################################

###########################################################
#		Create Array Subprogram

###########################################################
#		Arguments In and Out of subprogram
#
#	$a0
#	$a1
#	$a2
#	$a3
#	$v0
#	$v1
#	$sp array base address
#	$sp+4 array length
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#	$t0 array base address
#	$t1 array length
#	$t2
#	$t3
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8 5
#	$t9 15
###########################################################
		.data

user_prompt:	.asciiz "Enter an integer between 5 and 15 (inclusive)."
invalid_prompt: .asciiz "\nInvalid input. Please try again."
###########################################################
		.text

create_array:
	
	li $t8, 5					#$t8= 5
	li $t9, 15					#$t9= 15

	prompt:
		li $v0, 4				#begin print string calling
		la $a0, user_prompt		#load prompt
		syscall

		li $v0, 5				#read user input
		syscall		

		blt $v0, $t8, invalid	#if user input < 5 branch
		bgt $v0, $t9, invalid	#if user input > 15 branch

	allocate_array_stack_setup:
		addi $sp, $sp, -12		#allocate space for allocate_array_stack_setup
		sw $v0, 0($sp)			#array length at offset 0
		sw $ra, 8($sp)			#ra at offset 8

		jal allocate_array		#jump to allocate_array

		lw $t1, 0($sp)			#$t1 = array length
		lw $t0, 4($sp)			#$t0 = array base address
		lw $ra, 8($sp)			
		addi $sp, $sp, 12

	read_array_stack_setup:
		addi $sp, $sp, -12		#allocate for read_array
		sw $t0, 0($sp)			#base address at offset 0
		sw $t1, 4($sp)			#array length at offset 4
		sw $ra, 8($sp)			#ra at offset 8

		jal read_array

		lw $t0, 0($sp)			#$t0 = base address
		lw $t1, 4($sp)			#$t1 = array length
		lw $ra, 8($sp)
		addi $sp, $sp, 12

		b create_end

	invalid:
		li $v0, 4				
		la $a0, invalid_prompt
		syscall

		b prompt
	
create_end:
	sw $t0, 0($sp)
	sw $t1, 4($sp)

	jr $ra	#return to calling location
###########################################################

###########################################################
#		Allocate array subprogram

###########################################################
#		Arguments In and Out of subprogram
#
#	$a0
#	$a1
#	$a2
#	$a3
#	$v0
#	$v1
#	$sp array length
#	$sp+4 array base address
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#	$t0 array length
#	$t1 
#	$t2
#	$t3
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9 4
###########################################################
		.data

###########################################################
		.text
allocate_array:
	li $t9, 4					#$t9 = 4
	lw $t0, 0($sp)				#$t0 = array length

	li $v0, 9					#dynamic array calling
	mul $a0, $t0, $t9			#array length x 4
	syscall

	sw $v0, 4($sp)				#base address at offset 4
	
	jr $ra	#return to calling location
###########################################################

###########################################################
#		Read array subprogram

###########################################################
#		Arguments In and Out of subprogram
#
#	$a0
#	$a1
#	$a2
#	$a3
#	$v0
#	$v1
#	$sp base address
#	$sp+4 array length
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#	$t0
#	$t1
#	$t2
#	$t3
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9
###########################################################
		.data
input_prompt:	.asciiz	"Please enter a non-negative integer."
invalid_input:	.asciiz	"\nInvalid input. Please try again.\n"
###########################################################
		.text
read_array:
	lw $t0, 0($sp)			#$t0 = base address
	lw $t1, 4($sp)			#$t1 = array length

loop:
	beqz $t1, read_end			#while $t1>0 loop
	li $v0, 4				#string calling
	la $a0, input_prompt	#load prompt
	syscall

	li $v0, 5				#read input
	syscall

	bltz $v0, invalid_user_input	#if input < 0 branch

	sw $v0, 0($t0)			#saving user valid input

	addi $t0, 4				#incrementing array index
	addi $t1, -1			#decrementing counter

	b loop

invalid_user_input:
	li $v0, 4
	la $a0, invalid_input
	syscall

	b loop

read_end:
	jr $ra	#return to calling location
###########################################################

###########################################################
#		Print array subprogram

###########################################################
#		Arguments In and Out of subprogram
#
#	$a0
#	$a1
#	$a2
#	$a3
#	$v0
#	$v1
#	$sp base address
#	$sp+4 array length
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#	$t0 base address
#	$t1	length
#	$t2
#	$t3
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9
###########################################################
		.data
array:	.asciiz	"Array: "
array_space:	.asciiz	" "
###########################################################
		.text
print_array:
	lw $t0, 0($sp)		#$t0 = base address
	lw $t1, 4($sp)		#t1 = length

	li $v0, 4			#string call
	la $a0, array		#print "Array: "
	syscall

	print_loop:
		beqz $t1, print_end	#while $t1>0 loop

		li $v0, 1
		lw $a0, 0($t0)
		syscall

		li $v0, 4
		la $a0, array_space
		syscall
		
		addi $t0, 4
		addi $t1, -1

		b print_loop

print_end:
	jr $ra	#return to calling location
###########################################################

###########################################################
#		Sum Even values subprogram

###########################################################
#		Arguments In and Out of subprogram
#
#	$a0
#	$a1
#	$a2
#	$a3
#	$v0
#	$v1
#	$sp base address
#	$sp+4 length
#	$sp+8 sum of even values
#	$sp+12 count of even values
#	$sp+16 ra
###########################################################
#		Register Usage
#	$t0 base address
#	$t1 length
#	$t2 sum
#	$t3 count
#	$t4
#	$t5
#	$t6
#	$t7 2
#	$t8	remainder
#	$t9 temp
###########################################################
		.data

###########################################################
		.text
sum_even_values:
	lw $t0, 0($sp)			#$t0= base address
	lw $t1, 4($sp)			#$t1= length
	li $t7, 2				#$t7 = 2

sum_loop:
	beqz $t1, sum_end		#while $t1>0 loop

	lw $t9, 0($t0)			#$t9 = array index value
	rem $t8, $t9, $t7		#remainder of index value/2

	beqz $t8, even

	addi $t0, 4
	addi $t1, -1

	b sum_loop

even:
	add $t2, $t2, $t9
	addi $t3, 1

	addi $t0, 4
	addi $t1, -1

	b sum_loop

sum_end:
	sw $t2, 8($sp)
	sw $t3, 12($sp)

	jr $ra	#return to calling location
###########################################################

###########################################################
#		Print sum average subprogram

###########################################################
#		Arguments In and Out of subprogram
#
#	$a0
#	$a1
#	$a2
#	$a3
#	$v0
#	$v1
#	$sp sum
#	$sp+4 count
#	$sp+8 
#	$sp+12 
#	$sp+16 
###########################################################
#		Register Usage
#	$t0 sum
#	$t1 count
#	$t2 average
#	$t3 
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9
###########################################################
		.data
sum:	.asciiz	"\nSum of even integers: "
count:	.asciiz	"\nCount of even integers: "
average:	.asciiz	"\nAverage of even integers: "
###########################################################
		.text
print_sum_average:
	lw $t0, 0($sp)			#$t0= sum
	lw $t1, 4($sp)			#$t1= count

	div $t2, $t0, $t1		#$t2= average

	li $v0, 4
	la $a0, count
	syscall

	li $v0, 1
	move $a0, $t1
	syscall

	li $v0, 4
	la $a0, sum
	syscall

	li $v0, 1
	move $a0, $t0
	syscall

	li $v0, 4
	la $a0, average
	syscall

	li $v0, 1
	move $a0, $t2
	syscall

	jr $ra	#return to calling location
###########################################################

