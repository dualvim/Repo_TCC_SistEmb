#####################################################################################
# Script_teste_01.s                                                                 #
# --> Soma os numeros de 1 a 9 e mostra o resultado do somatorio em um registrador  #
#####################################################################################
# Inicio
addi x1, x0, 4        # x1 = 0 + 4
addi x2, x0, 0        # x2 = 0 + 0
addi x3, x0, 10       # x3 = 0 + 10
addi x4, x0, 1        # x13 = 0 + 1
addi x5, x0, 0
# Bloco 'loop'
loop: 
add x2, x2, x4       # x14 = x13 + x14 
addi x4, x4, 1       # x4 = x4 + 1
sub x5, x3, x4       # x5 = x3 - x4
beq x5, x0, label2
beq x4, x4, loop     # Se x4 < x3, voltar 2 linhas
# Linhas executadas após a última execução do bloco 'loop'
label2:
add x6, x0, x2       # x6 = x2
addi x7, x0, 0
addi x7, x6, -44     # x16 = x15 - 44
# Salvar os dados na memoria
sw   x1, 0(x1)       # A - MEM[4 + 0] = 0
lw  x10, 0(x1)
sw   x2, 4(x1)       # B - MEM[4 + 4] = 45 (0x2D)
lw  x10, 4(x1)
sw   x3, 8(x1)       # C - MEM[4 + 8] = 10 (0x0A)
lw  x10, 8(x1)
sw   x4, 12(x1)      # D - MEM[4 + 12] = 10 (0x0A)
lw  x10, 12(x1)
sw   x5, 16(x1)      # E - MEM[4 + 16] = 0
lw  x10, 16(x1)
sw   x6, 20(x1)      # F - MEM[4 + 20] = 45 (0x2D)
lw  x10, 20(x1)
sw   x7, 24(x1)      # G - MEM[4 + 24] = 1 (0x01)
lw  x10, 24(x1)
# lui
lui x8, 0xADB4 
sw x8, 28(x1)     # H - MEM[4 + 28] = 0xADB4
lw x10, 28(x1)
# Bloco 'end'
end: beq  x0, x0, end     # Encerra o programa