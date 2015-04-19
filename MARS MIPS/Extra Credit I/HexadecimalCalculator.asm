
# Raj Patel

.data
prompt: .asciiz "\nPlease enter an opcode and the correct arguments (use only capital letters and 16-bit): "

input: .space 16	# Allocate 16 bytes for string input

println: .asciiz "\n"

.text
main:
	la $a0, prompt
	li $v0, 4
	syscall
	
	addi $a1,$zero, 16		# Read max 15 characters. Reads (16-1) characters.
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
	
	addi $s1, $s1, -65535		# FFFF - unsigned = 65535 - unsigned
	# mul $s1, $s1, -1		# Multiply $s1 by -1 because the previous statement made it negative, so to get positive
	sub $s1, $zero, $s1		# Subtract $s1 from $zero, so $s1 = $zero - $s1, because $s1 is negative
		
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
	add $t5, $zero, $t1		# Move $t1 to $t5
	jal checkBig
	add $t1, $zero, $t5		# Move $t5 back to $t1
	
	add $t5, $zero, $t2		# Move $t2 to $t5
	jal checkBig
	add $t2, $zero, $t5		# Move $t5 back to $t2
	
	add $t5, $zero, $t3		# Move $t3 to $t5
	jal checkBig
	add $t3, $zero, $t5		# Move $t5 back to $t3
	
	add $t5, $zero, $t4		# Move $t4 to $t5
	jal checkBig
	add $t4, $zero, $t5		# Move $t5 back to $t4
	
	mul $s1, $t1, 4096		# Multiply the first character with 4096 and store in $s1
	mul $t2, $t2, 256		# Multiply the second character with 256
	add $s1, $s1, $t2		# Add $s1 and $t2 and store it to $s1
	mul $t3, $t3, 16		# Multiply the third character with 16
	add $s1, $s1, $t3		# Add $s1 and $t3 and store it to $s1
	add $s1, $s1, $t4		# Add $s1 and $t4 and store it to $s1
	
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
	
	addi $t1, $t1 -48		# Subtract 48 from the character in $t1
	addi $t2, $t2 -48		# Subtract 48 from the character in $t2
	addi $t3, $t3 -48		# Subtract 48 from the character in $t3
	addi $t4, $t4 -48		# Subtract 48 from the character in $t4
	
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
