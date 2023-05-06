module regfile
(
// Entradas


	// clock
	input logic clk,
	
	// WE3 : Señal de escritura
	input logic WE3,
	
	// A1 y A2: indices de los registros
	// A3 : indice del registro destino
	input logic [3:0] A1, A2, A3,
	
	// WD3 : dato a escribir en A3
	input logic [5:0][7:0] WD3,
	
	
// Salidas


	// RD2I : indice del registro 2
	output logic [3:0] RD2I,
	
	// RD1, RD2 : vectores 1 y 2
	output logic [5:0][7:0] RD1, RD2
);
	logic [5:0][7:0] rf[9:0];
	
	always_ff @(posedge clk) begin
	
		if (WE3) rf[A3] <= WD3;
		
	end
		
	assign RD1 = rf[A1];
	assign RD2 = rf[A2];
	assign RD2I = A3;
	
endmodule
