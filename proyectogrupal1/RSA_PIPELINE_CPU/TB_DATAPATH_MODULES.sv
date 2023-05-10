module TB_DATAPATH_MODULES;	
	
	parameter I = 32;
	parameter N = 8;
	parameter R = 6;
  
	// Input
	logic clk, reset, RegWrite, MemtoReg, MemWrite, FlagsWrite, RegSrc;
	logic [1:0] VSIFlag;
	logic [2:0] ALUControl;
//	logic [I-1:0] InstrF;
	logic [I-1:0] PCNext;
	logic [R-1:0][N-1:0] ReadData;
	// Output
	logic MemWriteM, FlagsWriteW, MemtoRegM;
	logic [R-1:0][1:0] ALUFlagsW;
//	logic [I-1:0] InstrD;
	logic [R-1:0][N-1:0] WriteDataM;
	logic [R-1:0][N-1:0] ALUOutputM;
	
	
//// Data register-immediate
//	logic [1:0] tipo = 'b01;
//	logic [1:0] IS = 'b11;
//	logic [2:0] op = 'b000;
//	logic [3:0] ra = 'd7;
//	logic [3:0] rd = 'd6;
//	logic [7:0] imm = 'd5;
//	logic [8:0] none = 'bx;
	
//	// MEM LD
//	logic [1:0] tipo = 'b10;
//	logic op = 'b0;
//	logic [3:0] null1 = 'b0000;
//	logic [3:0] rd = 'd6;
//	logic [3:0] ra = 'd0;
//	logic [7:0] imm = 'd0;
//	logic [8:0] none = 'b0;
	
	// MEM STR
	logic [1:0] tipo = 'b10;
	logic op = 'b1;
	logic [3:0] null1 = 'b0000;
	logic [3:0] rd = 'd0;
	logic [3:0] ra = 'd0;
	logic [7:0] imm = 'd0;
	logic [8:0] none = 'b0;
	
	// para poder hacer testing con las instrucciones.
	// cuando se quita esto, se descomenta InstrF y InstrD del las entradas.
	// logic [I-1:0] InstrF = {tipo, op, IS, rd, ra, imm, none};
	logic [I-1:0] InstrF = {tipo, op, null1, rd, ra, imm, none};
	logic [I-1:0] InstrD;
	
	
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

	control_unit c(
	// Entradas
		.Id(InstrD[31:25]),
	// Salidas
		.RegWrite(RegWrite), 
		.MemtoReg(MemtoReg),
		.MemWrite(MemWrite),
		.ALUControl(ALUControl),
		.VSIFlag(VSIFlag),
		.FlagsWrite(FlagsWrite),
		.RegSrc(RegSrc)
	);
	
	
	logic [3:0] RA2D;	

	mux2 #(4) ra2mux	(
	// Entradas
		.d0(InstrD[16:13]), 
		.d1(InstrD[24:21]), 
		.s(RegSrc), 
	// Salidas
		.y(RA2D)
		);
	
	
	logic [3:0] WA3W;   				// Se recibe de la etapa Write-back
	logic [R-1:0][N-1:0] ResultW;	// Se recibe de la etapa Write-back
	logic RegWriteW;					// Se recibe de la etapa Write-back
	logic [R-1:0][N-1:0] RD1D, RD2D;

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
		
		
	logic RegWriteE, MemtoRegE, MemWriteE, FlagsWriteE;
	logic [2:0] ALUControlE;
	logic [1:0] VSIFlagE;

	logic [R-1:0][N-1:0] RD1E, RD2E;
	logic [3:0] RA2E;
	logic [N-1:0] ImmE;

	logic [3:0] WA3E;
	
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
		.WA3D(InstrD[24:21]), 			// Write address RD
		.RD1D(RD1D),						// Reg 1
		.RD2D(RD2D),						// Reg 2
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
		.RD1E(RD1E), 
		.RD2E(RD2E),
		.RA2E(RA2E),
		.ImmE(ImmE)
		);
	
		
	// Execute ----------------------------------------------------------------------
	
	logic [I-1:0] AE;
	
	address_offset offset_model(
		.address({RD1E[3], RD1E[2], RD1E[1], RD1E[0]}),
		.offset(ImmE),
		.A(AE)
	);

	logic [R-1:0][1:0] ALUFlagsE;
	logic [R-1:0][N-1:0] ALUOutputE;
	
 	alu_lanes alu_lanes (
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
	  .ALUOutput(ALUOutputE)
	); 


	logic RegWriteM, FlagsWriteM;
	logic [R-1:0][1:0] ALUFlagsM;
	logic [3:0] WA3M;
	logic [I-1:0] AM;
	

	segment_ex_mem seg_ex_mem	(
	// Entradas
		.clk(clk), 
		.reset(reset), 
		.RegWriteE(RegWriteE), 
		.MemtoRegE(MemtoRegE), 
		.MemWriteE(MemWriteE), 
		.FlagsWriteE(FlagsWriteE),
		.ALUFlagsE(ALUFlagsE),
		.WA3E(WA3E),
		.AE(AE),
		.ALUOutputE(ALUOutputE),
		.WriteDataE(RD2E),
	// Salidas
		.RegWriteM(RegWriteM), 
		.MemtoRegM(MemtoRegM), 
		.MemWriteM(MemWriteM), 
		.FlagsWriteM(FlagsWriteM),
		.ALUFlagsM(ALUFlagsM),
		.WA3M(WA3M),
		.AM(AM),
		.ALUOutputM(ALUOutputM),
		.WriteDataM(WriteDataM)
	);
	
	
	// Memoria de datos
	data_mem_vect data_mem_vect(
	// Entradas
	.clk(clk), 
	.WE(MemWriteM), 
	.A(AM), 
	.WD(WriteDataM),
	// Salidas
	.RD(ReadData)
	);

	
	logic MemtoRegW;
	logic [R-1:0][N-1:0] ALUOutputW, ReadDataW;

	segment_mem_wb seg_mem_wb 	(
	// Entradas
		.clk(clk), 
		.reset(reset), 
		.RegWriteM(RegWriteM), 
		.MemtoRegM(MemtoRegM), 
		.FlagsWriteM(FlagsWriteM),
		.ALUFlagsM(ALUFlagsM),
		.WA3M(WA3M),
		.ReadDataM(ReadData), 
		.ALUOutputM(ALUOutputM),
	// Salidas
		.RegWriteW(RegWriteW),
		.MemtoRegW(MemtoRegW),
		.FlagsWriteW(FlagsWriteW),
		.ALUFlagsW(ALUFlagsW),
		.WA3W(WA3W),
		.ReadDataW(ReadDataW),
		.ALUOutputW(ALUOutputW)
	);
	
		
	mux2_vec res_mux(
	// Entradas
		.d0(ALUOutputW), 
		.d1(ReadDataW), 
		.s(MemtoRegW), 
	// Salidas
		.y(ResultW)
	);
	
	
	always begin
		clk = ~clk; #5;
	end

	initial begin
	
		reset = 1;
		#10;
		reset = 0;
		clk = 0;
	
		$display("\n> Fetch ");

//		$display("[ Data register-register ]");
//		$display("  Type [31:30] : %b", InstrF[31:30]);
//		$display("  OP   [29:27] : %b", InstrF[29:27]);
//		$display("  IS   [26:25] : %b", InstrF[26:25]);
//		$display("  RD   [24:21] : %b", InstrF[24:21]);
//		$display("  RA   [20:17] : %b", InstrF[20:17]);
//		$display("  RB   [16:13] : %b", InstrF[16:13]);
//		$display("  NULL [12: 0] : %b", InstrF[12:0]);
		
		$display("[ Data register-immediate ]");
		$display("  Type [31:30] : %b", InstrF[31:30]);
		$display("  OP   [29:27] : %b", InstrF[29:27]);
		$display("  IS   [26:25] : %b", InstrF[26:25]);
		$display("  RD   [24:21] : %b", InstrF[24:21]);
		$display("  RA   [20:17] : %b", InstrF[20:17]);
		$display("  Imm  [16: 9] : %b", InstrF[16:9]);
		$display("  NULL [ 8: 0] : %b", InstrF[8:0]);
//
//		$display("[ Data memory ]");
//		$display("  Type [31:30] : %b", InstrF[31:30]);
//		$display("  OP   [29:28] : %b", InstrF[29:28]);
//		$display("  NULL [27:25] : %b", InstrF[27:25]);
//		$display("  RD   [24:21] : %b", InstrF[24:21]);
//		$display("  RA   [20:17] : %b", InstrF[20:17]);
//		$display("  Imm  [16: 9] : %b", InstrF[16:9]);
//		$display("  NULL [ 8: 0] : %b", InstrF[8:0]);
//		
//		$display("[ Control ]");
//		$display("  Type [31:30] : %b", InstrF[31:30]);
//		$display("  OP   [29:28] : %b", InstrF[29:28]);
//		$display("  NULL [27:25] : %b", InstrF[27:25]);
//		$display("  NULL [24:17] : %b", InstrF[24:17]);
//		$display("  Imm  [16: 9] : %b", InstrF[16:9]);
//		$display("  NULL [ 8: 0] : %b", InstrF[8:0]);
		
		#10; // Clock para el registro pipeline
		
		$display("\n\n> DECODE ");
		
		$display("\n--- flags");
		$display(" RegWriteD   	: %0b", RegWrite);
		$display(" MemtoRegD   	: %0b", MemtoReg);
		$display(" MemWriteD   	: %0b", MemWrite);
		$display(" ALUControlD 	: %0b", ALUControl);
		$display(" VSIFlagD    	: %0b", VSIFlag);
		$display(" FlagsWriteD 	: %0b", FlagsWrite);
		$display(" RegSrcD 	 	: %0b", RegSrc);
		
		$display("\n--- data");
		$display(" RD   : %0d", InstrD[24:21]);
		$display(" RA   : %0d", InstrD[20:17]);
		if (VSIFlag[1] == 1'b1) $display(" Imm  : %0d", InstrD[16:9]); 
		else $display(" RB   : %0d", InstrD[16:13]);
		
		$display(" RA2D : %0d %0d %0d %0d", RA2D[3], RA2D[2], RA2D[1], RA2D[0]);
		$display(" RD1D : %0d %0d %0d %0d %0d %0d", RD1D[5], RD1D[4], RD1D[3], RD1D[2], RD1D[1], RD1D[0]);
		$display(" RD2D : %0d %0d %0d %0d %0d %0d", RD2D[5], RD2D[4], RD2D[3], RD2D[2], RD2D[1], RD2D[0]);
		
		
		#10; // Clock para el registro pipeline

		
		$display("\n\n> EXECUTE ");
		
		$display("\n--- flags");
		$display(" RegWriteE   : %0b", RegWriteE);
		$display(" MemtoRegE   : %0b", MemtoRegE);
		$display(" MemWriteE   : %0b", MemWriteE);
		$display(" ALUControlE : %0b", ALUControlE);
		$display(" VSIFlagE    : %0b", VSIFlagE);
		$display(" FlagsWriteE : %0b", FlagsWriteE);
		
		$display("\n--- data");
		$display(" RD1E : %0d %0d %0d %0d %0d %0d", RD1E[5], RD1E[4], RD1E[3], RD1E[2], RD1E[1], RD1E[0]);
		$display(" RD2E : %0d %0d %0d %0d %0d %0d", RD2E[5], RD2E[4], RD2E[3], RD2E[2], RD2E[1], RD2E[0]);
		$display(" RA2E : %0d", RA2E);
		$display(" ImmE : %0d", ImmE);

		$display(" ALUFlagsE : %0b %0b %0b %0b %0b %0b", ALUFlagsE[5], ALUFlagsE[4], ALUFlagsE[3], ALUFlagsE[2], ALUFlagsE[1], ALUFlagsE[0]);
		$display(" ALUOutputE : %0d %0d %0d %0d %0d %0d", ALUOutputE[5], ALUOutputE[4], ALUOutputE[3], ALUOutputE[2], ALUOutputE[1], ALUOutputE[0]);
		$display(" AE : %0h", AE);
		$display(" WriteDataE : %0d %0d %0d %0d %0d %0d", RD2E[5], RD2E[4], RD2E[3], RD2E[2], RD2E[1], RD2E[0]);
		$display(" WA3E : %0d", WA3E);
	
		#10;
		
		$display("\n\n> MEM ");
		
		$display("\n--- flags");
		$display(" RegWriteM : %0b", RegWriteM);
		$display(" MemtoRegM : %0b", MemtoRegM);
		$display(" MemWriteM : %0b", MemWriteM);
		$display(" FlagsWriteM : %0b", FlagsWriteM);
		$display(" ALUFlagsM : %0b %0b %0b %0b %0b %0b", ALUFlagsM[5], ALUFlagsM[4], ALUFlagsM[3], ALUFlagsM[2], ALUFlagsM[1], ALUFlagsM[0]);
		
		$display("\n--- data");
		$display(" ALUOutputM : %0d %0d %0d %0d %0d %0d", ALUOutputM[5], ALUOutputM[4], ALUOutputM[3], ALUOutputM[2], ALUOutputM[1], ALUOutputM[0]);
		$display(" AM : %0h", AM);
		$display(" WriteDataM : %0d %0d %0d %0d %0d %0d", WriteDataM[5], WriteDataM[4], WriteDataM[3], WriteDataM[2], WriteDataM[1], WriteDataM[0]);
		$display(" WA3M : %0d", WA3M);
		
		#10;
		
		$display("\n\n> WB ");
		
		$display("\n--- flags");
		$display(" RegWriteW : %0b", RegWriteW);
		$display(" MemtoRegW : %0b", MemtoRegW);
		$display(" FlagsWriteW : %0b", FlagsWriteW);
		$display(" ALUFlagsW : %0b %0b %0b %0b %0b %0b", ALUFlagsW[5], ALUFlagsW[4], ALUFlagsW[3], ALUFlagsW[2], ALUFlagsW[1], ALUFlagsW[0]);

		
		$display("\n--- data");
		$display(" ReadDataW : %0d %0d %0d %0d %0d %0d", ReadDataW[5], ReadDataW[4], ReadDataW[3], ReadDataW[2], ReadDataW[1], ReadDataW[0]);
		$display(" ALUOutputW : %0d %0d %0d %0d %0d %0d", ALUOutputW[5], ALUOutputW[4], ALUOutputW[3], ALUOutputW[2], ALUOutputW[1], ALUOutputW[0]);
		$display(" WAW : %0d", WA3W);
		
		#10;
		$display(" ResultW : %0d %0d %0d %0d %0d %0d", ResultW[5], ResultW[4], ResultW[3], ResultW[2], ResultW[1], ResultW[0]);
		$display("\n\n\n --- FIN --- ");
		#20 $finish;
		
	end

endmodule
