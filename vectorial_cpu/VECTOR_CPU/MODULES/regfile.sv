module regfile
(
// Entradas

	// clock
	input logic clk,
	
	// WE3 : Señal de escritura
	input logic WE3, WE1,
	
	// Type : Tipo de operacion
	input logic LDFlag,
	
	// A1 y A2: indices de los registros
	// A3 : indice del registro destino
	input logic [3:0] A1, A2, A3,
	
	// WD3 : dato a escribir en A3
	input logic [5:0][7:0] WD3,
	
	// SFlag : bandera de operacion escalar
	input logic SFlag,
	
	// SP index, SP data
	input logic [3:0] SP1,
	input logic [5:0][7:0] WD1,
	
// Salidas
	
	// RD1, RD2 : vectores 1 y 2
	output logic [5:0][7:0] RD1, RD2
);

	// Registros vectoriales
//	logic [5:0][7:0] rf[9:0] = '{default:'0};
	// El primer vector equivale a 6 Registros escalares

	logic [5:0][7:0] rf[14:0] = '{ 
	
											
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}, // 14
											
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}, // 13
											
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}, // 12
											
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}, // 11
											
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00},// 10
											
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}, // 9

											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}, // 8
											
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}, // 7
											
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}, // 6
											
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}, // 5
											
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}, // 4
											
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}, // 3
											
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}, // 2
											
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}, // 1
											
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00} // Scalar
										};
	

	always_ff @(posedge clk) begin
	
		// Write in address reg
		if (WE1) begin
			// SP1, SP2, SP3, SP4, 
			rf[SP1] <= WD1;
			$display("\n  () Updating... StackPointer");
			$display("     o RA%0d  =  %h", SP1-10, WD1);
			$display(" - - - - - - - - - - - - - - - - - - - ");
		end
		
		
		// LOAD escalar
		if (WE3 && SFlag && LDFlag) begin

			// R0, R1, R2, R3, R4, R5
			rf[0][A3] <= WD3[0];
			$display("\n  > RegFile Scalar");
			$display("     o RS%0d  =  %0h", A3+1, WD3[0]);
		end
	
		// LOAD vectorial
		// Todas las operaciones aritmeticas
		else if (WE3) begin
			// V6, V7, V8, V9, V10
			rf[A3] <= WD3;
			$display("\n  > RegFile Vectorial");
			$display("     o RV%0d  =  %0h %0h %0h %0h %0h %0h", A3, WD3[5], WD3[4], WD3[3], WD3[2], WD3[1], WD3[0]);
		end
	end

	// RD1
	// solo puede ser vectorial
	assign RD1 = rf[A1];
	
	
	// RD2
	// Si es escalar se envia el vector de registros escalares al alu, sino el vector correspondientes.
	assign RD2 = SFlag ? rf[0] : rf[A2];
	
endmodule
