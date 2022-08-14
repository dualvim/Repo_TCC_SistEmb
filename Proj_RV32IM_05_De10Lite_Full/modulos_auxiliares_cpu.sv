/*
** modulos_auxiliares_cpu.sv
**
**
** --> Definicao dos modulos com os recursos auxiliares da CPU
** -->
** -->  
*/


/******************************
** Branch Logic              **
******************************/
// --> Branch Logic: Sinal 'taken_br'
module branch_logic_takenbr #( parameter DATA_WIDTH=32, parameter END_IDX=DATA_WIDTH-1 )
                             ( input  logic [END_IDX:0]  src1_value,    // Primeiro operando
			             input  logic [END_IDX:0]  src2_value,    // Segundo operando
					 input  logic [      2:0]  funct3,
					 input  logic              branch,        // Indica se a instrucao eh uma das instrucoes de branch
			             output logic              taken_br );    // Sinal indicando se foi acionada uma instrucao de branch
//-------------------------------------------------------------------------------------------------------------------------------------
	// Sinal indicando que o bit de maior significancia eh diferente
	logic not_msb_vals;
	assign not_msb_vals = (src1_value[31] != src2_value[31]);
	
	// Sinal 'taken_br'
	always_comb begin
		if ( branch ) begin
			case( funct3 ) 
				3'b000: taken_br = (src1_value == src2_value);                 // Instrucao 'beq' (igual)
				3'b001: taken_br = (src1_value != src2_value);                 // Instrucao 'bne' (diferente)
				3'b100: taken_br = (src1_value < src2_value) ^ not_msb_vals;   // Instrucao 'blt' (Menor que, sinalizado)
				3'b101: taken_br = (src1_value >= src2_value) ^ not_msb_vals;  // Instrucao 'bge' (Maior ou igual, sinalizado)
				3'b110: taken_br = (src1_value < src2_value);                  // Instrucao 'bltu' (Menor que, nao-sinalizado)
				3'b111: taken_br = (src1_value >= src2_value);                 // Instrucao 'bgeu' (Maior ou igual, nao-sinalizado)
				default: taken_br = 1'b0;   // Caso padrao
			endcase
		end
		else begin 
			taken_br = 1'b0; 
		end
	end
endmodule




/***********************************
** Operacoes 'Set Less Than'      **
***********************************/
// set_less_than ////////////////////////////////////////////////////////////////////////////////
module set_less_than #( parameter DATA_WIDTH = 32, parameter END_IDX=(DATA_WIDTH - 1) )
                      ( input  logic [END_IDX:0] src1_value,  // Primeiro operando. Valor no registrador 'rs1'.
				input  logic [END_IDX:0] src2_value,  // Segundo operando. Valor no registrador 'rs2' ou 'Valor Imediato' (immediate));
				input  logic [     31:0] imm_ext,
				output logic [END_IDX:0] sltu_rslt,    // Resultado da operacao 'sltu' (unsigned)
				output logic [END_IDX:0] sltiu_rslt,   // Resultado da operacao 'sltiu' (unsigned) 
				output logic [END_IDX:0] slt_rslt,     // Resultado da operacao 'slt' (signed)
				output logic [END_IDX:0] slti_rslt );  // Resultado da operacao 'slti' (signed)
//------------------------------------------------------------------------------------------
	// Constantes
	parameter NULL_ARRAY = { END_IDX { 1'b0 } };
	
	// Array 'sltu_rslt' 
	assign sltu_rslt = { NULL_ARRAY, ( src1_value < src2_value ) };
	
	// Array 'sltiu_rslt'
	assign sltiu_rslt = { NULL_ARRAY, ( src1_value[31:0] < imm_ext ) };
	
	// Array 'slt_rslt'
	assign slt_rslt = (src1_value[END_IDX] == src2_value[END_IDX]) ? sltu_rslt : { NULL_ARRAY, src1_value[END_IDX] };
	
	// Array 'slti_rslt'
	assign slti_rslt = (src1_value[END_IDX] == imm_ext[END_IDX]) ? sltiu_rslt : { NULL_ARRAY, src1_value[END_IDX] };
endmodule





/***********************
** Next-PC Logic      **
***********************/
module next_pc_logic #( parameter DATA_WIDTH=32, parameter END_IDX=DATA_WIDTH-1 )
                      ( input  logic             clk, 
			      input  logic             reset,
				input  logic             taken_br,
				input  logic             is_jal,
				input  logic             is_jalr,
				output logic [END_IDX:0] pc_val,       // Valor armazenado no registrador 'pc' (program counter)
			      output logic [END_IDX:0] pc_next );    // Endereco da proxima instrucao a ser executada
//--------------------------------------------------------------------------------------------------------------------------
	// --> Constantes
	parameter VALUE_4 = { { (DATA_WIDTH-3) { 1'b0} }, 3'b100 };
	
	// --> Arrays com os valores e sinais usados dentro do modulo
	logic [END_IDX:0] br_tgt_pc, jalr_tgt_pc, pc_plus_4, pc_target;
	
	// --> Instancia do modulo 'ff_rst' (flip-flop com reset)
	ff_rst #( .DATA_WIDTH( DATA_WIDTH ) ) pc_register
	        ( .clk( clk ),
		    .reset( reset ),
		    .d( pc_next ), 
		    .q( pc_val )  );
	
	// --> Somador para calcular o valor de 'pc_plus_4'
	adder #( .DATA_WIDTH( DATA_WIDTH ) ) pc_add_4
		 ( .src1_value( pc_val ), .src2_value( VALUE_4 ), .sum_result( pc_plus_4 )  );
	
	// --> Computar o sinal 'br_tgt_pc'
	adder #( .DATA_WIDTH( DATA_WIDTH ) ) pc_add_branch
		 ( .src1_value( pc_val ), .src2_value( imm_ext ), .sum_result( br_tgt_pc )  );
	
	// --> Computar o sinal 'jalr_tgt_pc'
	adder #( .DATA_WIDTH( DATA_WIDTH ) ) adder_jalr_tgt_pc
		 ( .src1_value( src1_value ), .src2_value( imm_ext ), .sum_result( jalr_tgt_pc ) );
	
	// --> Computar o valor de 'pc_next'
	assign pc_next = ( taken_br || is_jal ) ? br_tgt_pc : ( is_jalr ? jalr_tgt_pc : pc_plus_4 );
endmodule










