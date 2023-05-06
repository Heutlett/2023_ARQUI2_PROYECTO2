module data_mem
(
	// Entradas
	input logic clk, WE,
	input logic [31:0] A, WD,
	
	// Salidas
	output logic [31:0] RD
);
	
	// Se inicializa la memoria de datos
	initial 
		$readmemh("data_mem_init.dat",RAM);
	
	logic [31:0] RAM[101:0];
	
	always_ff @(posedge clk) begin
	
		if (WE) begin
		
			RAM[A[13:2]] = WD;
			
			$display("\n\n---Write cycle DataMem----");
			$display("Address (hex):---------- %h", A);
			$display("Write data (hex):------- %h", WD);
			$display("Write data (dec):------- %d", WD);

		end
		
	end
	
	assign RD = RAM[A[13:2]];
	
	
	
endmodule
