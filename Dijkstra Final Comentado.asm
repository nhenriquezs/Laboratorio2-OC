.data

grafo:	
	.word 999,999,999,999,999,999,999,999
	.word 999,999,2,4,7,999,5,999
	.word 999,2,999,999,6,3,999,8
	.word 999,4,999,999,999,999,6,999
	.word 999,7,6,999,999,999,1,6
	.word 999,999,3,999,999,999,999,7
	.word 999,5,999,6,1,999,999,6
	.word 999,999,8,999,6,7,6,999
##GRAFO ORDENADADO PARA OTRA PRUEBA#	
#grafo:	.word 999,999,999,999,999,999,999,999
#	.word 999,999,1,2,3,999,4,999
#	.word 999,1,999,999,5,6,999,7
#	.word 999,2,999,999,999,999,8,999
#	.word 999,3,5,999,999,999,9,10
#	.word 999,999,6,999,999,999,999,11
#	.word 999,4,999,8,9,999,999,12
#	.word 999,999,7,999,10,	11,12,999
dist: 	.word 999,999,999,999,999,999,999,999
selected: 	.word 0,0,0,0,0,0,0,0
prev: 		.word -1,-1,-1,-1,-1,-1,-1,-1
tamano:		.word 8
fuente: 	.word 1
objetivo: 	.word 4
	
salto: .asciiz "\n"
espacio: .asciiz "\t"
suma: .asciiz " + "
igual: .asciiz " = "

presentacion: .asciiz "Algoritmo de DIJKSTRA en MIPS\n\n"
info: .asciiz "Su matriz de adyacencia es: "
nodoI: .asciiz "\nNodo inicial: "
nodoF: .asciiz "\nNodo final: "
resultado: .asciiz "\nEl camino más corto es: "


.text

j main
imprimirMatriz: #FUNCION QUE IMPRIME LA MATRIZ RECORRIENDO TODOS SUS ELEMENTOS#
	#IMPRIMIENDO INFO##
	addi $sp,$sp,-8
	sw $a0,0($sp)
	sw $v0,4($sp)
	
	la $a0, presentacion
	add $v0,$0,4
	syscall			
	la $a0, info
	add $v0,$0,4
	syscall			
		
	lw $a0,0($sp)
	lw $v0,4($sp)
	addi $sp,$sp,8
	##FIN IMPRIMIENDO INFO##	
	lw $t0,tamano
	addi $t1,$0,1
	for00:	#for(i=0 hasta tamano)
		la $a0,salto
		li $v0,4
		syscall
		beq $t1,$t0,finFor00
		addi $t2,$0,1
		for01: #for(j=0 hasta tamano)
			beq $t2,$t0,finFor01
			la $a0,($t1)
			la $a1,($t2)
			
			addi $sp,$sp,-4
			sw $ra,0($sp)
			jal accederMatriz #Accede a un punto especifico de la matriz
			lw $ra,0($sp)
			addi $sp,$sp,4
			
			la $a0,($v0)
			li $v0,1
			syscall
			la $a0,espacio
			li $v0,4
			syscall
			addi $t2,$t2,1
			j for01
		finFor01:
		
		addi $t1,$t1,1
		j for00
	finFor00:
	#IMPRIMIENDO NODOS##
	addi $sp,$sp,-8
	sw $a0,0($sp)
	sw $v0,4($sp)
	
	la $a0, nodoI
	add $v0,$0,4
	syscall	
	add $v0,$0,1
	lw $a0,fuente
	syscall	
	la $a0, nodoF
	add $v0,$0,4
	syscall	
	add $v0,$0,1
	lw $a0,objetivo
	syscall	
	
	lw $a0,0($sp)
	lw $v0,4($sp)
	addi $sp,$sp,8
	##FIN IMPRIMIENDO NODOS	
	jr $ra

#AccederMatriz recibe como parametros a0 y a1 como los valores de fila y columans, para llamar a un punto específico
#la idea general es que para llegar a una posicion calcula fila*tamano+columna

accederMatriz: ##$a0->fila (i)
	       ##$a1->columna (j)
	addi $sp,$sp,-8
	sw $t0,0($sp)
	sw $t1,4($sp)
	
	la $t0,grafo #llamada al grafo
	lw $t1,tamano#se guarda el valor de tamano
	
	mul $t1,$t1,$a0
	add $t1,$t1,$a1
	sll $t1,$t1,2
	add $t1,$t1,$t0
	lw $v0,0($t1)
	
	lw $t0,0($sp)
	lw $t1,4($sp)
	addi $sp,$sp,8	
	
	jr $ra
#Algorimo de Dijkstra que retorna el camino más corto para llegar del nodo incial al final.
#No recibe parametros porque los llama en un inicio.
dijkstra:
	la $a0, dist #simula un arreglo que guarda las distancias
	la $a1, prev #guarda los valores de una posicion anterios
	la $a2, selected #simula un arreglo con los nodos seleccionados
	lw $t0, fuente #se refiere al nodo inicial
	lw $t1, objetivo #simula el nodo final al cual se quiere llegar
	lw $t5,tamano #es el tamaño de la fila
	addi $t5,$t5,-1 #se le resta 1, porque los for se haran desde 1 hasta tamano-1
	
	#selected[fuente] = 1	
	#se asigna un 1 al primer valor del arreglo selected.
	addi $t2,$0,1
	sll $t3,$t0,2
	add $t3,$a2,$t3
	sw $t2,0($t3)
	#dist de fuente deja de 999
	#dist[fuente] = 0;
	addi $t2,$0,0
	sll $t3,$t0,2
	add $t3,$a0,$t3
	sw $t2,0($t3)
	
	#cuando selected[objetivo] sea distinto de 0 significará que ya se llegó al objetivo buscado, y se retornará el valor de coste.
	while00: #while(selected[objetivo] ==0)
		sll $t2,$t1,2 
		add $t3,$a2,$t2
		lw $t4,0($t3)		
		bnez $t4, finwhile00 #branch selected[objetivo]==0
		
		addi $t2,$0,999  #min=999
		addi $t3,$0,0	#m=0
		addi $t4,$0,1	#i=1
		for03:	#for i de 1 a tamano=$t5 (debe ir de 1 a tamaÃ±o-1)
			beq $t4,$t5,finFor03
			
			sll $t6,$t0,2 #t6 = fuente*4
			add $t6,$a0,$t6  
			lw $t7,0($t6) #t7=dist[fuente]
			
			addi $sp,$sp,-12
			sw $a0,0($sp)
			sw $a1,4($sp)
			sw $ra,8($sp)
	
			la $a0,0($t0) #a0=fuente
			la $a1,0($t4) #a1=i
			jal accederMatriz #grafo[fuente][i]
			add $t8,$0,$v0 #t8=grafo[fuente][i]
	
			lw $a0,0($sp)
			lw $a1,4($sp)
			lw $ra,8($sp)
			addi $sp,$sp,12

			add $t6,$t7,$t8 #d =t6=dist[fuente]+grafo[fuente][i]	
			
			sll $t8,$t4,2 #t8=i*4
			add $t8,$a2,$t8
			lw $t7,0($t8)#t7=selected[i]
			
			bnez $t7,if01out #if(selected[i]==0)
				
				#dist[t4]
				sll $t8,$t4,2 #t8=i*4
				add $t8,$a0,$t8
				lw $t7,0($t8)#t7=dist[i]
				bge $t6,$t7,if02out #if(t6<t7)
					sll $t8,$t4,2 #t8=i*4
					add $t8,$a0,$t8
					sw $t6,0($t8)	#dist[i] = t6 = d;
					
					sll $t8,$t4,2 #t8=i*4
					add $t8,$a1,$t8
					sw $t0,0($t8)  #prev[i] = fuente;
				if02out:
				sll $t8,$t4,2 #t8=i*4
				add $t8,$a0,$t8
				lw $t7,0($t8)#t7=dist[i]
				ble $t2,$t7,if01out #if(t3>t7)
					add $t2,$0,$t7 # min = dist[i];
					add $t3,$0,$t4 # m = i;	
			if01out:
			
			addi $t4,$t4,1 
			j for03
		finFor03:
        	add $t0,$0,$t3 # fuente = m;
		
		sll $t6,$t0,2 #t6=fuente*4
		add $t6,$a2,$t6
		addi $t8,$0,1 #t8 = 1
		sw $t8,0($t6) # selected[fuente] = t8 = 1;
		
		sll $t2,$t1,2 
		add $t3,$a2,$t2
		lw $t4,0($t3)		
		beqz $t4, while00 #branch selected[objetivo]==0
	finwhile00:
	add $t0,$0,$t1 #fuente = objetivo
	
	#dist[objetivo];
	sll $t1,$t1,2
	add $t1,$a0,$t1
	lw $v0,0($t1)
	jr $ra #return dist[objetivo];
main:
	#imprimimos la matriz y los nodos
	addi $sp,$sp,-4
	sw $ra,0($sp)
	jal imprimirMatriz
	lw $ra,0($sp)
	addi $sp,$sp,4
	
	#ingresando al algoritmo Dijkstra
	addi $sp,$sp,-4
	sw $ra,0($sp)
	jal dijkstra
	lw $ra,0($sp)
	addi $sp,$sp,4
	
	add $t0,$0,$v0 #solucion en t0
	
	la $a0, resultado
	add $v0,$0,4
	syscall	
			
	la $a0,($t0)
	li $v0,1
	syscall
	
	
