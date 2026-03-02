.data
a:  .word 1, 2, 3
    .word 0, 1, 4
    .word 0, 0, 1

b:  .word 1, -2, 5
    .word 0,  1, -4
    .word 0,  0,  1

bt: .word 0,0,0, 0,0,0, 0,0,0
c:  .word 0,0,0, 0,0,0, 0,0,0

msgNome: .asciiz "Digite o nome do arquivo (ex: saida.txt): "
msgC:    .asciiz "\nMatriz C (A * B^T):\n"
espaco:  .asciiz " "
quebra:  .asciiz "\n"

nomeArq: .space 128
bufNum:  .space 16
bufRev:  .space 16

.text
main:
    # nome do arquivo
    la   $a0, msgNome
    la   $a1, nomeArq
    li   $a2, 128
    jal  PROC_NOME
    move $s0, $v0

    # C = A * (B^T)
    la   $a0, a
    la   $a1, b
    la   $a2, bt
    la   $a3, c
    jal  PROC_MUL

    # imprime no console
    la   $a0, msgC
    li   $v0, 4
    syscall

    la   $t0, c
    li   $t1, 0
pc_loop:
    lw   $a0, 0($t0)
    li   $v0, 1
    syscall
    li   $v0, 4
    la   $a0, espaco
    syscall
    addi $t1, $t1, 1
    addi $t0, $t0, 4
    li   $t2, 3
    div  $t1, $t2
    mfhi $t3
    bne  $t3, $zero, pc_cont
    li   $v0, 4
    la   $a0, quebra
    syscall
pc_cont:
    blt  $t1, 9, pc_loop

    # abre arquivo
    li   $v0, 13
    move $a0, $s0
    li   $a1, 1
    li   $a2, 0
    syscall
    move $s1, $v0

    # escreve C (*** ORDEM CORRIGIDA ***)
    la   $t0, c
    li   $t1, 0
w_loop:
    lw   $a0, 0($t0)
    la   $a1, bufNum
    jal  ITOA            # $v0 = len (sem '\0')
    move $a2, $v0        # <- guarda len em a2 ANTES de mudar $v0
    li   $v0, 15
    move $a0, $s1
    la   $a1, bufNum
    syscall

    li   $v0, 15
    move $a0, $s1
    la   $a1, espaco
    li   $a2, 1
    syscall

    addi $t1, $t1, 1
    addi $t0, $t0, 4
    li   $t2, 3
    div  $t1, $t2
    mfhi $t3
    bne  $t3, $zero, w_cont
    li   $v0, 15
    move $a0, $s1
    la   $a1, quebra
    li   $a2, 1
    syscall
w_cont:
    blt  $t1, 9, w_loop

    li   $v0, 16
    move $a0, $s1
    syscall

    li   $v0, 10
    syscall

# leitura do nome e remoção do '\n'
PROC_NOME:
    li   $v0, 4
    move $t0, $a0
    move $t1, $a1
    move $t2, $a2
    move $a0, $t0
    syscall
    li   $v0, 8
    move $a0, $t1
    move $a1, $t2
    syscall
    move $t3, $t1
pn_scan:
    lb   $t4, 0($t3)
    beq  $t4, $zero, pn_done
    li   $t5, 10
    beq  $t4, $t5, pn_zero
    addi $t3, $t3, 1
    j    pn_scan
pn_zero:
    sb   $zero, 0($t3)
pn_done:
    move $v0, $t1
    jr   $ra

# transposta de B (3x3)
PROC_TRANS:
    lw $t0, 0($a0)
    sw $t0, 0($a1)
    lw $t0, 4($a0)
    sw $t0, 12($a1)
    lw $t0, 8($a0)
    sw $t0, 24($a1)

    lw $t0, 12($a0)
    sw $t0, 4($a1)
    lw $t0, 16($a0)
    sw $t0, 16($a1)
    lw $t0, 20($a0)
    sw $t0, 28($a1)

    lw $t0, 24($a0)
    sw $t0, 8($a1)
    lw $t0, 28($a0)
    sw $t0, 20($a1)
    lw $t0, 32($a0)
    sw $t0, 32($a1)

    move $v0, $a1
    jr   $ra

# C = A * (B^T) usando BT[k][j]
PROC_MUL:
    addi $sp, $sp, -20
    sw   $ra, 16($sp)
    sw   $s0, 12($sp)
    sw   $s1, 8($sp)
    sw   $s2, 4($sp)
    sw   $s3, 0($sp)

    move $s0, $a0
    move $s1, $a1
    move $s2, $a2
    move $s3, $a3

    move $a0, $s1
    move $a1, $s2
    jal  PROC_TRANS

    li   $t7, 0
pm_i:
    bgt  $t7, 2, pm_end
    li   $t8, 0
pm_j:
    bgt  $t8, 2, pm_nexti
    li   $t9, 0
    li   $t6, 0
pm_k:
    bgt  $t6, 2, pm_store
    li   $t0, 3
    mul  $t0, $t7, $t0
    add  $t0, $t0, $t6
    sll  $t0, $t0, 2
    add  $t1, $s0, $t0
    lw   $t1, 0($t1)
    li   $t2, 3
    mul  $t2, $t6, $t2
    add  $t2, $t2, $t8
    sll  $t2, $t2, 2
    add  $t3, $s2, $t2
    lw   $t3, 0($t3)
    mul  $t4, $t1, $t3
    add  $t9, $t9, $t4
    addi $t6, $t6, 1
    j    pm_k
pm_store:
    li   $t5, 3
    mul  $t5, $t7, $t5
    add  $t5, $t5, $t8
    sll  $t5, $t5, 2
    add  $t5, $s3, $t5
    sw   $t9, 0($t5)
    addi $t8, $t8, 1
    j    pm_j
pm_nexti:
    addi $t7, $t7, 1
    j    pm_i
pm_end:
    move $v0, $s3
    lw   $s3, 0($sp)
    lw   $s2, 4($sp)
    lw   $s1, 8($sp)
    lw   $s0, 12($sp)
    lw   $ra, 16($sp)
    addi $sp, $sp, 20
    jr   $ra

# inteiro -> string (len em v0, sem '\0')
ITOA:
    move $t0, $a0
    move $t1, $a1
    la   $t2, bufRev
    li   $t3, 0
    li   $t4, 0
    beq  $t0, $zero, itz
    bltz $t0, itneg
itabs:
    li   $t5, 10
it_loop:
    div  $t0, $t5
    mfhi $t6
    mflo $t0
    addi $t6, $t6, 48
    sb   $t6, 0($t2)
    addi $t2, $t2, 1
    addi $t3, $t3, 1
    bnez $t0, it_loop
    j    it_write
itneg:
    li   $t4, 1
    sub  $t0, $zero, $t0
    j    itabs
itz:
    li   $t6, '0'
    sb   $t6, 0($t1)
    sb   $zero, 1($t1)
    li   $v0, 1
    jr   $ra
it_write:
    beq  $t4, $zero, it_copy
    li   $t6, '-'
    sb   $t6, 0($t1)
    addi $t1, $t1, 1
it_copy:
    la   $t2, bufRev
    add  $t2, $t2, $t3
    addi $t2, $t2, -1
    move $t7, $t3
it_cpy_loop:
    lb   $t6, 0($t2)
    sb   $t6, 0($t1)
    addi $t1, $t1, 1
    addi $t2, $t2, -1
    addi $t7, $t7, -1
    bgtz $t7, it_cpy_loop
    sb   $zero, 0($t1)
    move $v0, $t3
    beq  $t4, $zero, it_ret
    addi $v0, $v0, 1
it_ret:
    jr   $ra