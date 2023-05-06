module regfile
(
	// Entradas
	input logic clk, WE3,
	input logic [3:0] A1, A2, A3,
	input logic [5:0][7:0] WD3,
	// Salidas
	output logic [3:0] RD2I,
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
