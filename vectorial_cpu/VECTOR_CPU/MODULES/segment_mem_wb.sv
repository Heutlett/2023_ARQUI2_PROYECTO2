module segment_mem_wb 
#(parameter I=32, N=8, R=6)

(
	// Entradas
	input logic clk, reset, RegWriteM, SPWriteM, MemtoRegM, FlagsWriteM, 
	input logic [1:0] ALUFlagsM,
	input logic [1:0] VSIFlagM,
	input logic LDFlagM,
	input logic [3:0] WA3M, 
	input logic [3:0] RA1M,
	input logic [R-1:0][N-1:0] WD1M,
	input logic [R-1:0][N-1:0] ReadDataM, 
	input logic [R-1:0][N-1:0] ALUOutputM,
	
	
	// Salidas
	output logic RegWriteW, SPWriteW, MemtoRegW, FlagsWriteW, 
	output logic [1:0] ALUFlagsW,
	output logic [1:0] VSIFlagW,
	output logic LDFlagW,
	output logic [3:0] WA3W,
	output logic [3:0] RA1W,
	output logic [R-1:0][N-1:0] WD1W,
	output logic [R-1:0][N-1:0] ReadDataW,
	output logic [R-1:0][N-1:0] ALUOutputW

);
			
	always_ff@(negedge clk, posedge reset)
		if(reset)
			begin
				
				RegWriteW = 0;
				SPWriteW = 0;
				MemtoRegW = 0;
				ReadDataW = 0;
				ALUOutputW = 0;
				VSIFlagW = 0;
				LDFlagW = 0;
				WA3W = 0;
				RA1W = 0;
				WD1W = 0;
				FlagsWriteW = 0;
				ALUFlagsW = 0;
				
			end
			
		else 
			begin
			
				RegWriteW = RegWriteM;
				SPWriteW = SPWriteM;
				MemtoRegW = MemtoRegM;
				ReadDataW = ReadDataM;
				ALUOutputW = ALUOutputM;
				WA3W = WA3M;
				VSIFlagW = VSIFlagM;
				LDFlagW = LDFlagM;
				RA1W = RA1M;
				WD1W = WD1M;
				FlagsWriteW = FlagsWriteM;
				ALUFlagsW = ALUFlagsM;
				
			end
		
endmodule
