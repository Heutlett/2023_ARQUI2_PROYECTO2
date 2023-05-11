module segment_mem_wb 
#(parameter I=32, N=8, R=6)

(
	// Entradas
	input logic clk, reset, RegWriteM, MemtoRegM, FlagsWriteM, 
	input logic [R-1:0][1:0] ALUFlagsM,
	input logic [3:0] WA3M, 
	input logic [R-1:0][N-1:0] ReadDataM, 
	input logic [R-1:0][N-1:0] ALUOutputM,
	
	
	// Salidas
	output logic RegWriteW, MemtoRegW, FlagsWriteW, 
	output logic [R-1:0][1:0] ALUFlagsW,
	output logic [3:0] WA3W,
	output logic [R-1:0][N-1:0] ReadDataW,
	output logic [R-1:0][N-1:0] ALUOutputW

);
			
	always_ff@(negedge clk, posedge reset)
		if(reset)
			begin
				
				RegWriteW = 0;
				MemtoRegW = 0;
				ReadDataW = 0;
				ALUOutputW = 0;
				WA3W = 0;
				FlagsWriteW = 0;
				ALUFlagsW = 0;
				
			end
			
		else 
			begin
			
				RegWriteW = RegWriteM;
				MemtoRegW = MemtoRegM;
				ReadDataW = ReadDataM;
				ALUOutputW = ALUOutputM;
				WA3W = WA3M;
				FlagsWriteW = FlagsWriteM;
				ALUFlagsW = ALUFlagsM;
				
			end
		
endmodule
