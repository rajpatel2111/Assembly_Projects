.data

intro: .asciiz "Please enter an integer: "
iterat:  .asciiz "Iterative method: "
recursion:  .asciiz "Recursive method: "
newline:  .asciiz "\n"

.text 

main:

	li  $v0, 4
	la  $a0, intro  #intro
	syscall
	
	li $v0, 5
	syscall
	
	move $a0, $v0
	move $a1, $v0
	
	jal iterative #calling subroutine
 	add $s0, $v0,$zero


 
	# reading answer and printing answer 
	la $a0, iterat 
	li $v0, 4
 	syscall

 	li $v0, 1
 	move $a0, $s0
 	syscall
 	
 	la $a0, newline
	li $v0, 4
 	syscall
	
	
	
 ############recursive######################################	
 	jal recursive
	move $a1, $v1
	
	la $a0, recursion
	li $v0, 4
 	syscall

 	li $v0, 1
 	move $a0, $a1
 	syscall
 	
	li $v0, 10
	syscall

	
recursive:
	subiu $sp, $sp, 12  #subtracts 12 from stack pointer
	sw $ra, 0($sp)	#stores $ra 12 back in stack
	li $t1, 10
	div $a1, $t1 #dividing the integer by 10
 	mfhi $t2 #obtaining the reminder and setting it on $t2
 	mflo $t3  #sets quotient to $t3
 	add $s1, $s1,$t2 #adding the reminder to $s1 
 	move $a0, $t3  #moves quotient
 	beq $a0,0,exitr
 	sw $t2, 4($sp)  #stores word 4 back on the stack
 	sw $t3, 8($sp)
 	
	jal loopr
	
loopr:
 	 
	lw $t3, 8($sp)  #loads quotient from stack
	lw $t2, 4($sp)  #loads remainder
	
	move $a0, $t3  #moves quotient
	li $t1, 10 
	div $a0, $t1 #dividing the integer by 10 
	mfhi $t2 #obtaining the reminder and setting it on $t2
 	mflo $t3  #sets quotient to $t3
 	add $s1, $s1,$t2 #adding the reminder to $s1
 	sw $t2, 4($sp)  #stores remainder in SP -8 
 	
 	sw $t3, 8($sp)
	
	beq $t3,0,exitr
	jal loopr
	
exitr:

	
	lw $ra 0($sp)  #loads return address
	addiu $sp, $sp 12  #sets sp back to zero
	move $v1, $s1
	jr $ra
########################iterative###########################

iterative:
 	li $t1, 10 
	div $a0, $t1 #dividing the integer by 10
 	mfhi $t2 #obtaining the reminder and setting it on $t2
 	mflo $t3 #setting the quotient to $t3 
	add $s0, $s0,$t2 #adding the reminder to $s0 
	move $a0, $t3
 	beq $t3,0,exitloop
 	j iterative

 exitloop:

 	move $v0, $s0
 	jr $ra 

	 
