
# Raj Patel

# Integer To Name

# A.8 [5] <ÅòA.9> Using SPIM, write and test a program that reads in a positive integer using the SPIM system calls.
# If the integer is not positive, the program should terminate with the message ÅgInvalid EntryÅh;
# otherwise the program should print out the names of the digits of the integers, delimited by exactly one space.
# For example, if the user entered Åg728,Åh the output would be ÅgSeven Two Eight.Åh

.data
	
	# ASCIIz
	prompt: .asciiz "Enter an integer: "
	invalid: .asciiz "Invalid Entry.\n"
	
	zero: .asciiz "Zero"
	one: .asciiz "One"
	two: .asciiz "Two"
	three: .asciiz "Three"
	four: .asciiz "Four"
	five: .asciiz "Five"
	six: .asciiz "Six"
	seven: .asciiz "Seven"
	eight: .asciiz "Eight"
	nine: .asciiz "Nine"
	space: .asciiz " "
	
	# Arrays
	#array: .word LengthInt
	revarray: .word LengthInt	# Only works when LengthInt parameter is present for some reason

.text
	
	main:
		# Prompt
		la $a0, prompt
		li $v0, 4
		syscall
		
		# Input
		li $v0, 5
		syscall
		
		# Invalid if negative
		bltz $v0, Invalid
		
		move $t0, $v0		# $t0 = $v0
		move $s0, $v0		# $s0 = $v0
		
		move $t1, $v0		# $t1 = $v0
		li $t4, -1			# $t4 is the counter. Initialized at -1 because index starts at 0
		#move $t6, $v0		# $t6 = $v0		# For LengthInt
		la $t6, revarray	# $t6 = revarray[]
		b ProcessInt
		
		
	Invalid:
		la $a0, invalid
		li $v0, 4
		syscall
		
		b Exit
		
	ProcessInt:
		div $t1, $t1, 10	# $t1 = $t1 / 10

		# remainder = $t0 - ($t1 * 10)
		
		mul $t2, $t1, 10	# $t2 = $t1 * 10
		
		# Make $t3 as remainder
		sub $t3, $t0, $t2	# $t3 = $t0 - $t2
		move $t0, $t1		# $t0 = #$t1 For the above code to work.
		
		# Add the remainder to revarray
		addi $t4,$t4, 1		# Increment the counter, $t4
		
		# Optimized code
		sw $t3, ($t6)		# revarray[index] now has value $t3, i.e. the remainder
		add $t6, $t6, 4		# index++	# Traverse forward
		
		
		#move $t5, $t4		# $t5 = $t4 So that  $t4 can be in integer and $t5 can be in bits
			
		#la $t6, revarray	# $t6 = revarray[]
		#add $t7, $t5, $t6	# $t7 is the address of revarray[$t5]
		#sw $t3, ($t7)		# revarray[$t5] now has value $t3, i.e. the remainder
		#mul $t5, $t5, 4	# $t5 has index in bits
		
		
		#b LengthInt		#li $t5, 0			# Counter for array index
		#mul $t5, $t5, 4	# $t5 has index in bits
		#la $t4, revarray	# $t4 = revarray[]
		#add $t6, $t5, $t4	# $t6 is the address of revarray[$t5]
		#sw $t3, ($t4)		# revarray[] now has value $t3
		
		
		# Print the remainder
		#move $a0, $t3
		#li $v0, 1
		#syscall
		
		beqz $t1, ProcessIntEnd
				
		b ProcessInt
	
	ProcessIntEnd:
		move $t0, $s0		# $t0 = $s0
		move $s1, $t4		# $s1 = $t4 The counter in integer
		move $s2, $t5		# $s2 = $t5 The counter in bits
		
		# Print the counter in integer
		#move $a0, $t4
		#li $v0, 1
		#syscall
		
		# Print the counter in bits
		#move $a0, $t5
		#li $v0, 1
		#syscall
		
		
		move $t4, $s1
		addi $t4, $t4, 1
		la $t6, revarray	# $t6 = revarray[]
		mul $t5, $t4, 4		# $t5 has index in bits
		add $t6, $t6, $t5	# $t6 now has address of revarray[$t4] i.e. the last element of the array		
		#b LoopArray
		b LoopArrayName
	
	LoopArray:
		subi $t4, $t4, 1
		
		# Optimized code
		sub $t6, $t6, 4		# index--	# Traverse backward
		lw $t3, ($t6)		# revarray[index] now has value $t3, i.e. the remainder
		#add $t6, $t6, 4	# index++	# Traverse forward
		
		#move $t5, $t4
		#la $t6, revarray
		#add $t7, $t5, $t6
		#lw $t3, ($t7)
		#mul $t5, $t5, 4
		
		move $a0, $t3
		li $v0, 1
		syscall
		
		bnez $t4, LoopArray
		
		b Exit
	
	LoopArrayName:
		subi $t4, $t4, 1
		
		# Optimized code
		sub $t6, $t6, 4		# index--	# Traverse backward
		lw $t3, ($t6)		# revarray[index] now has value $t3, i.e. the remainder
		
		beq $t3, $zero, Int0
		# Else
		beq $t3, 1, Int1
		# Else
		beq $t3, 2, Int2
		# Else
		beq $t3, 3, Int3
		# Else
		beq $t3, 4, Int4
		# Else
		beq $t3, 5, Int5
		# Else
		beq $t3, 6, Int6
		# Else
		beq $t3, 7, Int7
		# Else
		beq $t3, 8, Int8
		# Else
		beq $t3, 9, Int9
		
	LoopArrayNameContinue:
		bnez $t4, PrintSpace
		
		b Exit

	PrintSpace:
		la $a0, space
		li $v0, 4
		syscall
		
		b LoopArrayName
		
	Int0:
		la $a0, zero
		li $v0, 4
		syscall
		
		b LoopArrayNameContinue
	
	Int1:
		la $a0, one
		li $v0, 4
		syscall
		
		b LoopArrayNameContinue
		
	Int2:
		la $a0, two
		li $v0, 4
		syscall
		
		b LoopArrayNameContinue
		
	Int3:
		la $a0, three
		li $v0, 4
		syscall
		
		b LoopArrayNameContinue
		
	Int4:
		la $a0, four
		li $v0, 4
		syscall
		
		b LoopArrayNameContinue
		
	Int5:
		la $a0, five
		li $v0, 4
		syscall
		
		b LoopArrayNameContinue
		
	Int6:
		la $a0, six
		li $v0, 4
		syscall
		
		b LoopArrayNameContinue
		
	Int7:
		la $a0, seven
		li $v0, 4
		syscall
		
		b LoopArrayNameContinue
		
	Int8:
		la $a0, eight
		li $v0, 4
		syscall
		
		b LoopArrayNameContinue
		
	Int9:
		la $a0, nine
		li $v0, 4
		syscall
		
		b LoopArrayNameContinue

	
	# Not used
	ReduceInt:
		div $t1, $t0, 10	# $t1 = $t0 / 10
		
		# Print Integer
		move $a0, $t1
		li $v0, 1
		syscall
		
		#b ProcessInt
		b Exit
	
	# Used for declaring revarray
	LengthInt:
		div $t6, $t6, 10	# $t6 is used for counter calculation
		add $t5, $t5, 1		# Increment counter, $t5
		bnez $t6, LengthInt	# $t5 has index in bytes
		mul $t5, $t5, 4		# $t5 has index in bits
	
	Exit:
		li $v0, 10
		syscall
