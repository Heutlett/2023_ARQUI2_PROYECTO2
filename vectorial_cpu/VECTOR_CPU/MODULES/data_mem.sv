module data_mem #(parameter DMEM_SIZE = 10926)

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
	
	logic [5:0][7:0] RAM[DMEM_SIZE:0];
	
	always_ff @(posedge clk) begin
	
		if (WE) begin
		
			RAM[A[13:2]] = WD;
			$display("\n  - - - - - - - - - - - - - - - - - - - ");
			$display("|<<| DATA_MEM");
			$display(" o A (dec):  %h", A);
			$display(" o D (hex):  %d %d %d %d %d %d", WD[5], WD[4], WD[3], WD[2], WD[1], WD[0]);

		end
		
	end
	
	assign RD = RAM[A[13:2]];
	
	
	
endmodule
