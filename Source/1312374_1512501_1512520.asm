.data
	buffer:		.space 400
	length:		.word 0
	array:		.space 400
	array_new:	.space 400
	n:		.word 0
	n_prime:	.word 0
	n_perfect:	.word 0
	sum_square:	.word 0
	avg_symmetry:	.word 0
	max:		.word 0
	hasInput:	.word 0
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

main.Select:	
	# print 's_select' to console, then jump to 'main.Input:'
	li	$v0,	4
	la	$a0,	s_select
	syscall
	j	main.Input
	
main.SelectAgain:
	# print 's_selectAgain' to console, then jump to 'main.Input:'
	li	$v0,	4
	la	$a0,	s_selectAgain
	syscall
	j	main.Input
	
main.Input:	
	# input number and save it to 'select'
	li	$v0,	5
	syscall
	sw	$v0,	select
	
	# get value of 'select'
	lw	$t0,	select
	
	# quit if 'select' = 10; else jump to 'selectAgain:'
	beq	$t0,	1,	function_1
	
	lw	$t1,	hasInput		# if select != 1 and no Input array => end program
	beq	$t1,	$zero,	main.End
	
	beq	$t0,	2,	function_2
	beq	$t0,	3,	function_3
	beq	$t0,	4,	function_4
	beq	$t0,	5,	function_5
	beq	$t0,	6,	function_6
	beq	$t0,	7,	function_7
	beq	$t0,	10,	main.End
	bne	$t0,	10,	main.SelectAgain	# use when select < 1 or select > 10
	# add funtion base on 
	
# end program
main.End:
	li	$v0,	10
	syscall
	
# =================================FUNCTION=================================
function_X:
	# do something here
	
	li	$v0,	4
	la	$a0,	s_resultX
	syscall
	
	# jump back to selection in menu
	j	main.Select

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
	
	# call string.Length(buffer, &lenght) 
	la	$a0,	buffer
	li	$a1,	0
	jal	string.Length
	sw	$a1,	length
	
	# clear old array
	la	$s0,	array
	jal	array.Clear
	
	# convert string (buffer) to array ($s0)
	la	$s0,	array
	jal	string.ConvertToArray
	
	# set hasInput = 1
	li	$t4,	1
	sw	$t4,	hasInput
	
	# jump back to selection in menu
	j	main.Select
	
# Clear data of the old array
array.Clear:
	li	$t0,	1				# i = 1
	lw	$t1,	n
array.CheckData:
	sub	$t2,	$t0,	$t1			# t2 = i - n
	blez	$t2,	array.LoadAndClear		# if (t2 <= 0) then
	jr	$ra					# else return
array.LoadAndClear:
	sw	$zero,	($s0)				# a[i] = 0
	add	$s0,	$s0,	4
	add	$t0,	$t0,	1			# i++
	j	array.CheckData
	
# Length of string
string.Length:
	lb      $t0,	($a0)			# char ch = buffer[k]
	addu	$a0,	$a0,	1
	addu	$a1,	$a1,	1		# k++
	bne     $t0,	10,	string.Length	# loop while (ch != '\n')
	jr	$ra				# else return
	
# Convert string to array
string.ConvertToArray:
	lw	$s5,	length		# get string length
	li	$s6,	0		# array length = 0
	li	$s7,	0		# tmp = 0
	li	$t1,	0		# i = 0
	j	checkEoS	
# while not end of string
checkEoS:	
	bne	$t1,	$s5,	checkChar	# while i < strlen() => check character
	sb	$s6,	n			# if (EoS) => save array length to 'n'
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
	sub	$s2,	$s2,	48		# ch = ch - '0'
	li	$t3,	10
	mult	$s3,	$t3			# tmp = tmp * 10
	mflo	$s3	
	addu	$s3,	$s3,	$s2		# tmp = tmp + ch
	addu	$t1,	$t1,	1		# i++
	j	checkEoS
# push the new number ($3) into array ($s0)
push_Array:		
	sw	$s3,	($s0)			# array[j] = tmp
	li	$s3,	0			# tmp = 0
	addu	$s0,	$s0,	4
	addu	$s6,	$s6,	1		# n++
	addu	$t1,	$t1,	1		# j++
	j	checkEoS
# ===End of Function 1===


# =======Function 2======
function_2:
	# print 's_result2' to console
	li	$v0,	4
	la	$a0,	s_result2
	syscall
	
	# load array and length
	la 	$s0,	array
	lw	$s1,	n
	jal	array.Print
	
	# jump back to selection in menu
	j	main.Select
# ===End of Function 2===


# ===Print Array (for functions 2, 3, 4, 8, 9)===	
array.Print:	# array store in $s0, array length in $s6
	li 	$t0,	0			# i = 0
	j 	checkEoA

# while not end of array
checkEoA:
	blez	$s6,	return			# if (n <= 0)
	bne 	$t0,	$s6,	printNumber	# if (i < n)
	
return:
	# insert a new line
	li	$v0,	4
	la	$a0,	s_newLine
	syscall
	jr 	$ra				# return to function (2, 3, 4, 8, 9)

printNumber:
	# print a[i]
	li 	$v0,	1
	lw 	$a0,	($s0)
	syscall

	# insert 'space'
	li	$v0,	11
	li	$a0,	' '
	syscall
	
	# i++
	addu	$s0,	$s0,	4
	addu	$t0,	$t0,	1
	j	checkEoA
# ===End of Print Array===


# ===Function 3===
function_3:
	# print 's_result3' to console
	li	$v0,	4
	la	$a0,	s_result3
	syscall
	
	# load array and length to build prime array
	la 	$s0,	array
	lw	$s6,	n
	jal	primeArray.Build
	
	# load prime array and length to print to console
	la 	$s0,	array_new
	lw	$s6,	n_prime
	jal	array.Print
	
	# clear value
	add	$s0,	$zero,	$zero
	add	$s6,	$zero,	$zero
	
	j	main.Select
# ===End of Function 3===


# ===build prime number array===
primeArray.Build:
	la	$s1,	array_new
	li	$s7,	0			# n_prime = 0
	li	$t0,	0			# i = 0
	j	primeArray.Scan
	
primeArray.Scan:
	bne	$t0,	$s6,	primeArray.Check	# while (i < n) => primeArray.Check
	sw	$s7,	n_prime			# save 'n_prime'
	jr	$ra				# jump back to 'function_3'
	
primeArray.Check:
	lw	$s2,	($s0)			# x = a[i]
	beq	$s2,	$zero,	nextNumber	# if (x == 0)
	li	$t7,	1
	beq	$s2,	$t7,	nextNumber	# if (x == 1)
	li	$t7,	2
	beq	$s2,	$t7,	primeArray.Add	# if (x == 2)
	li	$t7,	3
	beq	$s2,	$t7,	primeArray.Add	# if (x == 3)
	j	findDivisor			# if (x >= 4)

# find all divisors of a[i]
findDivisor:
	li	$t1,	2			# j = 2		
	div	$s2,	$t1
	mflo	$t3				# y = x / 2
	addu	$t3,	$t3,	1		# y = y + 1

X:
	bne	$t1,	$t3,	loopCheck	# while (j < [x / 2])
	j	primeArray.Add
	
loopCheck:
	div	$s2,	$t1
	mfhi	$t5				# t5 = x mod j
	beq	$t5,	$zero,	nextNumber	# if (t5 == 0) => not prime number
	addu	$t1,	$t1,	1		# j++
	j	X

nextNumber:
	addu	$s0,	$s0,	4
	addu	$t0,	$t0,	1		# i++
	j	primeArray.Scan
	
primeArray.Add:		
	sw	$s2,	($s1)			# array_new[n_prime] = x
	addu	$s1,	$s1,	4
	addu	$s7,	$s7,	1		# n_prime++
	j	nextNumber
# ===End of function===


# ===Function 4===
function_4:
	# print 's_result7' to console
	li	$v0,	4
	la	$a0,	s_result4
	syscall
	
	# load array and length to build prime array
	la 	$s0,	array
	lw	$s6,	n
	jal	perfectArray.Build
	
	# load prime array and length to print to console
	la 	$s0,	array_new
	lw	$s6,	n_perfect
	jal	array.Print
	
	# clear value
	add	$s0,	$zero,	$zero
	add	$s6,	$zero,	$zero
	
	# jump back to selection in menu
	j	main.Select
# ===End of function 4===


# ===Build perfect number array===
perfectArray.Build:
	la	$s1,	array_new
	li	$s7,	0				# n_perfect = 0
	move	$s2,	$ra				# backup $ra
	li	$s4,	0				# i = 0	
	j	perfectArray.Scan

perfectArray.Scan:
	bne	$s4,	$s6,	perfectArray.Check	# while (i < n) => primeArray.Check
	sw	$s7,	n_perfect			# save 'n_prime'
	jr	$s2					# jump back to 'function_4'	

perfectArray.Check:
	lw	$a0,	($s0)				# x = a[i]
	move	$s3,	$a0
	jal	isPerfect
	beq	$v0,	1,	perfectArray.Add	# if (isPerfect) then add to array
	j	perfectArray.Next			# else next number
	
perfectArray.Next:
	addu	$s0,	$s0,	4
	addu	$s4,	$s4,	1			# i++
	j	perfectArray.Scan
	
perfectArray.Add:		
	sw	$s3,	($s1)				# array_new[n_perfect] = x
	addu	$s1,	$s1,	4
	addu	$s7,	$s7,	1			# n_prime++
	j	perfectArray.Next

#======= Ham KTHT ==================
isPerfect:
	li	$t0,	0			# S = 0
	li	$t1,	1			# i = 1
isPerfect.Loop:
	sub	$t2,	$t1,	$a0 		# tmp = i - n
	bltz	$t2,	isPerfect.checkDivisor 	# if (tmp < 0)  // if (i < n)
	j	isPerfect.Compare
isPerfect.checkDivisor:				# check if 'i' is a divisor of 'x'
	div	$a0,	$t1  
	mfhi	$t4 				# mod = n % i
	beq	$t4,	0,	isPerfect.Sum 	# if mod == 0
	j	isPerfect.Next
isPerfect.Sum:
	add	$t0,	$t0,	$t1		# S += i
isPerfect.Next:
	addi	$t1,	$t1,	1		# i++
	j	isPerfect.Loop
isPerfect.Compare:
	beq	$t0,	$a0,	isPerfect.True	# if S == x then return 1
	li	$v0,	0			# else return 0
	jr	$ra
isPerfect.True:
	li	$v0,	1
	jr	$ra
# ===End of function===


# ===Function 5===
function_5:
	# print 's_result7' to console
	li	$v0,	4
	la	$a0,	s_result5
	syscall
	
	# load array and length to build prime array
	la 	$s0,	array
	lw	$s6,	n
	jal	squareArray.Sum
	
	# print Sum
	li	$v0,	1
	lw	$a0,	sum_square
	syscall
	
	# insert a new line
	li	$v0,	4
	la	$a0,	s_newLine
	syscall
	
	# clear value
	add	$s0,	$zero,	$zero
	add	$s6,	$zero,	$zero
	
	# jump back to selection in menu
	j	main.Select
# ===End of function 5===

# ===Sum===
squareArray.Sum:
	move	$s2,	$ra				# backup $ra
	li	$s1,	0
	li	$s4,	0				# i = 0	
	j	squareArray.Scan

squareArray.Scan:
	bne	$s4,	$s6,	squareArray.Check	# while (i < n) then squareArray.Check
	sw	$s1,	sum_square
	jr	$s2					# jump back to 'function_4'	

squareArray.Check:
	lw	$a0,	($s0)				# x = a[i]
	move	$s3,	$a0
	jal	isSquare
	beq	$v0,	1,	squareArray.Plus	# if (isSquare) then Sum += x
	j	squareArray.Next			# else next number
	
squareArray.Next:
	addu	$s0,	$s0,	4
	addu	$s4,	$s4,	1			# i++
	j	squareArray.Scan
	
squareArray.Plus:		
	addu	$s1,	$s1,	$s3			# Sum += x
	j	squareArray.Next
# ===End===

# ===is Square===
isSquare:
	li	$t0,	1			# i = 1
isSquare.Loop:
	mult	$t0,	$t0
	mflo	$t1				# tmp = i * i
	sub	$t2,	$a0,	$t1		# sub = x - tmp	
	bgtz	$t2,	isSquare.iPlus		# if (sub > 0) then i++
	bltz	$t2,	isSquare.Return0	# if (sub < 0) then return 0
	j	isSquare.Return1		# else return 1
isSquare.iPlus:
	addi	$t0,	$t0,	1		# i++
	j	isSquare.Loop
isSquare.Return0:
	li	$v0,	0
	jr	$ra
isSquare.Return1:
	li	$v0,	1
	jr	$ra
# ===End Function===


# ===Function 6===
function_6:
	# print 's_result7' to console
	li	$v0,	4
	la	$a0,	s_result6
	syscall
	
	# load array and length to build prime array
	la 	$s0,	array
	lw	$s6,	n
	jal	symmetryArray.Sum
	
	move	$t0,	$zero
	beq	$v1,	0,	continue	# if count == 0 then avg = 0
	div	$v0,	$v1			# esle avg = Sum / count
	mflo	$t0	
	# print Sum
continue:
	sw	$t0,	avg_symmetry
	li	$v0,	1
	lw	$a0,	avg_symmetry
	syscall
	
	# insert a new line
	li	$v0,	4
	la	$a0,	s_newLine
	syscall
	
	# clear value
	add	$s0,	$zero,	$zero
	add	$s6,	$zero,	$zero
	
	# jump back to selection in menu
	j	main.Select
# ===End of function 6===


# ===$v0_Sum,$v1_count symmetryArray($s0_array, $s6_n)===
symmetryArray.Sum:
	move	$s2,	$ra				# backup $ra
	li	$s1,	0				# Sum = 0
	li	$s5,	0				# count = 0
	li	$s4,	0				# i = 0	
	j	symmetryArray.Scan

symmetryArray.Scan:
	bne	$s4,	$s6,	symmetryArray.Check	# while (i < n) then symmetryArray.Check
	move	$v0,	$s1
	move	$v1,	$s5
	jr	$s2					# jump back to 'function_6'	

symmetryArray.Check:
	lw	$a0,	($s0)				# x = a[i]	
	move	$a1,	$a0				# tmp = x
	move	$s3,	$a0
	jal	isSymmetry
	beq	$v0,	1,	symmetryArray.Plus	# if (isSymmetry) then Sum += x
	j	symmetryArray.Next			# else next number
	
symmetryArray.Next:
	addu	$s0,	$s0,	4
	addu	$s4,	$s4,	1			# i++
	j	symmetryArray.Scan
	
symmetryArray.Plus:		
	addu	$s1,	$s1,	$s3			# Sum += x
	addu	$s5,	$s5,	1			# count++
	j	symmetryArray.Next
# ===End symmetryArray()===

# ===$v0_check isSymmetry($a0_x, $a1_tmp)===
isSymmetry:
	li	$t0,	10
	li	$t1,	0				# reverse = 0
isSymmetry.Loop:
	div	$a1,	$t0				
	mfhi	$t2					# t2 = tmp % 10
	mflo	$a1					# tmp = tmp / 10
		
	mult	$t1,	$t0
	mflo	$t1					# reverse = reverse * 10
	add	$t1,	$t1,	$t2			# reverse += t2
	bne	$a1,	0,	isSymmetry.Loop		# while (tmp != 0)
	
	beq	$t1,	$a0,	isSymmetry.Return1	# if (reverse == x) then return 1
	li	$v0,	0				# else return 0
	jr	$ra
isSymmetry.Return1:
	li	$v0,	1
	jr	$ra
# ===End isSymmetry()===


# ===Function 7===
function_7:
	# print 's_result7' to console
	li	$v0,	4
	la	$a0,	s_result7
	syscall
	
	# load array and length
	la 	$a0,	array
	lw	$a1,	n
	jal	max.Find
	sw	$v0,	max
	
	# print 'max' to console
	lw	$t2, max
	li	$v0, 1
	la	$a0, ($t2)
	syscall
	
	# insert new line
	li	$v0, 4
	la	$a0, s_newLine
	syscall
	
	# jump back to selection in menu
	j	main.Select
# ===End of Function 7===


# ===Find max===
max.Find:
	li	$t0,	0			# int i = 0
	lw	$v0,	($a0)			# int Max = a[0]	
max.ScanArray:
	lw	$t1,	($a0)			# x = a[i]
	bne	$t0,	$a1,	max.Compare	# while (i < n)
	add	$a0,	$zero,	$zero
	add	$a1,	$zero,	$zero
	jr	$ra				# jump back funstion_7
max.Compare:
	sub	$t3,	$t1,	$v0		# tmp = x - max
	bgtz	$t3,	max.NewValue		# if (tmp > 0) { newMax }
	j max.NextNumber			# else	
max.NewValue:
	move	$v0,	$t1			# Max = x
	j max.NextNumber	
max.NextNumber:
	addu	$a0,	$a0,	4
	addu	$t0,	$t0,	1		# i++
	j max.ScanArray
# ===End of Find max===

