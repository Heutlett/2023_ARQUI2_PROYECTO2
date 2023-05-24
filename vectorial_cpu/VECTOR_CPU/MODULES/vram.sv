module VRAM
(
	input  logic clk, we,
	input  logic [16:0] a_cpu,
	input  logic [16:0] a_vga,
	input  logic [5:0][7:0] wd,
	
	output logic [5:0][7:0] vram_o
);
	logic [5:0][7:0] vram[10923:0];

//	initial 
//		$readmemh("data_mem_init.dat",vram);
	
	always_ff @(posedge clk) begin
			if (we) begin
				vram[a_cpu[16:2]] <= wd;
				$display("\n  - - - - - - - - - - - - - - - - - - - ");
				$display("|<<| VRAM");
				$display(" o A (dec):  %h", a_cpu);
				$display(" o D (hex):  %h %h %h %h %h %h", wd[5], wd[4], wd[3], wd[2], wd[1], wd[0]);
			end
				
			vram_o <= vram[a_vga];
	end
endmodule