# Script_teste_01.asm
# Inicio
addi x1, x0, 4       # 00400093
addi x2, x0, 0       # 00000113
addi x3, x0, 10      # 00a00193
addi x4, x0, 1       # 00100213
addi x5, x0, 0       # 00000293
# Bloco 'loop'
loop: 
add x2, x2, x4       # 00410133 
addi x4, x4, 1       # 00120213
sub x5, x3, x4       # 404182b3
beq x5, x0, label2   # 00028463
beq x4, x4, loop     # fe4208e3
# Linhas executadas após a última execução do bloco 'loop'
label2:              # Label 'label2'
addi x6, x0, 0       # 00000313
add x6, x0, x2       # 00200333
addi x7, x0, 0       # 00000393
addi x7, x6, -44     # fd430393
# Salvar os dados na memoria
sw   x1, 0(x1)       # 0010a023
lw  x10, 0(x1)       # 0000a503
sw   x2, 4(x1)       # 0020a223
lw  x10, 4(x1)       # 0040a503
sw   x3, 8(x1)       # 0030a423
lw  x10, 8(x1)       # 0080a503
sw   x4, 12(x1)      # 0040a623
lw  x10, 12(x1)      # 00c0a503
sw   x7, 20(x1)      # 0070aa23
lw  x10, 20(x1)      # 0140a503
sw   x6, 24(x1)      # 0060ac23
lw  x10, 24(x1)      # 0180a503
# Bloco 'end'
end: beq  x0, x0, end  #  00000063
