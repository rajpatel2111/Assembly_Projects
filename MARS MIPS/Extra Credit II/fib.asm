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

    	addi        $sp, $sp, -12
    	sw          $v0, 0($sp)
    	sw          $ra, 8($sp)
    	jal         recursive
        
	lw          $ra, 8($sp)
	lw          $s0, 4($sp)
	addi        $sp, $sp, 12
	
	la $a0, text_recursion
	li $v0, 4
	syscall
	
	la          $a0, series
	li          $v0, 4
	syscall
	
	move        $a0, $s0
	li          $v0, 1
	syscall
    	
	li, $v0, 10
	syscall
	
iterative:
	beq $s0, 0, iterative_exit_1
	subi $s0, $s0, 1
	
	add $t0, $s2, $zero
	add $s2, $s1, $s2
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

recursive:
    lw          $t0, 0($sp)
    # if n > 46, return 0 and don't overflow 32-bit register
    bge         $t0, 46, return0

    # base case
    ble         $t0, 0, return0
    beq         $t0, 1, return1

    # fibonacci(n - 1)
    addi        $t0, $t0, -1
    addi        $sp, $sp, -12
    sw          $t0, 0($sp)
    sw          $ra, 8($sp)
    jal         recursive
    # reload (n - 1)0
    lw          $t0, 0($sp)
    # get return value from fibonacci(n - 1)
    lw          $t1, 4($sp)
    lw          $ra, 8($sp)
    addi        $sp, $sp, 12
    # save the return value from fibonacci(n - 1) on the stack
    addi        $sp, $sp, -4
    sw          $t1, 0($sp)

    # fibonacci(n - 2)
    addi        $t0, $t0, -1
    addi        $sp, $sp, -12
    sw          $t0, 0($sp)
    sw          $ra, 8($sp)
    jal         recursive
    # get return value from fibonacci(n - 2)
    lw          $t2, 4($sp)
    lw          $ra, 8($sp)
    addi        $sp, $sp, 12
    lw          $t1, 0($sp)
    addi        $sp, $sp, 4

    # $t3 = fibonacci(n - 1) + fibonacci(n - 2)
    add         $t3, $t1, $t2
    sw          $t3, 4($sp)
    
    jr          $ra

return0:
    sw          $0, 4($sp)
    jr          $ra  

return1:
    li          $t0, 1
    sw          $t0, 4($sp)
    jr          $ra
