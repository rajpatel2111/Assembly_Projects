
# Raj Patel

# Write a MIPS assembly language program that
# 1. prompts the user for a positive integer N.
# 2. calls a subroutine sum_iterative, then displays the returned value
# 3. calls a subroutine sum_recursive, then displays the returned value
# Subroutine sum_iterative gets N as the input parameter and calculates the sum of its decimal digits iteratively
# (i.e. non-recursive) then returns the result. Subroutine sum_recursive does the same but uses recursion.
# The program should also display a string before calling each subroutine to identify which version it is calling
# (i.e. iterative or recursive).
# Can you tell which version runs faster?

.data
prompt: .asciiz "\nPlease enter a positive integer: "
resIterative: .asciiz "\nThe iterative sum is: "
resRecursive: .asciiz "\nThe recursive sum is: "

.text
main:
	li $v0, 4
	la $a0, prompt
	syscall
	
	li $v0, 5
	syscall
	
	add $s0, $zero, $v0	# Move the input to $s0	for backup
	
	add $a0, $zero, $s0	# Move the input to $a0
	jal sum_iterative
	j exit


modulusAndSum:
	addi $t1, $zero, 10	# Used for overflow division
	div $a0, $t1		# Overflow division
	mflo $a0		# Store quotient to $a0 for the next cycle
	mfhi $t2		# Store remainder to $t2
	add $v1, $v1, $t2	# Add the remainder to $v0
	# jr $ra

checkQuot0:
	bnez $a0, modulusAndSum	# If the quotient is not 0 then perform the next cycle
	jr $ra
	
sum_iterative:
	addiu $sp, $sp, -4	# Allocate 4 byte on the stack for the $ra
	sw $ra, 0($sp)		# Store the $ra on the stack pointer
	jal checkQuot0		# Check if the quotient is 0
	j exitIterative

exitIterative:
	li $v0, 4
	la $a0, resIterative
	syscall
	
	li $v0, 1
	add $a0, $zero, $v1
	syscall
	
	lw $ra, 0($sp)	
	jr $ra
	
sum_recursive:
	addiu $sp, $sp, -12	# Allocate 12 bytes onto the stack for $ra, quotient and remainder
	sw $ra 0($sp)		# Store the return address onto the stack pointer
	jal modulusAndSum
	sw $t2, 4($sp)		# Store the remainder to the stack pointer
	sw $a0, 8($sp)		# Store the quotient in the stack pointer
	j checkQuot0Recurse
	
checkQuot0Recurse:
	lw $a0, 8($sp)		# Load the quotient from the stack pointer
	lw $t2, 4($sp)		# Load the remainder from the stack pointer
	jal checkQuot0		# Check if the quotient is 0
	sw $t2, 4($sp)		# Store the remainder to the stack pointer
	sw $a0, 8($sp)		# Store the quotient in the stack pointer
	
	lw $ra, 0($sp)
	jr $ra
	
exit:
	li $v0, 10
	syscall	
