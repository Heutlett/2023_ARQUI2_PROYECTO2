module data_mem
(
	// Entradas
	input logic clk, WE,
	input logic [31:0] A,
	input logic [5:0][7:0] WD,
	
	// Salidas
	output logic [5:0][7:0] RD
);
	
	// Se inicializa la memoria de datos
	initial 
		$readmemh("data_mem_init.dat",RAM);
	
	logic [5:0][7:0] RAM[101:0];
	
	always_ff @(posedge clk) begin
	
		if (WE) begin
		
			RAM[A[13:2]] = WD;
			$display("\n  - - - - - - - - - - - - - - - - - - - ");
			$display("|<<| DATA_MEM");
			$display(" o A (dec):  %h", A);
			$display(" o D (hex):  %0h %0h %0h %0h %0h %0h", WD[5], WD[4], WD[3], WD[2], WD[1], WD[0]);

		end
		
	end
	
	assign RD = RAM[A[13:2]];
	
	
	
endmodule
