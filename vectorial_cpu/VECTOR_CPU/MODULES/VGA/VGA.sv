module VGA(
	input clk_fpga,
	input [5:0][7:0] vram_i,
	output clk_out,
	output hsync_out,
	output vsync_out,
	output [16:0] a_vga,
	output [7:0] o_red,
	output [7:0] o_blue,
	output [7:0] o_green
);
	
	logic inDisplayArea;
	logic [9:0] CounterX;
	logic [9:0] CounterY;
	logic clk_25;
	
	logic [7:0] r_red;
	logic [7:0] r_green;
	logic [7:0] r_blue;
	logic res;
	logic [23:0] colors;

	hvsync_generator hvsync(
		.clk(clk_fpga),
		.vga_h_sync(hsync_out),
		.vga_v_sync(vsync_out),
		.CounterX(CounterX),
		.CounterY(CounterY),
		.inDisplayArea(inDisplayArea)
	);
				
	painter t1(
		.clk(clk_fpga),
		.horzCoord(CounterX), // current position.x
		.vertCoord(CounterY), // current position.y
		.pixel(res),  // result, 1 if current pixel is on text, 0 otherwise
		.vram_i(vram_i),
		.colors(colors),
		.a_vga(a_vga)
		);


always_ff @(posedge clk_fpga)
	begin
		if (res)
			{r_red, r_green, r_blue} <= colors;
		else
			{r_red, r_green, r_blue} <= 24'h0096FF;
	end

	assign o_red = inDisplayArea ? r_red : 24'h000000;
	assign o_green = inDisplayArea ? r_green : 24'h000000;
	assign o_blue = inDisplayArea ? r_blue : 24'h000000;
	assign clk_out = clk_fpga;

endmodule