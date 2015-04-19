######
#INSTRUCTIONS: Keep MIPS, data.txt, and FILE.asm in the same folder for it to work.

## This Program maches all occurences of a given string with a given set of string in a
## file. For eac h string in the file it prints yes if the word in the file matches
## with the userInput and No if it does not.

## A sample input file is attached for file input format.
## 0 marks the end of the file and the words are separated by spaces.
######

# .include "project_include.asm"

.data
myarray: .space 100
time: .asciiz "Time left: "
sameWordError: .asciiz "You have already entered that word!\nSeconds left: "
gameOver: .asciiz "0\nSorry, your'e out of time! \nGAME OVER! \nThanks for playing. :)"
msg: .asciiz "\nPlease enter your word: "
r: .asciiz "correct!"
w: .asciiz "incorrect!"

fnf:	.ascii "The file was not found: "  
file:	 .asciiz "data.txt"
newLine: .asciiz "\n"
space_:  .asciiz " "
wrd: 	.asciiz "apple"
wrd2:   .asciiz ""

#####
yes: .asciiz "GOOD JOB! You get 10+ seconds!\nSeconds left: "
score: .asciiz "\nSCORE: "
no: .asciiz "\nNOPE. That doesn't seem right!\nTry a different word maybe.\nNOTE: All words entered MUST be in upper-case only.\nSeconds left: "

userInput: .asciiz "Awesome"

##right: .asciiz "Hello World World World 0"
######

cont:	.ascii  "" #File contents: 
#hello:	.ascii "Hello World!"
buffer: .space 1024
 
.text

run:	
	##la $t1,  ## user input is being stored here
	
# Open File
open:
	li	$v0, 13		# Open File Syscall
	la	$a0, file	# Load File Name
	li	$a1, 0		# Read-only Flag
	li	$a2, 0		# (ignored)
	syscall
	move	$s6, $v0	# Save File Descriptor
	blt	$v0, 0, err	# Goto Error
 
# Read Data
read:
	li	$v0, 14		# Read File Syscall
	move	$a0, $s6	# Load File Descriptor
	la	$a1, buffer	# Load Buffer Address
	li	$a2, 1024	# Buffer Size
	syscall
 
# Print Data
print:
	#li	$v0, 4		# Print String Syscall
	#la	$a0, cont	# Load Contents String
	#syscall
	#li	$v0, 4		# Print String Syscall
	#la	$a0, hello
	#syscall

#####################

.text

li $v0, 42  ##This
li $a1, 20 ##Code
syscall ## generates 
## random int 0 or 1 ## in $a0



addi $s0,$a0,'1' ## $s0 contains 1 or 2
la  $t1, cont ## $t1 has contents of the file


addi $s0,$a0,'1' ## random int is in $S0


loop1:
	lb  $t3, 0($t1) ## takes 1st char of file and stores in $t3
	addi $t1,$t1,1
	bne $t3,$s0, loop1

loop2:
	lb  $t3, 0($t1) ## takes 1st char of file and stores in $t3
	
	li $v0, 11
	move $a0, $t3
	syscall
	
	addi $t1,$t1,1
	bne $t3,'*', loop2

move $s0,$t1	

li $s1,-1
li $t6,60
li $t7,0
move $s6,$t1
li $s2,0

input:
	
	bgt $t6,0,jp
	
	li $v0,4
	la $a0, gameOver
	syscall
	
	j done
######################################TIME	
	jp:
	move $s3,$s1 ##prev time in $s3
	
	li $v0, 30 ##end time
	syscall    

	div $a0,$a0,1000 ##divide it by 1000
	mflo $s1	##stop time in s1

	beq $s3,-1,jump
			
	sub $s2,$s1,$s3 ##s2 = s1 - s0 
	sub $t6,$t6,$s2
	
	ble $t6,0,one
	li $v0, 1 
	move $a0,$t6 
	syscall
	j jump
	one:
	li $t9,1
	li $v0, 1 
	move $a0,$t9 
	syscall
	
###################################								
jump:	
	li $v0,4
	la $a0, score
	syscall
	
	li $v0,1
	move $a0,$v1
	syscall																													

li $v0, 4
la $a0,msg ## display message
syscall	

li $v0,8
li $a1,25
la $a0, userInput
syscall


# $t0 will be the parameter asciiz
# $t1 will be the asciiz from the file

la  $t0, userInput ## $t0 has user input
move $t1,$s0
###la  $t1, cont ## $t1 has contents of the file

## $t0, $t1 --> contains  the above strings
## $t2,$t3 --> contains chars of the strings (extracted below in loop) one by one
## $t4,$t5 --> counter 

loop:
	lb  $t3, 0($t1) ## takes 1st char of file and stores in $t3
	beq $t3,' ', reset
	
	lb  $t2, 0($t0) ## takes 1st char of user input and stores in $t2
	
	bne $t2,$t3, ncount  ## if(t2!=t3) goto ncount

	addi $t4,$t4,1    ## c1++ only if the flow hasn't gone to n count
	## T4++ happers as long as the char t3 extracted from file = char t2 extracted from word
	## so basically we are comparing each character in the two strings one by one 
ncount:
	addi $t5,$t5,1 ## c2++ this counter would increment unconditionally and keeps trak of 
	## the size of the word extracted

	addi $t0, $t0, 1  ## increment file and user input pointers
	addi $t1, $t1, 1  ## i++
	
	beq $t3, '0', exit_ ## if 0 is found exit
	
	j loop

reset:
	bne $t4,$t5,nfound ## check to see if the count of number of same characters same is the same as the 
	## size of the word formed
	## if true, the word is found else
	## not found
	
found:
	sub $t5,$t1,$s6	
	sub $t4,$t5,$t4
	jal exists
	
	beq $s4, 1, true
	
	sb $t4,myarray($t7)
	addi $t7,$t7,1
	
	addi $v1,$v1,10
	li $v0,4
	la $a0, yes
	syscall
					
	addi $t6,$t6,10
	j input
	
	true:
		li $v0,4
		la $a0, sameWordError
		syscall
	    
	j input
	
nfound:
	
end_reset: ## resetting all variables,pointers,strings
	la $t0, userInput
	li $t4,0
	li $t5,0	
	
	addi $t1, $t1, 1  ## i++
	
	j loop

exit_:
	li $v0,4
	la $a0, no
	syscall
	
	j input
####################

#loop: 
#	lb $t8, 0($t0)  ## load each character from the file    
	#li $v0, 11
	#syscall
#	sb $t8, 0($t7)
	
	
	#sb $t8,wrd ## store it in wrd
	#beq $t8, '*', close
#	bne $t8, ' ', nprint ## if \n is found  	
	
	
	
	
	
	#wrd: .asciiz ""
	
	## refresh the word...
	
#	nprint:	
	
#	li $v0, 11
#	la $a0, 0($t7)
#	syscall
	
#	addi $t7,$t7,1		
#	addi $t9,$t9,1   ## loop counter 
#	addi $t0,$t0,1  ## chage adress of file pointer

#bne $t9,100,loop	
	
# Close File
close:
	li	$v0, 16		# Close File Syscall
	move	$a0, $s6	# Load File Descriptor
	syscall
	j	done		# Goto End
 
# Error
err:
	li	$v0, 4		# Print String Syscall
	la	$a0, fnf	# Load Error String
	syscall
 
# Done
done:
	
	li	$v0, 10		# Exit Syscall
	syscall


exists: ## input in $t4, output in $s4
li $s4,0
li $s5,0
while: 
	lb $s4, myarray($s5)
	addi $s5,$s5,1
	beq $s4,$t4,fnd
	blt $s5,$t7,while 
	jr $ra
fnd:
	li $s4,1
	jr $ra
	
