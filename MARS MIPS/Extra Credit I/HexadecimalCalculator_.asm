
# Raj Patel

.data
prompt: .asciiz "\nPlease enter an opcode and the correct arguments (use only capital letters and 32-bit): "

input: .space 21	# Allocate 21 bytes for string input

println: .asciiz "\n"

.text
main:
	la $a0, prompt
	li $v0, 4
	syscall
	
	addi $a1,$zero, 21		# Read max 20 characters. Reads (21-1) characters.
	la $a0, input			# Make the value of $a0 in label input
	li $v0, 8			# $a0 will have the input
	syscall
	
	add $t0, $zero, $a0		# $t0 is temporary address
	
	lb $t1($t0)			# Store the first character, the operator, in $t7
	
	beq $t1, '+', addHex
	beq $t1, '~', notHex
	beq $t1, '?', unsignedHex
	

addHex:
	jal readAndSub			# For the first value			
	jal unsigned			# For the first value
	
	add $s0, $zero, $s1		# Move the unsigned decimal input to $s0
	
	jal readAndSub			# For the second value
	jal unsigned			# For the second value
	
	add $s0, $s0, $s1
	
	li $v0, 4
	la $a0, println
	syscall
	
	li $v0, 34
	la $a0, ($s0)
	syscall
	
	li $v0, 4
	la $a0, println
	syscall
	
	j main
	
notHex:
	jal readAndSub
	jal unsigned
	
	sub $s1, $s1, 4294967295	# FFFFFFFF - unsigned = 4294967295 - unsigned
	mul $s1, $s1, -1		# Multiply $s1 by -1 because the previous statement made it negative, so to get positive
	# add $s0, $zero, $s1		# Move $s1 to $s0
	
	li $v0, 4
	la $a0, println
	syscall
	
	li $v0, 34
	la $a0, ($s1)
	syscall
	
	li $v0, 4
	la $a0, println
	syscall
	
	j main	

unsignedHex:
	jal readAndSub
	jal unsigned
	
	li $v0, 4
	la $a0, println
	syscall
	
	li $v0, 1
	la $a0, ($s1)
	syscall
	
	li $v0, 4
	la $a0, println
	syscall
	
	j main	

unsigned:	
	addiu $sp, $sp, -4		# Allocate 4 bytes for $ra
	sw $ra, ($sp)			# Store $ra in $sp
	
	# Check if they are greater than 9
	add $t9, $zero, $t1		# Move $t1 to $t9
	jal checkBig
	add $t1, $zero, $t5		# Move $t9 back to $t1
	
	add $t9, $zero, $t2		# Move $t2 to $t9
	jal checkBig
	add $t2, $zero, $t5		# Move $t9 back to $t2
	
	add $t9, $zero, $t3		# Move $t3 to $t9
	jal checkBig
	add $t3, $zero, $t5		# Move $t9 back to $t3
	
	add $t9, $zero, $t4		# Move $t4 to $t9
	jal checkBig
	add $t4, $zero, $t5		# Move $t9 back to $t4
	
	add $t9, $zero, $t5		# Move $t5 to $t9
	jal checkBig
	add $t5, $zero, $t9		# Move $t9 back to $t5
	
	add $t9, $zero, $t6		# Move $t6 to $t9
	jal checkBig
	add $t6, $zero, $t9		# Move $t9 back to $t6
	
	add $t9, $zero, $t7		# Move $t7 to $t9
	jal checkBig
	add $t7, $zero, $t9		# Move $t9 back to $t7
	
	add $t9, $zero, $t8		# Move $t8 to $t9
	jal checkBig
	add $t8, $zero, $t9		# Move $t9 back to $t8
	
	mul $s1, $t1, 268435456		# Multiply the first character with 268435456 and store in $s1
	mul $t2, $t2, 16777216		# Multiply the second character with 16777216
	add $s1, $s1, $t2		# Add $s1 and $t2 and store it to $s1
	mul $t3, $t3, 1048576		# Multiply the third character with 1048576
	add $s1, $s1, $t3		# Add $s1 and $t3 and store it to $s1	
	mul $t4, $t4,  65536		# Multiply the fourth character with 65536
	add $s1, $s1, $t4		# Add $s1 and $t4 and store it to $s1	
	mul $t5, $t5,  4096		# Multiply the fifth character with 4096
	add $s1, $s1, $t5		# Add $s1 and $t5 and store it to $s1	
	mul $t6, $t6,  256		# Multiply the sixth character with 256
	add $s1, $s1, $t6		# Add $s1 and $t6 and store it to $s1	
	mul $t7, $t7,  16		# Multiply the seventh character with 16
	add $s1, $s1, $t7		# Add $s1 and $t7 and store it to $s1	
	add $s1, $s1, $t8		# Add $s1 and $t8 and store it to $s1
	
	lw $ra, ($sp)			# Load $ra from $sp
	addiu $sp, $sp, 4		# Restore $sp, freeing the allocated space
	
	jr $ra

readAndSub:
	addi $t0, $t0, 2		# For skipping the operator and space, and then just space for addHex
	
	lb $t1($t0)			# Store the first character in $t1
	addi $t0, $t0, 1		# Shift to the next character
	lb $t2($t0)			# Store the second character in $t2
	addi $t0, $t0, 1		# Shift to the next character
	lb $t3($t0)			# Store the third character in $t3
	addi $t0, $t0, 1		# Shift to the next character
	lb $t4($t0)			# Store the fourth character in $t4
	addi $t0, $t0, 1		# Shift to the next character
	lb $t5($t0)			# Store the fifth character in $t5
	addi $t0, $t0, 1		# Shift to the next character
	lb $t6($t0)			# Store the sixth character in $t6
	addi $t0, $t0, 1		# Shift to the next character
	lb $t7($t0)			# Store the seventh character in $t7
	addi $t0, $t0, 1		# Shift to the next character
	lb $t8($t0)			# Store the eighth character in $t8
	
	addi $t1, $t1 -48		# Subtract 48 from the character in $t1
	addi $t2, $t2 -48		# Subtract 48 from the character in $t2
	addi $t3, $t3 -48		# Subtract 48 from the character in $t3
	addi $t4, $t4 -48		# Subtract 48 from the character in $t4
	addi $t5, $t5 -48		# Subtract 48 from the character in $t5
	addi $t6, $t6 -48		# Subtract 48 from the character in $t6
	addi $t7, $t7 -48		# Subtract 48 from the character in $t7
	addi $t8, $t8 -48		# Subtract 48 from the character in $t8
	
	jr $ra

checkBig:
	bgt $t5, 9, big9		# If $t5 > 9 then go to label big9
	jr $ra

big9:
	addi $t5, $t5, -7
	jr $ra

exit:
	li $v0, 10
	syscall
