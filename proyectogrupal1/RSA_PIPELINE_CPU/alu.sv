module alu
#(parameter N = 4)
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

	always_comb
	begin
		case (opcode_i)
			ARITH_ADD:
			begin
				result_r = (a_i + b_i);
			end
			ARITH_SUB:
			begin
				result_r = (a_i - b_i);
			end
			ARITH_MUL:
			begin
				result_r = (a_i * b_i);
			end
			MOV_:
			begin
				result_r = b_i; 
			end
			default:
			begin
				result_r = '0;
			end
		endcase
	end
	
	
	assign result_o = result_r;
	assign ALUFlags[0] = (result_r == '0);
	assign ALUFlags[1] = result_r[N-1];
	
endmodule