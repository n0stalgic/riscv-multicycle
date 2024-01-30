# By Chris Strong
#
# this is intended to be an exhaustive (as possible) assembly test program
# to test the RISC-V CPU. It will grow as more instructions and processor
# features are added.

# test 
_start:
    nop
    nop
    nop
    j _j_branch_0
    nop
    nop
    nop
_j_branch_0:
    nop
    addi x2, x0, 0
    beqz x2, _beqz_branch_1
    nop
    nop
    nop
_beqz_branch_1:
    addi x2, x0, 32
    srli x3, x2, 2
    or   x4, x3, x2
    and  x5, x4, x2
    bnez x3, _bnez_arithmetic
    nop
    nop
    nop
_bnez_arithmetic:
    addi x4, x0, 7
    addi x6, x0, 1
    sub  x5, x4, x6 
    sll  x7, x4, x5
    slli x6, x4, 9
    xor  x6, x4, x5
    xori x5, x6, 31
    slt  x3, x4, x7
    slti x6, x4, 99
    addi x4, x0, 37
    addi x5, x0, 4
    blt  x5, x4, _blt_branch_2
    nop
    nop
    nop
_blt_branch_2:
    addi x2, x0, 1
    addi x3, x0, 100
    bge  x3, x2, _bltu_branch_3
    nop
    nop
    nop
_bltu_branch_3:
    addi x2, x0, -1273
    addi x3, x0, -1280
    bltu x3, x2, _bgeu_memtest
    nop
    nop
    nop
_bgeu_memtest:
    addi x2, x0, 45
    addi x3, x0, 23
    xor  x4, x2, x3
    addi x5, x0, 1024
    add  x6, x5, 0
    sw   x4, 0(x5)
    lh   x4, 0(x5)
_arithmetic_2:
    nop
    nop
    
_exit:
    beq x2, x2, _exit
