/*
** alu.sv
**
**
** --> Definicao dos modulos com os recursos auxiliares da CPU
** -->
** -->  
*/


/****************************************************************************************
** Resultado retornado na ALu referente as insttucoes 'auipc', 'jal', 'jalr' e 'lui    **
****************************************************************************************/
module result_alu_upperimm_jumps #( parameter DATA_WIDTH = 32, parameter END_IDX=DATA_WIDTH-1 )
                                  ( input  logic             is_auipc,    // Sinal indicando que a instrucao eh 'auipc'
						input  logic             is_lui,      // Sinal indicando que a instrucao eh 'lui'
						input  logic             is_jal,      // Sinal indicando se a instrucao eh 'jal'
						input  logic             is_jalr,     // Sinal indicando se a instrucao eh 'jalr'
						input  logic [     31:0] imm_ext,     // Valor imediato
						input  logic [END_IDX:0] pc_val,      // Valor armazenado no registrador 'pc' (program counter)
						output logic [END_IDX:0] out_value ); // Valor retornado pelo modulo. Se a instrucao nao for uma dessas 4, retorna 0
//----------------------------------------------------------------------------------------------------------
	// Constantes
	parameter NULL_VALUE = { DATA_WIDTH { 1'b0 } };	
	parameter VALUE_4 = { { (DATA_WIDTH - 3) { 1'b0 } }, 3'b100 };
	
	// Arrays que irao receber os resultados
	logic [3:0] arr_is_instr;
	logic [END_IDX:0] auipc_res, lui_res, jal_res, jalr_res;
	
	// Juntar os sinais das instrucoes em 'arr_is_instr'
	assign arr_is_instr = { is_auipc, is_lui, is_jal, is_jalr };
	
	
	// --> Somadores com os resultados
	adder #( .DATA_WIDTH( DATA_WIDTH ) ) adder_auipc
		 ( .src1_value( pc_val ), .src2_value( imm_ext ), .sum_result( auipc_res ) );
	
	adder #( .DATA_WIDTH( DATA_WIDTH ) ) adder_jal
		 ( .src1_value( pc_val ), .src2_value( VALUE_4 ), .sum_result( jal_res ) );
	
	adder #( .DATA_WIDTH( DATA_WIDTH ) ) adder_jalr
		 ( .src1_value( pc_val ), .src2_value( VALUE_4 ), .sum_result( jalr_res ) );
	
	// --> Valor da operacao 'lui'
	assign lui_res = { imm_ext[31:12], { 12 { 1'b0 } } };
	
	// Bloco 'always_comb' para gerar o valor de 'out_value'
	always_comb begin
		case( arr_is_instr )
			4'b1000: out_value = auipc_res;
			4'b0100: out_value = lui_res;
			4'b0010: out_value = jal_res;
			4'b0001: out_value = jalr_res;
		endcase
	end
endmodule




/************************
** Output Flags ALU    **
************************/
module output_flags_alu #( parameter DATA_WIDTH = 32, parameter END_IDX=DATA_WIDTH-1 )
                         ( input  logic             src1_b31,     // Ultimo bit do 1o operando da ALU
				   input  logic             src2_b31,     // Ultimo bit do 2o operando da ALU
				   input  logic             is_add_sub,   // Sinal indicando se a operacao eh de soma ou subtracao
				   input  logic             alu_ctrl_b0,  // Bit 0 de 'alu_ctrl', indica se a operacao eh de subtracao
				   input  logic             cout,         // Sinal indicando se foi produzido um 'carry out'
				   input  logic [END_IDX:0] result,       // Array com o resultado da operacao gerado na ALU
				   output logic             of_c,         // 'Output Flag' 'c': Indica se a operacao gerou um carry-out
				   output logic             of_n,         // 'Output Flag' 'n': Indica se o resultado eh negativo.
				   output logic             of_v,         // 'Output Flag' 'v': Indica a ocorrencia de overflow
				   output logic             of_z   );     // 'Output Flag' 'z': Indica se o resultado eh 0
//-----------------------------------------------------------------------------------------------------------------------------
	parameter ZERO_VAL = { DATA_WIDTH { 1'b0 } };
	
	// 'Output flag' 'of_z': Indica se o resultado eh 0
	assign of_z = (result == ZERO_VAL);
	
	// 'Output flag' 'of_n': Indica se o resultado eh negativo.
	assign of_n = result[END_IDX];
	
	// 'Output Flag' 'c': Indica se a operacao de soma/subtracao gerou um carry-out
	assign of_c = is_add_sub & cout;
	
	// 'Output Flag' 'v': Indica a ocorrencia de overflow
	assign of_v = ~(alu_ctrl_b0 ^ (src1_b31 ^ src2_b31)) & (src1_b31 ^ result[END_IDX]) & is_add_sub;
endmodule




/******************************
** Arithmetic Logic Unit     **
******************************/
// ALU (Arithmetic Logic Unit) ///////////////////////////////////////////////////////////////////
module alu #( parameter DATA_WIDTH=32, parameter END_IDX=(DATA_WIDTH - 1) )
            ( input  logic [END_IDX:0] src1_value, 
              input  logic [END_IDX:0] src2_value,
              input  logic [      4:0] alu_ctrl,
              input  logic [     31:0] imm_ext,
		  output logic [END_IDX:0] out_value,    // Valor de saida do modulo 'result_alu_upperimm_jumps'
		  output logic [END_IDX:0] result,       // Array com o resultado da operacao gerado na ALU
		  output logic             of_c,         // 'Output Flag' 'c': Indica se a operacao gerou um carry-out
		  output logic             of_n,         // 'Output Flag' 'n': Indica se o resultado eh negativo.
		  output logic             of_v,         // 'Output Flag' 'v': Indica a ocorrencia de overflow
		  output logic             of_z );       // 'Output Flag' 'z': Indica se o resultado eh 0
//------------------------------------------------------------------------------------------------
	// --> Constantes
	parameter NULL_VAL = { DATA_WIDTH { 1'bx } };
	
	
	/**********************
	** Soma/Subtracao    **
	**********************/
	logic [END_IDX:0] sum_oper;           // Resutado da operacao de soma/subtracao
	logic is_add_sub, is_sub, cin, cout;  // Sinais indicando se a operacao eh de soma e bit de carry-out
	
	full_adder #( .DATA_WIDTH( DATA_WIDTH ) ) adder_alu
			( .src1_value( src1_value ), .src2_value( src2_value ), .cin( cin ), .cout( cout ), .sum_result( sum_oper ) );
	
	
	/******************************
	** Operacoes AND, OR e XOR   ** 
	******************************/
	logic [END_IDX:0] and_oper, or_oper, xor_oper;    // Arrays retornados pelo modulo 'logical_oper_alu'
	
	logical_oper_alu #( .DATA_WIDTH( DATA_WIDTH ) ) log_opers
				( .src1_value( src1_value ), .src2_value( src2_value ), .result_and( and_oper ), .result_or( or_oper ), .result_xor( xor_oper ) );
	
	
	/****************************************
	** Operacoes de Deslocamento Logico    ** 
	****************************************/
	logic [END_IDX:0] log_shift_left, log_shift_right;  // Arrays retornados pelo modulo 'logical_shift_opers'
	
	logical_shift_opers #( .DATA_WIDTH( DATA_WIDTH ) ) log_shifts
				   ( .src1_value( src1_value ), .src2_value( src2_value ), .left_shift( log_shift_left ), .right_shift( log_shift_right ) );
	
	
	/********************************************
	** Operacoes de Deslocamento Aritmetico    ** 
	********************************************/
	logic [END_IDX:0] arith_shift_right; // Arrays retornados pelo modulo 'shift_right_arithmetic'
	
	shift_right_arithmetic #( .DATA_WIDTH( DATA_WIDTH ) ) arith_shifts
					( .src1_value( src1_value ), .src2_value( src2_value ), .sra_rslt( arith_shift_right ) );
	
	
	/********************************************
	** Operacoes de 'Set Less Than'            ** 
	********************************************/
	logic [END_IDX:0] op_slt, op_sltu, op_slti, op_sltiu; // Arrays retornados pelo modulo 'set_less_than'
	
	set_less_than #( .DATA_WIDTH( DATA_WIDTH ) ) mod_slt
			   ( .src1_value( src1_value ), .src2_value( src2_value ), .imm_ext( imm_ext ), .sltu_rslt( op_sltu ), .sltiu_rslt( op_sltiu ), .slt_rslt( op_slt ), .slti_rslt( op_slti ) );
	
	
	/********************************************
	** Operacoes de MULTIPLICACAO              ** 
	********************************************/
	// Arrays retornados pelo smodulos 'Mult1Unsigned', 'Mult2Signed' e 'mult_signed_unsigned'
	logic [END_IDX:0] val_mulhsu, prod_u, prod_s, upper_prod_uu, upper_prod_ss; 
	
	mult_signed_unsigned #( .DATA_WIDTH( DATA_WIDTH ) ) mod_mulhsu
				    ( .src1_value( src1_value ), .src2_value( src2_value ), .val_mulhsu( val_mulhsu ) );
	
	Mult1Unsigned #( .DATA_WIDTH( DATA_WIDTH ) ) mod_mulhsu
		         ( .dataa( src1_value ), .datab( src2_value ), .prod( prod_s ), .upper_prod( upper_prod_uu ) );
	
	Mult2Signed #( .DATA_WIDTH( DATA_WIDTH ) ) mod_mulhsu
		       ( .dataa( src1_value ), .datab( src2_value ), .prod( prod_u ), .upper_prod( upper_prod_ss ) );
	
	
	/********************************************
	** Operacoes de DIVISAO e RESTO            ** 
	********************************************/
	logic [END_IDX:0] quot_s, quot_u, rem_s, rem_u;
	
	Div1Unsigned #( .DATA_WIDTH( DATA_WIDTH ) ) mod_mulhsu
		        ( .numer( src1_value ), .denom( src2_value ), .quotient( quot_s ), .remain( rem_u ) );
	
	Div2Signed  #( .DATA_WIDTH( DATA_WIDTH ) ) mod_mulhsu
		       ( .numer( src1_value ), .denom( src2_value ), .quotient( quot_u ), .remain( rem_s ) );
	
	
	/*************************************************
	** Selecionar o output indicado em 'alu_ctrl'   ** 
	*************************************************/
      always_comb begin
            case( alu_ctrl )
                  // Operacoes de Adicao e Subtracao
			5'b00000:  result = sum_oper;          // 'add'/'addi'
                  5'b00001:  result = sum_oper;          // 'sub'
                  // Operacoes logicas
			5'b00010:  result = and_oper;          // 'and'/'andi'
			5'b00011:  result = or_oper;           // 'or'/'ori'
			5'b00100:  result = xor_oper;          // 'xor'/'xori'
			// Deslocamento logico e aritmetico
			5'b00101:  result = log_shift_left;    // 'sll'/'slli'
			5'b00110:  result = log_shift_right;   // 'srl'/'srli'
			5'b00111:  result = arith_shift_right; // 'sra'/'srai'
			// Set Less Than
			5'b01000:  result = op_slt;            // 'slt'/'slti'
			5'b01001:  result = op_sltu;           // 'sltu'
			5'b01010:  result = op_slti;           // 'slti'
			5'b01011:  result = op_sltiu;          // 'sltiu'
			// 'auipc', 'jal', 'jalr' e 'lui'
			5'b01100:  result = out_value;         // 'lui' / 'auipc'/ 'jal' / 'jalr'
			// Multiplicacao
			5'b01110:  result = prod_s;            // 'mul'
			5'b01111:  result = upper_prod_ss;     // 'mulh'
			5'b10000:  result = val_mulhsu;        // 'mulhsu
			5'b10001:  result = upper_prod_uu;     // 'mulhu'
			// Divisao e Resto da Divisao
			5'b10010:  result = quot_s;            // 'div'
			5'b10011:  result = quot_u;            // 'divu'
			5'b10100:  result = rem_s;             // 'rem'
			5'b10101:  result = rem_u;             // 'remu'		   
			// Caso padrao
			default:   result = NULL_VAL;                                 
            endcase
      end
	

	/*************************************************
	** Output Flags                                 ** 
	*************************************************/
	output_flags_alu #( .DATA_WIDTH(DATA_WIDTH) ) out_flags
		            ( .src1_b31(src1_value[END_IDX]), .src2_b31(src2_value[END_IDX]), .is_add_sub(is_add_sub), .alu_ctrl_b0(alu_ctrl[0]),
				  .cout(cout), .result(result), .of_c(of_c), .of_n(of_n), .of_v(of_v), .of_z(of_z) );
endmodule




