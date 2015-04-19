
# Raj Patel

# A.7 [5] <˜A.9> Using SPIM, write and test a program that reads in three integers and prints out the sum of the largest two of the three.
# Use the SPIM system calls described on pages A-43 and A-45. You can break ties arbitrarily.

.data
	# ASCIIz
	prompt: .asciiz "Enter an integer: "
	result: .asciiz "Total of the largest two integers: "
	
	# Array
	array: .word 3
	

.text
	main:
		la $t1, array		# $t1 = array[]
		li $t2, -1			# $t2 is the counter. Initialized at -1 because index starts at 0
		b PromptInput
	
	PromptInput:
		addi $t2, $t2, 1
		la $a0, prompt
		li $v0, 4
		syscall
		
		li $v0, 5
		syscall
		
		sw $v0, ($t1)		# revarray[index] now has value $t1, i.e. the remainder
		add $t1, $t1, 4		# index++	# Traverse forward
		
		bge $t2, 2, ProcessInt
		
		b PromptInput
	
	ProcessInt:
		la $t1, array
		lw $t3, ($t1)
		add $t1, $t1, 4
		lw $t4, ($t1)
		add $t1, $t1, 4
		lw $t5, ($t1)
		
		blt $t3, $t4, B		# $t3 < $t4
		b A					# $t3 > $t4
		
	A:
		blt $t4, $t5, C		# $t4 < $t5
		b B					# $t4 > $t5
	B:
		bgt $t3, $t5, SumAB		# $t3 + $t4
		b SumBC				# $t4 + $t5
	C:
		b SumAC				# $t3 + $t5
	
	SumAB:
		add $s0, $t3, $t4	# $s0 = $t3 + $t4
		b Exit
	
	SumBC:
		add $s0, $t4, $t5	# $s0 = $t4 + $t5
		b Exit
	
	SumAC:
		add $s0, $t3, $t5	# $s0 = $t3 + $t5
		b Exit
	
	Exit:
		la $a0, result
		li $v0, 4
		syscall
		
		# Print the summation
		move $a0, $s0		# $a0 = $s0
		li $v0, 1
		syscall
		
		li $v0, 10
		syscall