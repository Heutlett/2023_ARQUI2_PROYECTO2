module TB_TOP();

	// Entrada
	logic clk;
	logic reset;
	logic start;

	// Salida
	logic EndFlag;

	// Instanciación del módulo top
	top top_inst(
		.clk(clk),
		.reset(reset),
		.start(start),
		.EndFlag(EndFlag)
	);
	 
	 
	// initialize test
	initial begin
		clk = 0;
		reset = 1; # 6; reset = 0;
		start = 0; # 5; start = 1;
	end

	// generate clock to sequence tests
	always begin
		clk = ~clk; #5;
	end
	
endmodule