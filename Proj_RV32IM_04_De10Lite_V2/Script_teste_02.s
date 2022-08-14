# Limpar as words da memoria RAM
sw x0, 0(x0)
sw x0, 4(x0)
sw x0, 8(x0)
sw x0, 12(x0)
sw x0, 16(x0)
sw x0, 20(x0)
sw x0, 24(x0)
sw x0, 28(x0)
sw x0, 32(x0)
sw x0, 36(x0)
sw x0, 40(x0)
sw x0, 44(x0)
sw x0, 48(x0)
sw x0, 52(x0)
sw x0, 56(x0)
sw x0, 60(x0)
sw x0, 64(x0)
sw x0, 68(x0)
sw x0, 72(x0)
sw x0, 76(x0)
sw x0, 80(x0)
# Registradores com os valores usados nas operacoes
addi x12, x0, 23  # val 1
addi x13, x0, 3  # val 2
# Salvar os valores dos registradores
sw   x12, 4(x0)
lw   x3,  4(x0)
sw   x13, 8(x0)
lw   x3,  8(x0)
# Soma
add x2, x12, x13
sw  x2, 16(x0)
lw  x3, 16(x0)
# subtracao
sub x2, x12, x13
sw  x2, 20(x0)
lw  x3, 20(x0)
# and
and x2, x12, x13
sw  x2, 24(x0)
lw  x3, 24(x0)
# or
or x2, x12, x13
sw x2, 28(x0)
lw x3, 28(x0)
# xor
xor x2, x12, x13
sw  x2, 32(x0)
lw  x3, 32(x0)
# sll
sll x2, x12, x13
sw  x2, 36(x0)
lw  x3, 36(x0)
# srl
srl x2, x12, x13
sw x2, 40(x0)
lw x3, 40(x0)
# slt
slt x2, x12, x13
sw x2, 44(x0)
lw x3, 44(x0)
# sra
sra x2, x12, x13
sw  x2, 48(x0)
lw  x3, 48(x0)
# mul
mul x2, x12, x13
sw  x2, 52(x0)
lw  x3, 52(x0)
# mulh
mulh x2, x12, x13
sw   x2, 56(x0)
lw   x3, 56(x0)
# div
div x2, x12, x13
sw  x2, 60(x0)
lw  x3, 60(x0)
# rem
rem x2, x12, x13
sw  x2, 64(x0)
lw  x3, 64(x0)
# Bloco 'end'
end: 
bge x0, x0, end     # Encerra o programa
