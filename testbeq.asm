.text
	add $t1,$zero,3
	lui $s3,0x7fff
	ori $s3,0xeffc
	
	sw $t1, 0($s3)
	lw $s4, 0($s3)
	j Exit

Exit:
