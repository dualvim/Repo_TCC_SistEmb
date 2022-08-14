
# Registradores com os valores usados nas operacoes
addi x12, x0, 23  # val 1
addi x13, x0, 3  # val 2
# Salvar os valores dos registradores
sw   x12, 4(x0)
lw   x3,  4(x0)
sw   x13, 8(x0)
lw   x3,  8(x0)
# mul
mul x2, x12, x13
sw  x2, 16(x0)
lw  x3, 16(x0)
# mulh
mulh x2, x12, x13
sw   x2, 20(x0)
lw   x3, 20(x0)
# div
div x2, x12, x13
sw  x2, 24(x0)
lw  x3, 24(x0)
# rem
rem x2, x12, x13
sw  x2, 28(x0)
lw  x3, 28(x0)
# Bloco 'end'
end: beq x0, x0, end     # Encerra o programa
