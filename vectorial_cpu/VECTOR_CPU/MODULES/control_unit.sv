module control_unit (
	// Entradas
	input logic [6:0] Id,

	// Salidas
	output logic RegWrite, SPWrite, MemtoReg, MemWrite, FlagsWrite, RegSrc,
	output logic [1:0] VSIFlag,
	output logic LDSFlag, // Bandera que se utiliza para cuando la instruccion es MOV RS1, #1 o LDR RS1, [RA1, #4]
								// Cuando el registro RA es un escalar
	output logic [2:0] ALUControl
);

	import alu_defs::*;
	
	// Instruction decoder
	always_comb begin
			
		
		VSIFlag 	= Id[1:0]; 		// Asignar las banderas IS
		
		case (Id[6:5])
		
			// System operation
			2'b00: begin  
				FlagsWrite 	= 1'b0;
				RegSrc 		= 1'b0;
				VSIFlag 		= 2'b0;
				MemtoReg 	= 1'b0;
				RegWrite 	= 1'b0;
				MemWrite 	= 1'b0;
				LDSFlag		= 1'b0;
				SPWrite		= 1'b0;
				ALUControl  = 3'bz;
			end
			
			
			// Data-processing 
			2'b01: begin
			
				// Tipo		Op	    	IS
				//	6:5	 	4:2		1:0
				//	01		 	000		11
				FlagsWrite 	= (Id[4:2] == CMP)  ? 1'b1 : 1'b0;			// CMP: modifica las banderas pero no registros
				RegWrite 	= (Id[4:2] == CMP)  ? 1'b0 : 1'b1;			// CMP: modifica las banderas pero no registros
				RegSrc 		= (VSIFlag[1] == 1'b0) ? 1'b0 : 1'bz; 		// 1 -> Z, 0 -> RB
				MemtoReg 	= 1'b0;
				MemWrite 	= 1'b0;
				LDSFlag		= (Id[4:2] == MOV) ? 1'b1 : 1'b0;
				SPWrite		= 1'b0;
				ALUControl = Id[4:2];	// Arith operation
			end
			
			
			// Memory
			2'b10: begin
				// Tipo		Op	   NULL	 IS
				//	6:5	 	4		3:2    1:0
				//	10		 	0		xx	    00
				
				FlagsWrite 	= 1'b0;
				RegSrc 		= (Id[4] == 1'b1) ? 1'b1 : 1'b0;		// STR -> (RD y escritura en memoria)
				MemtoReg 	= (Id[4] == 1'b1) ? 1'b0 : 1'b1; 	// LDR -> (RB y escritura en registro)
				RegWrite 	= (Id[4] == 1'b1) ? 1'b0 : 1'b1;
				MemWrite		= (Id[4] == 1'b1) ? 1'b1 : 1'b0;
				LDSFlag		= 1'b1;
				SPWrite		= (Id[4] == 1'b1) ? 1'b1 : 1'b0;	   // STR -> actualiza registro sp
				ALUControl  = 3'bz;
			end

			// Control
			2'b11: begin				
				// Tipo		Op	   NULL
				//	6:5	 	4:3	2:0
				//	10		 	00		xxxx
				FlagsWrite 	= 1'b0;
				RegSrc 		= 1'b0; 
				MemtoReg 	= 1'b0;
				RegWrite 	= 1'b0;
				MemWrite 	= 1'b0;
				LDSFlag		= 1'b0;
				SPWrite		= 1'b0;
				ALUControl  = 3'bz;
			end

			default: begin  // Unimplemented
				FlagsWrite 	= 1'bz;
				RegSrc 		= 1'bz;
				VSIFlag  	= 2'bz;
				MemtoReg 	= 1'bz;
				RegWrite 	= 1'bz;
				MemWrite 	= 1'bz;
				LDSFlag		= 1'bz;
				SPWrite		= 1'bz;
				ALUControl  = 3'bz;
				end
		endcase
	end


endmodule