#####################################################################################
# Script_04_InstrsRV32IM.s                                                          #
# --> Testa as instrucoes do conjunto RV32M (multiplicacao/divisao de inteiros)     #
#####################################################################################
# Registradores com os valores usados nas operacoes
addi x12, x0, 23      # x12 = 0 + 23
addi x13, x0, 3       # x13 = 0 + 3
# Salvar os valores dos registradores
sw   x12, 4(x0)       # A - MEM[4] = 23 (0x17)
lw   x3,  4(x0)
sw   x13, 8(x0)       # B - MEM[8] = 3 (0x03)
lw   x3,  8(x0)
# 'add'
add x2, x12, x13      # x2 = x12 + x13 = 26 (0x1A)  
sw  x2, 16(x0)        # C - MEM[16] = 26 (0x1A)
lw  x3, 16(x0)
# 'sub'
sub x2, x12, x13      # x2 = x12 - x13 = 20 (0x14)
sw  x2, 20(x0)        # D - MEM[20] = 20 (0x14)
lw  x3, 20(x0)
# 'and' / 'andi'
and x2, x12, x13      # x2 = x12 & x13 = 3 (0x03)
sw  x2, 24(x0)        # E - MEM[24] = 3 (0x03)
lw  x3, 24(x0)
# 'or' / 'ori'
or x2, x12, x13       # x2 = x12 | x13 = 23 (0x17)
sw x2, 28(x0)         # F - MEM[28] = 23 (0x17)
lw x3, 28(x0)
# 'xor' / 'xori'
xor x2, x12, x13      # x2 = x12 ^ x13 = 20 (0x14)
sw  x2, 32(x0)        # G - MEM[32] = 20 (0x14)
lw  x3, 32(x0)
# 'sll' / 'slli'
sll x2, x12, x13      # x2 = x12 << x13 = 184 (0xB8)
sw  x2, 36(x0)        # H - MEM[36] = 184 (0xB8)
lw  x3, 36(x0)
# 'srl' / 'slti'
srl x2, x12, x13      # x2 = x12 >> x13 = 2 (0x02)
sw x2, 40(x0)         # I - MEM[40] = 2 (0x02)
lw x3, 40(x0)
# 'slt'
slt x2, x12, x13      # x2 = x12 < x13 = 0 (0x00)
sw x2, 44(x0)         # J - MEM[44] = 0 (0x00)
lw x3, 44(x0)
# 'sra' / 'srai'
sra x2, x12, x13      # x2 = x12 >>> x13 = 2 (0x02)
sw  x2, 48(x0)        # K - MEM[48] = 2 (0x02)
lw  x3, 48(x0)
# 'mul'
mul x2, x12, x13      # x2 = (x12  * x13)[31:0] = 69 (0x45)
sw  x2, 52(x0)        # L - MEM[52] = 69 (0x45)
lw  x3, 52(x0)
# 'mulh'
mulh x2, x12, x13     # x2 = (x12  * x13)[63:32] = 0 (0x00)
sw   x2, 56(x0)       # M - MEM[56] = 0 (0x00)
lw   x3, 56(x0)
# 'div'
div x2, x12, x13      # x2 = x12 / x13 = 7 (0x07)
sw  x2, 60(x0)        # N - MEM[60] = 7 (0x07)
lw  x3, 60(x0)
# 'rem'
rem x2, x12, x13      # x2 = x12 % x13 = 2 (0x02)
sw  x2, 64(x0)        # O - MEM[64] = 2 (0x02)
lw  x3, 64(x0)
# Bloco 'end'
end: beq x0, x0, end  # Encerra o programa
