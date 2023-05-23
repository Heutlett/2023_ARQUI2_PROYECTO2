module data_ram
(
	input logic clk, WE,
	input logic [31:0] A,
	input logic [16:0] A_VGA,
	input logic [5:0][7:0] WD,
	output logic [31:0] RD,
	output [5:0][7:0] vram_o
);

	logic ram_select;
	logic vram_select;
	logic [16:0] addr;
	
	assign addr = A[16:0];
	assign vram_select = A[17] & WE;
	assign ram_select = !A[17] & WE;
	
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
		.a_cpu(addr),
		.a_vga(A_VGA),
		.wd(WD),
		.vram_o(vram_o)
	);
	
endmodule
