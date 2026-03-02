.data
	limit:		.word 0
	dois:		.word 2
	
	limite_msg:	.asciiz "Digite o limite do contador: "
	contador_msg:	.asciiz "Contador: "
	qntd_msg:	.asciiz "Quantidade de pares: "
	linha:		.asciiz "\n"
	
.text
main:
	# Ler limite do teclado
	
	la 	$a0, limite_msg
	li	$v0, 4			# printar string
	syscall	
	
	li	$v0, 5			# ler inteiro valor vai para v0
	syscall
	
	# Atribuir limite para registrador
	
	move	$s0, $v0		# $s0 = limite
	
	# Definir contador (conta quantos números pares têm)
	
	li	$s1, 0			# $s1 = count
	
	li	$s3, 0			# $s3 = i
	
	la	$s4, dois

for:
	# for i < limite
	beq 	$s3, $s0, fim
	
	# verificar se divisão por 2 é igual a zero e ir para o if
	div 	$s3, $s4		# divide i por 2 ou multiplo de 2
	mfhi	$s4
	beqz	$s4, if	

fim_for:
	# incrementar i
	addi	$s3, $s3, 1
	j	for
	

if:
		# incrementar contador
	addi	$s1, $s1, 1
	
		# precisa incrementar divisor
	addi	$s4, $s4, 2
	
		# printar i
	la 	$a0, contador_msg
	li	$v0, 4			# printar string
	syscall	
	move 	$a0, $s3
	li	$v0, 1			# printar inteiro
	syscall
	la 	$a0, linha
	li	$v0, 4			# printar string
	syscall
	
		# sair do if
	j fim_for
	
	# finalizar programa
fim:
	# decidimos printar o count também:
	la	$a0, qntd_msg
	li	$v0, 4
	syscall
	move 	$a0, $s1
	li	$v0, 1			# printar inteiro
	syscall
	
	li	$v0, 10			# finalizar
	syscall	