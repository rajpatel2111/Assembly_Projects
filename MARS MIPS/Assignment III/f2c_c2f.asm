
# Raj Patel

# 1) Extend the F2C program posted on eLearning to add a C2F function and to
# give the user a choice: F2C or C2F then carry out the conversion accordingly.
# Show your program in action using a screen capture of MARS (per the syllabus).
# 2) Convert the following MIPS instructions to machine code (i.e. binary format)
# by hand (shows your work, refer to slide #16 of session 9).
# Then use MARS to verify your result.
# For this cut-n-paste the 'Text Segment' pane of MARS's 'Execute' tab that
# shows the machine code for each instruction to your Word document.
# add $t0, $s1, $s2		# R-format
# addi $t0, $t0, -64	# I-format, arithmetic
# lw $t1, 8($s3)		# I-format, data transfer

.data
# constants
five: .float 5.0
nine: .float 9.0
tt2:  .float 32.0
# strings
prompt: .asciiz "\nPress 1 for F to C. Press 2 for C to F. Press 0 to Exit. "
promptF: .asciiz "\nWhat is degree in F: "
resF: .asciiz "\nDegree in C is: "
promptC: .asciiz "\nWhat is degree in C: "
resC: .asciiz "\nDegree in F is: "
error: .asciiz "\nPlease input either integer 1 or integer 2."

# program
.text
main:
	li $v0, 4 # print a string
	la $a0, prompt
	syscall

	li $v0, 5
	syscall
	
	beqz $v0, exit
	beq $v0, 1, f2c_Handle
	beq $v0, 2, c2f_Handle
	j error_Handle


f2c_Handle:
	li $v0, 4 # print a string
	la $a0, promptF
	syscall
	#
	li $v0, 6 # read a single fp number, result will be in $f0
	syscall
	#
	jal f2c  # call the conversion routine, $f0 contains F  result returnee in $f0
	#
	li $v0, 4 # print a string
	la $a0, resF
	syscall
	#
	li $v0, 2 # print a float
	mov.s $f12, $f0 # move result (C) to $f12
	syscall
	j main # loop

#  function to do f2c conversion
f2c:
	lwc1  $f16, five
	lwc1  $f18, nine
	div.s $f16, $f16, $f18 # 5/9 in $f16
	lwc1  $f18, tt2
	sub.s $f18, $f0, $f18 # F - 32.0
	mul.s $f0,  $f16, $f18
	jr    $ra


c2f_Handle:
	li $v0, 4 # print a string
	la $a0, promptC
	syscall
	#
	li $v0, 6 # read a single fp number, result will be in $f0
	syscall
	#
	jal c2f  # call the conversion routine, $f0 contains C result returnee in $f0
	#
	li $v0, 4 # print a string
	la $a0, resC
	syscall
	#
	li $v0, 2 # print a float
	mov.s $f12, $f0 # move result (F) to $f12
	syscall
	j main # loop

#  function to do c2f conversion
c2f:
	lwc1  $f16, five
	lwc1  $f18, nine
	div.s $f16, $f18, $f16 # 9/5 in $f16
	lwc1  $f18, tt2
	mul.s $f16, $f0, $f16  # C * (9/5)
	add.s $f0,  $f16, $f18
	jr    $ra

error_Handle:
	la $a0, error
	li $v0, 4
	syscall
	j main

exit:
	li $v0, 10
	syscall
