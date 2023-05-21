module TB_TOP();

	// Entrada
	logic clk;
	logic reset;
	logic start;
	logic pause;
	logic [1:0] select;

	// Salida
	logic EndFlag;

	// Instanciación del módulo top
	top top_inst(
		.clk(clk),
		.reset(reset),
		.start(start),
		.pause(pause),
		.select(select),
		.EndFlag(EndFlag)
	);
	 
	 
	// initialize test
	initial begin
		clk = 0;
		reset = 1; # 6; reset = 0;
		select = 0;
		pause = 1;
		start = 0; # 5; start = 1;
		
		#500; pause = 0;
				
	end

	// generate clock to sequence tests
	always begin
		clk = ~clk; #5;
	end
	
endmodule