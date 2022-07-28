# Scripts em Assembly RISC-V      
         

# 1 - Script ``      
        
```r
        
#       RISC-V Assembly         Description               Address   Machine Code
main:   addi x2, x0, 5          # x2 = 5                  0         00500113   
        addi x3, x0, 12         # x3 = 12                 4         00C00193
        addi x7, x3, -9         # x7 = (12 - 9) = 3       8         FF718393
        or   x4, x7, x2         # x4 = (3 OR 5) = 7       C         0023E233
        and  x5, x3, x4         # x5 = (12 AND 7) = 4     10        0041F2B3
        add  x5, x5, x4         # x5 = (4 + 7) = 11       14        004282B3
        beq  x5, x7, end        # shouldn't be taken      18        02728863
        slt  x4, x3, x4         # x4 = (12 < 7) = 0       1C        0041A233
        beq  x4, x0, around     # should be taken         20        00020463
        addi x5, x0, 0          # shouldn't happen        24        00000293
around: slt  x4, x7, x2         # x4 = (3 < 5)  = 1       28        0023A233
        add  x7, x4, x5         # x7 = (1 + 11) = 12      2C        005203B3
        sub  x7, x7, x2         # x7 = (12 - 5) = 7       30        402383B3
        sw   x7, 84(x3)         # [96] = 7                34        0471AA23 
        lw   x2, 96(x0)         # x2 = [96] = 7           38        06002103 
        add  x9, x2, x5         # x9 = (7 + 11) = 18      3C        005104B3
        jal  x3, end            # jump to end, x3 = 0x44  40        008001EF
        addi x2, x0, 1          # shouldn't happen        44        00100113
end:    add  x2, x2, x9         # x2 = (7 + 18)  = 25     48        00910133
        sw   x2, 0x20(x3)       # mem[100] = 25           4C        0221A023 
done:   beq  x2, x2, done       # infinite loop           50        00210063
```   
       

# 2 - Script `riscvtest_03B_script3B.s`      
        
```r
        
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
```   
       


# 3 - Script `Script_teste_01.asm`      
        
```r
        
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
```   
       

