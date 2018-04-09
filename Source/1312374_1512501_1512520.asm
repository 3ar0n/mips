.data
	buffer:		.space 400
	length:		.word 0
	array:		.space 400
	n:		.word 0
	n_prime:	.word 0
	n_perfect:	.word 0
	sum_square:	.word 0
	average_symmetry: .word 0
	max:		.word 0
	s_newLine:	.asciiz "\n"
	s_space:	.asciiz " "
	s_menu:		.asciiz "========MENU========\n1. Nhap mang\n2. Xuat mang\n3. Liet ke so nguyen to\n4. Liet ke so hoan thien\n5. Tong cac so chinh phuong\n6. Trung binh cong cac so doi xung\n7. Gia tri lon nhat\n8. Sap xep mang tang dan (selection soft)\n9. Sap xep mang giam dan (bubble soft)\n10. Thoat\n==============\n"
	s_select:	.asciiz "Chon chuc nang: "
	s_selectAgain:	.asciiz "Chon lai: "
	select:		.word 0
	s_result1:	.asciiz "Nhap mang: "
	s_result2:	.asciiz "Mang da nhap: "
	s_result3:	.asciiz "Cac so nguyen to trong mang: "
	s_result4:	.asciiz "Cac so hoan thien trong mang: "
	s_result5:	.asciiz "Tong cac so chinh phuong: "
	s_result6:	.asciiz "Trung binh cong cac so doi xung: "
	s_result7:	.asciiz "Gia tri lon nhat: "
	s_result8:	.asciiz "Sap xep mang tang dan: "
	s_result9:	.asciiz "Sap xep mang giam dan: "
	s_resultX:	.asciiz "Just for testing...\n"

.text
# ===================================MAIN===================================
main:
	# print 's_menu' to console
	li	$v0,	4
	la	$a0,	s_menu
	syscall

m_select:	
	# print 's_select' to console, then jump to 'm_input:'
	li	$v0,	4
	la	$a0,	s_select
	syscall
	j	m_input
	
m_selectAgain:
	# print 's_selectAgain' to console, then jump to 'm_input:'
	li	$v0,	4
	la	$a0,	s_selectAgain
	syscall
	j	m_input
	
m_input:	
	# input number and save it to 'select'
	li	$v0,	5
	syscall
	sw	$v0,	select
	
	# get value of 'select'
	lw	$t0,	select
	
	# quit if 'select' = 10; else jump to 'selectAgain:'
	beq	$t0,	1,	function_1
	beq	$t0,	2,	function_2
	beq	$t0,	10,	m_end
	beq	$t0,	11,	function_X	# testing
	bne	$t0,	10,	m_selectAgain	# use when select < 1 or select > 10
	# add funtion base on 
	
# end program
m_end:
	li	$v0,	10
	syscall
	
# =================================FUNCTION=================================
function_X:
	# do something here
	
	li	$v0,	4
	la	$a0,	s_resultX
	syscall
	
	# jump back to selection in menu
	j	m_select

# =======Function 1======
function_1:
	# print 's_result1' to console
	li	$v0,	4
	la	$a0,	s_result1
	syscall
	
	# input string 'buffer'
	li	$v0,	8
	la	$a0,	buffer
	li	$a1,	399
	syscall
	
	# number of character ($7) in string ($0), then save it to 'length'
	la	$s0,	buffer
	li	$s7,	0
	jal	stringLen
	sw	$s7,	length
	
	# convert string (buffer) to array ($s0)
	la	$s0,	array
	jal	string_Array
	
	# jump back to selection in menu
	j	m_select
	
# Length of string ($s0)
stringLen:
	lb      $t0,	($s0)			# char ch = buffer[k]
	addu	$s0,	$s0,	1
	addu	$s7,	$s7,	1		# k++
	bne     $t0,	10,	stringLen	# while (ch != '\n') { strLen() }
	jr	$ra
	
# Convert string to array
string_Array:
	lw	$s5,	length		# get string length
	li	$s6,	0		# array length = 0
	li	$s7,	0		# tmp = 0
	li	$t1,	0		# i = 0
	j	checkEoS
	
# while not end of string
checkEoS:
	bne	$t1, $s5, checkChar	# while i < strlen() => check character
	sb	$s6, n			# if (EoS) => save array length to 'n'
	jr	$ra

# check each character ($s2) in string	
checkChar:
	lb	$s2,	buffer($t1)		# char ch = buffer[i]
	li	$t0,	32			# 'space' character
	li	$t7,	10
	beq	$s2,	$t0,	push_Array	# if (ch == ' ' || ch == '\n')
	beq	$s2,	$t7,	push_Array
	bne	$s2,	$t0,	char_Number	# while (ch != ' ')
	jr	$ra				# return to 'function_1'

# convert character ($s2) to number ($s3)
char_Number:
	#tinh gia tri cua so tu dang chuoi ky tu
	sub	$s2, $s2, 48		# ch = ch - '0'
	li	$t3, 10
	mult	$s3, $t3		# tmp = tmp * 10
	mflo	$s3	
	addu	$s3, $s3, $s2		# tmp = tmp + ch
	addu	$t1, $t1, 1		# i++
	j	checkEoS

# push the new number ($3) into array ($s0)
push_Array:		
	sw	$s3, ($s0)		# array[j] = tmp
	li	$s3, 0			# tmp = 0
	addu	$s0, $s0, 4
	addu	$s6, $s6, 1		# n++
	addu	$t1, $t1, 1		# j++
	j	checkEoS
# ===End of Function 1===


# =======Function 2======
function_2:
	# print 's_result2' to console
	li	$v0,	4
	la	$a0,	s_result2
	syscall
	
	# load array and length
	la 	$s0, array
	lw	$s6, n
	jal	printArray
	
	# jump back to selection in menu
	j	m_select
# ===End of Function 2===


# ===Print Array (for functions 2, 3, 4, 8, 9)===	
printArray:				# array store in $s0, array length in $s6
	li 	$t0, 0			# i = 0
	j 	checkEoA

# while not end of array
checkEoA:
	bne 	$t0, $s6, printNumber	# if (i < n) =>
	
	# insert a new line
	li	$v0, 4
	la	$a0, s_newLine
	syscall

	jr 	$ra			# return to 'function_2'

printNumber:
	# print a[i]
	li 	$v0, 1
	lw 	$a0, ($s0)
	syscall

	# insert 'space'
	li $v0, 11
	li $a0, ' '
	syscall
	
	# increase array's adress by 4
	addu	$s0, $s0, 4
	addu	$t0, $t0, 1
	j checkEoA