module segment_id_ex
#(parameter N=8, R=6) 
(
	// Entradas
	input logic clk, reset, RegWriteD, MemtoRegD, MemWriteD, FlagsWriteD,
	input logic [1:0] VSIFlagD,
	input logic [2:0] ALUControlD,
	input logic [3:0] WA3D,
	input logic [R-1:0][N-1:0] rd1D, rd2D,
	input logic [3:0] RA2D,
	input logic [N-1:0] ImmD,
	
	// Salidas
	output logic RegWriteE, MemtoRegE, MemWriteE, FlagsWriteE,
	output logic [1:0] VSIFlagE,
	output logic [2:0] ALUControlE, 
	output logic [3:0] WA3E,
	output logic [R-1:0][N-1:0] rd1E, rd2E,
	output logic [3:0] RA2E,
	output logic [N-1:0] ImmE
);
			
	always_ff@(negedge clk, posedge reset)
		if(reset)
			begin
				RegWriteE = 0;
				MemtoRegE = 0;
				MemWriteE = 0;
				ALUControlE = 0;
				VSIFlagE = 0;
				WA3E = 0;
				rd1E = 0;
				rd2E = 0;
				RA2E = 0;
				ImmE = 0;
				FlagsWriteE = 0;
			end
			
		else 
			begin
				RegWriteE = RegWriteD;
				MemtoRegE = MemtoRegD;
				MemWriteE = MemWriteD;
				ALUControlE = ALUControlD;
				VSIFlagE = VSIFlagD;
				WA3E = WA3D;
				rd1E = rd1D;
				rd2E = rd2D;
				RA2E = RA2D;
				ImmE = ImmD;
				FlagsWriteE = FlagsWriteD;
			end
		
endmodule