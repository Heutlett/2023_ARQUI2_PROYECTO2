module painter
(
	input clk,
	input [9:0] horzCoord,
	input [9:0] vertCoord,
	input [5:0][7:0] vram_i,
	output logic pixel,
	output logic [23:0] colors,
	output [16:0] a_vga
);
	logic [16:0] index;
	logic [16:0] pixels;
	
	assign pixels = ((vertCoord - 111) * 256 + (horzCoord - 191));
	always_ff @(negedge clk) begin
		if ((191 < horzCoord && horzCoord < 447) && (111 < vertCoord && vertCoord < 367)) begin
			a_vga <= pixels / 6 + (pixels % 6 > 0);
			colors <= {vram_i[pixels % 6], vram_i[pixels % 6], vram_i[pixels % 6]};
			pixel <= 1'b1;
		end else begin
			pixel <= 1'b0;
		end
	end
endmodule