module regfile
(
// Entradas

	// clock
	input logic clk,
	input logic reset,

//	// algoritmo seleccionado
//	input logic [1:0] select,
//	
//	// pausa del switch, 1 es pausa, 0 es continuar
//	input logic pause,
	
	// WE3 : Señal de escritura
	input logic WE3, WE1,
	
	// Type : Tipo de operacion
	input logic LDSFlag,
	
	
	// A1 y A2: indices de los registros
	// A3 : indice del registro destino
	input logic [3:0] A1, A2, A3,
	
	// WD3 : dato a escribir en A3
	input logic [5:0][7:0] WD3,
	
	// SFlag : bandera de guardado escalar 
	input logic WSFlag,

	// RSFlag : bandera de operacion escalar 
	input logic RSFlag,
	
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
	
	
	logic [5:0][7:0] rf[15:0] = '{ 
	
											
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}, // 15 RA5
											
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}, // 14 RA4
											
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}, // 13 RA3
											
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}, // 12 RA2
										
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}, // 11 RA1
											
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}, // 10 RV10

											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}, // 9  RV9
											
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}, // 8  RV8
											
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}, // 7  RV7
											
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}, // 6  RV6
											
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}, // 5  RV5
											
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}, // 4  RV4
										
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}, // 3  RV3
											
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}, // 2  RV2
											
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}, // 1  RV1
											
											'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}  // 0  RS1 RS2 RS3 RS4

										};
	

always_ff @(posedge clk, posedge reset) begin
		
		if (reset) begin
			// Reset condition
			for (integer i = 0; i < 16; i = i + 1) begin
				rf[i] = 48'b0;
			end
		end
	 
		else begin
		
		
			// Write in address reg
			if (WE1) begin
				// SP1, SP2, SP3, SP4, 
				rf[SP1] <= WD1;
				$display("\n  () Updating... StackPointer");
				$display("     o RA%0d  =  %0h", SP1-10, WD1);
				$display(" - - - - - - - - - - - - - - - - - - - ");
			end
		
		
			// LOAD escalar
			if (WE3 && WSFlag && LDSFlag) begin

				// R0, R1, R2, R3, R4, R5
				rf[0][A3] <= WD3[0];
				$display("\n  > RegFile Scalar");
				$display("     o RS%0d  =  %0h", A3+1, WD3[0]);
			end

			// LOAD vectorial
			// Todas las operaciones aritmeticas
			else if (WE3) begin
			
				rf[A3] <= WD3;
				
				$display("\n  > RegFile Vectorial");
				if (A3 < 11)
					$display("     o RV%0d  =  %0h %0h %0h %0h %0h %0h", A3, WD3[5], WD3[4], WD3[3], WD3[2], WD3[1], WD3[0]);
				else
					$display("     o RA%0d  =  %0h", A3-10, WD3);

			end
		end
	end
	
	// RD1
	// Solo puede ser vectorial
	assign RD1 = rf[A1];

	// RD2
	// Si es escalar se envia el vector de registros escalares al alu, sino el vector correspondientes.
	assign RD2 = RSFlag ? rf[0] : rf[A2];
	

	
	
endmodule
