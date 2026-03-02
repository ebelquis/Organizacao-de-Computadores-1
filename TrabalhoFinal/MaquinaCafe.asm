.data
    # --- VARIÁVEIS DE ESTOQUE ---
    est_cafe:    .word 20
    est_leite:   .word 20
    est_choc:    .word 20
    est_acucar:  .word 20

    # --- VARIÁVEIS DE CONTROLE ---
    bebida_id:   .word 0     
    tamanho_id:  .word 0     
    acucar_id:   .word 0     

    # --- DISPLAY (Mapa 0-F) ---
    mapa_seg:    .byte 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71
    
    # --- STRINGS PARA O ARQUIVO (CUPOM DETALHADO) ---
    arq_nome:    .asciiz "cupom.txt"
    
    # Cabeçalhos
    txt_head:    .asciiz "--- CUPOM FISCAL ---\n"
    txt_item:    .asciiz "Item: "
    txt_tam_lbl: .asciiz "Tamanho: "
    txt_acu_lbl: .asciiz "Acucar: "
    txt_prc_lbl: .asciiz "Total: R$ "
    txt_line:    .asciiz "--------------------\n\n"
    
    # Nomes das Bebidas
    str_b1:      .asciiz "Cafe Puro\n"       
    str_b2:      .asciiz "Cafe com Leite\n"  
    str_b3:      .asciiz "Mochaccino\n"      
    
    # Nomes dos Tamanhos
    str_sz_g:    .asciiz "Grande\n"          
    str_sz_p:    .asciiz "Pequeno\n"         
    
    # Açúcar
    str_ac_s:    .asciiz "Sim\n"             
    str_ac_n:    .asciiz "Nao\n"             
    
    # Preços
    str_p_200:   .asciiz "2.00\n"
    str_p_300:   .asciiz "3.00\n"
    str_p_400:   .asciiz "4.00\n"
    str_p_450:   .asciiz "4.50\n"
    str_p_600:   .asciiz "6.00\n"

    # --- MENSAGENS DO TERMINAL ---
    msg_header:  .asciiz "\n==============================\n   MAQUINA DE CAFE MIPS (C)   \n==============================\n"
    msg_est_fmt: .asciiz "Estoque atual: C:"
    msg_est_L:   .asciiz " L:"
    msg_est_Ch:  .asciiz " Ch:"
    msg_est_Ac:  .asciiz " Ac:"
    msg_nl:      .asciiz "\n"
    
    msg_menu:    .asciiz "1 - Cafe Puro\n2 - Cafe com Leite\n3 - Mochaccino\n5 - Reposicao (Manutencao)\nEscolha: "
    msg_tam:     .asciiz "\nTamanho (A-Grande, B-Pequeno): "
    msg_acucar:  .asciiz "\nAcucar? (E-Sim, F-Nao): "
    msg_prep:    .asciiz "\n--- PREPARANDO ---\n"
    msg_pronto:  .asciiz "\n>> BEBIDA PRONTA! Retire seu copo. <<\n"
    msg_erro:    .asciiz "\n[ERRO] Falta ingrediente! Operacao cancelada.\n"
    msg_repo_tit:.asciiz "\n--- MODO REPOSICAO ---\n"
    msg_repo_ask:.asciiz "Qual conteiner encher? (1-Cafe, 2-Leite, 3-Choc, 4-Acucar): "
    msg_repo_ok: .asciiz "Conteiner reabastecido para 20 doses.\n"
    msg_arq_ok:  .asciiz "[SISTEMA] Cupom gerado com sucesso (cupom.txt).\n"
    msg_arq_err: .asciiz "[ERRO] Nao foi possivel criar cupom.txt (Salve o arquivo .asm antes).\n"
    msg_log_key: .asciiz "Tecla detectada: "
    msg_log_fim: .asciiz "\n"
    
    # --- HARDWARE ---
    linha:       .word 0xFFFF0012
    leitura:     .word 0xFFFF0014
    led_dir:     .word 0xFFFF0010   
    led_esq:     .word 0xFFFF0011   

.text
.globl main

main:
    # ==========================================================
    # LOOP PRINCIPAL
    # ==========================================================
menu_principal:
    # 1. Imprime Cabeçalho e Estoque
    li $v0, 4
    la $a0, msg_header
    syscall
    
    jal exibir_estoque_c_style
    
    # 2. Imprime Menu (SÓ UMA VEZ)
    li $v0, 4
    la $a0, msg_menu
    syscall

    # 3. Reset Displays para '00'
    li $a0, 0
    jal mostrar_display_duplo

    # --- LOOP DE ESPERA DE TECLA ---
wait_menu_input:
    jal ler_teclado
    move $s0, $v0 
    
    # Verifica Opção
    beq $s0, 5, log_e_reposicao
    beq $s0, 1, log_e_bebida
    beq $s0, 2, log_e_bebida
    beq $s0, 3, log_e_bebida
    
    j wait_menu_input

# Helpers para logar
log_e_reposicao:
    move $a0, $s0
    jal log_tecla_terminal
    j modo_reposicao

log_e_bebida:
    move $a0, $s0
    jal log_tecla_terminal
    j selecionou_bebida

selecionou_bebida:
    sw $s0, bebida_id
    
    # Pisca 'd'
    li $a0, 13
    jal mostrar_display_dir
    
    # --- ESCOLHA TAMANHO ---
    li $v0, 4
    la $a0, msg_tam
    syscall

wait_tamanho:
    jal ler_teclado
    move $s1, $v0
    beq $s1, 10, tamanho_ok 
    beq $s1, 11, tamanho_ok 
    j wait_tamanho
    
tamanho_ok:
    move $a0, $s1
    jal log_tecla_terminal
    
    sw $s1, tamanho_id

    # Mostra 'A' no display (Açúcar)
    li $a0, 10
    jal mostrar_display_dir

    # --- ESCOLHA AÇÚCAR ---
    li $v0, 4
    la $a0, msg_acucar
    syscall

wait_acucar:
    jal ler_teclado
    move $s2, $v0
    beq $s2, 14, acucar_ok 
    beq $s2, 15, acucar_ok 
    j wait_acucar

acucar_ok:
    move $a0, $s2
    jal log_tecla_terminal

    sw $s2, acucar_id
    
    # --- VERIFICAÇÃO ---
    jal verificar_estoque
    beqz $v0, erro_estoque
    
    # --- PREPARO ---
    li $v0, 4
    la $a0, msg_prep
    syscall

    move $a0, $v1
    jal timer_visual_duplo
    
    li $v0, 4
    la $a0, msg_pronto
    syscall
    
    # --- GERA CUPOM DETALHADO ---
    jal gerar_arquivo_detalhado
    
    j menu_principal

erro_estoque:
    li $v0, 4
    la $a0, msg_erro
    syscall

    li $t0, 3 
loop_erro:
    li $a0, 14
    jal mostrar_display_dir
    
    li $v0, 32
    li $a0, 500
    syscall
    
    li $a0, 0xFF
    jal mostrar_display_raw_dir
    
    li $v0, 32
    li $a0, 500
    syscall
    
    sub $t0, $t0, 1
    bnez $t0, loop_erro
    j menu_principal

# ==========================================================
# MODO REPOSIÇÃO
# ==========================================================
modo_reposicao:
    li $v0, 4
    la $a0, msg_repo_tit
    syscall

    li $v0, 4
    la $a0, msg_repo_ask
    syscall

    li $a0, 5
    jal mostrar_display_dir
    
wait_repo_input:
    jal ler_teclado
    move $t0, $v0
    
    beq $t0, 1, repo_valido
    beq $t0, 2, repo_valido
    beq $t0, 3, repo_valido
    beq $t0, 4, repo_valido
    
    j wait_repo_input

repo_valido:
    move $a0, $t0
    jal log_tecla_terminal

    li $t1, 20
    beq $t0, 1, repo_cafe
    beq $t0, 2, repo_leite
    beq $t0, 3, repo_choc
    beq $t0, 4, repo_acucar
    j menu_principal

repo_acao:
    li $v0, 4
    la $a0, msg_repo_ok
    syscall
    li $v0, 32
    li $a0, 1000
    syscall
    j menu_principal

repo_cafe: 
    sw $t1, est_cafe
    j repo_acao
repo_leite: 
    sw $t1, est_leite
    j repo_acao
repo_choc: 
    sw $t1, est_choc
    j repo_acao
repo_acucar: 
    sw $t1, est_acucar
    j repo_acao

# ==========================================================
# LOG E ESTOQUE
# ==========================================================
log_tecla_terminal:
    move $t8, $a0
    li $v0, 4
    la $a0, msg_log_key
    syscall
    
    bge $t8, 10, print_letra
print_numero:
    li $v0, 1
    move $a0, $t8
    syscall
    j fim_log
print_letra:
    addi $a0, $t8, 55
    li $v0, 11       
    syscall
fim_log:
    li $v0, 4
    la $a0, msg_log_fim
    syscall
    jr $ra

exibir_estoque_c_style:
    li $v0, 4
    la $a0, msg_est_fmt
    syscall
    li $v0, 1
    lw $a0, est_cafe
    syscall
    
    li $v0, 4
    la $a0, msg_est_L
    syscall
    li $v0, 1
    lw $a0, est_leite
    syscall

    li $v0, 4
    la $a0, msg_est_Ch
    syscall
    li $v0, 1
    lw $a0, est_choc
    syscall

    li $v0, 4
    la $a0, msg_est_Ac
    syscall
    li $v0, 1
    lw $a0, est_acucar
    syscall
    
    li $v0, 4
    la $a0, msg_nl
    syscall
    jr $ra

# ==========================================================
# LÓGICA DE ESTOQUE
# ==========================================================
verificar_estoque:
    lw $t0, tamanho_id
    li $t1, 1             
    li $t9, 5             
    bne $t0, 10, calc_ingred 
    li $t1, 2             
    li $t9, 10            

calc_ingred:
    li $t2, 0 
    li $t3, 0 
    li $t4, 0 
    li $t5, 0 
    
    lw $t6, bebida_id
    beq $t6, 1, rec_cafe
    beq $t6, 2, rec_leite
    beq $t6, 3, rec_mocha

rec_cafe: 
    mul $t2, $t1, 1
    j check_acucar
rec_leite: 
    mul $t2, $t1, 1
    mul $t3, $t1, 1
    j check_acucar
rec_mocha: 
    mul $t2, $t1, 1
    mul $t4, $t1, 1
    j check_acucar

check_acucar:
    lw $t7, acucar_id
    bne $t7, 14, verificar_vals
    mul $t5, $t1, 1       

verificar_vals:
    lw $s0, est_cafe
    lw $s1, est_leite
    lw $s2, est_choc
    lw $s3, est_acucar
    
    blt $s0, $t2, falha
    blt $s1, $t3, falha
    blt $s2, $t4, falha
    blt $s3, $t5, falha
    
    sub $s0, $s0, $t2
    sw $s0, est_cafe
    sub $s1, $s1, $t3
    sw $s1, est_leite
    sub $s2, $s2, $t4
    sw $s2, est_choc
    sub $s3, $s3, $t5
    sw $s3, est_acucar
    
    add $v1, $t2, $t3
    add $v1, $v1, $t4
    add $v1, $v1, $t5     
    add $v1, $v1, $t9     
    
    li $v0, 1             
    jr $ra

falha:
    li $v0, 0             
    jr $ra

# ==========================================================
# TIMER VISUAL DUPLO
# ==========================================================
timer_visual_duplo:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    move $s5, $a0

loop_timer:
    move $a0, $s5
    jal mostrar_display_duplo
    
    li $v0, 32
    li $a0, 1000
    syscall
    
    sub $s5, $s5, 1
    bgez $s5, loop_timer
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

mostrar_display_duplo:
    li $t0, 10
    div $a0, $t0
    mflo $t1       
    mfhi $t2       
    
    la $t8, mapa_seg
    lw $t5, led_esq
    lw $t6, led_dir
    
    add $t9, $t8, $t1
    lb $t3, 0($t9)
    sb $t3, 0($t5)
    
    add $t9, $t8, $t2
    lb $t3, 0($t9)
    sb $t3, 0($t6)
    jr $ra

# ==========================================================
# GERAÇÃO ARQUIVO
# ==========================================================
gerar_arquivo_detalhado:
    li $v0, 13
    la $a0, arq_nome
    li $a1, 9       
    li $a2, 0
    syscall
    move $s6, $v0 
    
    blt $s6, 0, erro_arquivo
    
    # Cabeçalho
    li $v0, 15
    move $a0, $s6
    la $a1, txt_head
    li $a2, 21
    syscall

    # Item: 
    li $v0, 15
    move $a0, $s6
    la $a1, txt_item
    li $a2, 6
    syscall

    # Nome da Bebida
    lw $t0, bebida_id
    beq $t0, 1, write_cafe
    beq $t0, 2, write_leite
    beq $t0, 3, write_mocha
    j write_tam_lbl

write_cafe:
    la $a1, str_b1
    li $a2, 10
    j do_write_bebida
write_leite:
    la $a1, str_b2
    li $a2, 15
    j do_write_bebida
write_mocha:
    la $a1, str_b3
    li $a2, 11
do_write_bebida:
    li $v0, 15
    move $a0, $s6
    syscall

    # Tamanho: 
write_tam_lbl:
    li $v0, 15
    move $a0, $s6
    la $a1, txt_tam_lbl
    li $a2, 9
    syscall

    # Grande/Pequeno
    lw $t0, tamanho_id
    beq $t0, 10, write_g
    la $a1, str_sz_p
    li $a2, 8
    j do_write_tam
write_g:
    la $a1, str_sz_g
    li $a2, 7
do_write_tam:
    li $v0, 15
    move $a0, $s6
    syscall

    # Acucar: 
    li $v0, 15
    move $a0, $s6
    la $a1, txt_acu_lbl
    li $a2, 8
    syscall

    # Sim/Nao
    lw $t0, acucar_id
    beq $t0, 14, write_sim
    la $a1, str_ac_n
    li $a2, 4
    j do_write_ac
write_sim:
    la $a1, str_ac_s
    li $a2, 4
do_write_ac:
    li $v0, 15
    move $a0, $s6
    syscall

    # Total: R$ 
    li $v0, 15
    move $a0, $s6
    la $a1, txt_prc_lbl
    li $a2, 10
    syscall

    # Preço
    lw $t0, bebida_id
    lw $t1, tamanho_id 
    
    beq $t0, 1, prc_cafe
    beq $t0, 2, prc_leite
    beq $t0, 3, prc_mocha

prc_cafe:
    beq $t1, 10, p_cafe_g
    la $a1, str_p_200
    j write_final_price
p_cafe_g:
    la $a1, str_p_300
    j write_final_price

prc_leite:
    beq $t1, 10, p_leite_g
    la $a1, str_p_300
    j write_final_price
p_leite_g:
    la $a1, str_p_450
    j write_final_price

prc_mocha:
    beq $t1, 10, p_mocha_g
    la $a1, str_p_600
    j write_final_price
p_mocha_g:
    la $a1, str_p_400
    # Nota: Pequeno=4.00, Grande=6.00
    # Se for Pequeno(11), vai para p_mocha_p
    beq $t1, 11, p_mocha_p
    la $a1, str_p_600
    j write_final_price
p_mocha_p:
    la $a1, str_p_400

write_final_price:
    li $a2, 5 
    li $v0, 15
    move $a0, $s6
    syscall

    # Rodapé
    li $v0, 15
    move $a0, $s6
    la $a1, txt_line
    li $a2, 22
    syscall

    # Fechar
    li $v0, 16
    move $a0, $s6
    syscall
    
    li $v0, 4
    la $a0, msg_arq_ok
    syscall
    jr $ra

erro_arquivo:
    li $v0, 4
    la $a0, msg_arq_err
    syscall
    jr $ra

# ==========================================================
# DRIVER TECLADO (Unsigned)
# ==========================================================
ler_teclado:
    lw $t0, linha
    lw $t1, leitura
scan_loop:
    # Linha 1
    li $t2, 1
    sb $t2, 0($t0)
    li $v0, 32
    li $a0, 10
    syscall
    lbu $t3, 0($t1)
    
    beq $t3, 0x11, ret_0
    beq $t3, 0x21, ret_1
    beq $t3, 0x41, ret_2
    beq $t3, 0x81, ret_3
    
    # Linha 2
    li $t2, 2
    sb $t2, 0($t0)
    li $v0, 32
    li $a0, 10
    syscall
    lbu $t3, 0($t1)
    
    beq $t3, 0x12, ret_4
    beq $t3, 0x22, ret_5
    beq $t3, 0x42, ret_6
    beq $t3, 0x82, ret_7
    
    # Linha 3
    li $t2, 4
    sb $t2, 0($t0)
    li $v0, 32
    li $a0, 10
    syscall
    lbu $t3, 0($t1)
    
    beq $t3, 0x14, ret_8
    beq $t3, 0x24, ret_9
    beq $t3, 0x44, ret_A
    beq $t3, 0x84, ret_B
    
    # Linha 4
    li $t2, 8
    sb $t2, 0($t0)
    li $v0, 32
    li $a0, 10
    syscall
    lbu $t3, 0($t1)
    
    beq $t3, 0x18, ret_C
    beq $t3, 0x28, ret_D
    beq $t3, 0x48, ret_E
    beq $t3, 0x88, ret_F
    
    j scan_loop

# Retornos
ret_0:
    li $v0, 0
    j debounce
ret_1:
    li $v0, 1
    j debounce
ret_2:
    li $v0, 2
    j debounce
ret_3:
    li $v0, 3
    j debounce
ret_4:
    li $v0, 4
    j debounce
ret_5:
    li $v0, 5
    j debounce
ret_6:
    li $v0, 6
    j debounce
ret_7:
    li $v0, 7
    j debounce
ret_8:
    li $v0, 8
    j debounce
ret_9:
    li $v0, 9
    j debounce
ret_A:
    li $v0, 10
    j debounce
ret_B:
    li $v0, 11
    j debounce
ret_C:
    li $v0, 12
    j debounce
ret_D:
    li $v0, 13
    j debounce
ret_E:
    li $v0, 14
    j debounce
ret_F:
    li $v0, 15
    j debounce

debounce:
    move $s7, $v0
    li $v0, 32
    li $a0, 300
    syscall
    move $v0, $s7
    jr $ra

# ==========================================================
# DISPLAY HELPERS
# ==========================================================
mostrar_display_dir:
    la $t8, mapa_seg
    add $t8, $t8, $a0
    lb $t9, 0($t8)
    lw $t8, led_dir
    sb $t9, 0($t8)
    jr $ra

mostrar_display_raw_dir:
    lw $t8, led_dir
    sb $a0, 0($t8)
    jr $ra
