
.data
	hello: .asciiz "Hello World!"

.text
	la $a0, hello	# Load the address of hello into $a0
	li $v0, 4		# Print $a0
	syscall
	
	li $v0, 10		# Exit code
	syscall
