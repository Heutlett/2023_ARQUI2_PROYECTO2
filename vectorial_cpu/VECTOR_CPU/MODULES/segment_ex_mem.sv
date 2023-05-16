module segment_ex_mem 
#(parameter I=32, N=8, R=6)
(
	// Entradas
	input logic clk, reset, RegWriteE, MemtoRegE, MemWriteE, FlagsWriteE, 
	input logic [1:0] ALUFlagsE,
	input logic [3:0] WA3E,
	input logic [I-1:0] AddressE,
	input logic [1:0] VSIFlagE, 
	input logic [R-1:0][N-1:0] ALUOutputE, WriteDataE,
	
	// Salidas
	output logic RegWriteM, MemtoRegM, MemWriteM, FlagsWriteM, 
	output logic [1:0] ALUFlagsM,
	output logic [3:0] WA3M,
	output logic [I-1:0] AddressM,
	output logic [1:0] VSIFlagM, 
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
				VSIFlagM = 0;
				WA3M = 0;
				AddressM = 0;
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
				AddressM = AddressE;
				VSIFlagM = VSIFlagE;
				FlagsWriteM = FlagsWriteE;
				ALUFlagsM = ALUFlagsE;
				
			end
		
endmodule