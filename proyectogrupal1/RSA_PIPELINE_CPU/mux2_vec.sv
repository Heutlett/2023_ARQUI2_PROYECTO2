module mux2_vec #(parameter N=8, R=6)
(
	// Entradas
	input logic s,
	input logic [R-1:0][N-1:0] d0, d1,
	
	// Salidas
	output logic [R-1:0][N-1:0] y
);

	assign y = s ? d1 : d0;
	
endmodule