module painter
(
	input clk,
	input [9:0] horzCoord,
	input [9:0] vertCoord,
//	input [31:0] tex [20:0],
	output logic pixel,
	output logic [23:0] colors
);
	
	always_ff @(negedge clk) begin
		if (horzCoord > 255 || vertCoord > 255) begin
			pixel <= 1'b0;
		end else begin
			colors <= 24'hFFFFFF;
			pixel <= 1'b1;
		end
	end
endmodule