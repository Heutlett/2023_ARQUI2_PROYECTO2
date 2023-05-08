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
	
	// RD1, RD2 : vectores 1 y 2
	output logic [5:0][7:0] RD1, RD2
);
//	logic [5:0][7:0] rf[9:0] = '{default:'0}; // inicializar en cero

	logic [5:0][7:0] rf[9:0] = '{ 
											'{8'h09, 8'h09, 8'h09, 8'h09, 8'h09, 8'h09},
											'{8'h08, 8'h08, 8'h08, 8'h08, 8'h08, 8'h08},
											'{8'h01, 8'h02, 8'h03, 8'h04, 8'h05, 8'h06},
											'{8'h06, 8'h06, 8'h06, 8'h06, 8'h06, 8'h06},
											'{8'h05, 8'h05, 8'h05, 8'h05, 8'h05, 8'h05},
											'{8'h04, 8'h04, 8'h04, 8'h04, 8'h04, 8'h04},
											'{8'h03, 8'h03, 8'h03, 8'h03, 8'h03, 8'h03},
											'{8'h02, 8'h02, 8'h02, 8'h02, 8'h02, 8'h02},
											'{8'h01, 8'h01, 8'h01, 8'h01, 8'h01, 8'h01},
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}
										};

	always_ff @(posedge clk) begin
	
		if (WE3) rf[A3] <= WD3;
		
	end
		
	assign RD1 = rf[A1];
	assign RD2 = rf[A2];
	
endmodule
