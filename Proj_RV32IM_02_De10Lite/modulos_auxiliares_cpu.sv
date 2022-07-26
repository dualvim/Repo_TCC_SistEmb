/*
** modulos_auxiliares_cpu.sv
**
**
** --> Definicao dos modulos com os recursos auxiliares da CPU
** -->
** -->  
*/



/***********************
** Campos Instrucao   **
***********************/
// instr_fields /////////////////////////////////////////////////////////////////////////////
module instr_fields( input  logic [31:0] instr, 
			   output logic [ 6:0] opcode,
			   output logic [ 4:0] rd,
			   output logic [ 2:0] funct3,
			   output logic [ 4:0] rs1,
			   output logic [ 4:0] rs2,
			   output logic        funct7b0,
			   output logic        funct7b5   );
//------------------------------------------------------------------------------------------
	// Constantes:
	parameter NULL_REG_ADDR = 5'bxxxxx;
	parameter NULL_FUNCT3 = 3'bxxx;
	
	// Atribuicao ao conteudo do 'opcode'
	assign opcode = instr[6:0];
	
	// Array com o conteudo dos arrays referentes aos outputs
	logic [19:0] arr_outputs;
	assign { funct7b5, funct7b0, rs2, rs1, funct3, rd } = arr_outputs;
	
	// Valores dos elementos do tipo 'output', de acordo com o valor de 'opcode'
	always_comb begin
            case( opcode )
                  // RegWrite_ImmSrc_ALUSrc_MemWrite_ResultSrc_Branch_ALUOp_Jump
                  7'b0000011: arr_outputs = { 1'bx, 1'bx, NULL_REG_ADDR, instr[19:15], instr[14:12], instr[11:7] };   // I-Type, instrucao do tipo 'LOAD'
                  7'b0010011: begin
				if( instr[14:12] == 3'b001 ) begin
					arr_outputs = { 1'b0, 1'b0, NULL_REG_ADDR, instr[19:15], instr[14:12], instr[11:7] };
				end
				else if( instr[14:12] == 3'b101 ) begin
					arr_outputs = { instr[30], 1'b0, NULL_REG_ADDR, instr[19:15], instr[14:12], instr[11:7] };
				end
				else begin
					arr_outputs = { 1'bx, 1'bx, NULL_REG_ADDR, instr[19:15], instr[14:12], instr[11:7] };   // I-Type, instrucao do tipo I
				end
			end
			7'b0010111: arr_outputs = { 1'bx, 1'bx, NULL_REG_ADDR, NULL_REG_ADDR, NULL_FUNCT3, instr[11:7] }; // U-Type, instrucao 'auipc'
			7'b0100011: arr_outputs = { 1'bx, 1'bx,  instr[24:20], instr[19:15], instr[14:12], NULL_REG_ADDR }; // S-Type, instrucao do tipo 'STORE'
			7'b0110011: arr_outputs = { instr[30], instr[25],  instr[24:20], instr[19:15], instr[14:12], instr[11:7] }; // Instrucao do tipo R-type 
			7'b0110111: arr_outputs = { 1'bx, 1'bx, NULL_REG_ADDR, NULL_REG_ADDR, NULL_FUNCT3, instr[11:7] }; // U-Type, instrucao 'lui'
			7'b1100011: arr_outputs = { 1'bx, 1'bx, instr[24:20], instr[19:15], instr[14:12], NULL_REG_ADDR }; // B-Type, instrucoes do tipo 'BRANCH' 
			7'b1100111: arr_outputs = { 1'bx, 1'bx, NULL_REG_ADDR, instr[19:15], instr[14:12], instr[11:7] };   // I-Type, instrucao 'jalr'
			7'b1101111: arr_outputs = { 1'bx, 1'bx, NULL_REG_ADDR, NULL_REG_ADDR, NULL_FUNCT3, instr[11:7] }; // J-Type, instrucao 'jal'
                  default:    arr_outputs = { 1'bx, 1'bx, NULL_REG_ADDR, NULL_REG_ADDR, NULL_FUNCT3, NULL_REG_ADDR }; // non-implemented instruction
            endcase     
      end
endmodule




/***************************
** Immedate Extender      **
***************************/
// Extend /////////////////////////////////////////////////////////////////////////////////
module extend ( input  logic [31:7] instr,
                input  logic [2:0]  imm_src,
                output logic [31:0] imm_ext );
//---------------------------------------------------------------------------------------- 
      always_comb begin
            case( imm_src ) 
                  3'b000:   imm_ext = { { 20 { instr[31] } }, instr[31:20] };                                // I-type 
                  3'b001:   imm_ext = { { 20 { instr[31] } }, instr[31:25], instr[11:7] };                   // S-type (stores)
                  3'b010:   imm_ext = { { 20 { instr[31] } }, instr[7], instr[30:25], instr[11:8], 1'b0 };   // B-type (branches)
                  3'b011:   imm_ext = { { 12 { instr[31] } }, instr[19:12], instr[20], instr[30:21], 1'b0 }; // J-type (jal)
                  3'b100:   imm_ext = { instr[31:12], { 12 { 1'b0 } } };                                     // U-Type (lui e auipc)
			default:  imm_ext = { 32 { 1'bx } }; // undefined
            endcase
      end
endmodule




/*******************************
** Take Branch                **
*******************************/
module take_branch #( parameter DATA_WIDTH = 32, parameter END_IDX=DATA_WIDTH-1 )
                    ( input  logic [END_IDX:0] src1_value,   // Primeiro operando. Valor no registrador 'rs1'.
			    input  logic [END_IDX:0] src2_value,   // Segundo operando. Valor no registrador 'rs2' ou 'Valor Imediato' (immediate)
		          input  logic [      4:0] alu_control,  // Codigo da instrucao executada na ALU
		          output logic             taken_br );   // Indica a ocorrencia de branching
//---------------------------------------------------------------------------------------
	always_comb begin
		case( alu_control ) 
			// Instrucao 'beq'
			5'b01111: taken_br = (src1_value == src2_value); 
			// Instrucao 'bne'
			5'b10000: taken_br = (src1_value != src2_value); 
			// Instrucao 'blt' ou 'bltu'
			5'b10001: taken_br = (src1_value < src2_value) ^ (src1_value[END_IDX] != src2_value[END_IDX]); 
			// Instrucao 'bge' ou 'bgeu'
			5'b10010: taken_br = (src1_value >= src2_value) ^ (src1_value[END_IDX] != src2_value[END_IDX]);  
			// Caso padrao
			default:  taken_br = 1'b0; 
		endcase
	end
endmodule




/*******************************
** Decodificador Instrucoes   **
*******************************/
// Main Decoder //////////////////////////////////////////////////////////////////////////
module main_dec ( input  logic [6:0] opcode,      // OpCode da instrucao (sera os primeiros 7 bits)
                  output logic [1:0] result_src,  //
                  output logic       mem_write,   // Sinal indicando se a instrucao escreve dados na memoria
                  output logic       branch,      // Operacao de branch
                  output logic       alu_src,     // Sinal indicando se devemos usar um valor gerado na ALU
                  output logic       reg_write,   // Escrever dados no register file
                  output logic       is_jal,      // Sinal indicando se a instrucao eh 'jal'
			output logic       is_jalr,     // Sinal indicando se a instrucao eh 'jalr'
                  output logic [2:0] imm_src,     // Tipo de instrucao que recebe immediate
                  output logic [1:0] alu_op );    // Operacao realizada na ALU
//----------------------------------------------------------------------------------------
      // Array de 11 bits com os sinais agrupados
      logic [12:0] controls;
      assign { reg_write, imm_src, alu_src, mem_write, result_src, branch, alu_op, is_jal, is_jalr } = controls;

      always_comb begin
            case( opcode )
                  // RegWrite_ImmSrc_ALUSrc_MemWrite_ResultSrc_Branch_ALUOp_Jump
                  7'b0000011: controls = 13'b1_000_1_0_01_0_00_0_0; // Instrucoes que usam o formato I-Type, operacoes de LOAD
                  7'b0010011: controls = 13'b1_000_1_0_00_0_10_0_0; // Instrucoes que usam o formato I-Type, operacoes realizaveis na ALU
			7'b0010111: controls = 13'b1_100_0_0_11_0_00_0_0; // Instrucoes que usam o formato U-Type, instrucao 'auipc'
			7'b0100011: controls = 13'b0_001_1_1_00_0_00_0_0; // Instrucoes que usam o formato S-Type, operacoes de STORE
                  7'b0110011: controls = 13'b1_xxx_0_0_00_0_10_0_0; // Instrucoes que usam o formato R-type 
                  7'b0110111: controls = 13'b1_100_0_0_11_0_00_0_0; // Instrucoes que usam o formato U-Type, instrucao 'lui'
			7'b1100011: controls = 13'b0_010_0_0_00_1_01_0_0; // Instrucoes que usam o formato B-Type, operacoes de BRANCH
			7'b1100111: controls = 13'b1_000_1_0_00_0_10_0_1; // Instrucoes que usam o formato I-Type, instrucao 'jalr'
			7'b1101111: controls = 13'b1_011_0_0_10_0_00_1_0; // Instrucoes que usam o formato J-Type, instrucao 'jal'
                  default:    controls = 13'bx_xxx_x_x_xx_x_xx_x_0; // non-implemented instruction
            endcase     
      end
endmodule


// ALU Decoder //////////////////////////////////////////////////////////////////////////
module alu_dec ( input  logic [6:0] opcode,
                  input  logic [2:0] funct3,
                  input  logic       funct7b0,
		      input  logic       funct7b5, 
                  input  logic [1:0] alu_op,
                  output logic [4:0] alu_ctrl );
//---------------------------------------------------------------------------------------
	// Array com o conteudo dos campos das instrucoes
	logic [11:0] dados_instr;
	assign dados_instr = {funct7b5, funct7b0, funct3, opcode};
	
	
      always_comb begin
            case( alu_op )
              2'b00:   alu_ctrl = 5'b00000; // Adicao
              2'b01:   alu_ctrl = 5'b00001; // Subtracao
              default: case( dados_instr )     // Instrucao que usa a ALU do tipo R-type ou I-type
                            // Instrucoes R-Type
				    12'b0_0_000_0110011: alu_ctrl = 5'b00000; // add
				    12'b1_0_000_0110011: alu_ctrl = 5'b00001; // sub
				    12'b0_0_111_0110011: alu_ctrl = 5'b00010; // Instrucao 'and'
				    12'b0_0_110_0110011: alu_ctrl = 5'b00011; // Instrucao 'or'
				    12'b0_0_100_0110011: alu_ctrl = 5'b00100; // Instrucao 'xor'				    
				    12'b0_0_001_0110011: alu_ctrl = 5'b00101; // Instrucao 'sll'
				    12'b0_0_101_0110011: alu_ctrl = 5'b00110; // Instrucao 'srl'
				    12'b0_0_010_0110011: alu_ctrl = 5'b00111; // Instrucao 'slt'
				    12'b0_0_011_0110011: alu_ctrl = 5'b01000; // Instrucao 'sltu'
				    12'b1_0_101_0110011: alu_ctrl = 5'b01001; // Instrucao 'sra'
				    // Instrucoes do tipo I-Type
				    12'bx_x_000_0010011: alu_ctrl = 5'b00000; // Instrucao 'addi'
				    12'bx_x_111_0010011: alu_ctrl = 5'b00010; // Instrucao 'andi'
				    12'bx_x_110_0010011: alu_ctrl = 5'b00011; // Instrucao 'ori'
				    12'bx_x_100_0010011: alu_ctrl = 5'b00100; // Instrucao 'xori'
				    12'b0_0_001_0010011: alu_ctrl = 5'b00101; // Instrucao 'slli'
				    12'b0_0_101_0010011: alu_ctrl = 5'b00110; // Instrucao 'srli'
				    12'bx_x_010_0010011: alu_ctrl = 5'b00111; // Instrucao 'slti'
				    12'bx_x_011_0010011: alu_ctrl = 5'b01000; // Instrucao 'sltui'
				    12'b1_0_101_0010011: alu_ctrl = 5'b01001; // Instrucao 'srai'
				    // Instrucoes 'lui' 'auipc', 'jal' e 'jalr'
			          12'bx_x_xxx_0110111: alu_ctrl = 5'b01010; // Instrucao 'lui'
			          12'bx_x_xxx_0010111: alu_ctrl = 5'b01011; // Instrucao 'auipc'
			          12'bx_x_xxx_1101111: alu_ctrl = 5'b01100; // Instrucao 'jal'
			          12'bx_x_000_1100111: alu_ctrl = 5'b01101; // Instrucao 'jalr'
			          // Instrucoes do tipo B-Type
			          12'bx_x_000_1100011: alu_ctrl = 5'b01110; // Instrucao 'beq'
			          12'bx_x_001_1100011: alu_ctrl = 5'b01111; // Instrucao 'bne'
			          12'bx_x_100_1100011: alu_ctrl = 5'b10000; // Instrucao 'blt'
			          12'bx_x_101_1100011: alu_ctrl = 5'b10001; // Instrucao 'bge'
			          12'bx_x_110_1100011: alu_ctrl = 5'b10000; // Instrucao 'bltu'
			          12'bx_x_111_1100011: alu_ctrl = 5'b10001; // Instrucao 'bgeu'
                            // Instrucoes R-Type Multiplicacao/Divisao 
			          12'b0_1_000_0110011: alu_ctrl = 5'b10010; // Instrucao 'mul'
			          12'b0_1_001_0110011: alu_ctrl = 5'b10011; // Instrucao 'mulh'
			          12'b0_1_010_0110011: alu_ctrl = 5'b10100; // Instrucao 'mulhsu'
			          12'b0_1_011_0110011: alu_ctrl = 5'b10101; // Instrucao 'mulhu'
			          12'b0_1_100_0110011: alu_ctrl = 5'b10110; // Instrucao 'div'
			          12'b0_1_101_0110011: alu_ctrl = 5'b10111; // Instrucao 'divu'
			          12'b0_1_110_0110011: alu_ctrl = 5'b11000; // Instrucao 'rem'
			          12'b0_1_111_0110011: alu_ctrl = 5'b11001; // Instrucao 'remu'
			          // caso padrao
				    default:  alu_ctrl = 5'bxxxxx;
                        endcase
            endcase      
      end
endmodule

