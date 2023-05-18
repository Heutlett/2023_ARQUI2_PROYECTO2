module datapath
#(parameter I=32, N=8, R=6)
(
	// Entradas
	input logic clk, reset, RegWriteD, SPWriteD, MemtoRegD, MemWriteD, FlagsWriteD, RegSrcD,
	input logic [1:0] VSIFlagD,
	input logic LDFlagD,
	input logic [2:0] ALUControlD,
	input logic [I-1:0] InstrF,
	input logic [R-1:0][N-1:0] ReadData,
	
	// Salidas
	output logic MemWriteM, FlagsWriteW,
	output logic [1:0] ALUFlagsW,
	output logic [I-1:0] InstrD,
	output logic [I-1:0] AddressM,
	output logic [R-1:0][N-1:0] WriteDataM
);	



// FETCH ***********************************************************************

	segment_if_id seg_if_id	(
	// Entradas
		.clk(clk), 
		.reset(reset), 
		.InstrF(InstrF), 
	// Salidas
		.InstrD(InstrD)
	);
	
		
// DECODE ***********************************************************************

	logic [3:0] RA2D;	

	mux2 #(4) ra2mux	(
	// Entradas
		.d0(InstrD[16:13]), 
		.d1(InstrD[24:21]), 
		.s(RegSrcD), 
	// Salidas
		.y(RA2D)
	);
		
	logic [3:0] WA3W;   				// Se recibe de la etapa Write-back
	logic [R-1:0][N-1:0] ResultW;	// Se recibe de la etapa Write-back
	logic RegWriteW;					// Se recibe de la etapa Write-back
	logic SPWriteW;
	logic [R-1:0][N-1:0] RD1D, RD2D;
	logic [3:0] RA1W;
	logic [1:0] VSIFlagW;
	logic LDFlagW;
	logic [5:0][7:0] WD1W;
	
	regfile reg_file (
	// Entradas
		.clk(clk), 
		.WE3(RegWriteW),
		.WE1(SPWriteW),
		.LDFlag(LDFlagW),
		.A1(InstrD[20:17]),
		.A2(RA2D),
		.A3(WA3W),
		.SFlag(VSIFlagW[0]),
		.WD3(ResultW),
		.WD1(WD1W),
		.SP1(RA1W),
	// Salidas
		.RD1(RD1D),
		.RD2(RD2D)
	);
	
	logic RegWriteE, SPWriteE, MemtoRegE, MemWriteE, FlagsWriteE;
	logic [2:0] ALUControlE;
	logic [R-1:0][N-1:0] RD1E, RD2E;
	logic [3:0] RA2E, RA1E;
	logic [N-1:0] ImmE;
	logic [1:0] VSIFlagE;
	logic LDFlagE;
	logic [3:0] WA3E;

	segment_id_ex seg_id_ex	(
	// Entradas
		.clk(clk),
		.reset(reset),
		.RegWriteD(RegWriteD),
		.MemtoRegD(MemtoRegD),
		.MemWriteD(MemWriteD),
		.VSIFlagD(VSIFlagD),
		.LDFlagD(LDFlagD),
		.FlagsWriteD(FlagsWriteD),
		.ALUControlD(ALUControlD),
		.WA3D(InstrD[24:21]), 			// Write address RD
		.RD1D(RD1D),						// Reg 1
		.RD2D(RD2D),						// Reg 2
		.RA1D(InstrD[20:17]),
		.RA2D(RA2D),						// Reg 2 index
		.ImmD(InstrD[16:9]),				// Immediate
		.SPWriteD(SPWriteD),
	// Salidas
		.RegWriteE(RegWriteE), 
		.MemtoRegE(MemtoRegE), 
		.MemWriteE(MemWriteE), 
		.VSIFlagE(VSIFlagE),
		.LDFlagE(LDFlagE),
		.FlagsWriteE(FlagsWriteE),
		.ALUControlE(ALUControlE), 
		.WA3E(WA3E),
		.RD1E(RD1E), 
		.RD2E(RD2E),
		.RA1E(RA1E),
		.RA2E(RA2E),
		.ImmE(ImmE),
		.SPWriteE(SPWriteE)
	);
	
	
// EXECUTE ----------------------------------------------------------------------
	
	logic [I-1:0] AddressE;
	logic [5:0][7:0] WD1E;
	
	address_offset offset_model(
		.address({RD1E[3], RD1E[2], RD1E[1], RD1E[0]}),
		.offset(ImmE),
		.A(AddressE),
	   .WD1E(WD1E)
	);

	logic [1:0] ALUFlagsE;
	logic [R-1:0][N-1:0] ALUOutputE;
	
 	alu_lanes alu_lanes (
	// Entradas
	  .clk(clk),
	  .SrcAE(RD1E),
	  .SrcBE(RD2E),
	  .SrcBiE(RA2E),
	  .ImmE(ImmE),
	  .VSIFlagE(VSIFlagE),
	  .ALUControlE(ALUControlE),
	// Salidas
	  .ALUFlagsE(ALUFlagsE),
	  .ALUOutputE(ALUOutputE)
	); 


	logic RegWriteM, MemtoRegM, FlagsWriteM;
	logic [1:0] ALUFlagsM;
	logic [R-1:0][N-1:0] ALUOutputM;
	logic [3:0] WA3M;
	logic [R-1:0][N-1:0] WD1M;
	logic [3:0] RA1M;
	logic [1:0] VSIFlagM;
	logic LDFlagM;
	logic SPWriteM;
	
	segment_ex_mem seg_ex_mem	(
	// Entradas
		.clk(clk), 
		.reset(reset), 
		.RegWriteE(RegWriteE), 
		.MemtoRegE(MemtoRegE), 
		.MemWriteE(MemWriteE), 
		.VSIFlagE(VSIFlagE),
		.LDFlagE(LDFlagE),
		.FlagsWriteE(FlagsWriteE),
		.ALUFlagsE(ALUFlagsE),
		.WA3E(WA3E),
		.AddressE(AddressE),
		.ALUOutputE(ALUOutputE),
		.WriteDataE(RD2E),
		.RA1E(RA1E),
		.WD1E(WD1E),
		.SPWriteE(SPWriteE),
	// Salidas
		.RegWriteM(RegWriteM), 
		.MemtoRegM(MemtoRegM), 
		.MemWriteM(MemWriteM), 
		.VSIFlagM(VSIFlagM),
		.LDFlagM(LDFlagM),
		.FlagsWriteM(FlagsWriteM),
		.ALUFlagsM(ALUFlagsM),
		.WA3M(WA3M),
		.AddressM(AddressM),
		.ALUOutputM(ALUOutputM),
		.WriteDataM(WriteDataM),
		.RA1M(RA1M),
		.WD1M(WD1M),
		.SPWriteM(SPWriteM)
	);

// MEMORY ----------------------------------------------------------------------

	logic MemtoRegW;
	logic [R-1:0][N-1:0] ALUOutputW, ReadDataW;

	segment_mem_wb seg_mem_wb 	(
	// Entradas
		.clk(clk), 
		.reset(reset), 
		.RegWriteM(RegWriteM), 
		.MemtoRegM(MemtoRegM), 
		.FlagsWriteM(FlagsWriteM),
		.VSIFlagM(VSIFlagM),
		.LDFlagM(LDFlagM),
		.ALUFlagsM(ALUFlagsM),
		.WA3M(WA3M),
		.ReadDataM(ReadData), 
		.ALUOutputM(ALUOutputM),
		.RA1M(RA1M),
		.WD1M(WD1M),
		.SPWriteM(SPWriteM),
	// Salidas
		.RegWriteW(RegWriteW),
		.MemtoRegW(MemtoRegW),
		.FlagsWriteW(FlagsWriteW),
		.ALUFlagsW(ALUFlagsW),
		.VSIFlagW(VSIFlagW),
		.LDFlagW(LDFlagW),
		.WA3W(WA3W),
		.ReadDataW(ReadDataW),
		.ALUOutputW(ALUOutputW),
		.RA1W(RA1W),
		.WD1W(WD1W),
		.SPWriteW(SPWriteW)
	);
	

	
// WRITE-BACK ----------------------------------------------------------------------
		
	mux2_vec res_mux(
	// Entradas
		.d0(ALUOutputW), 
		.d1(ReadDataW), 
		.s(MemtoRegW), 
	// Salidas
		.y(ResultW)
	);
	
	
endmodule