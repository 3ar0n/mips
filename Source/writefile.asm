.data
	fin:	.asciiz	"input.txt"
	fout:	.asciiz "output.txt"
	buffer:		.space 1024 		#buffer of 1024  <=> a[256]
	.align 2
	array:		.space 1024
	n:	.word 100
	new_line:	.asciiz "\n"
	space:		.asciiz " "
.text
main:
	jal	input
	
	li	$s5, 0		# int strlen() = 0
	
	jal	strLen
	jal	StringToArray
	sw	$s6, n
	
	la 	$s0, array
	jal	printArray
	
	li	$v0, 13
	la	$a0, fout
	li	$a1, 1
	li	$a2, 0
	syscall	
	move	$s7, $v0
	
	li	$v0, 15
	move	$a0, $s7
	la	$a1, array
	li	$a2, 1024
	syscall
	
	li	$v0, 16			# system call for close file
	move	$a0, $s7		# file descriptor to close
	syscall
	
	#jal	output
	
	li	$v0, 10
	syscall
	
ArrayToString:
	la	$s1, buffer
	lw	$s6, n
	li	$t0, 0			# int i = 0 //array[]
	li	$t1, 0			# int j = 0 //buffer
	
	bne	$t0, $s6, convert	# while (i < n)
	
convert:
	lw	$t3, ($s0)		# x = a[i]
	bgtz	$t3, NumberToChar	# if (x > 0) { NumberToChar }
					# else

NumberToChar:
			
	
	
#___________________________Doc file input.txt
input:
	#Open file for for reading purposes
	li	$v0, 13			#syscall 13 - open file
	la	$a0, fin		#passing in file name
	li	$a1, 0			#set to read mode
	li	$a2, 0			#mode is ignored
	syscall	
	move	$s0, $v0		#else save the file descriptor

	#Read input from file
	li	$v0, 14			#syscall 14 - read filea
	move	$a0, $s0		#sets $a0 to file descriptor
	la	$a1, buffer		#stores read info into buffer
	li	$a2, 1024		#hardcoded size of buffer
	syscall            
	
	#Close the file 
	li	$v0, 16			# system call for close file
	move	$a0, $s0		# file descriptor to close
	syscall
	jr	$ra

#___________________________Chuyen chuoi ky tu doc tu file thanh mang int
strLen:
	#Dem so luong ky tu cua chuoi buffer
	lb      $t0, buffer($s5)	# char ch = buffer[k]
	addu	$s5, $s5, 1		# k++
	bne     $t0, $zero, strLen	# while (ch != \0) { strLen() }
	jr	$ra
	
StringToArray:
	#Chuyen chuoi buffer thanh mang array[]
	la	$s1, buffer		# string buffer
	la	$s0, array		# int arrar[]
	
	li	$s3, 0			#int tmp = 0
	li	$t1, 0			#int i = 0
	la	$s4, space		#string s4 = " "
	j	whileNotEoS
	
whileNotEoS:	
	bne	$t1, $s5, numberCount	# while i < strlen()
	jr	$ra
	
numberCount:
	# kiem tra tung ky tu cua chuoi buffer
	lb	$s2, buffer($t1)	# char ch = buffer[i]
	li	$t0, 32			# ky tu "khoang trang"
	li	$t7, 0			# ky tu ket thuc chuoi
	beq	$s2, $t0, newNumber	# if (ch == ' ')
	beq	$s2, $t7, newNumber	# if (ch == \0)
	bne	$s2, $t0, isNotSpace	# while (ch != ' ')
	jr	$ra
	
isNotSpace:
	#tinh gia tri cua so tu dang chuoi ky tu
	sub	$s2, $s2, 48		# ch - '0'
	li	$t3, 10
	mult	$s3, $t3		# tmp = tmp * 10
	mflo	$s3	
	addu	$s3, $s3, $s2		# tmp = tmp + ch
	addu	$t1, $t1, 1		# i++
	j	whileNotEoS

newNumber:		
	sw	$s3, ($s0)		# array[j] = tmp
	li	$s3, 0			# tmp = 0
	addu	$s0, $s0, 4
	addu	$s6, $s6, 1		# n++
	addu	$t1, $t1, 1		# j++
	j	whileNotEoS

#________________________________________________________	
printArray:
	li 	$t0, 0
	li	$v0, 4
	la	$a0, new_line
	syscall
	j 	loopPrint
	
loopPrint:
	bne 	$t0, $s6, Print
	jr 	$ra

Print:
	#Xuat a[i]
	li 	$v0, 1
	lw 	$a0, ($s0)
	syscall

	#xuat khoang trang
	li $v0, 11
	li $a0, ' '
	syscall
	
	#Tang dia chi mang
	addu	$s0, $s0, 4
	addu	$t0, $t0, 1
	j loopPrint