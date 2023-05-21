module pc_control_unit
#(parameter I=32, R=6)
(	
	// Entradas
	input logic clk, reset, FlagsWrite, start,
	
	// algoritmo seleccionado
	input logic [1:0] select,
	
	// pausa del switch, 1 es pausa, 0 es continuar
	input logic pause,

	input logic [1:0] ALUFlags,
	input logic [3:0] Id,
	input logic [27:0] Address, // 28 bits
	input logic [1:0] Imm, // dos bits
	
	// Salidas
	output logic EndFlag, COMFlag,
	output logic [I-1:0] PCNext
);

	logic [1:0] ALUFlagsTemp;
	logic	COMFlagTemp;
	logic [I-1:0] PC;
	
	flopenr #(2) flagreg1(
								// Entradas
								.clk(clk), 
								.reset(reset), 
								.en(FlagsWrite), 
								.d(ALUFlags), 
								// Salidas
								.q(ALUFlagsTemp)
								);
								
	flopenr #(1) flagreg2(
								// Entradas
								.clk(clk), 
								.reset(reset), 
								.en(COMFlagTemp), 
								.d(1'b1), 
								// Salidas
								.q(COMFlag)
								);
	
	flopr #(32) pcreg	(
							// Entradas
							.clk(clk), 
							.reset(reset), 
							.start(start), 
							.d(PC), 
							// Salidas
							.q(PCNext)
							);
							
	always_comb begin
		case(Id)
	
			4'b0000: PC <= PCNext + 4;		 		// NOP

			4'b0001: begin 							// PSE
				if (pause == Imm[0]) begin
					PC <= Address[25:0];
					$display("\n\n *** CONTINUAR... ***");
				end
				else 
					PC <= PCNext + 4;
				
			end

			4'b0010: begin							   // SEL
				if (select == Imm) begin
					PC <= Address[25:0];
					$display("\n\n *** SELECT %0d ***", Imm);
				end
				else  
					PC <= PCNext + 4;
			end

			4'b0011: begin 
				PC <= PCNext;							// END
				$display("\n\n *** EL PROGRAMA HA TERMINADO EXITOSAMENTE ***");
			end
			
	
			4'b1100: PC <= Address; 				// JMP
			
			4'b1101: if (ALUFlagsTemp[0])		 	// JEQ
							PC <= Address;	
						else 
							PC <= PCNext + 4;
						
						
			4'b1110: if (ALUFlagsTemp[1])			// JLT
							PC <= Address;
						else 
							PC <= PCNext + 4;
						
			
			default: PC <= PCNext + 4;				// Not control instruction
		
		endcase
		
	end
	
	assign EndFlag = (Id == 4'b0010);
	assign COMFlagTemp = (Id == 4'b0001);
	
endmodule