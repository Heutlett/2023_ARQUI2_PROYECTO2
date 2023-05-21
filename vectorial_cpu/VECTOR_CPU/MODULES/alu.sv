module alu
#(parameter N = 8)
(
	// Entradas
	input logic [N-1:0] a_i, b_i,
	input logic [2:0] opcode_i,
	
	// Salidas
	output logic [N-1:0] result_o,
	output [1:0] ALUFlags
);
	import alu_defs::*;
	
	logic [N:0] result_r;
	logic [N-1:0] left;
	logic [N-1:0] right;

	shift_module #(N) shift_inst (.a(a_i), .b(b_i[2:0]), .left(left), .right(right));
	
	always_comb begin
		
		case (opcode_i)
		
			ADD: result_r = (a_i + b_i);
			MOV: result_r = b_i;
			XOR: result_r = (a_i ^ b_i);
			OR:  result_r = (a_i | b_i);
			SHR: result_r = right;
			SHL: result_r = left;
			CMP: result_r = (a_i - b_i);
			SUB: result_r = (a_i - b_i);
			default: result_r = 8'bz;
		
		endcase
	end
 
	
	
	assign result_o = result_r[N-1:0];		// Result
	assign ALUFlags[0] = (opcode_i == CMP) ? (result_r == '0) : 1'bx;	// ZERO flag
	assign ALUFlags[1] = (opcode_i == CMP) ? result_r[N-1] : 1'bx; 	// SIGN flag
	
endmodule