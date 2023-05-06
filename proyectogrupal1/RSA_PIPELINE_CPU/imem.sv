module imem
(
	input logic [31:0] a,
	input clk,
	output logic [31:0] rd
);

	logic [31:0] RAM[150:0];
	
	initial
		$readmemh("inst_mem_init.dat",RAM);
	
	assign rd = RAM[a[31:2]];
	
endmodule