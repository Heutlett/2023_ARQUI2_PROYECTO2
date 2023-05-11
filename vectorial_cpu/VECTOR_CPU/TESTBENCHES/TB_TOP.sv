module TB_TOP();

    // Señales de entrada
    logic clk = 0;
    logic reset = 1;
    logic start = 0;
    
    // Señales de salida
    logic EndFlag;
	 
	 
	
	// Instanciación del módulo top
	 top top_inst(
		  .clk(clk),
		  .reset(reset),
		  .start(start),
		  .EndFlag(EndFlag)
	 );
	 
	 
	// generate clock to sequence tests
	always begin
		clk = ~clk; #5;
	end
	
	// Señales de entrada
	initial begin
		#10; reset = 0; #10; reset = 1;
		#10; start = 1; #10;
		
		
		
		#100 $finish;
    end
		
endmodule