module segment_ex_mem 
#(parameter I=32, N=8, R=6)
(
	// Entradas
	input logic clk, reset, RegWriteE, MemtoRegE, MemWriteE, FlagsWriteE, 
	input logic [R-1:0][1:0] ALUFlagsE,
	input logic [3:0] WA3E,
	input logic [I-1:0] AE,
	input logic [R-1:0][N-1:0] ALUOutputE, WriteDataE,
	
	// Salidas
	output logic RegWriteM, MemtoRegM, MemWriteM, FlagsWriteM, 
	output logic [R-1:0][1:0] ALUFlagsM,
	output logic [3:0] WA3M,
	output logic [I-1:0] AM,
	output logic [R-1:0][N-1:0] ALUOutputM, WriteDataM
);
			
	always_ff@(negedge clk, posedge reset)
		if(reset)
			begin
				
				RegWriteM = 0;
				MemtoRegM = 0;
				MemWriteM = 0;
				ALUOutputM = 0;
				WriteDataM = 0;
				WA3M = 0;
				AM = 0;
				FlagsWriteM = 0;
				ALUFlagsM = 0;
				
			end
			
		else 
			begin
			
				RegWriteM = RegWriteE;
				MemtoRegM = MemtoRegE;
				MemWriteM = MemWriteE;
				ALUOutputM = ALUOutputE;
				WriteDataM = WriteDataE;
				WA3M = WA3E;
				AM = AE;
				FlagsWriteM = FlagsWriteE;
				ALUFlagsM = ALUFlagsE;
				
			end
		
endmodule