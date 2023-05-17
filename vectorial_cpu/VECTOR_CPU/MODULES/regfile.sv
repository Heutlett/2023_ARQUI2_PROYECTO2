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
	
	input logic SFlag,
// Salidas
	
	// RD1, RD2 : vectores 1 y 2
	output logic [5:0][7:0] RD1, RD2
);

	// Registros vectoriales
//	logic [5:0][7:0] rf[9:0] = '{default:'0};
	// El primer vector equivale a 6 Registros escalares

	logic [5:0][7:0] rf[9:0] = '{ 
											'{8'h05, 8'h04, 8'h03, 8'h02, 8'h01, 8'h00},
											'{8'h01, 8'h02, 8'h03, 8'h04, 8'h05, 8'h06},
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00},
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00},
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00},
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00},
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00},
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00},
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00},
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}
										};
	

	
	always_ff @(posedge clk) begin
	
	// LOAD o escrituras en registros
	  if (WE3 && SFlag) begin
	  	// Si es registro escalar
		// R0, R1, R2, R3, R4, R5
		 rf[0][A3] <= WD3[0];
		 $display("\n\n--- Write RegFile Scalar ----");
		 $display("R0 i (dec):  %0d", A3);
		 $display("Data (hex):  %0h", WD3[0]);

	  end
	  else if (WE3) begin
		 // Si es registro vectorial
		// V6, V7, V8, V9, V10
		 rf[A3] <= WD3;
		 $display("\n\n--- Write RegFile Vectorial ----");
		 $display("Index (dec):  %0d", A3);
		 $display("Data  (hex):  %0h %0h %0h %0h %0h %0h", WD3[5], WD3[4], WD3[3], WD3[2], WD3[1], WD3[0]);

	  end
	end

	// RD1 
	// solo puede ser vectorial
	assign RD1 = rf[A1];
	
	
	// RD2
	// Si es escalar se envia el vector de registros escalares al alu, sino el vector correspondientes.
	assign RD2 = SFlag ? rf[0] : rf[A2];
	
endmodule
