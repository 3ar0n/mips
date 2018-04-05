.data
	string:		.asciiz "16 0 92 345 3635 42352 54645 1 0 6545"
	.align 2			#bien arr duoc dinh nghia kieu word
	arr: 		.space 1024	#int arr[256]
	ch_space:	.byte	' '
	space:		.asciiz " "
	new_line:	.asciiz "\n"
	dash:		.asciiz " _"
	quoteA:		.asciiz " <"
	quoteB:		.asciiz "> "
.text
main:
	li	$s5, 0
	jal	strLen
	
	#li	$v0, 4
	#la	$a0, string
	#syscall
	#li	$v0, 4
	#la	$a0, new_line
	#syscall
	#li	$v0, 1
	#la	$a0, ($s5)
	#syscall
	#li	$v0, 4
	#la	$a0, new_line
	#syscall
	
	jal	convertStringToArray
	li	$v0, 1
	la	$a0, ($s6)
	syscall
	li	$v0, 4
	la	$a0, new_line
	
	jal	print
	jal	end
		
strLen:
	#Dem so luong ky tu cua chuoi buffer
	lb      $t0, string($s5)
	add     $s5, $s5, 1
	bne     $t0, $zero, strLen
	jr	$ra
	
convertStringToArray:
	#Chuyen chuoi buffer thanh mang array[]
	la	$s1, string
	la	$s0, arr
	
	li	$s3, 0
	li	$t1, 0
	la	$s4, space
	j	whileNotEoS
	
whileNotEoS:
	#li	$v0, 1
	#la	$a0, ($t1)
	#syscall
	#li	$v0, 4
	#la	$a0, new_line
	#syscall
	
	bne	$t1, $s5, numberCount
	jr	$ra
	
numberCount:
	lb	$s2, string($t1)
	#mflo	$s2
	
	#li	$v0, 4
	#la	$a0, quoteA
	#syscall
	#li	$v0, 11
	#la	$a0, ($s2)
	#syscall
	#li	$v0, 4
	#la	$a0, space
	#syscall
	#li	$v0, 1
	#la	$a0, ($s2)
	#syscall
	#li	$v0, 4
	#la	$a0, quoteB
	#syscall
	
	li	$t0, 32
	li	$t7, 0	
	beq	$s2, $t0, newNumber
	beq	$s2, $t7, newNumber
	bne	$s2, $t0, isNotSpace
	jr	$ra
	
isNotSpace:
	sub	$s2, $s2, 48
	li	$t3, 10
	mult	$s3, $t3
	mflo	$s3
	
	addu	$s3, $s3, $s2
	addu	$t1, $t1, 1
	
	#li	$v0, 4
	#la	$a0, quoteA
	#syscall
	#li	$v0, 1
	#la	$a0, ($s3)
	#syscall
	#li	$v0, 4
	#la	$a0, quoteB
	#syscall
	j	whileNotEoS

newNumber:	
	#li	$v0, 4
	#la	$a0, quoteA
	#syscall
	#li	$v0, 1
	#la	$a0, ($s2)
	#syscall
	#li	$v0, 4
	#la	$a0, quoteB
	#syscall
	
	sw	$s3, ($s0)
	li	$s3, 0
	addu	$s0, $s0, 4
	addu	$s6, $s6, 1
	addu	$t1, $t1, 1
	
	#li	$v0, 4
	#la	$a0, dash
	#syscall
	#li	$v0, 1
	#la	$a0, ($s6)
	#syscall
	#li	$v0, 4
	#la	$a0, dash
	#syscall
	#li	$s3, 0
	j	whileNotEoS
	
print:
	la 	$s0, arr
	li 	$t0, 0
	
	li	$v0, 4
	la	$a0, new_line
	syscall
	
	j 	loopOut
	
loopOut:
	bne 	$t0,$s6,output
	jr 	$ra

output:
	#Xuat a[i]
	li 	$v0, 1
	lw 	$a0, ($s0)
	syscall

	#xuat khoang trang
	li $v0, 11
	li $a0, ' '
	syscall
	
	#Tang dia chi mang
	addi	$s0, $s0, 4
	addi	$t0, $t0, 1
	j loopOut
end:
	li $v0, 10
	syscall