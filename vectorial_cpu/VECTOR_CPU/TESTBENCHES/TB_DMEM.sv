module TB_DMEM;

	// Parámetros
	parameter CLK_PERIOD = 10;

	// Señales
	logic clk;
	logic WE;
	logic [31:0] A;
	logic [5:0][7:0] WD;
	logic [5:0][7:0] RD;
	
	// Instancia del módulo de memoria de datos
	data_mem_vect dut (.clk(clk), .WE(WE), .A(A), .WD(WD), .RD(RD));

	// Generación de señales de prueba
	initial begin
		clk = 0;
		WE = 1;
		A = 32'h00000000;
		WD = '{8'h00, 8'h11, 8'h22, 8'h33, 8'h44, 8'h55};
		#CLK_PERIOD;
		
		clk = 1;
		#CLK_PERIOD;
		
		clk = 0;
		#CLK_PERIOD;
		
		WE = 0;
		A = 32'h00000000;
		#CLK_PERIOD;
		
		A = 32'h00000004;
		#CLK_PERIOD;
		
		A = 32'h00000008;
		#CLK_PERIOD;
		
		A = 32'h0000000C;
		#CLK_PERIOD;
		
		A = 32'h00000010;
		#CLK_PERIOD;
		
		A = 32'h00000000;
		#CLK_PERIOD;
		
	end

endmodule
