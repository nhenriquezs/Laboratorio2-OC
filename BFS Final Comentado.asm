.data

grafo:	.word 999,2,4,7,999,5,999
	.word 2,999,999,6,3,999,8
	.word 4,999,999,999,999,6,999
	.word 7,6,999,999,999,1,6
	.word 999,3,999,999,999,999,7
	.word 5,999,6,1,999,999,6
	.word 999,8,999,6,7,6,999
##GRAFO ORDENADADO PARA OTRA PRUEBA#
#grafo:	.word 999,1,2,3,999,4,999
#	.word 1,999,999,5,6,999,7
#	.word 2,999,999,999,999,8,999
#	.word 3,5,999,999,999,9,10
#	.word 999,6,999,999,999,999,11
#	.word 4,999,8,9,999,999,12
#	.word 999,7,999,10,11,12,999

visitados: 	.word -1,-1,-1,-1,-1,-1,-1
camino:		.word 0
tamano:		.word 7 #tamaño de la fila
fuente: 	.word 0 #nodo origen
objetivo: 	.word 3 #nodo final
	
salto: .asciiz "\n"
espacio: .asciiz "\t"
suma: .asciiz " + "
igual: .asciiz " = "

presentacion: .asciiz "Algoritmo de BFS en MIPS\n\n"
info: .asciiz "Su matriz de adyacencia es: "
nodoI: .asciiz "\nNodo inicial: "
nodoF: .asciiz "\nNodo final: "
resultado: .asciiz "\nEl costo del camino calculado es: "

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

#FUNCION PRINCIPAL DE BEAST FIRST SEARCH
#No recibe parametros porque los llama en un principio y retorna el valor del coste desde el nodo inicial hasta el final.
bfs:
	la $a0, visitados #visitados representa al arreglo que guarda los nodos que han sido visitados y contados.
	lw $a1, camino #será la suma de los costes de los recorridos.
	lw $s0,tamano
	lw $s1, fuente
	lw $s2, objetivo	
	
	sw $s1,0($a0)#visitados[0]=fuente;

	
	addi $t2,$0,1 #j=1
	#primer while que marca cuando el programa ya llegó a su objetivo
	while00: #while(fuente!=objetivo)
	addi $t1,$0,0 #i=0
		beq $s1,$s2,finwhile00
		addi $t3,$0,999 #menor=9999
		for02: #for(i=0;i<7;i++)
			beq $t1,$s0,finfor02 #for(i=0;i<7;i++)
			if00: #visitados[i]!=i
				sll $t4,$t1,2 #t4=i*4
				add $t4,$a0,$t4
				lw $t5,0($t4) #t5=visitados[i]
				beq $t5,$t1,finif00 #if(visitados[i]!=i)
				if01: #menor>matriz[fuente][i]
					addi $sp,$sp,-12
					sw $a0,0($sp)
					sw $a1,4($sp)
					sw $ra,8($sp)
					
					#acceder a la matriz para conocer un valor.
					add $a0,$0,$s1 #a0=fuente
					add $a1,$0,$t1 #a1=i
					jal accederMatriz #matriz[fuente][i]
					add $t4,$0,$v0 #t4=matriz[fuente][i]
	
					lw $a0,0($sp)
					lw $a1,4($sp)
					lw $ra,8($sp)
					addi $sp,$sp,12
					ble $t3,$t4,finif00 #if(menor>matriz[fuente][i])
					
					#se guarda el menor coste que contenga la posicion matriz[fuente][i]
					add $t3,$0,$t4	#menor=matriz[fuente][i];
							
					sll $t5,$t2,2 #t5=j*4
					add $t6,$a0,$t5
					#se guarda el nodo visitado
					sw $t1,0($t6) #visitados[j]=i;
			finif00:
			
			
			addi $t1,$t1,1 #i++
			j for02
		finfor02:
		add $a1,$a1,$t3 #camino=camino+menor;

		sll $t5,$t2,2 #t5=j*4
		add $t6,$a0,$t5
		lw $t7,0($t6) #t7=visitados[j]
		add $s1,$0,$t7	#fuente=visitados[j];
		addi $t2,$t2,1	#j++;

		j while00
	finwhile00:
	
	add $v0,$0,$a1
	jr $ra
	
main:
	#imprimimos la matriz
	addi $sp,$sp,-4
	sw $ra,0($sp)
	jal imprimirMatriz
	lw $ra,0($sp)
	addi $sp,$sp,4

	#ejecutamos el algoritmo.
	addi $sp,$sp,-4
	sw $ra,0($sp)
	jal bfs
	lw $ra,0($sp)
	addi $sp,$sp,4
	
	add $t0,$0,$v0 #solucion en t0
	
	la $a0, resultado
	add $v0,$0,4
	syscall	
			
	la $a0,($t0)
	li $v0,1
	syscall
	
	
	
