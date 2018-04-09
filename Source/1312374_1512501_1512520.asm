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
	s_menu:		.asciiz "========MENU========\n1. Nhap mang\n2. Xuat mang\n3. Liet ke so nguyen to\n4. Liet ke so hoan thien\n5. Tong cac so chinh phuong\n6. Trung binh cong cac so doi xung\n7. Gia tri lon nhat\n8. Sap xep mang tang dan (selection soft)\n9. Sap xep mang giam dan (bubble soft)\n10. Thoat\n==============\n"
	s_select:	.asciiz "Chon: "
	s_selectAgain:	.asciiz "Chon lai: "
	select:		.word 0
	s_result2:	.asciiz "Mang da nhap: "
	s_result3:	.asciiz "Cac so nguyen to trong mang: "
	s_result4:	.asciiz "Cac so hoan thien trong mang: "
	s_result5:	.asciiz "Tong cac so chinh phuong: "
	s_result6:	.asciiz "Trung binh cong cac so doi xung: "
	s_result7:	.asciiz "Gia tri lon nhat: "
	s_result8:	.asciiz "Sap xep mang tang dan: "
	s_result9:	.asciiz "Sap xep mang giam dan: "
	s_resultX:	.asciiz "Just for testing...\n"

# Note (using registers)
#	$s0	selection of the menu
#	$s1	array (integer) - which has been converted from string
#	$s2	count of number of array (n)
#	$s3	"prime number" array (count = n_prime)
#	$s4	"perfect number" array (count = n_perfect)
#	$s5	sorted array (selection sort/bubble sort)

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
	lw	$s0,	select
	
	# quit if 'select' = 10; else jump to 'selectAgain:'
	beq	$s0,	10,	m_end
	beq	$s0,	11,	function_X	# testing
	bne	$s0,	10,	m_selectAgain	# use when select < 1 or select > 10
	# add funtion base on 
	
# end program
m_end:
	li $v0, 10
	syscall
	
# =================================FUNCTION=================================
function_X:
	# do something here
	
	li	$v0,	4
	la	$a0,	s_resultX
	syscall
	
	# jump back to selection in menu
	j	m_select