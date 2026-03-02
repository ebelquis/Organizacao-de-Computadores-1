.data
	tx: .asciiz "Escreva o valor de x: "
	tn: .asciiz "Escreva o valor de n: "
	tr: .asciiz "Valor aproximadoda raiz quadrada: "
	ts: .asciiz "Valor com sqrt: "
	te: .asciiz "Valor do erro: "
	newline: .asciiz "\n"
	
.text
	#obter os valores
	li $v0, 4
	la $a0, tx
	syscall
	li $v0, 5
	syscall
	mtc1 $v0, $f0
	li $v0, 4
	la $a0, tn
	syscall
	li $v0, 5
	syscall
	move $a2, $v0
	cvt.d.w $f0, $f0
	mfc1.d $a0, $f0
	mov.d $f28, $f0
	jal raiz_quadrada
	
	#imprimir os resultados
	mtc1.d $v0, $f12
	li $v0, 4
	la $a0, tr
	syscall
	li $v0, 3
	syscall
	mov.d $f30, $f12
	sqrt.d $f12, $f28
	li $v0, 4
	la $a0, newline
	syscall
	li $v0, 4
	la $a0, ts
	syscall
	li $v0, 3
	syscall
	sub.d $f12, $f12, $f30
	abs.d $f12, $f12
	li $v0, 4
	la $a0, newline
	syscall
	li $v0, 4
	la $a0, te
	syscall
	li $v0, 3
	syscall
	j end

raiz_quadrada:
	mtc1.d $a0, $f0
	li $t1, 0
	li $t0, 1
	mtc1 $t0, $f2
	li $t0, 2
	mtc1 $t0, $f4
	move $t0, $a2
	cvt.d.w $f2, $f2
	cvt.d.w $f4, $f4
loop:
	div.d $f6, $f0, $f2
	add.d $f2, $f2, $f6
	div.d $f2, $f2, $f4
	addi $t1, $t1, 1
	bne $t0, $t1, loop
	mfc1.d $v0, $f2
	jr $ra

end:
