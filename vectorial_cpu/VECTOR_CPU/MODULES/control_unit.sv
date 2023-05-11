module control_unit (
	// Entradas
	input logic [6:0] Id,

	// Salidas
	output logic RegWrite, MemtoReg, MemWrite, FlagsWrite, RegSrc,
	output logic [1:0] VSIFlag,
	output logic [2:0] ALUControl
);

	
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
			end
			
			
			// Data-processing 
			2'b01: begin
			
				// Tipo		Op	    	IS
				//	6:5	 	4:2		1:0
				//	01		 	000		11
				FlagsWrite 	= (Id[4:2] == 3'b100)  ? 1'b1 : 1'b0;			// CMP: modifica las banderas pero no registros
				RegWrite 	= (Id[4:2] == 3'b100)  ? 1'b0 : 1'b1;			// CMP: modifica las banderas pero no registros
				RegSrc 		= (VSIFlag[1] == 1'b0) ? 1'b0 : 1'bz; 			// 1 -> Z, 0 -> RB
				MemtoReg 	= 1'b0;
				MemWrite 	= 1'b0;
			end
			
			
			// Memory
			2'b10: begin
				// Tipo		Op	   S	NULL
				//	6:5	 	4		3	2:0
				//	10		 	0		1	xxx
				
				FlagsWrite 	= 1'b0;
				RegSrc 		= (Id[4] == 1'b1) ? 1'b1 : 1'b0;		// STR -> (RD y escritura en memoria)
				MemtoReg 	= (Id[4] == 1'b1) ? 1'b0 : 1'b1; 	// LDR -> (RB y escritura en registro)
				RegWrite 	= (Id[4] == 1'b1) ? 1'b0 : 1'b1;
				MemWrite		= (Id[4] == 1'b1) ? 1'b1 : 1'b0;
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
			end

			default: begin  // Unimplemented
				FlagsWrite 	= 1'bx;
				RegSrc 		= 1'bx;
				VSIFlag  	= 2'bx;
				MemtoReg 	= 1'bx;
				RegWrite 	= 1'bx;
				MemWrite 	= 1'bx;
				end
		endcase
	end

	// ALU Decoder
	always_comb begin
		unique case (Id[4:2])
		3'b000: ALUControl  = 3'b000; // ADD
		3'b001: ALUControl  = 3'b001; // SUB
		3'b010: ALUControl  = 3'b010; // MOV
		3'b011: ALUControl  = 3'b011; // MUL
		3'b100: ALUControl  = 3'b001; // CMP
		default: ALUControl = 3'bx; // unimplemented
		endcase
		
		// Overwrite -> ADD for MEM Instructions
		ALUControl = (Id[6:5] == 2'b10) ? 3'b000 : ALUControl;
	end			
endmodule