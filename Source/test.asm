.data
	a: .space 1024
	x: .word 0
	n: .word 20
.text
main:
	li $s1,1
	lw $s2,n
	jal scan
	jal print
	jal end
	
scan:
	la $t0,($s1)	#i = 0
	la $s0,a
	la $t1,x
	j loopIn
	
loopIn:
	bne $t0,$s2,input
	jr $ra
	
input:	
	li $v0, 42
	li $a1, 100
	sw $a0,($s0)
	syscall
	
	addi $t0,$t0,1
	addi $s0,$s0,4
	j loopIn
	
print:
	la $s0,a
	la $t0,($s1)
	j loopOut
	
loopOut:
	bne $t0,$s2,output
	jr $ra

output:
	#Xuat a[i]
	li $v0,1
	lw $a0,($s0)  
	syscall

	#xuat khoang trang
	li $v0,11
	li $a0,' '
	syscall
	
	#Tang dia chi mang
	addi $s0,$s0,4
	addi $t0,$t0,1
	j loopOut
end:
	li $v0, 10
	syscall