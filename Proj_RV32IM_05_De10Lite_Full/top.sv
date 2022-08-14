/*
** top.sv
**
**
** --> Arquivo com o móduo principal do projeto
** --> Aqui estao definidos os modulos especificos da CPU
**
*/

// --> top - Módulo principal do projeto //////////////////////////////////////////////
module top ( input  logic       MAX10_CLK1_50,
		 input  logic [9:0] SW,
		 output logic [9:0] LEDR,
		 output logic [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 );
//---------------------------------------------------------------------------------------
	// --> Constantes:
	parameter RST = 1'b0;
	
	// --> Sinais e variaveis usadas aqui:
	logic MemWrite, RegWrite;
	logic [31:0] WriteData, DataAdr, PC;
	
	
	
	principal #( .DATA_WIDTH(32), .ADDR_W_ROM(15), .ADDR_W_RAM(13), .HEX_FILE("Script_teste_01.txt") ) rv32im_cpu
		     ( .clk( MAX10_CLK1_50 ), .reset( RST ), .pc( PC ), .write_data( WriteData ), .data_addr( DataAdr ) );
	
endmodule





// Modulo principal (criado dentro de 'top')  ///////////////////////////////////////////////////////////////////
module principal #( parameter DATA_WIDTH=32, parameter END_IDX=(DATA_WIDTH-1),  parameter ADDR_W_ROM=15, 
			  parameter ADDR_W_RAM=13, parameter HEX_FILE="Script_teste_01.txt" )
                  ( input  logic             clk,  
                    input  logic             reset, 
                    output logic             mem_write,
                    output logic [END_IDX:0] pc,
			  output logic [END_IDX:0] write_data, 
                    output logic [END_IDX:0] data_addr ); 
//--------------------------------------------------------------------------------------------------------------
	// --> Constantes
	
	
	// --> Sinais e arrays de sinais
      logic [2:0] imm_src;
	logic [31:0] instr;  // As instrucoes do RISC-S possuem 32 bits de comprimento, mesmo na imlementacao de 64 bits
	logic [END_IDX:0] read_data, pc, imm_ext; 
	
	/************************************************************
	** Memoria ROM para armazenar o programa (program memory)  **
	************************************************************/
	instr_mem #( .DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_W_ROM), .HEX_FILE(HEX_FILE) ) IMem 
		     ( .addr( pc ), .instr( instr ) );
	
	
	/*************************************************************
	** Memoria RAM para armazenamento temporario (data memory)  **
	*************************************************************/
	data_mem_single #( .DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_W_RAM)) DMem
			     ( .clk( clk ), .w_en( mem_write ), .addr( data_addr ), .w_data( write_data ), .r_data( read_data ) );
	
	
	// --> Array de 32 bits com o conteudo do valor imediato (immediate) 
	extend ext ( .instr( instr[31:7] ), // As instrucoes possuem o tamanho fixo de 32 bits
                   .imm_src( imm_src ), 
                   .imm_ext( imm_ext ) );
	
endmodule




// CPU RISC-V Single-Cycle  ////////////////////////////////////////////////////////////////////////////////////////////
module riscv_single #( parameter DATA_WIDTH=32, parameter END_IDX=(DATA_WIDTH-1),  parameter ADDR_W_ROM=10, 
			     parameter ADDR_W_RAM=10, parameter HEX_FILE="Script_teste_01.txt" )
                     ( input  logic             clk,  
                       input  logic             reset, 
			     input  logic [     31:0] instr,         // Instrucao de 32 bits
			     input  logic [END_IDX:0] read_data,     // Dados lidos em um registrador 			     
                       output logic             mem_write,
                       output logic [END_IDX:0] pc,            // Contador do programa
			     output logic [END_IDX:0] alu_result,    // Resultado produzido na ALU
                       output logic [END_IDX:0] write_data );  // Dados a serem escritos no registrador de destino
//----------------------------------------------------------------------------------------------------------------------
     // --> Constantes
     
     
     
     
     
     
     // --> Sinais e variaveis usadas aqui:
     logic [31:0] instr;  // Instrucoes de 32 bits executadas na CPU criada aqui
     logic [END_IDX:0] read_data, pc; 
     
     
endmodule


