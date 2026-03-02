.data
	matriz:      .space 1024	# 1024 = 16 * 16 * 4 bytes

	msg_coluna:   .asciiz "\n 2: matriz preenchida coluna por coluna \n"
	espaco:       .asciiz "   "
	nova_linha:   .asciiz "\n"

.text
main:
	#  2 coluna por coluna
    	li $v0, 4
    	la $a0, msg_coluna
    	syscall

    	la $a0, matriz
    	jal preenche_por_coluna

	jal imprime_matriz		# $a0 está com a matriz

	li $v0, 10			# encerra
	syscall

# preenche_por_coluna
preenche_por_coluna:
    move $s0, $a0			# endereço base da matriz
    li $s2, 0				# coluna
    li $s3, 0				# valor que vai ser inserido

loop_coluna_externo:
    beq $s2, 16, fim_coluna		# Se col = 16, termina
    li $s1, 0				# s1 = linha

loop_coluna_interno:
    beq $s1, 16, proxima_coluna 	# Se linha = 16, vai para a próxima coluna
    
    sll $t0, $s1, 4			# linha * 16
    add $t0, $t0, $s2           	# linha * 16 + col
    sll $t0, $t0, 2             	# * 4 (tamanho do inteiro)
    add $t1, $s0, $t0           	# endereço_base + deslocamento

    sw $s3, 0($t1)			# Salva o valor no endereço calculado
    addi $s3, $s3, 1			# valor++

    addi $s1, $s1, 1			# linha++
    j loop_coluna_interno

proxima_coluna:
    addi $s2, $s2, 1			# coluna++
    j loop_coluna_externo

fim_coluna:
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
