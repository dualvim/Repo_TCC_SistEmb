/*
** Div2Signed.v
**
**
** --> Modulo para calcular a divisao e o resto da divisao.
** --> Valores SINALIZADOS
** -->  
*/


// synopsys translate_off
`timescale 1 ps / 1 ps


// synopsys translate_on
module Div2Signed #( parameter DATA_WIDTH=32, parameter END_IDX=DATA_WIDTH-1 )
	             ( denom, numer, quotient, remain);
//-------------------------------------------------------------------------------------------------
	input	 [END_IDX:0]  denom;
	input	 [END_IDX:0]  numer;
	output [END_IDX:0]  quotient;
	output [END_IDX:0]  remain;
//-------------------------------------------------------------------------------------------------
	wire [END_IDX:0] sub_wire0;
	wire [END_IDX:0] sub_wire1;
	wire [END_IDX:0] quotient = sub_wire0[END_IDX:0];
	wire [END_IDX:0] remain = sub_wire1[END_IDX:0];

	lpm_divide	LPM_DIVIDE_component (
				.denom( denom ),
				.numer( numer ),
				.quotient( sub_wire0 ),
				.remain( sub_wire1 ),
				.aclr( 1'b0 ),
				.clken( 1'b1 ),
				.clock( 1'b0 )  );
	defparam
		LPM_DIVIDE_component.lpm_drepresentation = "SIGNED",
		LPM_DIVIDE_component.lpm_hint = "LPM_REMAINDERPOSITIVE=FALSE",
		LPM_DIVIDE_component.lpm_nrepresentation = "SIGNED",
		LPM_DIVIDE_component.lpm_type = "LPM_DIVIDE",
		LPM_DIVIDE_component.lpm_widthd = DATA_WIDTH,
		LPM_DIVIDE_component.lpm_widthn = DATA_WIDTH;


endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "MAX 10"
// Retrieval info: PRIVATE: PRIVATE_LPM_REMAINDERPOSITIVE STRING "FALSE"
// Retrieval info: PRIVATE: PRIVATE_MAXIMIZE_SPEED NUMERIC "-1"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "1"
// Retrieval info: PRIVATE: USING_PIPELINE NUMERIC "0"
// Retrieval info: PRIVATE: VERSION_NUMBER NUMERIC "2"
// Retrieval info: PRIVATE: new_diagram STRING "1"
// Retrieval info: LIBRARY: lpm lpm.lpm_components.all
// Retrieval info: CONSTANT: LPM_DREPRESENTATION STRING "SIGNED"
// Retrieval info: CONSTANT: LPM_HINT STRING "LPM_REMAINDERPOSITIVE=FALSE"
// Retrieval info: CONSTANT: LPM_NREPRESENTATION STRING "SIGNED"
// Retrieval info: CONSTANT: LPM_TYPE STRING "LPM_DIVIDE"
// Retrieval info: CONSTANT: LPM_WIDTHD NUMERIC "32"
// Retrieval info: CONSTANT: LPM_WIDTHN NUMERIC "32"
// Retrieval info: USED_PORT: denom 0 0 32 0 INPUT NODEFVAL "denom[31..0]"
// Retrieval info: USED_PORT: numer 0 0 32 0 INPUT NODEFVAL "numer[31..0]"
// Retrieval info: USED_PORT: quotient 0 0 32 0 OUTPUT NODEFVAL "quotient[31..0]"
// Retrieval info: USED_PORT: remain 0 0 32 0 OUTPUT NODEFVAL "remain[31..0]"
// Retrieval info: CONNECT: @denom 0 0 32 0 denom 0 0 32 0
// Retrieval info: CONNECT: @numer 0 0 32 0 numer 0 0 32 0
// Retrieval info: CONNECT: quotient 0 0 32 0 @quotient 0 0 32 0
// Retrieval info: CONNECT: remain 0 0 32 0 @remain 0 0 32 0
// Retrieval info: GEN_FILE: TYPE_NORMAL Div2Signed.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL Div2Signed.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL Div2Signed.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL Div2Signed.bsf FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL Div2Signed_inst.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL Div2Signed_bb.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL Div2Signed_syn.v TRUE
// Retrieval info: LIB_FILE: lpm
