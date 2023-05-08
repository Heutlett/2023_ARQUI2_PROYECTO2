module datapath_vec
#(parameter I=32, N=8, R=6)
(
	// Entradas
	input logic clk, reset, RegWrite, MemtoReg, MemWrite, FlagsWrite, RegSrc,
	input logic [1:0] VSIFlag,
	input logic [2:0] ALUControl,
	input logic [I-1:0] InstrF, ReadData, PCNext,
	
	// Salidas
	output logic MemWriteM, FlagsWriteW, MemtoRegM,
	output logic [R-1:0][1:0] ALUFlagsW,

	output logic [I-1:0] InstrD,
	output logic [N-1:0] ALUOutM, WriteDataM,
	output logic [I-1:0] A
);	

	// ***************************** Wires *****************************************
	
	
// DECODE ***********************************************************************

	// -- output
	logic [R-1:0][N-1:0] RD1D, RD2D;
	logic [3:0] RA2D;	
	
// EXECUTE **********************************************************************
	
	// -- flags
	logic RegWriteE, MemtoRegE, MemWriteE, FlagsWriteE;
	logic [2:0] ALUControlE;
	logic [1:0] VSIFlagE;

	// -- input
	logic [R-1:0][N-1:0] RD1E, RD2E;
	logic [3:0] RA2E;
	logic [N-1:0] ImmE;

	// -- output
	logic [R-1:0][1:0] ALUFlagsE;
	logic [R-1:0][N-1:0] ALUResultE;

	// -- pass
	logic [3:0] WA3E;


// MEM *************************************************************************
	
	// -- flags
	logic RegWriteM;
	logic [R-1:0][1:0] ALUFlagsM;

	// -- pass
	logic [3:0] WA3M;
	
	
// WB **************************************************************************

	// -- flags
	logic RegWriteW, MemtoRegW;

	// -- input
	logic [R-1:0][N-1:0] ReadDataW, ALUOutW;
	
	// -- output
	logic [3:0] WA3W;
	logic [R-1:0][N-1:0] ResultW;

	
	
	// ------------------------------- Etapas --------------------------------------
	
	
	// Fetch -----------------------------------------------------------------------
	
	segment_if_id seg_if_id	(
	// Entradas
		.clk(clk), 
		.reset(reset), 
		.InstrF(InstrF), 
	// Salidas
		.InstrD(InstrD)
		);
		
		

	// Decode ----------------------------------------------------------------------
	
	
	mux2 #(4) ra2mux	(
	// Entradas
		.d0(InstrD[16:13]), 
		.d1(InstrD[24:21]), 
		.s(RegSrc), 
	// Salidas
		.y(RA2D)
		);
	
	regfile reg_file (
	// Entradas
		.clk(clk), 
		.WE3(RegWriteW), 
		.A1(InstrD[20:17]), 
		.A2(RA2D),
		.A3(WA3W),
		.WD3(ResultW),
	// Salidas
		.RD1(RD1D), 
		.RD2(RD2D)
		);
	
	segment_id_ex seg_id_ex	(
	// Entradas
		.clk(clk),
		.reset(reset),
		.RegWriteD(RegWrite),
		.MemtoRegD(MemtoReg),
		.MemWriteD(MemWrite),
		.VSIFlagD(VSIFlag),
		.FlagsWriteD(FlagsWrite),
		.ALUControlD(ALUControl),
		.WA3D(InstrD[25:22]), 			// Write address
		.rd1D(RD1D),						// Reg 1
		.rd2D(RD2D),						// Reg 2
		.RA2D(RA2D),						// Reg 2 index
		.ImmD(InstrD[16:9]),				// Immediate
	// Salidas
		.RegWriteE(RegWriteE), 
		.MemtoRegE(MemtoRegE), 
		.MemWriteE(MemWriteE), 
		.VSIFlagE(VSIFlagE), 
		.FlagsWriteE(FlagsWriteE),
		.ALUControlE(ALUControlE), 
		.WA3E(WA3E),
		.rd1E(RD1E), 
		.rd2E(RD2E),
		.RA2E(RA2E),
		.ImmE(ImmE)
		);
	
	
	// Execute ------------------------------------------------------------------------------

	alu_lanes alu (
	// Entradas
	  .clk(clk),
	  .SrcAE(RD1E),
	  .SrcBE(RD2E),
	  .SrcBiE(RA2E),
	  .Imm(ImmE),
	  .VSIFlag(VSIFlagE),
	  .ALUControl(ALUControlE),
	// Salidas
	  .ALUFlags(ALUFlagsE),
	  .ALUResult(ALUResultE)
	);
	
	
	// CALC ADDRESS
		address_offset offset_module(
			.address({RD1E[3], RD1E[2], RD1E[1], RD1E[0]}),
			.offset(ImmE),
			.A(A)
		);
	
	
//	segment_ex_mem seg_ex_mem	(
//	// Entradas
//		.clk(clk), 
//		.reset(reset), 
//		.RegWriteE(RegWriteE), 
//		.MemtoRegE(MemtoRegE), 
//		.MemWriteE(MemWriteE), 
//		.FlagsWriteE(FlagsWriteE),
//		.ALUFlagsE(ALUFlagsE),
//		.WA3E(WA3E), 
//		.ALUResultE(ALUResultE), 
//		.WriteDataE(rd2E),
//	// Salidas
//		.RegWriteM(RegWriteM), 
//		.MemtoRegM(MemtoRegM), 
//		.MemWriteM(MemWriteM), 
//		.FlagsWriteM(FlagsWriteM),
//		.ALUFlagsM(ALUFlagsM),
//		.WA3M(WA3M), 
//		.ALUOutM(ALUOutM),
//		.WriteDataM(WriteDataM)
//	);
	
	
//		
//	// MEM -----------------------------------------------------------------
//	
//	segment_mem_wb seg_mem_wb 	(
//										// Entradas
//										.clk(clk), 
//										.reset(reset), 
//										.RegWriteM(RegWriteM), 
//										.MemtoRegM(MemtoRegM), 
//										.FlagsWriteM(FlagsWriteM),
//										.ALUFlagsM(ALUFlagsM),
//										.WA3M(WA3M), 
//										.ReadDataM(ReadData), 
//										.ALUOutM(ALUOutM),
//										// Salidas
//										.RegWriteW(RegWriteW), 
//										.MemtoRegW(MemtoRegW), 
//										.FlagsWriteW(FlagsWriteW),
//										.ALUFlagsW(ALUFlagsW),
//										.WA3W(WA3W), 
//										.ReadDataW(ReadDataW), 
//										.ALUOutW(ALUOutW)
//										);
//								
//	// WB --------------------------------------------------------------------
//					
//	mux2 #(32) resmux(
//							// Entradas
//							.d0(ALUOutW), 
//							.d1(ReadDataW), 
//							.s(MemtoRegW), 
//							// Salidas
//							.y(Result)
//							);
	
endmodule