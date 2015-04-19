.data
str: .asciiz "+ 1234 ABCD"

.text
li $v0, 1
add $a0, $zero, $t2
syscall


la $a1, str
lw $t0, ($a1)

add $a1, $a1, 4
lw $t1, ($a1)

add $a1, $a1, 4
lw $t2, ($a1)

srl $t0, $t0, 16
sll $t1, $t1, 16

add $t0, $t0, $t1

add $t1, $zero, $zero

la $t1, ($t0)
la $t0, ($t1)

add $t1, $zero, $zero

lb $t1($t0)
add $a0, $zero, $t1
li $v0, 11
syscall
addi $t1, $t1, 1

lb $s0, 4($t0)
add $a0, $zero, $s0
li $v0, 11
syscall
addi $t1, $t1, 1

lb $s0, 8($t0)
add $a0, $zero, $s0
li $v0, 11
syscall
addi $t1, $t1, 1

lb $s0, 12($t0)
add $a0, $zero, $s0
li $v0, 11
syscall
addi $t1, $t1, 1

# sll $t1, $t0, 8
# srl $t2, $t1, 16
# li $v0, 11
# Length:

# lb $t4, ($t0)
# move $a0, $t4
# syscall

# j Length


