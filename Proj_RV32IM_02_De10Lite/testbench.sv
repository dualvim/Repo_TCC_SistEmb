/*
** testbench.sv
**
**
** --> Modulos com o testbench para testar mo modulo 'top' 
** 
**       
*/

`timescale 1 ps / 1 ps

module testbench();
	// Constantes
	parameter ROM_REG_ADDR = 10; // 1024 bytes de memoria ROM
	parameter RAM_REG_ADDR = 10; // 1024 bytes de memoria RAM
	
	// Sinais e arrays usados aqui
	logic        clk;
	logic        reset; 
	logic        MemWrite;
	logic [31:0] WriteData;
	logic [31:0] DataAdr;
	
	// --> Instancia do modulo principal do projeto
	top #( .DATA_WIDTH(32), .ADDR_W_ROM(15), .ADDR_W_RAM(13), .HEX_FILE("riscvtest.txt")  ) dut
	     ( .clk( clk ), 
		 .reset( reset ), 
		 .mem_write( MemWrite ),
		 .write_data( WriteData ), 
		 .data_addr( DataAdr ) );
	// Inicializacao dos testes
	initial begin
		reset <= 1; 
		#22; 
		reset <= 0;
	end
	
	
	// Geracao dos pulsos de clock usados nos testes sequenciais
	always begin
		clk <= 1; 
		#5; 
		clk <= 0; 
		#5;
	end
	
	// --> Variavel do tipo numero inteiro para mostra a iteracao atual
	integer i = 0;
	
	// --> Verificacao dos resultados
	always @( negedge clk ) begin
		$monitor("i=%d, MemWrite=%d, WriteData=%d, DataAdr=%d\n", i, MemWrite, WriteData, DataAdr);
		#5;
		i = i + 1;
		#5;
		
		if( MemWrite ) begin
			if( (DataAdr === 100) & (WriteData === 25) ) begin
				$display("Simulation succeeded");
				$stop;
			end 
			else if( DataAdr !== 96 ) begin
				$display("Simulation failed");
				$stop;
			end
		end
	end
endmodule
