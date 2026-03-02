.data
	tx: .asciiz "Escreva o valor de x: "
	ts: .asciiz "Valor do seno: "
	
.text
	# obter os valores
	li $v0, 4
	la $a0, tx
	syscall
	li $v0, 7
	syscall
	li $t0, 1
	mtc1 $t0, $f6
	cvt.d.w $f6, $f6
	
	# inicializa $f2 = 0.0 
	mtc1 $zero, $f2
	cvt.d.w $f2, $f2
	
	#1
	add.d $f2, $f2, $f0
	
	#2
	mul.d $f4, $f0, $f0
	mul.d $f4, $f4, $f0
	add.d $f8, $f6, $f6
	mov.d $f10, $f8
	add.d $f8, $f8, $f6
	mul.d $f12, $f8, $f10
	mov.d $f14, $f12
	div.d $f12, $f4, $f12
	sub.d $f2, $f2, $f12
	
	#3
	mul.d $f4, $f4, $f0
	mul.d $f4, $f4, $f0
	add.d $f8, $f8, $f6
	mov.d $f10, $f8
	add.d $f8, $f8, $f6
	mul.d $f12, $f8, $f10
	mul.d $f12, $f12, $f14
	mov.d $f14, $f12
	div.d $f12, $f4, $f12
	add.d $f2, $f2, $f12
	
	#4
	mul.d $f4, $f4, $f0
	mul.d $f4, $f4, $f0
	add.d $f8, $f8, $f6
	mov.d $f10, $f8
	add.d $f8, $f8, $f6
	mul.d $f12, $f8, $f10
	mul.d $f12, $f12, $f14
	mov.d $f14, $f12
	div.d $f12, $f4, $f12
	sub.d $f2, $f2, $f12
	
	#5
	mul.d $f4, $f4, $f0
	mul.d $f4, $f4, $f0
	add.d $f8, $f8, $f6
	mov.d $f10, $f8
	add.d $f8, $f8, $f6
	mul.d $f12, $f8, $f10
	mul.d $f12, $f12, $f14
	mov.d $f14, $f12
	div.d $f12, $f4, $f12
	add.d $f2, $f2, $f12
	
	#6
	mul.d $f4, $f4, $f0
	mul.d $f4, $f4, $f0
	add.d $f8, $f8, $f6
	mov.d $f10, $f8
	add.d $f8, $f8, $f6
	mul.d $f12, $f8, $f10
	mul.d $f12, $f12, $f14
	mov.d $f14, $f12
	div.d $f12, $f4, $f12
	sub.d $f2, $f2, $f12
	
	#7
	mul.d $f4, $f4, $f0
	mul.d $f4, $f4, $f0
	add.d $f8, $f8, $f6
	mov.d $f10, $f8
	add.d $f8, $f8, $f6
	mul.d $f12, $f8, $f10
	mul.d $f12, $f12, $f14
	mov.d $f14, $f12
	div.d $f12, $f4, $f12
	add.d $f2, $f2, $f12
	
	#8
	mul.d $f4, $f4, $f0
	mul.d $f4, $f4, $f0
	add.d $f8, $f8, $f6
	mov.d $f10, $f8
	add.d $f8, $f8, $f6
	mul.d $f12, $f8, $f10
	mul.d $f12, $f12, $f14
	mov.d $f14, $f12
	div.d $f12, $f4, $f12
	sub.d $f2, $f2, $f12
	
	#9
	mul.d $f4, $f4, $f0
	mul.d $f4, $f4, $f0
	add.d $f8, $f8, $f6
	mov.d $f10, $f8
	add.d $f8, $f8, $f6
	mul.d $f12, $f8, $f10
	mul.d $f12, $f12, $f14
	mov.d $f14, $f12
	div.d $f12, $f4, $f12
	add.d $f2, $f2, $f12
	
	#10
	mul.d $f4, $f4, $f0
	mul.d $f4, $f4, $f0
	add.d $f8, $f8, $f6
	mov.d $f10, $f8
	add.d $f8, $f8, $f6
	mul.d $f12, $f8, $f10
	mul.d $f12, $f12, $f14
	mov.d $f14, $f12
	div.d $f12, $f4, $f12
	sub.d $f2, $f2, $f12
	
	#11
	mul.d $f4, $f4, $f0
	mul.d $f4, $f4, $f0
	add.d $f8, $f8, $f6
	mov.d $f10, $f8
	add.d $f8, $f8, $f6
	mul.d $f12, $f8, $f10
	mul.d $f12, $f12, $f14
	mov.d $f14, $f12
	div.d $f12, $f4, $f12
	add.d $f2, $f2, $f12
	
	#12
	mul.d $f4, $f4, $f0
	mul.d $f4, $f4, $f0
	add.d $f8, $f8, $f6
	mov.d $f10, $f8
	add.d $f8, $f8, $f6
	mul.d $f12, $f8, $f10
	mul.d $f12, $f12, $f14
	mov.d $f14, $f12
	div.d $f12, $f4, $f12
	sub.d $f2, $f2, $f12
	
	#13
	mul.d $f4, $f4, $f0
	mul.d $f4, $f4, $f0
	add.d $f8, $f8, $f6
	mov.d $f10, $f8
	add.d $f8, $f8, $f6
	mul.d $f12, $f8, $f10
	mul.d $f12, $f12, $f14
	mov.d $f14, $f12
	div.d $f12, $f4, $f12
	add.d $f2, $f2, $f12
	
	#14
	mul.d $f4, $f4, $f0
	mul.d $f4, $f4, $f0
	add.d $f8, $f8, $f6
	mov.d $f10, $f8
	add.d $f8, $f8, $f6
	mul.d $f12, $f8, $f10
	mul.d $f12, $f12, $f14
	mov.d $f14, $f12
	div.d $f12, $f4, $f12
	sub.d $f2, $f2, $f12
	
	#15
	mul.d $f4, $f4, $f0
	mul.d $f4, $f4, $f0
	add.d $f8, $f8, $f6
	mov.d $f10, $f8
	add.d $f8, $f8, $f6
	mul.d $f12, $f8, $f10
	mul.d $f12, $f12, $f14
	mov.d $f14, $f12
	div.d $f12, $f4, $f12
	add.d $f2, $f2, $f12
	
	#16
	mul.d $f4, $f4, $f0
	mul.d $f4, $f4, $f0
	add.d $f8, $f8, $f6
	mov.d $f10, $f8
	add.d $f8, $f8, $f6
	mul.d $f12, $f8, $f10
	mul.d $f12, $f12, $f14
	mov.d $f14, $f12
	div.d $f12, $f4, $f12
	sub.d $f2, $f2, $f12
	
	#17
	mul.d $f4, $f4, $f0
	mul.d $f4, $f4, $f0
	add.d $f8, $f8, $f6
	mov.d $f10, $f8
	add.d $f8, $f8, $f6
	mul.d $f12, $f8, $f10
	mul.d $f12, $f12, $f14
	mov.d $f14, $f12
	div.d $f12, $f4, $f12
	add.d $f2, $f2, $f12
	
	#18
	mul.d $f4, $f4, $f0
	mul.d $f4, $f4, $f0
	add.d $f8, $f8, $f6
	mov.d $f10, $f8
	add.d $f8, $f8, $f6
	mul.d $f12, $f8, $f10
	mul.d $f12, $f12, $f14
	mov.d $f14, $f12
	div.d $f12, $f4, $f12
	sub.d $f2, $f2, $f12
	
	#19
	mul.d $f4, $f4, $f0
	mul.d $f4, $f4, $f0
	add.d $f8, $f8, $f6
	mov.d $f10, $f8
	add.d $f8, $f8, $f6
	mul.d $f12, $f8, $f10
	mul.d $f12, $f12, $f14
	mov.d $f14, $f12
	div.d $f12, $f4, $f12
	add.d $f2, $f2, $f12
	
	#20
	mul.d $f4, $f4, $f0
	mul.d $f4, $f4, $f0
	add.d $f8, $f8, $f6
	mov.d $f10, $f8
	add.d $f8, $f8, $f6
	mul.d $f12, $f8, $f10
	mul.d $f12, $f12, $f14
	mov.d $f14, $f12
	div.d $f12, $f4, $f12
	sub.d $f2, $f2, $f12
	
	mov.d $f12, $f2
	li $v0, 4
	la $a0, ts
	syscall
	li $v0, 3
	syscall	
