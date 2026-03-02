.data
led_direita:  .word 0xFFFF0010	# Valor do endereço referente ao led direito do digital lab sim
led_esquerda: .word 0xFFFF0011	# Valor do endereço referente ao led direito do digital lab sim

.text
main:
    lw 	$t1, led_direita	# Salva em t1 o valor do endereço referente ao led direito do digital lab sim
    li  $a0, 1000		# Tempo em milissegundos referente a 1 segundo
    li  $v0, 32			# Carrega 32 no registrador v0 para poder contar 1 segundo após o syscall e continuar o codigo
    
    
    li 	$t0, 0x3F           	# Carrega o byte referente a 0 no display 7 segmentos
    sb 	$t0, 0($t1)		# Salva esse byte no endereço referenciado por t1
    syscall			# Atraso de 1 seg
          	
    li 	$t0, 0x06		# Carrega o byte referente a 1 no display 7 segmentos	
    sb	$t0, 0($t1)         	# Salva esse byte no endereço referenciado por t1
    syscall			# Atraso de 1 seg

    li 	$t0, 0x5B		# Carrega o byte referente a 2 no display 7 segmentos  	
    sb	$t0, 0($t1)		# Salva esse byte no endereço referenciado por t1
    syscall			# Atraso de 1 seg
    
    li 	$t0, 0x4F		# Carrega o byte referente a 3 no display 7 segmentos  	
    sb	$t0, 0($t1)		# Salva esse byte no endereço referenciado por t1
    syscall			# Atraso de 1 seg
    
    li 	$t0, 0x66		# Carrega o byte referente a 4 no display 7 segmentos  	
    sb	$t0, 0($t1)		# Salva esse byte no endereço referenciado por t1
    syscall			# Atraso de 1 seg
    
    li 	$t0, 0x6D		# Carrega o byte referente a 5 no display 7 segmentos   	
    sb	$t0, 0($t1)		# Salva esse byte no endereço referenciado por t1
    syscall			# Atraso de 1 seg
    
    li 	$t0, 0x7D		# Carrega o byte referente a 6 no display 7 segmentos  	
    sb	$t0, 0($t1)		# Salva esse byte no endereço referenciado por t1
    syscall			# Atraso de 1 seg
    
    li 	$t0, 0x07		# Carrega o byte referente a 7 no display 7 segmentos 	
    sb	$t0, 0($t1)		# Salva esse byte no endereço referenciado por t1
    syscall			# Atraso de 1 seg
    
    li 	$t0, 0x7F		# Carrega o byte referente a 8 no display 7 segmentos  	
    sb	$t0, 0($t1)		# Salva esse byte no endereço referenciado por t1
    syscall			# Atraso de 1 seg
    
    li 	$t0, 0x6F		# Carrega o byte referente a 9 no display 7 segmentos  	
    sb	$t0, 0($t1)		# Salva esse byte no endereço referenciado por t1
    syscall			# Atraso de 1 seg
    
    li 	$v0, 10			# Carrega 10 em v0 para finalizar o sistema
    syscall