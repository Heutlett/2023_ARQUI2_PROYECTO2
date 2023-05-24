`timescale 1 ps / 1 ps
module TB_TOP();

	// Entrada
	logic clk;
	logic reset;
	logic start;
	logic pause;
	logic [1:0] select;
	logic clk_vga;
	logic hsync_out;
	logic vsync_out;
	logic [7:0] o_red;
	logic [7:0] o_blue;
	logic [7:0] o_green;
	

	// Salida
	logic EndFlag;

	// Instanciación del módulo top
	top top_inst(
		.clk_50(clk),
		.reset(reset),
		.start(start),
		.pause(pause),
		.select(select),
		.EndFlag(EndFlag),
		.clk_vga(clk_vga),
		.hsync_out(hsync_out),
		.vsync_out(vsync_out),
		.o_red(o_red),
		.o_blue(o_blue),
		.o_green(o_green)
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