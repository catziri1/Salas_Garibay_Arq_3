.text
	nop
	addi $t0, $zero, 5
	nop
	nop
	add $t1, $t0, $zero
	nop
	nop
	addi $t1, $t1, 2
	nop
	nop
	addi $t2, $t1, 3
	addi $t3, $t3, 0x010010000
	nop
	jal STORE
STORE:
	sw $t2, 0($t3)
	nop
	nop
	add $s0, $t2, $t1
	nop
	nop
	sub $s1, $s0, $t3
	nop
	nop
	lw $t6, 0($t3)
	nop
	nop
	addi $s2, $t2, -2
	nop
	nop
	or $s2, $s2, $t4
	nop
	nop
	sll $s7, $s2, 2
exit:
	
	
