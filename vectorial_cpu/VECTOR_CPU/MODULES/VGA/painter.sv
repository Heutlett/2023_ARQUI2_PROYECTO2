module painter
(
	input clk,
	input [9:0] horzCoord,
	input [9:0] vertCoord,
	input [5:0][7:0] vram_i[10923:0],
	output logic pixel,
	output logic [23:0] colors
);
	
	always_ff @(negedge clk) begin
		if (191 < horzCoord < 447 || 111 < vertCoord < 367) begin
			colors <= 24'hFFFFFF;
			pixel <= 1'b1;
		end else begin
			pixel <= 1'b0;
		end
	end
endmodule