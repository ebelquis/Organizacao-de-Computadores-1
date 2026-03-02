.data
	matriz:      .space 1024  # 1024 = 16 * 16 * 4 bytes

	msg_linha:    .asciiz "\n 1: matriz preenchida linha por linha \n"
	espaco:       .asciiz "   "
	nova_linha:   .asciiz "\n"

.text
main:
	# 1 linha por linha
	li 	$v0, 4			# Imprimir string
	la 	$a0, msg_linha
	syscall

	la 	$a0, matriz
	jal 	preenche_por_linha

    	jal imprime_matriz		# $a0 está com a matriz

	li $v0, 10			# encerra
	syscall

# preenche_por_linha

preenche_por_linha:
    move $s0, $a0			# endereço base da matriz
    li $s1, 0				# linha
    li $s3, 0				# valor que vai ser inserido

loop_linha_externo:
    beq $s1, 16, fim_linha		# Se linha = 16, termina o preencheimneto da matriz
    li $s2, 0				# s2 = coluna

loop_linha_interno:
    beq $s2, 16, proxima_linha		# Se col = 16, vai para a próxima linha

    # endereço_base + (linha * 16 + coluna) * 4
    sll $t0, $s1, 4             	# linha * 16
    add $t0, $t0, $s2           	# linha * 16 + col
    sll $t0, $t0, 2             	# * 4 (tamanho do inteiro)
    add $t1, $s0, $t0           	# endereço_base + deslocamento

    sw $s3, 0($t1)			# Salva o valor no endereço calculado
    addi $s3, $s3, 1			# valor++

    addi $s2, $s2, 1			# col++
    j loop_linha_interno

proxima_linha:
    addi $s1, $s1, 1			# linha++
    j loop_linha_externo

fim_linha:
    jr $ra

# imprime_matriz

imprime_matriz:
    move $s0, $a0			# s0 = endereço base da matriz
    li $s1, 0				# s1 = linha

print_loop_externo:
    beq $s1, 16, fim_print		# Se linha = 16, termina
    li $s2, 0				# s2 = coluna

print_loop_interno:
    beq $s2, 16, print_nlinha		# Se col = 16, pula a linha no print

    # Calcular endereço
    sll $t0, $s1, 4			# linha * 16
    add $t0, $t0, $s2			# t0 vai guardar linha * 16 + col
    sll $t0, $t0, 2			# * 4 pq são words
    add $t1, $s0, $t0			# t1 tem endereço do elemento (s0 tem o endereço inicial)

    lw $a0, 0($t1)
    li $v0, 1
    syscall

    la $a0, espaco
    li $v0, 4
    syscall

    addi $s2, $s2, 1			# coluna++
    j print_loop_interno

print_nlinha:
    la $a0, nova_linha
    li $v0, 4
    syscall
    addi $s1, $s1, 1			# linha++
    j print_loop_externo

fim_print:
    jr $ra
