.data
	tb1: .asciiz "Nhap n: "
	tb2: .asciiz "N la so hoan thien."
	tb3: .asciiz "N khong la so hoan thien."
	n: .word 0
.text
main:
	#Xuat tb1
	li $v0,4
	la $a0,tb1
	syscall

	#Nhap so nguyen
	li $v0,5
	syscall

	#Luu vao n
	sw $v0,n

	#Truyen tham so
	lw $a0,n
	
	#Goi ham
	jal KTHT
	
	#Lay ket qua tra ve
	move $s0,$v0
	beq $s0,1,LaHT

	#Khong la hoan thien
	li $v0,4
	la $a0,tb3
	syscall
	j KetThuc
LaHT:	
	li $v0,4
	la $a0,tb2
	syscall
	
KetThuc:
	li $v0,10
	syscall

#======= Ham KTHT ==================
#Dau thu tuc
KTHT:
	#Khai bao kich thuoc stack
	addi $sp,$sp,-16
	#Backup thanh ghi
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $t0,8($sp)
	sw $t1,12($sp)
	

#Than thu tuc
	# S = 0
	li $s0,0
	#Khoi tao vong lap
	#i = 1
	li $t0,1
KTHT.Lap:
	sub $t1,$t0,$a0 # t1 = i - n
	bltz $t1,KTHT.KTUS # t1 < 0 <=> i < n
	j KTHT.KTLap
KTHT.KTUS:
	# Kiem tra i la uoc so cua n ?
	div $a0,$t0  
	mfhi $t1 # Lay phan du t1 = n % i
	beq $t1,0,KTHT.TongUS  #Neu phan du t1 = 0 thi tinh tong us
	j KTHT.Tangi
KTHT.TongUS:
	add $s0,$s0,$t0
KTHT.Tangi:
	addi $t0,$t0,1
	j KTHT.Lap
KTHT.KTLap:
	beq $s0,$a0,KTHT.Return1
	#Reutrun 0
	li $v0,0
	j KTHT.KetThuc	
KTHT.Return1:
	li $v0,1
KTHT.KetThuc:
#Cuoi Thu Tuc
	#Restore thanh ghi
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $t0,8($sp)
	lw $t1,12($sp)

	#Xoa stack
	addi $sp,$sp,16
	
	#Tra ve
	jr $ra
	