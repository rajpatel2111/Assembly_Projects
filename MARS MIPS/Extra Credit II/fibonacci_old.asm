.data

input: .asciiz "\nEnter number: "
text_iteration: .asciiz "\nIterative: "
text_recursion: .asciiz "\nRecursive: "
series: .asciiz "\nThe series is: "
space: .asciiz " "

.text

main:
	la $a0, input
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	# RPP START
	add $t9, $zero, $v0	# $t9 will have the input
	# RPP END
	
	subi $s0, $v0, 1
	add $s7, $s7, $s0
	
	addi $s1, $s1, 1
	addi $s2, $s2, 1
	
	la $a0, text_iteration
	li $v0, 4
	syscall
	
	la $a0, series
	li $v0, 4
	syscall
	
	addi $a0, $zero, 1
	li $v0, 1
	syscall
	
	jal iterative
	
	move $s1, $s7
	# add $v0, $s1, $zero
	addi $v0, $s1, 1
	
	la $a0, text_recursion
	li $v0, 4
	syscall
	
	la          $a0, series
	li          $v0, 4
	syscall
	
	move        $a0, $s0
	li          $v0, 1
	syscall
    	
    	jal recurse
    	
	li, $v0, 10
	syscall
	
iterative:
	beq $s0, 0, iterative_exit_1
	subi $s0, $s0, 1
	
	add $t0, $s2, $zero
	add $s2, $s2, $s1
	add $s1, $t0, $zero
	
	la $a0, space
	li $v0, 4
	syscall
	
	add $a0, $s1, $zero
	li $v0, 1
	syscall
	
	bnez $s0, iterative
	
	jr $ra
	
iterative_exit_1:
	jr $ra

return0:
    sw          $0, 4($sp)
    jr          $ra  

return1:
    li          $t0, 1
    sw          $t0, 4($sp)
    jr          $ra

recurse:
	addiu $sp, $sp, -32
	sw $ra, 0($sp)
	# if n > 46, return 0 and don't overflow 32-bit register
	# CHANGE THIS LATER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	bge $t0, 46, return0
	
	# base case
	ble $t0, 0, return0
	beq $t0, 1, return1
	
	add $t1, $zero, 0	# First
	add $t2, $zero, 1	# Second
	
	beqz $t9, recurse_end
	add $t3, $t1, $t2	# Sum
	add $t1, $zero, $t2	# First = Second
	add $t2, $zero, $t3	# Second = Sum
	
	li $v0, 1
	add $a0, $zero, $t3
	syscall			# printf("%1d ", sum);
	
	addi $t9, $t9, -1	# n - 1
	jal recurse
	
recurse_end:
	lw $ra, 0($sp)
	addiu $sp, $sp, 32
	jr $ra


FIB:
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s1, 4($sp)
	sw $a0, 8($sp)
	sw $a0, $a0, 1
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	


