module data_ram
(
	input logic clk, WE,
	input logic [31:0] A,
	input logic [5:0][7:0] WD,
	output logic [31:0] RD,
	output [5:0][7:0] vram_o[10923:0]
);

	logic ram_select;
	logic vram_select;
	logic [13:0] addr;
	
	assign addr = A[13:0];
	assign vram_select = A[14] & WE;
	assign ram_select = !A[14] & WE;
	
	data_mem cpu_ram
	(
		.clk(clk),
		.WE(ram_select),
		.A(addr),
		.WD(WD),
		.RD(RD)
	);

	
	VRAM vram
	(
		.clk(clk),
		.we(vram_select),
		.a(addr),
		.wd(WD),
		.vram_o(vram_o)
	);
	
endmodule
