	.data			#data Segment

numArray: .space 40	
.text 

main:

li $s6, 12
la $s5, numArray			#loads address of the array to $s5
li $t0, 1863
li $s7, 0

moduloLoop:
	j index					#creates array with individual digits of the entered number in order	
x:
	div $t1, $t0, 10			#set $t1 equal to $t0/10
	mul $t2, $t1, 10			#set $t2 equal to $t1*10
	sub $t3, $t0, $t2			#set $t3 equal to $t0-$t2
	move $t0, $t1				#set $t0 equal to $t1
	sw $t3, index($s5)			#set $s5 array at location of s6 value to value of $t3
	sub $s6, $s6, 4				#set $s6 equal to $s6-4
	bne $t0, $s7, moduloLoop	       	#if $t0 does not equal $s7 (0) goto moduloLoop else continue
	
	
	lw $a0, 0($s5)		#Moves value from $t7 to $a0
	li $v0, 1 		#Syscall #1 prints int in $a0
	syscall 		#Prints int in $a0
			
	lw $a0, 4($s5)		#Moves value from $t7 to $a0
	li $v0, 1 		#Syscall #1 prints int in $a0
	syscall 		#Prints int in $a0
	
	lw $a0, 8($s5)		#Moves value from $t7 to $a0
	li $v0, 1 		#Syscall #1 prints int in $a0
	syscall 		#Prints int in $a0
	
	lw $a0, 12($s5)		#Moves value from $t7 to $a0
	li $v0, 1 		#Syscall #1 prints int in $a0
	syscall 		#Prints int in $a0
	
exit:						#Exiting the program
	li $v0, 10 				#syscall #10: exit
	syscall 				#ends program

index:
	la $s6, index
	j x