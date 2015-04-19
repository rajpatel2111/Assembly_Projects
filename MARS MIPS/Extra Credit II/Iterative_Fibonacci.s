	.file	"Iterative_Fibonacci.c"
	.section	.rodata
	.align 4
.LC0:
	.string	"Enter the range of the Fibonacci series: "
.LC1:
	.string	"%d"
.LC2:
	.string	"Fibonacci Series: %d %d "
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	leal	4(%esp), %ecx
	.cfi_def_cfa 1, 0
	andl	$-16, %esp
	pushl	-4(%ecx)
	pushl	%ebp
	.cfi_escape 0x10,0x5,0x2,0x75,0
	movl	%esp, %ebp
	pushl	%ecx
	.cfi_escape 0xf,0x3,0x75,0x7c,0x6
	subl	$20, %esp
	movl	$0, -12(%ebp)
	movl	$1, -16(%ebp)
	subl	$12, %esp
	pushl	$.LC0
	call	printf
	addl	$16, %esp
	subl	$8, %esp
	leal	-20(%ebp), %eax
	pushl	%eax
	pushl	$.LC1
	call	__isoc99_scanf
	addl	$16, %esp
	subl	$4, %esp
	pushl	$1
	pushl	$0
	pushl	$.LC2
	call	printf
	addl	$16, %esp
	movl	-20(%ebp), %eax
	subl	$12, %esp
	pushl	%eax
	call	iterativeFibonacci
	addl	$16, %esp
	subl	$12, %esp
	pushl	$10
	call	putchar
	addl	$16, %esp
	movl	$0, %eax
	movl	-4(%ebp), %ecx
	.cfi_def_cfa 1, 0
	leave
	.cfi_restore 5
	leal	-4(%ecx), %esp
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.section	.rodata
.LC3:
	.string	"%1d "
	.text
	.globl	iterativeFibonacci
	.type	iterativeFibonacci, @function
iterativeFibonacci:
.LFB1:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	movl	$0, -12(%ebp)
	movl	$1, -16(%ebp)
	jmp	.L4
.L5:
	movl	-12(%ebp), %edx
	movl	-16(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, -20(%ebp)
	movl	-16(%ebp), %eax
	movl	%eax, -12(%ebp)
	movl	-20(%ebp), %eax
	movl	%eax, -16(%ebp)
	subl	$8, %esp
	pushl	-20(%ebp)
	pushl	$.LC3
	call	printf
	addl	$16, %esp
	subl	$1, 8(%ebp)
.L4:
	cmpl	$0, 8(%ebp)
	jg	.L5
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	iterativeFibonacci, .-iterativeFibonacci
	.ident	"GCC: (GNU) 4.9.2"
	.section	.note.GNU-stack,"",@progbits
