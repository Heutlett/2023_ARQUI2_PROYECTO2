module VRAM
(
	input logic clk, we,
	input logic [13:0] a,
	input logic [5:0][7:0] wd,
	output [5:0][7:0] vram_o[10923:0]
);
	logic [5:0][7:0] vram[10923:0];

	assign vram_o = vram;

	always_ff @(posedge clk)
		if (we) begin 
			vram[a[13:2]] <= wd;
		end
endmodule