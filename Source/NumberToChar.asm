.data
	n:	.word	12345
	ch:	.byte
	buffer:	.space	1024
.text
main:
	lw	$s1, n
	la	$s2, ch
	li	$s6, 0				# i = 0
	li	$s7, 0				# strlen(buffer)
	li	$t0, 0
	li	$t1, 10
	jal	pushStack
	jal	popStack
	
	li	$v0, 4
	la	$a0, buffer
	syscall
	
	jal	end
	
#______________push to stack
pushStack:
	beq	$s1, $zero, push_Zero		# if (n == 0)
	j	push_A
	
push_A:
	bgtz	$s1, push_B			# while (n > 0)
	jr	$ra

push_Zero:
	subu	$sp, $sp, 4 
	sw	$s1, ($sp) 
	li	$s6, 1
	jr	$ra
	
push_B:
	div	$s1, $t1
	mfhi	$t2			# tmp = n % 10
	div	$s1, $s1, 10		# n = n / 10
	#push tmp to stack
	subu	$sp, $sp, 4 
	sw	$t2, ($sp)
	addu	$s6, $s6, 1
	
	j	push_A

#______________pop from stack (add to string)
popStack:
	bgtz	$s6, pop_A
	jr	$ra

pop_A:
	#pop from stack
	lw	$t2, ($sp)
	addu	$sp, $sp, 4
	
	addu	$t2, $t2, 48
	sb	$t2, buffer($s7)
	addu	$s7, $s7, 1
	
	subu	$s6, $s6, 1
	j	popStack
	
end:
	#end
	li	$v0, 10
	syscall