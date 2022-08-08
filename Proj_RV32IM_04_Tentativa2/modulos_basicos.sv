/*
** modulos_basicos.sv
**
**
** --> Modulos basicos de uso geral 
** --> Esses modulos nao sao especificos para a aplicacao da CPU;
** --> Isto eh, estes modulos podem ser usados em outros projetos, sem precisar de serem modificados.       
*/


/********************
** Flip-Flops      **
********************/
// Flip-Flop com Reset ///////////////////////////////////////////////////////////
module ff_rst #( parameter DATA_WIDTH=32, parameter END_IDX=DATA_WIDTH-1 )
               ( input  logic              clk, 
                 input  logic              reset,
                 input  logic [END_IDX:0]  d, 
                 output logic [END_IDX:0]  q );
//---------------------------------------------------------------------------------------
      always_ff @( posedge clk, posedge reset ) begin
            if( reset ) begin q <= 0; end
            else begin q <= d; end
      end
endmodule




// Flip-Flop com Reset e Enable ///////////////////////////////////////////////////////////
module ff_rst_en #( parameter DATA_WIDTH = 32, parameter END_IDX=DATA_WIDTH-1 )
                  ( input  logic                    clk, 
                    input  logic                    reset,
                    input  logic                    en,
                    input  logic [END_IDX:0] d, 
                    output logic [END_IDX:0] q);
//-------------------------------------------------------------
      always_ff @( posedge clk, posedge reset ) begin
            if( reset ) begin 
			q <= 0; 
		end
            else if( en == 1'b1 ) begin 
			q <= d; 
		end
      end
endmodule




/********************
** Multiplexadores **
********************/
// --> Multiplexador 2:1 ///////////////////////////////////////////////////////////
module mux2 #( parameter DATA_WIDTH=32, parameter END_IDX=DATA_WIDTH-1 )
             ( input  logic [END_IDX:0] d0, 
		   input  logic [END_IDX:0] d1, 
               input  logic             sel, 
               output logic [END_IDX:0] y );
//---------------------------------------------------------------------------------------
      assign y = sel ? d1 : d0; 
endmodule


// --> Multiplexador 3:1 ///////////////////////////////////////////////////////////
module mux3 #( parameter DATA_WIDTH=32, parameter END_IDX=DATA_WIDTH-1 )
             ( input  logic [ END_IDX:0] d0, 
		   input  logic [ END_IDX:0] d1, 
		   input  logic [ END_IDX:0] d2,
               input  logic [       1:0] sel, 
               output logic [END_IDX:0] y );
//----------------------------------------------------------------------------------------
    assign y = sel[1] ? d2 : ( sel[0] ? d1 : d0 ); 
endmodule


// --> Multiplexador 4:1 ///////////////////////////////////////////////////////////
module mux4 #( parameter DATA_WIDTH = 32, parameter END_IDX=DATA_WIDTH-1 )
             ( input  logic [END_IDX:0] d0, 
		   input  logic [END_IDX:0] d1, 
		   input  logic [END_IDX:0] d2, 
		   input  logic [END_IDX:0] d3, 
               input  logic [      1:0] sel, 
               output logic [END_IDX:0] y );
//--------------------------------------------------------------------------
    assign y = sel[1] ? (sel[0] ? d3 : d2) : (sel[0] ? d1 : d0);
endmodule




/**********************************************************************
** --> dig_displ_7_segs                                              **
** --> Modulo para escrever um digito em um display de 7 segmentos   **
**                                                                   **
**********************************************************************/
module dig_displ_7_segs( input logic [3:0] digit, 
				 output logic [7:0] segs_dsp );
//--------------------------------------------------------------------------------------------------
	// Escrevr no display de 7 segmentos o valor indicado em 'digit'
	always_comb begin
		case( digit )
			4'h0 : segs_dsp = 8'b11000000;
			4'h1 : segs_dsp = 8'b11111001;
			4'h2 : segs_dsp = 8'b10100100; 
			4'h3 : segs_dsp = 8'b10110000; 
			4'h4 : segs_dsp = 8'b10011001;
			4'h5 : segs_dsp = 8'b10010010;
			4'h6 : segs_dsp = 8'b10000010;
			4'h7 : segs_dsp = 8'b11111000;
			4'h8 : segs_dsp = 8'b10000000;
			4'h9 : segs_dsp = 8'b10010000;
			4'ha : segs_dsp = 8'b10001000;
			4'hb : segs_dsp = 8'b10000011;
			4'hc : segs_dsp = 8'b11000110;
			4'hd : segs_dsp = 8'b10100001;
			4'he : segs_dsp = 8'b10000110;
			4'hf : segs_dsp = 8'b10001110;
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
/*
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
	
	assign mul1 = $signed(op_val1) * $signed(op_val2);
	assign mul2 = $signed(op_val1) * $unsigned(op_val2);
	assign mul3 = $unsigned(op_val1) * $unsigned(op_val2);
	// Arrays com as saidas
	assign prod_result = mul3[END_IDX:0];
	assign prod_high_uu = mul3[LAST_ADDR:DATA_WIDTH];
	assign prod_high_ss = mul1[LAST_ADDR:DATA_WIDTH];
	assign prod_high_su = mul2[LAST_ADDR:DATA_WIDTH];
endmodule
*/

// --> divide_remainder////////////////////////////////////////////////////////////////////////////////
/*
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
*/



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






