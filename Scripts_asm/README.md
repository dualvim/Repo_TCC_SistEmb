# Scripts em Assembly RISC-V      
         

# 1 - Script `riscvtest.s`      
        
```asm
        
#;       RISC-V Assembly         Description               Address   Machine Code
main:   addi x2, x0, 5          #; x2 = 5                  0         00500113   
        addi x3, x0, 12         #; x3 = 12                 4         00C00193
        addi x7, x3, -9         #; x7 = (12 - 9) = 3       8         FF718393
        or   x4, x7, x2         #; x4 = (3 OR 5) = 7       C         0023E233
        and  x5, x3, x4         #; x5 = (12 AND 7) = 4     10        0041F2B3
        add  x5, x5, x4         #; x5 = (4 + 7) = 11       14        004282B3
        beq  x5, x7, end        #; shouldn't be taken      18        02728863
        slt  x4, x3, x4         #; x4 = (12 < 7) = 0       1C        0041A233
        beq  x4, x0, around     #; should be taken         20        00020463
        addi x5, x0, 0          #; shouldn't happen        24        00000293
around: slt  x4, x7, x2         #; x4 = (3 < 5)  = 1       28        0023A233
        add  x7, x4, x5         #; x7 = (1 + 11) = 12      2C        005203B3
        sub  x7, x7, x2         #; x7 = (12 - 5) = 7       30        402383B3
        sw   x7, 84(x3)         #; [96] = 7                34        0471AA23 
        lw   x2, 96(x0)         #; x2 = [96] = 7           38        06002103 
        add  x9, x2, x5         #; x9 = (7 + 11) = 18      3C        005104B3
        jal  x3, end            #; jump to end, x3 = 0x44  40        008001EF
        addi x2, x0, 1          #; shouldn't happen        44        00100113
end:    add  x2, x2, x9         #; x2 = (7 + 18)  = 25     48        00910133
        sw   x2, 0x20(x3)       #; mem[100] = 25           4C        0221A023 
done:   beq  x2, x2, done       #; infinite loop           50        00210063
```   
       

# 2 - Script `Script_01_Soma1a9.s`      
        
```asm
        
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
sw   x1, 0(x1)       # MEM[4 + 0] = 0
lw  x10, 0(x1)
sw   x2, 4(x1)       # MEM[4 + 4] = 45 (0x2D)
lw  x10, 4(x1)
sw   x3, 8(x1)       # MEM[4 + 8] = 10 (0x0A)
lw  x10, 8(x1)
sw   x4, 12(x1)      # MEM[4 + 12] = 10 (0x0A)
lw  x10, 12(x1)
sw   x5, 16(x1)      # MEM[4 + 16] = 0
lw  x10, 16(x1)
sw   x6, 20(x1)      # MEM[4 + 20] = 45 (0x2D)
lw  x10, 20(x1)
sw   x7, 24(x1)      # MEM[4 + 24] = 1 (0x01)
lw  x10, 24(x1)
# Bloco 'end'
end: beq  x0, x0, end     # Encerra o programa
```   
       


# 3 - Script `Script_02_InstrsRV32I.s`      
        
```asm
        
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
```   
       


# 4 - Script `Script_03_InstrsRV32M.s`      
        
```asm
        
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
```       
        

# 5 - Script `Script_04_InstrsRV32IM.s`      
        
```asm
        
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
```     
        

