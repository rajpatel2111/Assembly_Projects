.data

prompt:		.asciiz "Enter integer, n: " #prompt1
sequence:	.asciiz "My Fibonacci sequence is: " #prompt2
exitOut:	.asciiz "Exiting Program  ... " #prompt3
output:		.asciiz " " #spaces between outputs
newline:	.asciiz "\n" #newline


.globl main 	#use main function
.text 
main:
__start: 	#typical start function


start2:		#start2, return to this	
		li $v0, 4	#load 4 into $v0, can print 
		la $a0, prompt	#print prompt
		syscall #system call, prints prompt

		li $t4, 1 #register $t4=1
		li $t5, 2 #register $t5=2

		li $v0, 5 #get n 
		syscall #system call, has n in $v0
		move $t3, $v0 #$t3=n

	 	beqz $t3, done2 #if $t3==0, jump to done2

 		li $v0, 4 #load 4 into $v0, can print 
 		la $a0, sequence #print sequence
 		syscall #system call

		li $v0, 4 #load 4 into $v0, can print
		la $a0, newline #print newline
		syscall #system call 


					# Print the first three numbers
		li $v0, 4	#load 4 into $v0, can print
		la $a0, output #print output
		syscall #system call

		li $v0, 1 #load 1 into $v0, print integer
		li $a0, 1 #print integer 1 
		syscall #system call

		beq $t3, $t4, exit #if $t3==1, jump to exit
 
		li $v0, 4 #load 4 into $v0, can print
		la $a0, output #print output
		syscall #system call

		li $v0, 1 #load 1 into $v0, print integer
		li $a0, 1 #print integer 1
		syscall #system call

		beq $t3, $t5, exit #if $t3==2, jump to exit

		li $v0, 4 #load 4 into $v0, can print
		la $a0, output #print output
		syscall #system call

		li $v0, 1 #load 1 into $v0, print integer
		li $a0, 1 #print 1
 		syscall #system call 

		li $t0, 1 #have $t0=1
		li $t1, 1 #have $t1=1
		li $t2, 1 #have $t2=1

		# Calculate the remaining fibonacci numbers and output
		addi $t3, $t3, -2 #t3=n, n=n-2 because we printed out the first two 1's 
fib:
		addi $t3, $t3, -1 #as this function continues, subtract 1 from n
		add $t5, $t0, $t1 #$t5=$t0+$t1
		add $t4, $t5, $t2 #$t4=($t0+$t1) + $t2 ##adds to get next fib number
		beqz $t3, exit #if $t3 (n) = 0, jump to exit

		li $v0, 4 #load 4 into $v0, to print
		la $a0, output #print output
		syscall #system call

		li $v0, 1 #load 1 into $v0, print integer
		move $a0, $t4 #print what $t4 is 
		syscall #system call

		move $t0, $t1 #$t0=$t1
		move $t1, $t2 #$t1=$t2
		move $t2, $t4 #t2=$t4

		b fib #branch back

exit:
		# Done and restart Fibonacci sequence
		li $v0, 4 #load 4 into $v0, print
		la $a0, newline #print newline
		syscall #system call
 
		b start2 #branch back to start2

done2:    	
		li $v0, 4
		la $a0, exitOut	#print exit Statement
		syscall

		li $v0, 4
		la $a0, newline	#print newline
		syscall
 
		li $v0, 10 #load 10 into $v0, exit program
		syscall #system call
