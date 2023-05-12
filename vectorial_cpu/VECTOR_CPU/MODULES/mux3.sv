module mux3 #(parameter WIDTH = 8)
(
	// Entradas
	input logic [1:0] sel,
	input logic [WIDTH-1:0] d0, d1, d2,
	
	// Salidas
	output logic [WIDTH-1:0] y
);

	assign y = (sel == 2'b00) ? d0 :
	           (sel == 2'b01) ? d1 :
	           (sel == 2'b11) ? d2 :
	           'bz; // Valor indeterminado en caso de que s tome un valor no válido
endmodule
