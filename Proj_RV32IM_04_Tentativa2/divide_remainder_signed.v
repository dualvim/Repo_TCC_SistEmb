/*
** divide_remainder_signed.v
**
**
** --> Codigo do modulo com o hardware para realziar operacoes de divoisao que recebe valores nao-sinalizados.
** --> 
** -->      
*/
// synopsys translate_off
`timescale 1 ps / 1 ps


// synopsys translate_on
module divide_remainder_signed #( parameter DATA_WIDTH=32, parameter END_IDX=DATA_WIDTH-1 )
                                  ( clk, denom, numer, quotient, remain );
//-------------------------------------------------------------------------------------------------
	input	              clk;
	input	 [END_IDX:0]  denom;
	input	 [END_IDX:0]  numer;
	output [END_IDX:0]  quotient;
	output [END_IDX:0]  remain;
//-------------------------------------------------------------------------------------------------
	wire [END_IDX:0] sub_wire0;
	wire [END_IDX:0] sub_wire1;
	//wire [END_IDX:0] quotient = sub_wire0[END_IDX:0];
	//wire [END_IDX:0] remain = sub_wire1[END_IDX:0];
	assign quotient = sub_wire0[END_IDX:0];
	assign remain = sub_wire1[END_IDX:0];
	
	lpm_divide	LPM_DIVIDE_component ( .clock( clk ),
				                 .denom( denom ),
				                 .numer( numer ),
				                 .quotient( sub_wire0 ),
				                 .remain( sub_wire1 ),
				                 .aclr( 1'b0 ),
				                 .clken( 1'b1 )   );
	defparam
		LPM_DIVIDE_component.lpm_drepresentation = "SIGNED",
		LPM_DIVIDE_component.lpm_hint = "LPM_REMAINDERPOSITIVE=TRUE",
		LPM_DIVIDE_component.lpm_nrepresentation = "SIGNED",
		LPM_DIVIDE_component.lpm_pipeline = 1,
		LPM_DIVIDE_component.lpm_type = "LPM_DIVIDE",
		LPM_DIVIDE_component.lpm_widthd = 32,
		LPM_DIVIDE_component.lpm_widthn = 32;
endmodule
