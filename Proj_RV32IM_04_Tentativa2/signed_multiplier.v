/*
** signed_multiplier.v
**
**
** --> Codigo do modulo multiplicador que recebe valores sinalizados
** --> 
** -->      
*/
// synopsys translate_off
`timescale 1 ps / 1 ps

// synopsys translate_on
(* multstyle = "dsp" *) module signed_multiplier #( parameter DATA_WIDTH=32, parameter END_IDX=DATA_WIDTH-1, parameter END_IDX2=(2*DATA_WIDTH)-1 ) 
				  ( clk, dataa, datab, result );
//-----------------------------------------------------------------------------------------
	input	             clk;
	input	[END_IDX:0]  dataa;
	input	[END_IDX:0]  datab;
	output[END_IDX2:0] result;
//-----------------------------------------------------------------------------------------
	wire [END_IDX2:0] sub_wire0;
	//wire [END_IDX2:0] result = sub_wire0[END_IDX2:0];
	assign result = sub_wire0[END_IDX2:0];
	
	lpm_mult	lpm_mult_component ( .clock( clk ),
						   .dataa( dataa ),
				               .datab( datab ),
				               .result( sub_wire0 ),
				               .aclr( 1'b0 ),
				               .clken( 1'b1 ),
				               .sclr( 1'b0 ),
				               .sum( 1'b0 )  );
	defparam
		lpm_mult_component.lpm_hint = "MAXIMIZE_SPEED=5",
		lpm_mult_component.lpm_type = "LPM_MULT",
		lpm_mult_component.lpm_representation = "SIGNED",
		lpm_mult_component.lpm_pipeline = 1,
		lpm_mult_component.lpm_widtha = DATA_WIDTH,
		lpm_mult_component.lpm_widthb = DATA_WIDTH,
		//lpm_mult_component.lpm_widths = DATA_WIDTH,
		lpm_mult_component.lpm_widthp = (DATA_WIDTH*2);
endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: AutoSizeResult NUMERIC "0"
// Retrieval info: PRIVATE: B_isConstant NUMERIC "0"
// Retrieval info: PRIVATE: ConstantB NUMERIC "0"
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "MAX 10"
// Retrieval info: PRIVATE: LPM_PIPELINE NUMERIC "1"
// Retrieval info: PRIVATE: Latency NUMERIC "1"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "1"
// Retrieval info: PRIVATE: SignedMult NUMERIC "1"
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
// Retrieval info: CONSTANT: LPM_HINT STRING "MAXIMIZE_SPEED=5"
// Retrieval info: CONSTANT: LPM_PIPELINE NUMERIC "1"
// Retrieval info: CONSTANT: LPM_REPRESENTATION STRING "SIGNED"
// Retrieval info: CONSTANT: LPM_TYPE STRING "LPM_MULT"
// Retrieval info: CONSTANT: LPM_WIDTHA NUMERIC "32"
// Retrieval info: CONSTANT: LPM_WIDTHB NUMERIC "32"
// Retrieval info: CONSTANT: LPM_WIDTHP NUMERIC "64"
// Retrieval info: USED_PORT: clock 0 0 0 0 INPUT NODEFVAL "clock"
// Retrieval info: USED_PORT: dataa 0 0 32 0 INPUT NODEFVAL "dataa[31..0]"
// Retrieval info: USED_PORT: datab 0 0 32 0 INPUT NODEFVAL "datab[31..0]"
// Retrieval info: USED_PORT: result 0 0 64 0 OUTPUT NODEFVAL "result[63..0]"
// Retrieval info: CONNECT: @clock 0 0 0 0 clock 0 0 0 0
// Retrieval info: CONNECT: @dataa 0 0 32 0 dataa 0 0 32 0
// Retrieval info: CONNECT: @datab 0 0 32 0 datab 0 0 32 0
// Retrieval info: CONNECT: result 0 0 64 0 @result 0 0 64 0
// Retrieval info: GEN_FILE: TYPE_NORMAL MultSigned.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL MultSigned.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL MultSigned.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL MultSigned.bsf FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL MultSigned_inst.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL MultSigned_bb.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL MultSigned_syn.v TRUE
// Retrieval info: LIB_FILE: lpm
