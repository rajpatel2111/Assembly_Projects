#Matthew Bachelder
#Extra Credit Exam 1

# Prompt the user for three items, each should be sperated by one space. The first item should be choice of +, ~, OR ?.
# the second and third  items should be  hexadecimal numbers up to 7 char. 
# if the user enters a + add the two hexadecimal numbers, and return its hexadecimal representation
# of the user enters ~, nor the two hexadecimal numbers and return hexadecimal representation
# if the user enters ?, return the decimal value for both hexadecimal numbers entered

.data

prompt:	.asciiz	"\nPlease enter either +, ~, or ?, followed by a space and\ntwo hexadecimal numbers (max 7 char) each followed by a space. \n(e.g. + FFFFFFF AAAAAAA)\n"
input:	.space	20
space:	.asciiz 	" "
operatorChoices: .asciiz "+~?"
operator:	.asciiz	" "
operand1:	.asciiz	"       "
operand2:	.asciiz	"         "
result:	.asciiz	"                   "
resultSpace: .asciiz " and "
result1String: .asciiz "\nHex value after adding is "
result2String: .asciiz "\nNor value after performing a nor operation is  "
result3String: .asciiz "\nThe decimla values of each hex number you entered are  "

.text

main:
	
	li	$v0, 4		#load service to print string
	la	$a0, prompt	#load string
	syscall			#execute call

	li	$v0, 8		#load service to read string
	la	$a0, input 	#set the address where the string will be stored
	li	$a1, 20		
	syscall
	lbu	$s1, input($zero)
	sb	$s1, operator($zero)	# operator stored in $s1
	
	jal	parseInput	#jump to parse input. Returned strings (operands) will be stored as string in operand1 and operand2
	
	jal	convertOperand1 	 # converted decimal value will be returned and stored in $s0
	jal	convertOperand2 	 # converted decimal value will be returned and stored in $s2
	li	$t0, 0
	li	$t1, 1
	li 	$t2, 2
	lb	$t4, operatorChoices($t0)
	beq	$s1, $t4, op1 #if + goto op1
	lb	$t4, operatorChoices($t1)
	beq	$s1, $t4, op2 #if ~ goto op2
	lb	$t4, operatorChoices($t2)	
	beq	$s1, $t4, op3 #if ? goto op3
		
	

# the following is carried out if + is operator
op1:
	add	$s4, $s0, $s2
	jal	loadHex		#number to convert is stored in $s4 hex (Ascii equivalent will be stored in result on return
	li	$v0, 4		#load service to print string
	la	$a0, result1String	#load string
	syscall	
	li	$v0, 4		#load service to print string
	la	$a0, result	#load string
	syscall			#execute call
	b	exit
# the following will be carried out if ~ is operator
op2:
	nor	$s4, $s0, $s2
	jal	loadHex	#number to convert is stored in $s4 hex (Ascii equivalent will be stored in result on return
	li	$v0, 4		#load service to print string
	la	$a0, result2String	#load string
	syscall	
	li	$v0, 4		#load service to print string
	la	$a0, result	#load string
	syscall			#execute call
	b	exit
# the following will be carried out if ? is the operator
op3:
	li	$v0, 4		#load service to print string
	la	$a0, result3String	#load string
	syscall	
	li	$v0, 1		#load service to print integer
	addi	$a0, $s0, 0		#load integer
	syscall	
	li	$v0, 4		#load service to print string
	la	$a0, resultSpace	#load string
	syscall	
	li	$v0, 1		#load service to print integer
	addi	$a0, $s2, 0		#load integer
	syscall			
	b	exit
				
# the following changes each of the stored char to decimal value and proceeds to due manual hex to decimal conversion of both operand1 and operand2
# the resulting values are stored in $s0 (operand 1) and $s2 (operand 2)		
convertOperand1:
	li	$a1, 0		#$a1 will hold the char position
	li	$s0, 0		#$s0 will hold the returned value
	
countChar:
	li	$a3, 0		#$a0 will hold the string length
startCounting:			#count how many char are in the string (up to 7) so the hex to decimal conversions can be carried out accordingly
	lbu	$a0, operand1($a3)	#load index of operant1 at position stored in $a3
	beq	$a0, 0x20, startConvertOperand1 #check to see if char loader is equal to " " if yes stop counting
	addi	$a3, $a3, 1		#add 1 to $a3, remember we are counting how many positions are in the string		
	b	startCounting		#loop 


#convert each hex bit to its dec equivalent
startConvertOperand1:		 
	lbu 	$a0, operand1($a1)	#load char from operand at index stored in $a1. remember we are starting at 0
	beq	$a0, 0x20, endConvertOperand1	##check to see if char loader is equal to " " if yes stop counting
convert:		
	sltiu   	$t0, $a0, 0x41	#check if input character is less than 0x41 if yes load 0 into$t0, if no load 1
	beq	$t0, $zero, isLetter#check to see if value in $t0 is 0, if yes we no it is a letter (from previous staement) so jump to isLetter
	addi 	$a0, $a0, -0x30	#if not a letter then subtract 0x30 to get the dec value of the ascii symbol.
	b	multiplyThenAdd	#hex is loaded into $a0. jump to multiplyThenAdd to get the decimal equivalent. result will be added	
				 #to final result stored in $s0
isLetter:		
	addi 	$t0, $a0, -0x41	#subtract 0x41 to bring into dec range
	addi 	$a0, $t0, 10	#add 10 to get the actual dec value
	b	multiplyThenAdd	#hex is loaded into $a0. jump to multiplyThenAdd to get the decimal equivalent. result will be added	
				 #to final result stored in $s0

#here we are going to check the string length we determined earlier and branch to the label that will handle the hex to decimal coversion correctly
multiplyThenAdd:
	beq	$a3, 1,label1	#if string length 1 go to label1
	beq	$a3, 2,label2	#if string length 2 goto label2
	beq	$a3, 3,label3	#if string length 3 goto label3	
	beq	$a3, 4,label4	#if string length 4 goto label4
	beq	$a3, 5,label5	#if string length 5 goto label5
	beq	$a3, 6,label6	#if string length 6 goto label6
	beq	$a3, 7,label7	#if string length 7 goto label7

#label1 handles as if only 1 hex char was entered, label2 handles as if 2 hex char were entered,...,label7 handles as if 7 hex char were entered	
label1:	
	beq	$a1,0, label1.8.1	#this is given if 1char but wanted to stay consitent with what follows.
				 #remeber $a1 stores the char position, so we want need to check the char position to 
				  #carry out the appropiate mul for ex, poisiton 0 would be multiplied by 1
				  #whereas a char at potion 1 would be multiplied by 16 and so on
#we do the same in label2-7 check the character position and branch to the neccessary label to carry out correct multiplication for that position
label2:	
	beq	$a1,1, label1.8.1
	beq	$a1,0, label1.8.2
	
label3:	
	beq	$a1,2, label1.8.1
	beq	$a1,1, label1.8.2
	beq	$a1,0, label1.8.3
	
label4:	
	beq	$a1,3, label1.8.1
	beq	$a1,2, label1.8.2
	beq	$a1,1, label1.8.3
	beq	$a1,0, label1.8.4
	
label5:	
	beq	$a1,4, label1.8.1
	beq	$a1,3, label1.8.2
	beq	$a1,2, label1.8.3
	beq	$a1,1, label1.8.4
	beq	$a1,0, label1.8.5
	
label6:	
	beq	$a1,5, label1.8.1
	beq	$a1,4, label1.8.2
	beq	$a1,3, label1.8.3
	beq	$a1,2, label1.8.4
	beq	$a1,1, label1.8.5
	beq	$a1,0, label1.8.6
	
label7:	
	beq	$a1,6, label1.8.1
	beq	$a1,5, label1.8.2
	beq	$a1,4, label1.8.3
	beq	$a1,3, label1.8.4
	beq	$a1,2, label1.8.5
	beq	$a1,1, label1.8.6
	beq	$a1,0, label1.8.7	
#here is where we start multiplying based on char position. we multiply by required value and add the result into $s0	
label1.8.1:
	mul	$a0, $a0, 1
	add	$s0, $s0, $a0
	addi	$a1, $a1, 1
	j	startConvertOperand1
label1.8.2:
	mul	$a0, $a0, 16
	add	$s0, $s0, $a0
	addi	$a1, $a1, 1
	j	startConvertOperand1
label1.8.3:
	mul	$a0, $a0, 256
	add	$s0, $s0, $a0
	addi	$a1, $a1, 1
	j	startConvertOperand1
label1.8.4:
	mul	$a0, $a0, 4096
	add	$s0, $s0, $a0
	addi	$a1, $a1, 1
	j	startConvertOperand1
label1.8.5:
	mul	$a0, $a0, 65536
	add	$s0, $s0, $a0
	addi	$a1, $a1, 1
	j	startConvertOperand1
label1.8.6:
	mul	$a0, $a0, 1048576
	add	$s0, $s0, $a0
	addi	$a1, $a1, 1
	j	startConvertOperand1
label1.8.7:
	mul	$a0, $a0, 1677216
	add	$s0, $s0, $a0
	addi	$a1, $a1, 1
	j	startConvertOperand1
	
#end convert and jump back to stored address (will be main)	
endConvertOperand1:
	jr	$ra		
	


#following the same concept outlined for operand1 above. Refer to operand1 comments if needed
convertOperand2:
	li	$a1, 0
	li	$s2, 0
	
op2countChar:
	li	$a3, 0
op2startCounting:
	
	lbu	$a0, operand2($a3)
	beq	$a0, 0x20, startConvertOperand2
	addi	$a3, $a3, 1
	b	op2startCounting


startConvertOperand2:
	lbu	$a0, operand2($a1)
	beq	$a0, 0x20, endConvertOperand2
op2convert:		
	sltiu   	$t0, $a0, 0x41	#check if input character is less than 0x41 if yes load 0 into$t0, if no load 1
	beq	$t0, $zero, op2isLetter#check to see if value in $t0 is 0, if yes we no it is a letter (from previous staement) so jump to isLetter
	addi 	$a0, $a0, -0x30	#if not a letter then subtract 0x30 to get the dec value of the ascii symbol.
	b	op2multiplyThenAdd		
		
op2isLetter:		
	addi 	$t0, $a0, -0x41	#subtract 0x41 to bring into dec range
	addi 	$a0, $t0, 10	#add 10 to get the actual dec value
	b	op2multiplyThenAdd	

op2multiplyThenAdd:
	beq	$a3, 1,op2label1
	beq	$a3, 2,op2label2
	beq	$a3, 3,op2label3
	beq	$a3, 4,op2label4
	beq	$a3, 5,op2label5
	beq	$a3, 6,op2label6
	beq	$a3, 7,op2label7
	
op2label1:	
	beq	$a1,0, op2label1.8.1
op2label2:	
	beq	$a1,1, op2label1.8.1
	beq	$a1,0, op2label1.8.2
	
op2label3:	
	beq	$a1,2, op2label1.8.1
	beq	$a1,1, op2label1.8.2
	beq	$a1,0, op2label1.8.3
	
op2label4:	
	beq	$a1,3, op2label1.8.1
	beq	$a1,2, op2label1.8.2
	beq	$a1,1, op2label1.8.3
	beq	$a1,0, op2label1.8.4
	
op2label5:	
	beq	$a1,4, op2label1.8.1
	beq	$a1,3, op2label1.8.2
	beq	$a1,2, op2label1.8.3
	beq	$a1,1, op2label1.8.4
	beq	$a1,0, op2label1.8.5
	
op2label6:	
	beq	$a1,5, op2label1.8.1
	beq	$a1,4, op2label1.8.2
	beq	$a1,3, op2label1.8.3
	beq	$a1,2, op2label1.8.4
	beq	$a1,1, op2label1.8.5
	beq	$a1,0, op2label1.8.6
	
op2label7:	
	beq	$a1,6, op2label1.8.1
	beq	$a1,5, op2label1.8.2
	beq	$a1,4, op2label1.8.3
	beq	$a1,3, op2label1.8.4
	beq	$a1,2, op2label1.8.5
	beq	$a1,1, op2label1.8.6
	beq	$a1,0, op2label1.8.7	
	
op2label1.8.1:
	mul	$a0, $a0, 1
	add	$s2, $s2, $a0
	addi	$a1, $a1, 1
	j	startConvertOperand2
op2label1.8.2:
	mul	$a0, $a0, 16
	add	$s2, $s2, $a0
	addi	$a1, $a1, 1
	j	startConvertOperand2
op2label1.8.3:
	mul	$a0, $a0, 256
	add	$s2, $s2, $a0
	addi	$a1, $a1, 1
	j	startConvertOperand2
op2label1.8.4:
	mul	$a0, $a0, 4096
	add	$s2, $s2, $a0
	addi	$a1, $a1, 1
	j	startConvertOperand2
op2label1.8.5:
	mul	$a0, $a0, 65536
	add	$s2, $s2, $a0
	addi	$a1, $a1, 1
	j	startConvertOperand2
op2label1.8.6:
	mul	$a0, $a0, 1048576
	add	$s2, $s2, $a0
	addi	$a1, $a1, 1
	j	startConvertOperand2
op2label1.8.7:
	mul	$a0, $a0, 1677216
	add	$s2, $s2, $a0
	addi	$a1, $a1, 1
	j	startConvertOperand2
	
	
endConvertOperand2:
	jr	$ra		
	





#here we take the string the user entered and store each of the operands in operand1 and operand2

parseInput:
	li	$a0, 1	#use $a1 as the position counter. we set it to 1 because we already pulled the operator in main
	li	$a2, 0	#$a2 will be used to determine the index(position) of where we will store the char from inputstring to operand1
	li	$a3, 0	#$a3 will be used to determine the index(position) of where we will store the char from inputstring to operand2

# loop through input string starting at position 1 ending at first space. store each bit in position within operand1	
getFirst:	
	addi	$a0, $a0,1	#go ahead and add 1 to poition counter here, because we were given the second position would be a space(dont need it)
	lbu	$a1, input($a0)	#load the char at index $a0 from input string
	beq 	$a1, 0x20, getSecond #check if char is " " if yes stop and start second operand
	sb	$a1, operand1($a2)  #else store the char at index $a2 in operand1
	addi	$a2, $a2, 1	#add 1 to poisiton counter
	j	getFirst		#loop

#pick up after space and loop through remaining characters storing each in position within operand 2	
getSecond:
	addi	$a0, $a0,1	#go ahead and add 1 to poition counter here, because we know the values stored is equal to a space(dont need it)
	lbu	$a1, input($a0)	#load the char at index $a0 from input string
	beq 	$a1, 0x20, endParse.1 #check if char is " " if yes go and make the last position equal to a space (explained sort of below)
	beqz	$a1,  endParse.1 #check if char is end of line char if yes go and make the last position equal to a space (explained sort of below)
	sb	$a1, operand2($a3) #else store the char at index $a2 in operand1
	addi	$a3, $a3, 1 #add 1 to poisiton counter
	j	getSecond #loop
#added this because I wasnt sure what value was being stored after the last character from input. Stored char 0x20 so I can identify later
endParse.1:
	addi	$a3, $a3, -1
	li	$a1, 0x20
	sb	$a1, operand2($a3)
endParse:
	jr $ra #return to address in main


	
		#here we will take the decimal value stored in $s4 and change to Ascii equivalent store in string result
loadHex:
	li $t0, 8		#use this as a counter assume up to 8 char finsih when 0
	li $t3, 0		#will control the storage position in string result
	
begin:
	beq $t0, $zero, endLoad
	rol $s4, $s4, 4 	#rotate the value in $s4 4 bits to the left
	and $t2, $s4, 0xf	# mask with 1111 store resulting value in $t2
	ble $t2, 9, addTo	#if value in $t2 is now less than  9 branch to add 48 to result to get equivalent Asciiz char
	addi $t2, $t2, 55	# if not then larger than 9 so add 55 to get Ascii value
	b storeByte
addTo:
	addi $t2, $t2, 48	#larger than 9 only need to add 48 to get to needed range in Ascii char
storeByte:
	sb $t2, result($t3)
 	addi $t3, $t3, 1        # increment counter
    	addi $t0, $t0, -1       # decrement loop counter
    	j begin
endLoad:
	jr $ra		#return to main
			
exit:
	li $v0, 10		#exit the program
	syscall