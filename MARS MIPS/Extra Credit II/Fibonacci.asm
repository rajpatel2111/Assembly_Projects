
# Raj Patel

.data
prompt:	.asciiz	"\nPlease input an integer for the Fibonacci sequence : "
space:	.asciiz " "
resIterative: .asciiz "\nIterative"
resRecursive: .asciiz "\nRecursive"
result:	.asciiz "\nThe Fibonacci sequence is: "

.text
main:
	li $t0, 0
	li $t1, 1
	la $ra, endRecursive
	
	la $a0, prompt
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	add $s0, $zero, $v0	# Save the input in $s0
	
	la $a0, resIterative	# Print iterative
	li $v0, 4
	syscall
	
	la $a0, result
	li $v0, 4
	syscall
	
	add $a0, $zero, $t0	# Print $t0
	li $v0,  1
	syscall
	
	la $a0, space
	li $v0, 4
	syscall
	
	add $a0, $zero, $t1	# Print $t1
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	sw $t0, ($sp)		# Store 0
	sw $t1, -4($sp)		# Store 1
	addi $sp, $sp, -8	# Allocate 8 bytes on the stack
	li $t7, 2		# $t7 is the counter

iterative:
	# for iteration i assume that the equation is f(n)=f(n-1)+f(n-2) where to get those values i start at f(1) and move on from there.
	lw $t2, 4($sp)		# Load first number
	lw $t3, 8($sp)		# Load second number
	
	add $a0, $t3, $t2	# Add the two previous values, $t2 and $t3, and store them in $a0
	sw $a0, ($sp)		# Store $a0 in stack
	addi $sp, $sp, -4	# Allocate 4 bytes for the stack
	
	li $v0, 1
	syscall
	
	la $a0, space
	li $v0, 4
	syscall
	
	addi $t7, $t7, 1	# Increment the counter, $t7
	bne $s0, $t7, iterative	# Iterate until $t7 = $s0, the requested sequence value
	mul $t6, $s0, 4
	add $sp, $sp, $t6
	
	mul $t6, $s0, -12	# Calculate all the required stack
	add $sp, $sp, $t6	# Allocate all the required stack
	addi $sp, $sp, 8

recursive:
	lw $t4, 4($sp)		# Load first number
	lw $t5, 0($sp)		# Load second number
	sw $ra, 8($sp)		# Store the return address in the stack pointer
	addi $sp, $sp, 12	# Go until it reaches 0 and 1 at the bottom of the stack
	beqz $t4, check		# If $t4 is 0 then go to check

continue:
	jal recursive

endR:
	addi $sp, $sp, -12	# Allocate 12 bytes on the stack
	
	lw $ra, 8($sp)		# Load the return address from the stack
	lw $t4, 4($sp)		# Load $t4 from the stack
	lw $t5, ($sp)		# Load $t5 from the stack
	
	add $t6, $t4, $t5
	
	sw $t6, -8($sp)		# Store $t6 on the stack
	sw $t4, -12($sp)	# Store $t4 on the stack
	
	jr $ra

check:
	beqz $t5, continue
	beq $t5, 1, endR
	mul $t6, $s0, -12	# Calculate all the required stack
	add $sp, $sp, $t6	# Allocate all the required stack
	j continue

endRecursive:
	mul $t6, $s0, 12	# Calculate all the required stack
	add $sp, $sp, $t6	# Restore all the required stack
	addi $sp, $sp, 12	# Restore the stack
	
	li $t7, 0		# Reset the counter, $t7
	
	la $a0, resRecursive	# Print recursive
	li $v0, 4
	syscall
	
	la $a0, result
	li $v0, 4
	syscall

printRecursive:
	lw $t1, -36($sp)
	
	add $a0, $zero, $t1	# Save $t1 to $a0
	li $v0, 1
	syscall
	
	la $a0, space
	li $v0, 4
	syscall
	
	addi $sp, $sp, -12	# Restore the stack
	addi $t7, $t7, 1	# Increment the counter, $t7
	beq $t7, $s0, exit
	j printRecursive

exit:
	li $v0, 10
	syscall
