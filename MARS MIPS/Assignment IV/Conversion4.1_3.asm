
# Raj Patel

# 1) Write a MIPS assembly language program and test it on MARS that does the followings:
# Prompt user for an integer. 
# If input is 1, perform UNSIGNED 16-bit hexa-to-decimal conversion by prompting user for a 4 digit hexadecimal number,
# e.g. F0F1, then print the input number in decimal.
# If input is 2, perform SIGNED 16-bit hexa-to-decimal conversion by prompting user for a 4 digit hexadecimal number,
# e.g. F0F1, then print the input number in decimal with the '-' character if the input is negative.
# Your test should include at least on conversion that results in a negative decimal number.
# If input is 3, prompt for four integers that are between 65 and 90 inclusive, then print out a string of 4 ASCII characters
# corresponding the the input integers. For instance if user inputs '65 66 67 and 68'  the program would print  'ABCD'.
# Assuming that we have only syscall #4 and do not have syscall #11.
# If input is 0 stop.
# Hint: This is typical case of 'switch/case' construct in high-level language. For the 3rd bullet,
# 'A' to 'Z' can be stored in memory as a table (array) for conversion. E.g. T[0] contains 'A', T[1] contains 'B' etc...
# using the .byte directive. 
# Submit your code and screen shot(s) of test runs as stated in the syllabus.

# 2) Translate the following (pseudo) branching instructions into native instructions (using native instructions slt, bne, beq and register $zero):
# less than    blt $s1, $s2, Label
# less than or equal to   ble $s1, $s2, Label
# greater than    bgt $s1, $s2, Label
# great than or equal to    bge $s1, $s2, Label
# Hint: You can verify your answers using MARS. Please try to translate manually fist, then verify.
# You still get full credit if your translation is not correct but you document in your submission WHY you think it is incorrect.

.data
prompt: .asciiz "\nPlease input integers 0, 1, 2, or 3: "
pUnsign: .asciiz "\nPlease input a 4 digit hexadecimal number using only capital letters: "
pSign: .asciiz "\nPlease input a 4 digit hexadecimal number using only capital letters: "
pASCII: .asciiz "\nPlease input 4 integers that are between 65 and 90 inclusive: "

input: .space 64		# Allocate 64 bytes for string input

table: .byte 'A', 0, 'B', 0, 'C', 0, 'D', 0, 'E', 0, 'F', 0, 'G', 0, 'H', 0, 'I', 0, 'J', 0, 'K', 0, 'L', 0, 'M', 0, 'N', 0, 'O', 0, 'P', 0, 'Q', 0, 'R', 0, 'S', 0, 'T', 0, 'U', 0, 'V', 0, 'W', 0, 'X', 0, 'Y', 0, 'Z', 0

println: .asciiz "\n"

.text
main:
	la $a0, prompt
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	beqz $v0, exit
	beq $v0, 1, unsigned
	beq $v0, 2, signed
	beq $v0, 3, ascii
	

# If input is 1, perform UNSIGNED 16-bit hexa-to-decimal conversion by prompting user for a 4 digit hexadecimal number,
# e.g. F0F1, then print the input number in decimal.
unsigned:
	la $a0, pUnsign
	li $v0, 4
	syscall
	
	addi $a1,$zero, 5	# Read max 4 characters. Reads (5-1) characters.
	la $a0, input		# Make the value of $a0 in label input
	li $v0, 8			# $a0 will have the input
	syscall
	
	# la $a0, input		# Make the value of $a0 in label input
	# move $s0, $a0		# Backups the input, $a0, to $s0	
	add $t0, $zero, $a0	# $t0 is temporary address
	
	lb $t1($t0)			# Store the first character in $t1
	addi $t0, $t0, 1	# Shift to the next character
	lb $t2($t0)			# Store the second character in $t1
	addi $t0, $t0, 1	# Shift to the next character
	lb $t3($t0)			# Store the third character in $t1
	addi $t0, $t0, 1	# Shift to the next character
	lb $t4($t0)			# Store the fourth character in $t1
	
	addi $t1, $t1 -48	# Subtract 30 HEX, 48 DEC from the character in $t1
	addi $t2, $t2 -48	# Subtract 30 HEX, 48 DEC from the character in $t2
	addi $t3, $t3 -48	# Subtract 30 HEX, 48 DEC from the character in $t3
	addi $t4, $t4 -48	# Subtract 30 HEX, 48 DEC from the character in $t4
	
	# We need to check if $t1, $t2, $t3, $t4 is greater than 9. To do so we need a branch unless you can find another alternative.
	# Set Less Than may or may not work as it for boolean. The problem with branching is, say $t1 is greater than 9,
	# if you branch then what register will you use to make it work? If you move $t1 to $t5 then after the branch statement ... One sec...
	# I think I figured it out.
	
	# Check if they are greater than 9 HEX, 9 DEC
	
	add $t5, $zero, $t1	# Move $t1 to $t5
	jal checkt1
	add $t1, $zero, $t5	# Move $t5 back to $t1
	
	add $t5, $zero, $t2	# Move $t2 to $t5
	jal checkt2
	add $t2, $zero, $t5	# Move $t5 back to $t2
	
	add $t5, $zero, $t3	# Move $t3 to $t5
	jal checkt3
	add $t3, $zero, $t5	# Move $t5 back to $t3
	
	add $t5, $zero, $t4	# Move $t4 to $t5
	jal checkt4
	add $t4, $zero, $t5	# Move $t5 back to $t4
	
	# add $t5, $zero, $t1	# Move $t1 to $t5
	# bgt $t5, 9, big9	# If $t5 > 9 then go to label big9
	# add $t1, $zero, $t5	# Move $t5 back to $t1
	
	# add $t5, $zero, $t2	# Move $t2 to $t5
	# bgt $t5, 9, big9	# If $t5 > 9 then go to label big9
	# add $t2, $zero, $t5	# Move $t5 back to $t2
	
	# add $t5, $zero, $t3	# Move $t3 to $t5
	# bgt $t5, 9, big9	# If $t5 > 9 then go to label big9
	# add $t3, $zero, $t5	# Move $t5 back to $t3
	
	# add $t5, $zero, $t4	# Move $t4 to $t5
	# bgt $t5, 9, big9	# If $t5 > 9 then go to label big9
	# add $t4, $zero, $t5	# Move $t5 back to $t4
	
	# la $t0, 0($s0)
	# sll $t0, $a0, 4
	
	#la $t0, 0($s0)
	
	mul $s1, $t1, 4096		# multiply the first character with 4096 and store in $s1
	mul $t2, $t2, 256		# multiply the second character with 256 and add that value to $s1
	add $s1, $s1, $t2		
	mul $t3, $t3, 16		# multiply the third character with 16 and add that value to $s1
	add $s1, $s1, $t3		
	add $s1, $s1, $t4
	
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

signed:

ascii:

checkt1:
	bgt $t5, 9, big9	# If $t5 > 9 then go to label big9
	jr $ra

checkt2:
	bgt $t5, 9, big9	# If $t5 > 9 then go to label big9
	jr $ra
	
checkt3:
	bgt $t5, 9, big9	# If $t5 > 9 then go to label big9
	jr $ra
		
checkt4:
	bgt $t5, 9, big9	# If $t5 > 9 then go to label big9
	jr $ra
	
big9:
	addi $t5, $t5, -7
	jr $ra

exit:
	li $v0, 10
	syscall
