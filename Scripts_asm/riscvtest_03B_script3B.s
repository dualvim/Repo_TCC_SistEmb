# Registradores com os valores usados nas operacoes
addi x12, x0, 23    # 01700613
addi x13, x0, 3     # 00300693
# Salvar os valores dos registradores
sw   x12, 4(x0)     # 00c02223
lw   x3,  4(x0)     # 00402183
sw   x13, 8(x0)     # 00d02423
lw   x3,  8(x0)     # 00802183
# Soma
add x2, x12, x13    # 00d60133
sw  x2, 12(x0)      # 00202623
lw  x3, 12(x0)      # 00c02183
# subtracao
sub x2, x12, x13    # 40d60133
sw  x2, 16(x0)      # 00202823
lw  x3, 16(x0)      # 01002183
# and
and x2, x12, x13    # 00d67133
sw  x2, 20(x0)      # 00202a23
lw  x3, 20(x0)      # 01402183
# or
or x2, x12, x13     # 00d66133
sw x2, 24(x0)       # 00202c23
lw x3, 24(x0)       # 01802183
# xor
xor x2, x12, x13    # 00d64133
sw  x2, 28(x0)      # 00202e23
lw  x3, 28(x0)      # 01c02183
# sll
sll x2, x12, x13    # 00d61133
sw  x2, 32(x0)      # 02202023
lw  x3, 32(x0)      # 02002183
# srl
srl x2, x12, x13    # 00d65133
sw x2, 36(x0)       # 02202223
lw x3, 36(x0)       # 02402183
# slt
slt x2, x12, x13    # 00d62133
sw x2, 40(x0)       # 02202423
lw x3, 40(x0)       # 02802183
# sra
sra x2, x12, x13    # 40d65133
sw  x2, 44(x0)      # 02202623
lw  x3, 44(x0)      # 02c02183
# mul
mul x2, x12, x13    # 02d60133
sw  x2, 48(x0)      # 02202823
lw  x3, 48(x0)      # 03002183
# mulh
mulh x2, x12, x13   # 02d61133
sw   x2, 52(x0)     # 02202a23
lw   x3, 52(x0)     # 03402183
# div
div x2, x12, x13    # 02d64133
sw  x2, 56(x0)      # 02202c23
lw  x3, 56(x0)      # 03802183
# rem
rem x2, x12, x13    # 02d66133
sw  x2, 60(x0)      # 02202e23
lw  x3, 60(x0)      # 03c02183
end: beq x0, x0, end   # 00000063
