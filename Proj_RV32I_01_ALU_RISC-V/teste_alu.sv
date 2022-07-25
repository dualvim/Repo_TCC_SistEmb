/*
** teste_alu.sv
**
**
** --> Arquivo com o móduo principal do projeto
**
*/

module teste_alu ( input  logic MAX10_CLK1_50, 
			 input  logic [9:0] SW, 
			 output logic [9:0] LEDR, 
			 output logic [7:0] HEX0, 
			 output logic [7:0] HEX1, 
			 output logic [7:0] HEX2 );
//---------------------------------------------------------------------------------------
	
	logic [4:0] alu_ctrl;
	logic [31:0] val1, val2, pc, resultado;
	logic tkn_brch, branch, z, n, c, v;
	
	// Atribuicoes iniciais
	assign val1 = 32'd23;
	assign val2 = 32'd3;
	assign pc = 32'd0;
	assign alu_ctrl = SW[4:0];
	
	
	/*************************
	** Modulo com a ALU:    **
	*************************/
	alu #( .DATA_WIDTH(32) ) alu_rv_cpu
	     ( .src1_value(val1), 
	       .src2_value(val2), 
		 .alu_ctrl(alu_ctrl),
		 .result(resultado), 
	       .branch(branch),
		 .taken_br(tkn_brch), 
		 .of_z(z), 
		 .of_n(n), 
		 .of_c(c), 
		 .of_v(v) );
	
	
	/*************************
	** Depuracao da ALU:    **
	*************************/
	logic [3:0] dg1, dg2, dg3;
	
	// Valores dos digitos a serem escritos nos displays de 7 segmentos
	assign dg3 = (resultado[9:0] / 100);
	assign dg2 = ( resultado[9:0] / 10) - ((resultado[9:0] / 100)*10);
	assign dg1 = (resultado[9:0] % 10);
	
	// Inserir os digitos nos displays de 7 segmentos
	dig_displ_7_segs dig1 ( .digit(dg1), .segs_dsp(HEX0) );
	dig_displ_7_segs dig2 ( .digit(dg2), .segs_dsp(HEX1) );
	dig_displ_7_segs dig3 ( .digit(dg3), .segs_dsp(HEX2) );
	
	// Escrever o resultado também nos LEDs do kit FPGA
	//assign LEDR = resultado[9:0];
	//assign LEDR = { 4'b00000, v, c, n, z, tkn_brch, branch };
	assign LEDR = (SW[9] == 1) ? resultado[9:0] : { 4'b00000, v, c, n, z, tkn_brch, branch };
endmodule


