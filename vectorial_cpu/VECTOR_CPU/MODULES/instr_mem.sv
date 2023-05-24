module instr_mem #(parameter IMEM_SIZE = 250) (
	// Entradas
	input logic [31:0] A,
	
	// Salidas
	output logic [31:0] RD
);

	// Se inicializa la memoria de instrucciones
	initial
		$readmemh("inst_mem_init.dat", RAM);

	logic [31:0] RAM[IMEM_SIZE:0];

	assign RD = RAM[A[31:2]];
	
endmodule
