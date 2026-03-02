.data
	a: .word 1
	b: .word -5
	c: .word 6
	x1: .word 0
	x2: .word 0
	espaco: .asciiz " "
.text 
	lw 	$t9, a		# Salva o valor de A para o registrador t9
	lw 	$t8, b		# Salva o valor de B para o registrador t8
	lw 	$t7, c		# Salva o valor de C para o registrador t7

	mul 	$t0, $t8, $t8	# b^2
	
	mul 	$t1, $t9, 4	# Bloco da operação 4ac
	mul 	$t1, $t1, $t7
	
	sub 	$t0, $t0, $t1	# Operação b^2-4ac
	
	mtc1 $t0, $f1        	# Move o inteiro de $t0 para o registrador de ponto flutuante $f4
	cvt.s.w $f1, $f1     	# Converte de inteiro (word) para float (single)
	
	sqrt.s 	$f1, $f1	# Faz a raiz quadrada de delta
	
	cvt.w.s $f1, $f1	# Converte para word novamente
	mfc1  $t0, $f1		# Move do registrador de ponto flutuante f1 para t0
	
	sub 	$t1, $zero, $t8	# Operação para obter -b
	
	mul 	$t2, $t9, 2	# Operação 2a
	
	add 	$t3, $t1, $t0	# Operação (-b)+ raiz quadrada de delta
	div 	$s0, $t3, $t2	# Divide a operação acima por 2a
	
	sub 	$t3, $t1, $t0	# Operação (-b) - raiz quadrada de delta
	div 	$s1, $t3, $t2	# Divide a operação acima por 2a
	
	li 	$v0, 1		# Carrega 1 em v0 para printar inteiro
	add 	$a0, $a0, $s0	# Salva em a0 o valor final da conta
	sw 	$a0, x1		# Salva em x1 o valor final da conta
	syscall
	
	li 	$v0, 4		# Carrega 4 em v0 para printar uma string
	la  	$a0, espaco	# Salva em a0 um espaço em branco (" ") só para separar os dois valores de x na hora da exibicao
	syscall
	
	li 	$v0, 1		# Carrega 1 em v0 para printar inteiro
	add 	$a0, $zero, $s1	# Salva em a0 o valor final da conta
	sw 	$a0, x2		# Salva em x2 o valor final da conta
	syscall
