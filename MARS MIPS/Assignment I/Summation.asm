
# Raj Patel

# Summation

#A.6 [5] <˜A.9> Using SPIM, write and test an adding machine program that repeatedly reads in integers and adds them into a running sum.
#The program should stop when it gets an input that is 0, printing out the sum at that point.
#Use the SPIM system calls described on pages A-43 and A-45.

.data
	prompt: .asciiz "Enter an integer: "
	result: .asciiz "Total: "

.text
	main:
		j Prompt
		
		j Input
		
	Prompt:
		# Print to console
		la $a0, prompt
		li $v0, 4
		syscall
		
	Input:
		# Input integer
		li $v0, 5
		syscall
		
		# Exit if input is 0
		beqz $v0, Exit
		# Else
		move $t0, $v0		# Input is now in $t0		
		add $t1, $t1, $t0	# Add $t1 = $t1 + $t0
		
		j Prompt			# Recall the Prompt
		
	Exit:
		# Display summation
		la $a0, result
		li $v0, 4
		syscall
		
		la $a0, ($t1)
		li $v0, 1
		syscall
		
		# Exit the program
		li $v0, 10
		syscall
