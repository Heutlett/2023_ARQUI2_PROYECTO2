module VRAM
(
	input logic clk, we,
	input logic [16:0] a_cpu,
	input logic [16:0] a_vga,
	input logic [5:0][7:0] wd,
	output [5:0][7:0] vram_o
);
	logic [5:0][7:0] vram[10923:0];
	
	initial 
		$readmemh("data_mem_init.dat",vram);

	always_ff @(posedge clk) begin
			if (we)
				vram[a_cpu] <= wd;
				
			vram_o <= vram[a_vga];
	end
endmodule