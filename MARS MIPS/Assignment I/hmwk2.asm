
# Raj Patel

#A.8 [5] <ÅòA.9> Using SPIM, write and test a program that reads in a positive integer using the SPIM system calls.
#If the integer is not positive, the program should terminate with the message ÅgInvalid EntryÅh;
#otherwise the program should print out the names of the digits of the integers, delimited by exactly one space.
#For example, if the user entered Åg728,Åh the output would be ÅgSeven Two Eight.Åh

.data
	prompt: .asciiz "\nEnter an integer: "
	invalid: .asciiz "Invalid Entry."
	
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
	
.text
	main:
	
	Prompt:
		# Print to console
		la $a0, prompt
		li $v0, 4
		syscall
		
	Input:
		# Input integer
		li $v0, 5
		syscall
		
	CheckInteger:
		# If the input is less than 0 then print "Invalid Entry"
		bltz $v0, invalid
		# Else
		beq $v0, $zero, i0
		# Else
		beq $v0, 1, i1
		# Else
		beq $v0, 2, i2
		# Else
		beq $v0, 3, i3
		# Else
		beq $v0, 4, i4
		# Else
		beq $v0, 5, i5
		# Else
		beq $v0, 6, i6
		# Else
		beq $v0, 7, i7
		# Else
		beq $v0, 8, i8
		# Else
		beq $v0, 9, i9
		
	i0:
		la $a0, zero
		li $v0, 4
		syscall
	
	i1:
		la $a0, one
		li $v0, 4
		syscall
		
	i2:
		la $a0, two
		li $v0, 4
		syscall
		
	i3:
		la $a0, three
		li $v0, 4
		syscall
		
	i4:
		la $a0, four
		li $v0, 4
		syscall
		
	i5:
		la $a0, five
		li $v0, 4
		syscall
		
	i6:
		la $a0, six
		li $v0, 4
		syscall
		
	i7:
		la $a0, seven
		li $v0, 4
		syscall
		
	i8:
		la $a0, eight
		li $v0, 4
		syscall
		
	i9:
		la $a0, nine
		li $v0, 4
		syscall
