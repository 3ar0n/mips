.data
	fin:		.asciiz "input.txt"
	fout:		.asciiz "output.txt"
	buffer:		.space 400
	buffer_prime:	.space 400
	buffer_sum:	.space 4
	buffer_max:	.space 4
	.align 2
	array:		.space 400
	array_sorted:	.space 400
	array_primeN:	.space 400
	new_line:	.asciiz "\n"
	space:		.asciiz " "
	n:		.word 0
	prime_n:	.word 0
	sum:		.word 0
	max:		.word 0
	#tmp:		.word 0
	pointer:	.word
	tb1:		.asciiz "1. Mang da nhap:\r\n"			# 21
	tb2:		.asciiz "\r\n2. Cac so nguyen to trong mang:\r\n"	# 35
	tb3:		.asciiz "\r\n3. Tong cac so nguyen to:\r\n"		# 29
	tb4:		.asciiz "\r\n4. Gia tri lon nhat:\r\n"			# 24
	tb5:		.asciiz "\r\n5. Mang da duoc sap xep:\r\n"		# 28

#error strings
	readErrorMsg:	.asciiz "\nError in reading file\n"
	openErrorMsg:	.asciiz "\nError in opening file\n"

# note	
#	$s5	strlen(buffer)
#	$s6	n/prime_n	(number of integer in array)
#	$s0	arrar/array_primeN/array_sorted

.text
main:
	# doc file
	jal	input
	
	# dem so luong ki tu trong chuoi
	la	$s0, buffer
	li	$s5, 0
	jal	StringLen
	
	# chuoi -> mang
	la	$s0, array
	jal	StringToArray
	
	# in mang ra man hinh
	la 	$s0, array
	lw	$s6, n
	jal	printArray
	
	# liet ke cac so nguyen to trong mang
	la	$s0, array
	lw	$s6, n
	jal	listPrimeNumber
	
	# in cac so nguyen to	
	la 	$s0, array_primeN
	lw	$s6, prime_n
	jal	printArray
	
	# tinh tong cac so nguyen to (SUM)
	la	$s0, array_primeN
	lw	$s6, prime_n
	jal	CalSum
	
	# in gia tri SUM
	lw	$t0, sum
	li	$v0, 1
	la	$a0, ($t0)
	syscall
	li	$v0, 4
	la	$a0, new_line
	syscall
	
	# tim gia tri MAX
	la	$s0, array
	lw	$s6, n
	jal	findMax
	
	# in gia tri MAX
	lw	$t2, max
	li	$v0, 1
	la	$a0, ($t2)
	syscall
	li	$v0, 4
	la	$a0, new_line
	syscall
	
	# mo file de ghi
	li	$v0, 13
	la	$a0, fout
	li	$a1, 1
	li	$a2, 0
	syscall
	move	$s4, $v0
	
# ghi file
	# mang da nhap
	li	$v0, 15
	move	$a0, $s4
	la	$a1, tb1
	la	$a2, 18
	syscall
	
	la	$s0, buffer
	li	$s5, 0
	jal	StringLen
	
	li	$v0, 15
	move	$a0, $s4
	la	$a1, buffer
	la	$a2, ($s5)
	syscall
	
	li	$v0, 15
	move	$a0, $s4
	la	$a1, tb2
	la	$a2, 35
	syscall
	
	# cac so nguyen to
	la	$s0, array_primeN
	lw	$s6, prime_n
	la	$s7, buffer_prime
	jal	ArrayToString
	
	la	$s0, buffer_prime
	li	$s5, 0
	jal	StringLen
	
	li	$v0, 15
	move	$a0, $s4
	la	$a1, buffer_prime
	la	$a2, ($s5)
	syscall
	
	# Tong cac so nguyen to
	li	$v0, 15
	move	$a0, $s4
	la	$a1, tb3
	la	$a2, 29
	syscall
	
	lw	$s1, sum
	la	$s7, buffer_sum
	jal	NumberToString
	
	la	$s0, buffer_sum
	li	$s5, 0
	jal	StringLen
	
	li	$v0, 15
	move	$a0, $s4
	la	$a1, buffer_sum
	la	$a2, ($s5)
	syscall
	
	# Gia tri lon nhat
	li	$v0, 15
	move	$a0, $s4
	la	$a1, tb4
	la	$a2, 24
	syscall
	
	lw	$s1, max
	la	$s7, buffer_max
	jal	NumberToString
	
	la	$s0, buffer_max
	li	$s5, 0
	jal	StringLen
	
	li	$v0, 15
	move	$a0, $s4
	la	$a1, buffer_max
	la	$a2, ($s5)
	syscall
	
	# Mang da duoc sap xep
	li	$v0, 15
	move	$a0, $s4
	la	$a1, tb5
	la	$a2, 28
	syscall
	
	# Dong file 
	li	$v0, 16			# system call for close file
	move	$a0, $t0		# file descriptor to close
	syscall
	
	# ket thuc chuong trinh
	li	$v0, 10
	syscall

#___________________________Doc file <fin> va luu chuoi vao <buffer>
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
	li	$a2, 400		#hardcoded size of buffer
	syscall            
	
	#Close the file 
	li	$v0, 16			# system call for close file
	move	$a0, $s0		# file descriptor to close
	syscall
	jr	$ra

		
# Length of string
StringLen:
	lb      $t0, ($s0)		# char ch = buffer[k]
	addu	$s0, $s0, 1
	addu	$s5, $s5, 1		# k++
	bne     $t0, $zero, StringLen	# while (ch != \0) { strLen() }
	jr	$ra

#___________________________Chuyen chuoi <buffer> (co <$5> ky tu) sang mang <$s0> (co <$6> phan tu)
	
StringToArray:
	#Chuyen chuoi buffer thanh mang array[]
	li	$s3, 0			#int tmp = 0
	li	$t1, 0			#int i = 0
	la	$s4, space		#string s4 = " "
	j	string_A
	
# while not end of string
string_A:	
	bne	$t1, $s5, string_B	# while i < strlen()
	sb	$s6, n
	jr	$ra

# check each character in string	
string_B:

	lb	$s2, buffer($t1)	# char ch = buffer[i]
	li	$t0, 32			# ky tu "khoang trang"
	li	$t7, 0			# ky tu ket thuc chuoi
	beq	$s2, $t0, string_C1	# if (ch == ' ')
	beq	$s2, $t7, string_C1	# if (ch == \0)
	bne	$s2, $t0, string_C0	# while (ch != ' ')
	jr	$ra
	
string_C0:
	#tinh gia tri cua so tu dang chuoi ky tu
	sub	$s2, $s2, 48		# ch - '0'
	li	$t3, 10
	mult	$s3, $t3		# tmp = tmp * 10
	mflo	$s3	
	addu	$s3, $s3, $s2		# tmp = tmp + ch
	addu	$t1, $t1, 1		# i++
	j	string_A

string_C1:		
	sw	$s3, ($s0)		# array[j] = tmp
	li	$s3, 0			# tmp = 0
	addu	$s0, $s0, 4
	addu	$s6, $s6, 1		# n++
	addu	$t1, $t1, 1		# j++
	j	string_A

#_______________in chuoi <$s0> (co <$6> phan tu) ra man hinh	
printArray:
	li 	$t0, 0
	j 	print_A
	
print_A:
	bne 	$t0, $s6, print_B
	
	li	$v0, 4
	la	$a0, new_line
	syscall
	
	jr 	$ra

print_B:
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
	j print_A
	
#___________________liet ke cac so nguyen to trong mang <$s0> (<$s6> phan tu), luu trong mang <array_primeN> (<prime_n> phan tu)
listPrimeNumber:
	la	$s1, array_primeN
	li	$s7, 0			# int N = 0
	#la	$s0, array
	#lw	$s6, n
	li	$t0, 0			# int i = 0
	j	Y
	
Y:
	bne	$t0, $s6, isPrimeNumber	# while (i < n) { check }
	sw	$s7, prime_n
	jr	$ra			# else { break }
	
isPrimeNumber:
	lw	$s2, ($s0)		# x = a[i]

	beq	$s2, $zero, next	# if (x == 0)
	li	$t7, 1
	beq	$s2, $t7, next		# if (x == 1)
	li	$t7, 2
	beq	$s2, $t7, newPrime	# if (x == 2)
	li	$t7, 3
	beq	$s2, $t7, newPrime	# if (x == 3)
	j	checkPrime		# if (x >= 4)

checkPrime:
	li	$t1, 2			# int j = 2		
	div	$s2, $t1
	mflo	$t3			# y = [x / 2]
	addu	$t3, $t3, 1		# y = y + 1
	j	X

X:
	#li	$v0, 1
	#la	$a0, ($t1)
	#syscall
	#li	$v0, 4
	#la	$a0, new_line
	#syscall
	bne	$t1, $t3, loopCheck	# while (j < [x / 2])
	j	newPrime
	
loopCheck:
	div	$s2, $t1
	mfhi	$t5			# t5 = x mod j
	beq	$t5, $zero, next	# if (t5 == 0) { next }
	j	jPlus			# else
	
jPlus:
	addu	$t1, $t1, 1		# j++
	j	X

next:
	addu	$s0, $s0, 4
	addu	$t0, $t0, 1		# i++
	j	Y
	
newPrime:		
	sw	$s2, ($s1)		# array_prime[j] = tmp
	addu	$s1, $s1, 4
	addu	$s7, $s7, 1		# N++
	j	next

#_______________________________________________________
CalSum:
	li	$t0, 0			# int i = 0
	li	$t1, 0			# int Sum = 0

loopCal:
	bne	$t0, $s6, calculate	# while (i < n)
	sw	$t1, sum	
	jr	$ra

calculate:
	lw	$s1, ($s0)		# int x = a[i]
	addu	$t1, $t1, $s1		# Sum += x
	addu	$s0, $s0, 4
	addu	$t0, $t0, 1		# i++
	j loopCal

#______________________________________________________
findMax:
	li	$t0, 0			# int i = 0
	lw	$t1, ($s0)		# int Max = a[0]
	
loopFind:
	lw	$s1, ($s0)		# x = a[i]
	bne	$t0, $s6, checkMax	# while (i < n)
	sw	$t1, max
	jr	$ra

checkMax:
	sub	$t3, $s1, $t1		# tmp = x - max
	bgtz	$t3, newMax		# if (tmp > 0) { newMax }
	j nextFind			# else
	
newMax:
	move	$t1, $s1		# Max = x
	j nextFind
	
nextFind:
	addu	$s0, $s0, 4
	addu	$t0, $t0, 1		# i++
	j loopFind

#___________________chuyen mang <$s0> (<$s6> phan tu) sang chuoi <$s7>
ArrayToString:
	sw	$ra, pointer		
	#li	$s7, 0				# buffer
	li	$t0, 0				# i = 0
	li	$t1, 10
	jal	loopGet

#______________step 1: load a[i]
loopGet:
	bne	$t0, $s6, getNumber		# while (i < n)
	lw	$t4, pointer
	jr	$t4
getNumber:
	lw	$s1, ($s0)			# a[i]
	li	$t6, 0				# index = 0
	j	pushStack

#______________step 2: push to stack
pushStack:
	beq	$s1, $zero, push_Zero		# if (a[i] == 0)
	j	push_A
	
push_A:
	bgtz	$s1, push_B			# while (a[i] > 0)
	j	popStack
	
push_Zero:
	#push 0 to stack
	subu	$sp, $sp, 4 
	sw	$s1, ($sp) 	
	li	$t6, 1				# index = 1
	j	popStack
	
push_B:
	div	$s1, $t1
	mfhi	$t2			# tmp = a[i] % 10
	div	$s1, $s1, 10		# a[i] = a[i] / 10
	
	#push tmp to stack
	subu	$sp, $sp, 4 
	sw	$t2, ($sp)
	addu	$t6, $t6, 1			# index++	
	j	push_A

#______________step 3: pop from stack (add to string)
popStack:
	bgtz	$t6, pop_A			# while (index > 0)
	# add space
	li	$t2, 32				# ' '
	sb	$t2, ($s7)		# save <ch> to string <$s7>
	addu	$s7, $s7, 1
	addu	$s0, $s0, 4
	addu	$t0, $t0, 1			# i++
	#j	loopGet
	jr	$ra

pop_A:
	#pop from stack
	lw	$t2, ($sp)
	addu	$sp, $sp, 4
	
	addu	$t2, $t2, 48			# ch = ch + '0'
	sb	$t2, ($s7)			# save <ch> to string
	addu	$s7, $s7, 1
	
	subu	$t6, $t6, 1			# index--
	j	popStack
	
#_____________________chuyen so <$s1> thanh
NumberToString:
	sw	$ra, pointer
	li	$t1, 10
	li	$t6, 0
	jal	pushStack
	lw	$t4, pointer
	jr	$t4