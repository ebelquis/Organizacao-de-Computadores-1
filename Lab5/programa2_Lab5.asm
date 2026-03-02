.data
	
	vetor_msg:	.asciiz "Digite o tamanho do vetor: "
	numeros1_msg:	.asciiz "Digite "
	numeros2_msg:	.asciiz " números para o vetor:\n"
	key_msg:	.asciiz "Digite o número a procurar: "
	achou_msg:	.asciiz "Número encontrado!\n"
	n_achou_msg:	.asciiz "Número não encontrado!\n"
	linha:		.asciiz "\n"
	
.text
main:
	# Ler size do teclado
	
	la 	$a0, vetor_msg
	li	$v0, 4			# printar string
	syscall	
	
	li	$v0, 5			# ler inteiro valor vai para v0
	syscall
	
	# Atribuir size para registrador
	
	move	$s0, $v0		# $s0 = size
	
	# Criar vetor de tamanho size. size * 4 (pq são inteiros)
	sll	$t0, $s0, 2
	subu	$sp, $sp, $t0		# Aloca espaço na pilha movendo o ponteiro ($sp)
	move	$s3, $sp		# Guarda o endereço base do vetor em $s3
	
	# pedir números do vetor
	la 	$a0, numeros1_msg
	li	$v0, 4			# printar string
	syscall	
	
	move 	$a0, $s0
	li	$v0, 1			# printar size
	syscall	
	
	la 	$a0, numeros2_msg
	li	$v0, 4			# printar string
	syscall	
	
	# Ler n numeros
	li	$t1, 0			# $t1 = i
	
for:
	beq	$t1, $s0, pos_for	# i<size
	addi	$t1, $t1, 1		# i++
	li	$v0, 5			# ler inteiro valor vai ficar em v0
	syscall
	
	# colocar inteiro no array endereço = endereço_base + (i * 4)
	sll	$t2, $t1, 2		# $t2 = deslocamento
	add	$t3, $s3, $t2		# $t3 = endereço_base + deslocamento
	
	# Armazenar o número lido no vetor
	sw	$v0, 0($t3)

	j	for

pos_for:
	# Ler key do teclado
	
	la 	$a0, key_msg
	li	$v0, 4			# printar string
	syscall	
	
	li	$v0, 5			# ler inteiro valor vai para v0
	syscall
	
	# Atribuir key para registrador
	
	move	$s1, $v0		# $s1 = key

	# criar flag de found (foi inicializada em 0)
	li	$s2, 0			# $s2 = found = 0
	
	li	$t1, 0			# $t1 = i
for2:
	beq	$t1, $s0, pos_for2	# i<size
	addi	$t1, $t1, 1		# i++
	
	# colocar o valor do array[i] num registrador 
	sll	$t2, $t1, 2		# $t2 = deslocamento
	add	$t3, $s3, $t2		# $t3 = endereço_base + deslocamento
	lw	$t0, 0($t3)		# $t0 = vetor[i]
	
	beq	$t0, $s1, if
	j 	for2

if:
	li	$s2, 1			# $s2 = found = 1
	
pos_for2:
	beq	$s2, 0, nao_encontrado	# if found = 0
	
	# printar encontrado
	la 	$a0, achou_msg
	li	$v0, 4			# printar string
	syscall	
	
	j	fim
nao_encontrado:
	# printar encontrado
	la 	$a0, n_achou_msg
	li	$v0, 4			# printar string
	syscall	
	
fim:
	# Deslocar memória da pilha
	sll	$t0, $s0, 2		# $t0 = size * 4
	addu	$sp, $sp, $t0

	li	$v0, 10			# finalizar
	syscall	