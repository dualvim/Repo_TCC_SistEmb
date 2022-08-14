/*
** Mult1Unsigned.v
**
**
** --> Modulo referente ao hardware MULTIPLICADOR.
** --> O array com o resultado possui duas partes, cada uma com 'DATA_WIDTH' bits
** --> Recebe em suas entradas valores NAO-SINALIZADOS     
*/

// synopsys translate_off
`timescale 1 ps / 1 ps


// synopsys translate_on
module Mult1Unsigned #( parameter DATA_WIDTH=32, parameter END_IDX=DATA_WIDTH-1 )
			    ( dataa, datab, prod, upper_prod );
//-----------------------------------------------------------------------------------------
	input	 [END_IDX:0]  dataa;
	input	 [END_IDX:0]  datab;
	output [END_IDX:0]  prod;
	output [END_IDX:0]  upper_prod;
//-----------------------------------------------------------------------------------------
	// Constantes
	parameter WIDTH_2X = DATA_WIDTH*2;
	parameter END_IDX2 = WIDTH_2X-1;
	
	// Arrays com os sinais
	wire [END_IDX2:0] sub_wire0;
	wire [END_IDX2:0] result;
	
	// Atribuicao ao valor em 'result'
	assign result = sub_wire0[END_IDX2:0];
	
	// Atribuicoes aos sinais 'prod' e 'upper_prod'
	assign prod = result[END_IDX:0];
	assign upper_prod = result[END_IDX2:DATA_WIDTH];
	
	// Modulo com o hardware do multiplicador
	lpm_mult	lpm_mult_component ( .dataa( dataa ),
						   .datab( datab ),
						   .result( sub_wire0 ),
						   .aclr( 1'b0 ),
						   .clken( 1'b1 ),
						   .clock( 1'b0 ),
						   .sclr( 1'b0 ),
						   .sum( 1'b0 )  );
	defparam
		lpm_mult_component.lpm_hint = "DEDICATED_MULTIPLIER_CIRCUITRY=YES,MAXIMIZE_SPEED=5",
		lpm_mult_component.lpm_representation = "UNSIGNED",
		lpm_mult_component.lpm_type = "LPM_MULT",
		lpm_mult_component.lpm_widtha = DATA_WIDTH,
		lpm_mult_component.lpm_widthb = DATA_WIDTH,
		lpm_mult_component.lpm_widthp = WIDTH_2X;
endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: AutoSizeResult NUMERIC "0"
// Retrieval info: PRIVATE: B_isConstant NUMERIC "0"
// Retrieval info: PRIVATE: ConstantB NUMERIC "0"
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "MAX 10"
// Retrieval info: PRIVATE: LPM_PIPELINE NUMERIC "0"
// Retrieval info: PRIVATE: Latency NUMERIC "0"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "1"
// Retrieval info: PRIVATE: SignedMult NUMERIC "0"
// Retrieval info: PRIVATE: USE_MULT NUMERIC "1"
// Retrieval info: PRIVATE: ValidConstant NUMERIC "0"
// Retrieval info: PRIVATE: WidthA NUMERIC "32"
// Retrieval info: PRIVATE: WidthB NUMERIC "32"
// Retrieval info: PRIVATE: WidthP NUMERIC "64"
// Retrieval info: PRIVATE: aclr NUMERIC "0"
// Retrieval info: PRIVATE: clken NUMERIC "0"
// Retrieval info: PRIVATE: new_diagram STRING "1"
// Retrieval info: PRIVATE: optimize NUMERIC "0"
// Retrieval info: LIBRARY: lpm lpm.lpm_components.all
// Retrieval info: CONSTANT: LPM_HINT STRING "DEDICATED_MULTIPLIER_CIRCUITRY=YES,MAXIMIZE_SPEED=5"
// Retrieval info: CONSTANT: LPM_REPRESENTATION STRING "UNSIGNED"
// Retrieval info: CONSTANT: LPM_TYPE STRING "LPM_MULT"
// Retrieval info: CONSTANT: LPM_WIDTHA NUMERIC "32"
// Retrieval info: CONSTANT: LPM_WIDTHB NUMERIC "32"
// Retrieval info: CONSTANT: LPM_WIDTHP NUMERIC "64"
// Retrieval info: USED_PORT: dataa 0 0 32 0 INPUT NODEFVAL "dataa[31..0]"
// Retrieval info: USED_PORT: datab 0 0 32 0 INPUT NODEFVAL "datab[31..0]"
// Retrieval info: USED_PORT: result 0 0 64 0 OUTPUT NODEFVAL "result[63..0]"
// Retrieval info: CONNECT: @dataa 0 0 32 0 dataa 0 0 32 0
// Retrieval info: CONNECT: @datab 0 0 32 0 datab 0 0 32 0
// Retrieval info: CONNECT: result 0 0 64 0 @result 0 0 64 0
// Retrieval info: GEN_FILE: TYPE_NORMAL Mult1Unsigned.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL Mult1Unsigned.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL Mult1Unsigned.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL Mult1Unsigned.bsf FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL Mult1Unsigned_inst.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL Mult1Unsigned_bb.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL Mult1Unsigned_syn.v TRUE
// Retrieval info: LIB_FILE: lpm
