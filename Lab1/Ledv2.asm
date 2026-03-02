.data
linha:       		.word 0xFFFF0012      		# Endereço relativo à linha do teclado
leitura_teclado:	.word 0xFFFF0014      		# Endereço relativo à leitura da tecla
led_direita:  		.word 0xFFFF0010      		# Valor do endereço referente ao led direito do digital lab sim

# Tabela com os valores dos numeros no display de 7 segmentos
tabela_segmentos: 	.byte 0x3F,0x06,0x5B,0x4F  	 
           		.byte 0x66,0x6D,0x7D,0x07   	
           		.byte 0x7F,0x6F,0x77,0x7C   	
           		.byte 0x39,0x5E,0x79,0x71   	

# Tabela dos códigos do teclado do digital lab sim
tabela_codigos: 	.byte 0x11,0x21,0x41,0x81
           		.byte 0x12,0x22,0x42,0x82
           		.byte 0x14,0x24,0x44,0x84
           		.byte 0x18,0x28,0x48,0x88
           		
.text
	main:						# Inicio do programa
		lw 	$t0, linha			# Carrega o endereço da ativação da linha no registrador t0
		lw 	$t1, leitura_teclado		# Carrega o endereço relativo à leitura no registrador t1
		lw	$t2, led_direita		# Carrega o endereço relativo ao let direito no registrador t2
		li	$t3, 1				# Carrega 0001 em t3 para ser usado futuramente
	lendo_teclado:
		sb	$t3, 0($t0)			# Ativa a linha, carregando o valor de t3 no endereço de ativação da linha
		lb	$t4, 0($t1)			# Lê a tecla e armazena em t4
		bne 	$t4, $zero, pressionada		# Compara t4 com zero para saber se alguma tecla foi pressionada, se foi, passa para o proximo bloco
		sll	$t3, $t3, 1			# Da shift left em t3 para assim ativar a proxima linha, exemplo 0001 (linha 1) -> 0010 (linha 2)
		ble  	$t3, 8, lendo_teclado		# Enquanto t3 for menor ou igual a 8(ou seja, enquanto ainda nao tiver passado por todas as linhas), mantem o loop
		j	fim				# Nenhuma tecla pressionada até o final, jogando assim para o fim do programa
	 
	pressionada:
		li 	$t3, 0				# Carrega 0 em t3 para servir de contador futuramente
		la 	$t5, tabela_codigos		# Carrega a tabela dos codigos do teclado para comparar com o resultado adquirido
		
	traduzir_tecla:
		lb	$t6, 0($t5)			# Carrega em t6 o byte referente a t5 (no primeiro caso, o byte 0x11)
		beq	$t6, $t4, iguais		# Verifica se o byte de t6 é igual ao byte t4(byte salvo pelo teclado), se for, passa para o proximo bloco
		addi	$t3, $t3, 1			# Adiciona 1 ao contador
		addi	$t5, $t5, 1			# Adiciona 1 a t5 para checar o proximo byte ( em primeira instacia, após verificar que 0x11 nao é o byte 
							#desejado, passa para 0x21)
		blt  	$t3, 16, traduzir_tecla		#Fica nesse loop até o contador resultar em 16(passou por todas as teclas)
		j	fim				#Não achou tecla pressionada, jogando assim para o fim do programa
		
	iguais:
		la	$t7, tabela_segmentos		# Carrega em t7 a tabela dos numeros traduzidos em seus segmentos
		add	$t7, $t7, $t3			# Soma t7 com o contador (t3) para assim ter o deslocamento referente a qual byte foi equivalente na tabela anterior
		lb	$t8, 0($t7)			# Carrega este byte em t8
		
	display:
		sb	$t8, 0($t2)			# Armazena no endereço relativo ao led direito o valor do byte carregado em t8
	
	fim:
		li	$v0,10				# Carrega 10 em v0 para encerrar o sistema
		syscall					# Chama o encerramento do sistema 
