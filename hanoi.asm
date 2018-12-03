.text
Main:
	lui $sp,  0x1001
	ori $sp,0x800
	add $s0,$zero, 3#valor de n
	add $a0,$zero,0 #conrador para ir recorriendo la memoria si son mas de 8 discos
	add $t2,$zero, $s0 #auxiliar donde se guarda n, dicho registro se utilizará para llenar la "pila" origen
	lui $t1,  0x1001 #se indica la dirección de memoria donde se guardará la "pila" origen
	ori $t1,0x0000
	lui $t3 , 0x1001 #pila auxiliar
	ori $t3,0x0020
	lui $t4 ,0x1001 #pila destino
	ori $t4,0x0040
	
	j Load #ciclo para llenar la "pila" origen



Load:
	
	sw $t2, 0($t1) #se guarda lo que tiene t2 en la dirección que contiene  t1
	add $t1, $t1, 4 #se suma 4 al program counter
	sub $t2,$t2,1 #se le resta uno a t2

	add $a0,$a0,1 #se le suma uno al contador
	beq $a0,9,ModificarM
continue:bne $t2,0,Load #se vuelve a llamar el ciclo mientras no se llegue a cero
	sub $t1,$t1,4
	j Hanoi

	
ModificarM:

	add $a0,$zero,0#iniciar de nuevo en 0
	add $t3,$t3,32
	add $t4 ,$t4,64
	j continue

Hanoi:

	beq $s0,1,Move	 	#si es uno salta a Move

	addi $sp, $sp,-8 # Decreasing the stack pointer
	sw $ra 4($sp)  
	sw $s0, 0($sp)  # Storing n
	sub $s0,$s0,1	#n-1
	
	#cambiamos dirección destino por auxiliar
	addi $t0, $t3,0 #auxiliar para cambiar las direcciones de pilas destino y auxiliar para la llamada recursiva
	addi $t3 $t4, 0#la pila aux ahora es la destino
	addi $t4 $t0, 0 #la pila destino ahora es la auxiliar

	
	jal Hanoi #llamada recursiva
	
	##REGRESAMOS A LOS VALORES DE LA PRIMERA LLAMADA
	#cambiamos dirección auxiliar  por destino para regresar a las direcciones de la primera llamada
	addi $t0, $t3,0 #auxiliar para cambiar las direcciones de pilas destino y auxiliar para la llamada recursiva
	addi $t3 $t4, 0#la pila aux ahora es la destino
	addi $t4 $t0, 0 #la pila destino ahora es la auxiliar
	
	sub $t1, $t1, 4 
	#cuando sale de la llamada recursiva
	lw $s0, 0($sp) 		# Carga el último valor de n en s0
	lw $ra, 4($sp) 		# Loading values from stack
	
	sw $s0,0($t4) 		#mueve
	sw $t2, 0($t1) 		#va a ir cambiando la constante
	
	sub $s0,$s0,1 		#n-1 para la segunda llamada recursiva

	
	#cambiamos dirección para segunda llamada recursiva origen por auxiliar
	addi $t0, $t1,0 #auxiliar para cambiar las direcciones de pilas origen y auxiliar para la llamada recursiva
	addi $t1 $t3, 0#la pila origen ahora es la auxiliar
	addi $t3 $t0, 0 #la pila aux ahora es la origen
	add $t4, $t4, 4
	
	
	#########################
	###  SEGUNDA RECURSION ##
	########################
	
	jal Hanoi  #segunda llamada recursiva
		
	#cambiamos dirección auxiliar  por origen para regresar a las direcciones de la primera llamada
	addi $t0, $t3,0 #auxiliar para cambiar las direcciones de pilas origen y auxiliar para la llamada recursiva
	addi $t3 $t1, 0#la pila aux ahora es la origen
	addi $t1 $t0, 0 #la pila origen ahora es la auxiliar
	
	#sub $t4, $t4, 4
	
	#cuando sale de la llamada recursiva
	lw $s0, 0($sp) 		# Carga el último valor de n en s0
	lw $ra, 4($sp) 		# Loading values from stack
#	addi $sp, $sp, 8	#Regresa el stack


	addi $sp, $sp, 8	#Regresa el stack
	jr $ra
	

Move: #función para guardar el valor del disco en la pila destino. 
	sw $s0,0($t4) 		#mueve
	sw $t2, 0($t1) 		#va a ir cambiando la constante
	#sub $t1, $t1, 4 	#regresa a la dirección anterior 
	jr $ra

Exit:

