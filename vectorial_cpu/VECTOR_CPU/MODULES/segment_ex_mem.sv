module segment_ex_mem 
#(parameter I=32, N=8, R=6)
(
	// Entradas
	input logic clk, reset, RegWriteE, SPWriteE, MemtoRegE, MemWriteE, FlagsWriteE, 
	input logic [1:0] ALUFlagsE,
	input logic [3:0] WA3E,
	input logic [3:0] RA1E,
	input logic [R-1:0][N-1:0] WD1E,
	input logic [I-1:0] AddressE,
	input logic [1:0] VSIFlagE,
	input logic LDFlagE,
	input logic [R-1:0][N-1:0] ALUOutputE, WriteDataE,
	
	// Salidas
	output logic RegWriteM, SPWriteM, MemtoRegM, MemWriteM, FlagsWriteM, 
	output logic [1:0] ALUFlagsM,
	output logic [3:0] WA3M,
	output logic [I-1:0] AddressM,
	output logic [1:0] VSIFlagM,
	output logic [3:0] RA1M,
	output logic [R-1:0][N-1:0] WD1M,
	output logic LDFlagM,
	output logic [R-1:0][N-1:0] ALUOutputM, WriteDataM
);
			
	always_ff@(negedge clk, posedge reset)
		if(reset)
			begin
				
				RegWriteM = 0;
				SPWriteM = 0;
				MemtoRegM = 0;
				MemWriteM = 0;
				ALUOutputM = 0;
				WriteDataM = 0;
				VSIFlagM = 0;
				LDFlagM = 0;
				WA3M = 0;
				RA1M = 0;
				WD1M = 0;
				AddressM = 0;
				FlagsWriteM = 0;
				ALUFlagsM = 0;
				
			end
			
		else 
			begin
			
				RegWriteM = RegWriteE;
				SPWriteM = SPWriteE;
				MemtoRegM = MemtoRegE;
				MemWriteM = MemWriteE;
				ALUOutputM = ALUOutputE;
				WriteDataM = WriteDataE;
				WA3M = WA3E;
				AddressM = AddressE;
				VSIFlagM = VSIFlagE;
				LDFlagM = LDFlagE;
				RA1M = RA1E;
				WD1M = WD1E;
				FlagsWriteM = FlagsWriteE;
				ALUFlagsM = ALUFlagsE;
				
			end
		
endmodule