/*
** alu.sv
**
**
** --> Definicao dos modulos com os recursos auxiliares da CPU
** -->
** -->  
*/


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
	parameter LAST_ADDR = (2*DATA_WIDTH)-1;
	logic [LAST_ADDR:0] mul1, mul2, mul3;
	
	//assign { prod_high_ss, prod_result } = $signed(op_val1) * $signed(op_val2);
	assign mul1 = op_val1 * op_val2;
	assign mul2 = $signed(op_val1) * $unsigned(op_val2);
	assign mul3 = $unsigned(op_val1) * $unsigned(op_val2);
	
	assign prod_high_ss = mul1[LAST_ADDR:DATA_WIDTH];
	assign prod_high_su = mul2[LAST_ADDR:DATA_WIDTH];
	assign prod_result = mul3[END_IDX:0];
	assign prod_high_uu = mul3[LAST_ADDR:DATA_WIDTH];
endmodule


// --> divide_remainder////////////////////////////////////////////////////////////////////////////////
module divide_remainder #( parameter DATA_WIDTH=32, parameter END_IDX=DATA_WIDTH-1 )
		                    ( input  logic [END_IDX:0] operand_1,
		                      input  logic [END_IDX:0] operand_2,
			                output logic [END_IDX:0] quotient,
				          output logic [END_IDX:0] remainder );
//------------------------------------------------------------------------------------------
	logic [END_IDX:0] q, r;
	assign q = (operand_1 / operand_2);
	assign r = (operand_1 % operand_2);
	assign quotient = q[END_IDX:0];
	assign remainder = r[END_IDX:0];
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
	logic [4:0] uimm;
	assign uimm = src2_value[4:0];
	// Realizar a operacao de deslocamento aritmetico
	assign sext_src1 = { { DATA_WIDTH { src1_value[END_IDX] } }, src1_value };
	assign sra_rslt1 = sext_src1 >> uimm;
	assign sra_rslt = sra_rslt1[END_IDX:0];
endmodule



// logical_shift_opers ////////////////////////////////////////////////////////////////////////////////
module logical_shift_opers #( parameter DATA_WIDTH = 32, parameter END_IDX=DATA_WIDTH-1 )
				    ( input  logic [END_IDX:0] src1_value,
				      input  logic [END_IDX:0] src2_value,
					output logic [END_IDX:0] left_shift, 
					output logic [END_IDX:0] right_shift  );
//-----------------------------------------------------------------------------------------------------
	logic [4:0] uimm;
	assign uimm = src2_value[4:0];
	
	assign left_shift = src1_value << uimm;
	assign right_shift = src1_value >> uimm;
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
module alu #( parameter DATA_WIDTH = 32, parameter END_IDX=DATA_WIDTH-1 )
            ( input  logic [END_IDX:0] src1_value, 
              input  logic [END_IDX:0] src2_value,
              input  logic [4:0]       alu_ctrl,
              output logic [END_IDX:0] result,       // Array com o resultado da operacao gerado na ALU
		  output logic             of_c,         // 'Output Flag' 'c': Indica se a operacao gerou um carry-out
		  output logic             of_n,         // 'Output Flag' 'n': Indica se o resultado eh negativo.
		  output logic             of_v,         // 'Output Flag' 'v': Indica a ocorrencia de overflow
		  output logic             of_z );       // 'Output Flag' 'z': Indica se o resultado eh 0
//------------------------------------------------------------------------------------------------
	// --> Constantes
	parameter NULL_VAL = { DATA_WIDTH { 1'b0 } };
	
	// --> Declaracao dos sinais e arrays de sinais
	logic [END_IDX:0] cond_inv_b; 
      logic [END_IDX:0] sum;
	logic             is_add_sub, is_sub; // Sinal indicando se a operacao eh de soma
	logic             cout;       // Bit de carry out
	logic [END_IDX:0] res_and, res_or, res_xor;
	logic [END_IDX:0] sltu_rslt, slt_rslt, sra_rslt;
	logic [END_IDX:0] prod_result_u, prod_result_s, prod_high_ss, prod_high_su, prod_high_uu;
	logic [END_IDX:0] quotient_s, remainder_s, quotient_u, remainder_u;
	logic [END_IDX:0] left_shift_res, right_shift_res, lui_value; //, auipc_value;
	
	
	// --> Soma e Carry-Out
	assign is_add_sub = (alu_ctrl == 5'b00000) || (alu_ctrl == 5'b00001);
	assign is_sub = (alu_ctrl == 5'b00001); 
	
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
				     .src2_value(src2_value), 
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
	Mult1Unsigned #( .DATA_WIDTH(DATA_WIDTH) ) mult_unsign
 	               ( .dataa(src1_value),
			     .datab(src2_value),
			     .prod(prod_result_u),
			     .upper_prod(prod_high_uu) );
			     
	Mult2Signed   #( .DATA_WIDTH(DATA_WIDTH) ) mult_sign
 	               ( .dataa(src1_value),
			     .datab(src2_value),
			     .prod(prod_result_s),
			     .upper_prod(prod_high_ss) );
	/*
	multiply #( .DATA_WIDTH(DATA_WIDTH) ) multiplicador
		    ( .op_val1(src1_value), 
		      .op_val2(src2_value), 
			.prod_result(prod_result), 
			.prod_high_ss(prod_high_ss),
		      .prod_high_su(prod_high_su), 
			.prod_high_uu(prod_high_uu) );
	*/
	
	// --> Operacoes 'div', 'divu', 'rem' e 'remu'
	Div1Unsigned #( .DATA_WIDTH(DATA_WIDTH) ) div_unsign
	              ( .denom(src2_value),
	   	          .numer(src1_value),
			    .quotient(quotient_u),
			    .remain(remainder_u) );
			    
	Div2Signed #( .DATA_WIDTH(DATA_WIDTH) ) div_sign
	            ( .denom(src2_value),
	   	        .numer(src1_value),
			  .quotient(quotient_s),
			  .remain(remainder_s) );
	
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
			//5'b01011:  result = auipc_value;     // 'auipc'
			// --> Multiplicacao/Divisao
			5'b10010:  result = prod_result_s;   // 'mul'
			5'b10011:  result = prod_high_ss;  // 'mulh'
			5'b10100:  result = prod_high_ss;  // 'mulhsu
			5'b10101:  result = prod_high_uu;  // 'mulhu'
			5'b10110:  result = quotient_s;      // 'div'
			5'b10111:  result = quotient_u;      // 'divu'
			5'b11000:  result = remainder_s;     // 'rem'
			5'b11001:  result = remainder_u;     // 'remu		   
			default:   result = NULL_VAL;      // Caso padrao                
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




