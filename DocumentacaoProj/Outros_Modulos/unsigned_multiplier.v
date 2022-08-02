/*
** unsigned_multiplier.v
**
**
** --> Codigo do modulo multiplicador que recebe valores nao-sinalizados.
** --> 
** -->      
*/

// synopsys translate_off
`timescale 1 ps / 1 ps

// synopsys translate_on
module unsigned_multiplier #( parameter DATA_WIDTH=32, parameter END_IDX=DATA_WIDTH-1, parameter END_IDX2=(2*DATA_WIDTH)-1 ) 
				    ( dataa, datab, result );
//-----------------------------------------------------------------------------------------
	input	[END_IDX:0]  dataa;
	input	[END_IDX:0]  datab;
	output[END_IDX2:0]  result;
//-----------------------------------------------------------------------------------------
	wire [END_IDX2:0] sub_wire0;
	wire [END_IDX2:0] result = sub_wire0[END_IDX2:0];

	lpm_mult	lpm_mult_component (
				.dataa( dataa ),
				.datab( datab ),
				.result( sub_wire0 ),
				.aclr( 1'b0 ),
				.clken( 1'b1 ),
				.clock( 1'b0 ),
				.sclr( 1'b0 ),
				.sum( 1'b0 ) );
	defparam
		lpm_mult_component.lpm_hint = "MAXIMIZE_SPEED=5",
		lpm_mult_component.lpm_representation = "UNSIGNED",
		lpm_mult_component.lpm_type = "LPM_MULT",
		lpm_mult_component.lpm_widtha = DATA_WIDTH,
		lpm_mult_component.lpm_widthb = DATA_WIDTH,
		lpm_mult_component.lpm_widthp = (DATA_WIDTH*2);
endmodule

