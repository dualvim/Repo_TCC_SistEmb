#####################################################################################
# Script_03_InstrsRV32M.s                                                           #
# --> Testa as instrucoes do conjunto RV32M (multiplicacao/divisao de inteiros)     #
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
# div
div  x4, x2, x3    # x4 = x2 / x3 = 7 (0x07)
sw x4, 12(x1)      # MEM[4 + 12] = 7 (0x07) 
lw x30, 12(x1)
# rem
rem  x5, x2, x3   # x5 = x2 % x3 = 2 (0x02)
sw x5, 16(x1)     # MEM[4 + 16] =  2 (0x02)
lw x30, 16(x1)
# divu
div  x6, x2, x3    # x6 = x2 / x3 = 7 (0x07)
sw x6, 20(x1)      # MEM[4 + 20] = 7 (0x07) 
lw x30, 20(x1)
# remu
rem  x7, x2, x3   # x7 = x2 % x3 = 2 (0x02)
sw x7, 24(x1)     # MEM[4 + 24] =  2 (0x02)
lw x30, 24(x1)
# mul
mul  x8, x2, x3   # x8 = (x2 * x3)[31:0] = 69 (0x45)
sw x8, 28(x1)     # MEM[4 + 28] = 69 (0x45)
lw x30, 28(x1)
# Bloco 'end'
end: beq  x0, x0, end     # Encerra o programa