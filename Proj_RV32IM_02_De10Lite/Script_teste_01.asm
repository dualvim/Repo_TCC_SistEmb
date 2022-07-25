# Script_teste_01.asm
# Inicio
addi x1, x0, 4
addi x2, x0, 0     # x2 = 0 + 0
addi x3, x0, 10    # x3 = 0 + 10
addi x4, x0, 1     # x13 = 0 + 1
addi x5, x0, 0
# Bloco 'loop'
loop: 
add x2, x2, x4   # x14 = x13 + x14 
addi x4, x4, 1    # x4 = x4 + 1
sub x5, x3, x4
beq x5, x0, label2
beq x4, x4, loop  # Se x4 < x3, voltar 2 linhas
# Linhas executadas após a última execução do bloco 'loop'
label2:
addi x6, x0, 0
add x6, x0, x2    # Copiar para x15 o valor de x14
addi x7, x0, 0
addi x7, x6, -44  # x16 = x15 - 44
# Valor do registrador x2
#addi x2, x0, 45
# Salvar os dados na memoria
sw   x1, 0(x1)
lw  x10, 0(x1)
sw   x2, 4(x1)
lw  x10, 4(x1)
sw   x3, 8(x1)
lw  x10, 8(x1)
sw   x4, 12(x1)
lw  x10, 12(x1)
sw   x7, 20(x1)
lw  x10, 20(x1)
sw   x6, 24(x1)
lw  x10, 24(x1)
# Bloco 'end'
end: beq  x0, x0, end     # Encerra o programa
