.data
prompt:	.asciiz	"put in the number of fibonacci numbers you want to see: "
line:	.asciiz "\n"
space:	.asciiz " "
itre:	.asciiz	"this is the iteration output"
recu:	.asciiz "this is the recursive output"

.text
start:	li $t0,0
	li $t1,1
	la $ra, endr
	la $a0,prompt
	li $v0,4
	syscall
	li $v0,5
	syscall
	add $t9,$zero,$v0
	add $a0,$t0,$zero
	li $v0,1
	syscall
	la $a0, space
	li $v0,4
	syscall
	li $v0,1
	add $a0,$t1,$zero
	syscall
	li $v0,4
	la $a0,space
	syscall
	sw $t0, ($sp)
	sw $t1, -4($sp)
	addi $sp,$sp,-8
	li $t8,2
itr:	lw $t2, 4($sp)		# for iteration i assume that the equation is f(n)=f(n-1)+f(n-2) where to get those values i start at f(1) and move on from there.
	lw $t3, 8($sp)
	add $a0,$t3,$t2
	sw $a0, ($sp)
	addi $sp,$sp,-4
	li $v0,1
	syscall
	la $a0, space
	li $v0,4
	syscall
	addi $t8,$t8,1
	bne $t9,$t8,itr
	mul $t6,$t9,4		# i may want to take these lines out for the recursive step since recursion starts
	add $sp,$sp,$t6		# at the last number i need and then back track if needed these lines will be noted
	
	la $a0,line
	li $v0,4
	syscall
	
			# i have stored in first two spaces of the stack 0 and 1 this will be f(0) and f(1)
			# now my thought is to recursively do this i need to make a jal over and over to get back to starting numbers
			# at which point it will move into a new loop for calculating the numbers back up the list
			# as it does this i'm going to print the sequence up to that point
			# i need a start to my stack but it needs to be a multiple of 12 to make it work		
	mul $t6,$t9,-12
	add $sp,$sp,$t6		# this should set it to the top of the list for the stack		
	addi $sp,$sp,8		
				# to stop the jal $t4=0 and $t5=1 or the first numbers in the stack
rec:	lw $t4, 4($sp)	
	lw $t5, 0($sp)
	sw $ra, 8($sp)		
	addi $sp,$sp,12		# im moving down the list til i get to the 0 and 1 at the bottom
	beqz $t4,ch1
cont:	jal rec
jend:	addi $sp,$sp,-12	# with how this works the 4th position will be f(n-2) and the 8th position will be f(n-1)
	lw $ra, 8($sp)		# then the f(n) value will be stored in the 20th position which will be come the new f(n-1)
	lw $t4, 4($sp)		# for the next value in the sequence
	lw $t5, ($sp)
	add $t6,$t4,$t5
	sw $t6, -8($sp)		# when i add 12 to the stack it will then be called on by 8
	
	sw $t4, -12($sp)		# i will need this to add the next set of numbers
	jr $ra	
endr:	mul $t6,$t9,12			# now all i care about is printing the every 12th value starting on position 4
	add $sp,$sp,$t6
	addi $sp,$sp,12
	li $t8,0
prec:	lw $t1, -36($sp)
	add $a0,$t1,$zero
	li $v0,1
	syscall
	la $a0,space
	li $v0,4
	syscall
	addi $sp,$sp,-12		# because this was built on an every 12 values system
	addi $t8,$t8,1
	beq $t8,$t9,end
	j prec
	
end:	li $v0,10
	syscall

ch1:	beqz $t5,cont
	beq $t5,1, jend	# i feel this line could interupt the code if it isnt below the syscall 10
	mul $t6,$t9,-12
	add $sp,$sp,$t6
	#addi $sp,$sp,-4
	j cont	
