module TB_REG_FILE;

	// Definición de las señales de entrada
	logic clk;
	logic WE3;
	logic LDFlag;
	logic [3:0] A1;
	logic [3:0] A2;
	logic [3:0] A3;
	logic [5:0][7:0] WD3;

	// Definición de las señales de salida
	logic [5:0][7:0] RD1;
	logic [5:0][7:0] RD2;
	logic [3:0] RD2I;

	// Instanciar el módulo de registro
	regfile regfile_inst (
		.clk(clk),
		.WE3(WE3),
		.LDFlag(LDFlag),
		.A1(A1),
		.A2(A2),
		.A3(A3),
		.WD3(WD3),
		.RD1(RD1),
		.RD2(RD2),
		.RD2I(RD2I)
	);

	 always begin
	  clk = ~clk; #5;
	 end

	initial begin
	
		#10; 
		clk = 0; #10;
	
		WE3 = 1;
		A3 = 1;
		WD3 = 'hABCD;
		#10;
		
		WE3 = 1;
		A3 = 2;
		WD3 = 'h1234;
		#10;
	
		A1 = 1;
		A2 = 2;
		#10;
		$display("RD1 = %h", RD1);
		$display("RD2 = %h", RD2);
		$display("RD2I = %d", RD2I);
		
	end

endmodule
