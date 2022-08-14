/*
** modulos_oper_aritmeticas.sv
**
**
** --> Modulos basicos referentes as operacoes aritmeticas de uso geral 
** --> Esses modulos nao sao especificos para a aplicacao da CPU;
** --> Isto eh, estes modulos podem ser usados em outros projetos, sem precisar de serem modificados.       
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





/*****************************************************
** Deslocamento Logico e Deslocamento Aritmetico    **
*****************************************************/
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




/*****************************************************
** Deslocamento do tipo 'Barrel Shift'              **
*****************************************************/
module barrel_shifter #( parameter ADDR_WIDTH=5, parameter DATA_WIDTH=(2**ADDR_WIDTH) )
                       ( input  logic                    clk,
		             input  logic                    enable,
		             input  logic                    shift_left,
		             input  logic [(DATA_WIDTH-1):0] src1_value, 
                         input  logic [(DATA_WIDTH-1):0] src2_value,
				 output logic [(DATA_WIDTH-1):0] sr_out );
//-------------------------------------------------------------------------------------
	// Constantes
	parameter END_IDX = DATA_WIDTH;
	parameter END_IDX2 = (DATA_WIDTH*2)-1;
	parameter END_ADDR = ADDR_WIDTH - 1;
	
	// Array para armazenar valores temporarios
	logic [END_IDX2:0] tmp;
	
	// Numero de deslocamentos a serem realizados
	logic [END_ADDR:0] distance;
	assign distance = src2_value[END_ADDR:0];
	
	// Bloco 'always_ff':
	always_ff @( posedge clk ) begin
		// Valor temporario
		tmp = { src1_value , src1_value };
		
		// Se 'enable' estiver ativo
		if( enable ) begin
			// Realizar o deslocamento
			tmp = tmp << distance;
			sr_out <= tmp[END_IDX2:DATA_WIDTH];
		end
		
		else begin
			tmp = tmp >> distance;
			sr_out <= tmp[END_IDX:0];
		end
	end
endmodule




/*********************************************
** Adicao/Subtracao                         **
*********************************************/
// --> Adder ////////////////////////////////////////////////////////////////////////////////
module adder #( parameter DATA_WIDTH=32, parameter END_IDX=DATA_WIDTH-1 )
              ( input  logic [END_IDX:0] src1_value, 
                input  logic [END_IDX:0] src2_value,
                output logic [END_IDX:0] sum_result );
//-----------------------------------------------------------------------------------------
      assign sum_result = src1_value + src2_value;
endmodule


// --> Somador completo  ////////////////////////////////////////////////////////////////////////////////
module full_adder #( parameter DATA_WIDTH=32, parameter END_IDX=DATA_WIDTH-1 )
                   ( input  logic signed [END_IDX:0] src1_value, 
                     input  logic signed [END_IDX:0] src2_value,
		         input  logic                    cin,
                     output logic                    cout,
			   output logic signed [END_IDX:0] sum_result );
//--------------------------------------------------------------------------------------------------------
	// --> Declaracao dos sinais e arrays de sinais
	logic [END_IDX:0] cond_inv_b;
	
	// --> Instancia de 'mux2' para inverter ou nao os bits de 'src2_value'
	mux2 #( .DATA_WIDTH(DATA_WIDTH) ) mux_src2_val
		( .d0( src2_value ), .d1( ~src2_value ), .sel(is_sub), .y(cond_inv_b) );
	
	// --> Resultado da operacao de soma/subtracao
	assign {cout, sum_result} = src1_value + src2_value + cin;
endmodule


/**********************************************************************************
** Modulo para retornar o 'upper immediate' de uma multiplicacao Signed-Unsigned **
**********************************************************************************/
(* multstyle = "dsp" *) module mult_signed_unsigned #( parameter DATA_WIDTH = 32, parameter END_IDX=DATA_WIDTH-1 )
								     ( input  logic [END_IDX:0] src1_value,
								       input  logic [END_IDX:0] src2_value,
									 output logic [END_IDX:0] val_mulhsu );
//-------------------------------------------------------------------------------------------------------------------------------
	// Constantes
	parameter END_IDX2 = (2 * DATA_WIDTH) - 1;
	
	// Corpo do modulo
	logic [END_IDX2:0] mul1;
	assign mul1 = $signed(src1_value) * $unsigned(src2_value);	
	assign val_mulhsu = mul1[END_IDX2:DATA_WIDTH];
endmodule



/*
(* multstyle = "dsp" *) module multiply_basic #( parameter DATA_WIDTH = 32, parameter END_IDX=DATA_WIDTH-1 )
							     ( input  logic [END_IDX:0] src1_value,
								 input  logic [END_IDX:0] src2_value,
								 output logic [END_IDX:0] product );
//-------------------------------------------------------------------------------------------------------------------------------
	logic [(END_IDX*2):0] prod;
	assign prod = src1_value * src12_value;
	assign product = prod[END_IDX:0];
endmodule
*/
