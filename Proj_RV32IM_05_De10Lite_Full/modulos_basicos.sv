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


// Multiplexador 8:1 ///////////////////////////////////////////////////////////
module mux8 #( parameter DATA_WIDTH = 32, parameter END_IDX=DATA_WIDTH-1 )
             ( input  logic [END_IDX:0] d0, 
		   input  logic [END_IDX:0] d1, 
		   input  logic [END_IDX:0] d2, 
		   input  logic [END_IDX:0] d3, 
		   input  logic [END_IDX:0] d4, 
		   input  logic [END_IDX:0] d5, 
		   input  logic [END_IDX:0] d6, 
		   input  logic [END_IDX:0] d7,
               input  logic [      2:0] sel, 
               output logic [END_IDX:0] y   );
//--------------------------------------------------------------------------
    always_comb begin
        case( sel ) 
            3'b000:  y = d0;
            3'b001:  y = d1;
            3'b010:  y = d2;
            3'b011:  y = d3;
            3'b100:  y = d4;
            3'b101:  y = d5;
            3'b110:  y = d6;
            3'b111:  y = d7;
            default: y = { DATA_WIDTH { 1'b0 } };
        endcase
    end
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




