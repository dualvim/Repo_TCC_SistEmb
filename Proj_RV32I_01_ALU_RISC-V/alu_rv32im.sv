/*
** alu_rv32im.sv
**
**
** --> Arquivo com o modulo da ALU e os modulos que realizam as operacoes aritmeticas
**
*/

// Immediate Extender ///////////////////////////////////////////////////////////////////
module extend(input  logic [31:0] instr,     // Instrucao de Assembly RISC-V que sera executada
              input  logic [2:0]  imm_src,   // Modo que o valor imediato (immediate) eh tratado no modulo 'extend'
              output logic [31:0] imm_ext ); // Array com o valor imediato (immediate)
//---------------------------------------------------------------------------------------
	always_comb
		case( imm_src ) 
			// I-type 
			3'b000:   imm_ext = { { 21 { instr[31] } }, instr[30:25], instr[24:21], instr[20] };  
			
			// S-type (stores)
			3'b001:   imm_ext = { { 21 { instr[31] } }, instr[30:25], instr[11:8], instr[7] }; 
			
			// B-type (branches)
			3'b010:   imm_ext = { { 20 { instr[31] } }, instr[7], instr[30:25], instr[11:8], 1'b0 }; 
			
			// J-type/UJ-Type (jal)
			3'b011:   imm_ext = { { 12 { instr[31] } }, instr[19:12], instr[20], instr[30:25], instr[24:21], 1'b0 };
			
			// U-type (Upper Immediate)
			3'b100:   imm_ext = { instr[31], instr[30:20], instr[19:12], { 12 { 1'b0 } }  };
			
			// undefined
			default: imm_ext = 32'bx;
		endcase             
endmodule


// take_branch //////////////////////////////////////////////////////////////////////////////
module take_branch #( parameter DATA_WIDTH = 32, parameter END_IDX=DATA_WIDTH-1 )
	( input  logic [END_IDX:0] src1_value,   // Primeiro operando. Valor no registrador 'rs1'.
			    input  logic [END_IDX:0] src2_value,   // Segundo operando. Valor no registrador 'rs2' ou 'Valor Imediato' (immediate)
		          input  logic [      4:0] alu_ctrl,     // Codigo da instrucao executada na ALU
		          output logic             branch,       // Indica a ocorrencia de branching
			    output logic             taken_br );   // Sinal indicando se a operacao se refere auma 
//---------------------------------------------------------------------------------------
	always_comb begin
		case( alu_ctrl ) 
			// Instrucao 'beq'
			5'b01110: begin 
				taken_br = (src1_value === src2_value);
				branch = 1'b1;
			end
			// Instrucao 'bne'
			5'b01111: begin 
				taken_br = (src1_value !== src2_value);
				branch = 1'b1;
			end
			// Instrucao 'blt' ou 'bltu'
			5'b10000: begin 
				taken_br = (src1_value < src2_value) ^ (src1_value[END_IDX] !== src2_value[END_IDX]);
				branch = 1'b1;
			end
			// Instrucao 'bge' ou 'bgeu'
			5'b10001: begin 
				taken_br = (src1_value >= src2_value) ^ (src1_value[END_IDX] !== src2_value[END_IDX]);
				branch = 1'b1;
			end
			// Caso padrao
			default: begin 
				taken_br = 1'b0;
				branch = 1'b0;
			end	
		endcase
	end
endmodule

/***************************************************
** Operacoes logicas AND, OR e XOR                **
***************************************************/
// logical_oper_alu //////////////////////////////////////////////////////////////////////
module logical_oper_alu #( parameter DATA_WIDTH=32, parameter END_IDX=DATA_WIDTH-1 )
                         ( input  logic [END_IDX:0] src1_value, 
				   input  logic [END_IDX:0] src2_value,
				   output logic [END_IDX:0] result_and, 
				   output logic [END_IDX:0] result_or,
				   output logic [END_IDX:0] result_xor );
//-----------------------------------------------------------------------------------------
	assign result_and = src1_value & src2_value;
	assign result_or = src1_value | src2_value;
	assign result_xor = src1_value ^ src2_value;
endmodule




/*********************************************
** Adicao/Subtracao/multiplicacao/divisao   **
*********************************************/
// --> Adder ////////////////////////////////////////////////////////////////////////////////
module adder #( parameter DATA_WIDTH=32, parameter END_IDX=DATA_WIDTH-1 )
              ( input  logic [END_IDX:0] op_val1, 
                input  logic [END_IDX:0] op_val2,
                output logic [END_IDX:0] sum_result );
//-----------------------------------------------------------------------------------------
      assign sum_result = op_val1 + op_val2;
endmodule


// --> Somador 2 (com carry-in) ////////////////////////////////////////////////////////////////////////////////
module adder2 #( parameter DATA_WIDTH=32, parameter END_IDX=DATA_WIDTH-1 )
               ( input  logic signed [END_IDX:0] op_val1, 
                 input  logic signed [END_IDX:0] op_val2,
		     input  logic                    cin,
                 output logic signed [END_IDX:0] sum_result,
		     output logic                    cout );
//-----------------------------------------------------------------------------------------
      assign {cout, sum_result} = op_val1 + op_val2 + cin;
endmodule


// --> multiply ////////////////////////////////////////////////////////////////////////////////
(* multstyle = "dsp" *) module multiply #( parameter DATA_WIDTH=32, parameter END_IDX=DATA_WIDTH-1 )
		                             ( input  logic [END_IDX:0] op_val1,
		                               input  logic [END_IDX:0] op_val2,
			                         output logic [END_IDX:0] prod_result,
			                         output logic [END_IDX:0] prod_high_ss,
							 output logic [END_IDX:0] prod_high_su,
							 output logic [END_IDX:0] prod_high_uu );
//------------------------------------------------------------------------------------------
	parameter END_IDX2 = (DATA_WIDTH*2)-1;
	
	logic [END_IDX2:0] mul1, mul2, mul3;
	assign mul1 = $signed(op_val1) * $signed(op_val2);
	assign mul2 = $signed(op_val1) * $unsigned(op_val2);
	assign mul3 = $unsigned(op_val1) * $unsigned(op_val2);
	
	assign prod_result  = mul3[END_IDX:0];
	assign prod_high_ss = mul1[END_IDX2:DATA_WIDTH];
	assign prod_high_su = mul2[END_IDX2:DATA_WIDTH];
	assign prod_high_uu = mul3[END_IDX2:DATA_WIDTH];
endmodule



// --> divide_remainder Signed ////////////////////////////////////////////////////////////////////////////////
module divide_remainder_sign #( parameter DATA_WIDTH=32, parameter END_IDX=DATA_WIDTH-1 )
		                  ( input  logic signed [END_IDX:0] operand_1,
		                    input  logic signed [END_IDX:0] operand_2,
			              output logic signed [END_IDX:0] quotient,
				        output logic signed [END_IDX:0] remainder );
//------------------------------------------------------------------------------------------
	assign quotient = $signed(operand_1) / $signed(operand_2);
	assign remainder = $signed(operand_1) % $signed(operand_2);
endmodule


// --> divide_remainder Unsigned////////////////////////////////////////////////////////////////////////////////
module divide_remainder_unsign #( parameter DATA_WIDTH=32, parameter END_IDX=DATA_WIDTH-1 )
		                    ( input  logic signed [END_IDX:0] operand_1,
		                      input  logic signed [END_IDX:0] operand_2,
			                output logic signed [END_IDX:0] quotient,
				          output logic signed [END_IDX:0] remainder );
//------------------------------------------------------------------------------------------
	assign quotient = $unsigned(operand_1) / $unsigned(operand_2);
	assign remainder = $unsigned(operand_1) % $unsigned(operand_2);
endmodule




/***************************************************
** 'Logical Shift'/'Arithmetic Shift'             **
***************************************************/
// shift_right_arithmetic ////////////////////////////////////////////////////////////////////////////////
module shift_right_arithmetic #( parameter DATA_WIDTH = 32, parameter END_IDX=DATA_WIDTH-1 )
                               ( input  logic [END_IDX:0] src1_value,  // Primeiro operando. Valor no registrador 'rs1'.
					   input  logic [END_IDX:0] src2_value,  // Segundo operando. Valor no registrador 'rs2' ou 'Valor Imediato' (immediate));
					   output logic [END_IDX:0] sra_rslt  ); // Resultado da operacao
//------------------------------------------------------------------------------------------
	// Constantes
	parameter END_IDX2 = (2*DATA_WIDTH)-1;
	// Variaveis
	logic [END_IDX2:0] sext_src1, sra_rslt1;
	// Realizar a operacao de deslocamento aritmetico
	assign sext_src1 = { { DATA_WIDTH { src1_value[END_IDX] } }, src1_value };
	assign sra_rslt1 = sext_src1 >> src2_value[4:0];
	assign sra_rslt = sra_rslt1[END_IDX:0];
endmodule



// logical_shift_opers ////////////////////////////////////////////////////////////////////////////////
module logical_shift_opers #( parameter DATA_WIDTH = 32, parameter END_IDX=DATA_WIDTH-1 )
				    ( input  logic [END_IDX:0] src1_value,
				      input  logic [      4:0] src2_value,
					output logic [END_IDX:0] left_shift, 
					output logic [END_IDX:0] right_shift  );
//-----------------------------------------------------------------------------------------------------
	assign left_shift = src1_value << src2_value;
	assign right_shift = src1_value >> src2_value;
endmodule





/*************************
** 'Set Less Than'      **
*************************/
// set_less_than ////////////////////////////////////////////////////////////////////////////////
module set_less_than #( parameter DATA_WIDTH = 32, parameter END_IDX=DATA_WIDTH-1 )
                      ( input  logic [END_IDX:0] src1_value,  // Primeiro operando. Valor no registrador 'rs1'.
				input  logic [END_IDX:0] src2_value,  // Segundo operando. Valor no registrador 'rs2' ou 'Valor Imediato' (immediate));
				output logic [END_IDX:0] sltu_rslt,   // Resultado da operacao (unsigned)
				output logic [END_IDX:0] slt_rslt );  // Resultado da operacao (signed)
//------------------------------------------------------------------------------------------
	// Constantes
	parameter ZERO_VAL = { END_IDX { 1'b0 } };
	// Realizar a operacao 
	assign sltu_rslt = { ZERO_VAL, (src1_value < src2_value) };
	assign slt_rslt = (src1_value[END_IDX] == src2_value[END_IDX]) ? sltu_rslt : { ZERO_VAL, src1_value[END_IDX] };
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
	assign of_z = (result === ZERO_VAL);
	
	// 'Output flag' 'of_n': Indica se o resultado eh negativo.
	assign of_n = result[END_IDX];
	
	// 'Output Flag' 'c': Indica se a operacao de soma/subtracao gerou um carry-out
	assign of_c = is_add_sub & cout;
	
	// 'Output Flag' 'v': Indica a ocorrencia de overflow
	assign of_v = ~(alu_ctrl_b0 ^ (src1_b31 ^ src2_b31)) & (src1_b31 ^ result[END_IDX]) & is_add_sub;
endmodule




// ALU ///////////////////////////////////////////////////////////////////////////////////////////////////////////
module alu #( parameter DATA_WIDTH = 32, parameter END_IDX=DATA_WIDTH-1 )
            ( input  logic [END_IDX:0] src1_value,  // Primeiro operando. Valor no registrador 'rs1'.
              input  logic [END_IDX:0] src2_value,  // Segundo operando. Valor no registrador 'rs2' ou 'Valor Imediato' (immediate)
              input  logic [      4:0] alu_ctrl,    // Codigo de 6 bits indicando a operacao a ser realizada
              output logic [END_IDX:0] result,      // Resultado da operacao
		  output logic             branch,      // Indica a ocorrencia de uma instrucao de 'branching' 
		  output logic             taken_br,    // Indica se a instrucao "pega" o branch"
              output logic             of_z,        // 'output flag' que indica que 'result' eh negativo
		  output logic             of_n,        // 'output flag' que indica que 'result' eh zero
		  output logic             of_c,        // 'output flag' que indica que houve um carry-out
		  output logic             of_v );      // 'output flag' que indica que houve overflow
//----------------------------------------------------------------------------------------------------------
	// --> Constantes
	parameter NULL_VAL = { DATA_WIDTH { 1'bx } };
	
	// --> Declaracao dos sinais e arrays de sinais
	logic [END_IDX:0] cond_inv_b; 
      logic [END_IDX:0] sum;
	logic             is_add_sub, is_sub; // Sinal indicando se a operacao eh de soma
	logic             cout;       // Bit de carry out
	logic [END_IDX:0] res_and, res_or, res_xor;
	logic [END_IDX:0] sltu_rslt, slt_rslt, sra_rslt;
	logic [END_IDX:0] prod_result, prod_high_ss, prod_high_su, prod_high_uu;
	logic [END_IDX:0] quotient_s, remainder_s, quotient_u, remainder_u;
	logic [END_IDX:0] left_shift_res, right_shift_res, lui_value, auipc_value;
	
	// --> Instancia do modulo 'take_branch': Instrucoes 'beq', 'bne', 'blt', 'bltu, 'bge' ou 'bgeu'
	take_branch #( .DATA_WIDTH(DATA_WIDTH) ) branch_oper
			 ( .src1_value(src1_value), .src2_value(src2_value), .alu_ctrl(alu_ctrl), .branch(branch), .taken_br(taken_br) );
	
	
	// --> Soma e Carry-Out
	assign is_add_sub = (alu_ctrl === 5'b00000) || (alu_ctrl === 5'b00001);
	assign is_sub = (alu_ctrl === 5'b00001); 
	
	mux2 #( .DATA_WIDTH(DATA_WIDTH) ) mux_src2_val
		( .d0(src2_value), 
		  .d1(~src2_value), 
		  .sel(is_sub), 
		  .y(cond_inv_b) );
	
	// Modulo do somador que ira retornar o resultado das operacoes de soma/subtracao 
      adder2 #( .DATA_WIDTH(DATA_WIDTH) ) add_sub_op
	        ( .op_val1(src1_value), 
		    .op_val2(cond_inv_b), 
		    .cin(is_sub), 
		    .sum_result(sum), 
		    .cout(cout) );
	
	
	// --> Operacoes Logicas AND, OR e XOR
	logical_oper_alu #( .DATA_WIDTH(DATA_WIDTH) ) log_op_alu
				( .src1_value(src1_value), 
				  .src2_value(src2_value), 
				  .result_and(res_and), 
				  .result_or(res_or), 
				  .result_xor(res_xor) );
	
	
	// --> Operacoes de deslocamento logico ('sll', 'slli', 'sra', 'srai')
	logical_shift_opers #( .DATA_WIDTH(DATA_WIDTH) ) shift_opers
				   ( .src1_value(src1_value), 
				     .src2_value(src2_value[4:0]), 
				     .left_shift(left_shift_res), 
				     .right_shift(right_shift_res) );
	
	
	// --> Operacoes 'sra'/'srai'
	shift_right_arithmetic #( .DATA_WIDTH(DATA_WIDTH) ) oper_sra
	                        ( .src1_value(src1_value), 
					  .src2_value(src2_value), 
					  .sra_rslt(sra_rslt) );
	
	
	// --> Operacoes 'slt'/'slti'/'sltu'/'sltiu'
	set_less_than #( .DATA_WIDTH(DATA_WIDTH) ) oper_slt
	               ( .src1_value(src1_value), 
			     .src2_value(src2_value), 
			     .sltu_rslt(sltu_rslt), 
			     .slt_rslt(slt_rslt) );
	
	// --> Operacoes 'mul'/'mulh'/'mulhsu'/'mulhu'
	multiply #( .DATA_WIDTH(DATA_WIDTH) ) multiplicador
		    ( .op_val1(src1_value), 
		      .op_val2(src2_value), 
			.prod_result(prod_result), 
			.prod_high_ss(prod_high_ss),
		      .prod_high_su(prod_high_su), 
			.prod_high_uu(prod_high_uu) );
	
	// --> Operacoes 'div' e 'rem'
	divide_remainder_sign #( .DATA_WIDTH(DATA_WIDTH) ) div_rem_s
		                 ( .operand_1(src1_value), 
				       .operand_2(src2_value), 
					 .quotient(quotient_s), 
					 .remainder(remainder_s) );
	
	
	// --> Operacoes 'divu' e 'remu'		     
	divide_remainder_unsign #( .DATA_WIDTH(DATA_WIDTH) ) div_rem_u
		                   ( .operand_1(src1_value), 
					   .operand_2(src2_value), 
					   .quotient(quotient_u), 
					   .remainder(remainder_u) );
	
	// --> Valor da operacao 'lui'
	assign lui_value = { src2_value[31:12], {12 { 1'b0 }} };
	
	// --> Selecionar o output indicado em 'alu_ctrl'
      always_comb begin
            case( alu_ctrl )
                  // --> Instrucoes aritmeticas nos formatos R-Type ou I-Type
			5'b00000:  result = sum;             // 'add'/'addi'
                  5'b00001:  result = sum;             // 'sub'
                  5'b00010:  result = res_and;         // 'and'/'andi'
			5'b00011:  result = res_or;          // 'or'/'ori'
			5'b00100:  result = res_xor;         // 'xor'/'xori'
			5'b00101:  result = left_shift_res;  // 'sll'/'slli'
			5'b00110:  result = right_shift_res; // 'srl'/'srli'
			5'b00111:  result = slt_rslt;        // 'slt'/'slti'
			5'b01000:  result = sltu_rslt;       // 'sltu'/'sltui'
			5'b01001:  result = sra_rslt;        // 'sra'/'srai'
			5'b01010:  result = lui_value;       // 'lui'
			// --> Multiplicacao/Divisao
			5'b10010:  result = prod_result;     // 'mul'
			5'b10011:  result = prod_high_ss;    // 'mulh'
			5'b10100:  result = prod_high_su;    // 'mulhsu
			5'b10101:  result = prod_high_uu;    // 'mulhu'
			5'b10110:  result = quotient_s;      // 'div'
			5'b10111:  result = quotient_u;      // 'divu'
			5'b11000:  result = remainder_s;     // 'rem'
			5'b11001:  result = remainder_u;     // 'remu		   
			default:   result = NULL_VAL;        // Caso padrao                
            endcase
      end
	
	// --> Output Flags
	output_flags_alu #( .DATA_WIDTH(DATA_WIDTH) ) out_flags
		            ( .src1_b31(src1_value[END_IDX]), 
				  .src2_b31(src2_value[END_IDX]), 
				  .is_add_sub(is_add_sub),
				  .alu_ctrl_b0(alu_ctrl[0]),
				  .cout(cout),
				  .result(result), 
				  .of_c(of_c), 
				  .of_n(of_n),
				  .of_v(of_v),
				  .of_z(of_z) );
endmodule


