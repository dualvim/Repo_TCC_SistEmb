#####################################################################################
# Script_02_InstrsRV32I.s                                                           #
# --> Testa as instrucoes do conjunto RV32I                                         #
#####################################################################################
# Inicio
addi x1, x0, 4     # x1 = 0 + 4
addi x2, x0, 23    # x2 = 0 + 23
addi x3, x0, 3     # x3 = 0 + 3
# Salvar os valores dos registradores
sw   x1,  0(x0)    # MEM[0] = 4 (0x04)
lw   x30, 0(x0)
sw   x2,  0(x1)    # MEM[4 + 0] = 23 (0x17)
lw   x30, 0(x1)   
sw   x3,  4(x1)    # MEM[4 + 4] = 3 (0x03)
lw   x30, 4(x1)
# Instrucoes do Assembly RISC-V
# add
add  x4, x2, x3    # x4 = x2 + x3 = 26 (0x1A)   
sw x0, 12(x1)
sw x4, 12(x1)      # MEM[4 + 12] = 26 (0x1A)
lw x30, 12(x1)
# sub
sub  x5, x2, x3    # x4 = x2 - x3 = 20 (0x14)
sw x5, 16(x1)      # MEM[4 + 16] = 20 (0x14)
lw x30, 16(x1)
# and / andi
and  x6, x2, x3    # x2 & x3 = 3 (0x03)   
sw x6, 20(x1)      # MEM[4 + 20] = 3 (0x03)
lw x30, 20(x1)
# or / ori
or x7, x2, x3      # x2 | x3 = 23 (0x17)  
sw x7, 24(x1)      # MEM[4 + 24] =  23 (0x17)
lw x30, 24(x1)
# xor / xori
xor  x8, x2, x3    # x2 ^ x3 = 20 (0x14) 
sw x8, 28(x1)      # MEM[4 + 28] = 20 (0x14)
lw x30, 28(x1)
# sll / slli 
sll  x9, x2, x3    # x2 << x3 = 184 (0xB8)
sw x9, 32(x1)      # MEM[4 + 32] = 184 (0xB8)
lw x30, 32(x1)
# srl / srli 
srl  x10, x2, x3   # x2 >> x3 = 2 (0x02)
sw x10, 36(x1)     # MEM[4 + 36] = 2 (0x02)
lw x30, 36(x1)
# sra / srai 
sra  x11, x2, x3   # x2 >>> x3 = 2 (0x02)
sw x11, 40(x1)     # MEM[4 + 40] = 2 (0x02)
lw x30, 40(x1)
# slt / slti
slt  x12, x2, x3   # x2 < x3 = 0 (0x00)
sw x12, 44(x1)     # MEM[4 + 44] = 0 (0x00)
lw x30, 44(x1)
# lui
lui x13, 0xADB4 
sw x13, 48(x1)     # MEM[4 + 48] = 0xADB4
lw x30, 48(x1)
# Bloco 'end'
end: beq  x0, x0, end     # Encerra o programa
