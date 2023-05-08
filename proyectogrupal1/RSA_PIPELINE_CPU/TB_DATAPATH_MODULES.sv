module TB_DATAPATH_MODULES;	
	
	parameter I = 32;
	parameter N = 8;
	parameter R = 6;
  
	// Input
	logic clk, reset, RegWrite, MemtoReg, MemWrite, FlagsWrite, RegSrc;
	logic [1:0] VSIFlag;
	logic [2:0] ALUControl;
//	logic [I-1:0] InstrF;
	logic [I-1:0] ReadData, PCNext;
	
	// Output
	logic MemWriteM, FlagsWriteW, MemtoRegM;
	logic [R-1:0][1:0] ALUFlagsW;
//	logic [I-1:0] InstrD;
	logic [N-1:0] ALUOutM, WriteDataM;	
	
	logic [1:0] tipo = 'b01;
	logic [1:0] IS = 'b11;
	logic [2:0] op = 'b000;
	logic [3:0] ra = 'd7;
	logic [3:0] rd = 'd6;
	logic [7:0] imm = 'd5;
	logic [8:0] none = 'bx;
	
// FETCH ***********************************************************************
	logic [I-1:0] InstrF = {tipo, op, IS, rd, ra, imm, none};
	logic [I-1:0] InstrD;

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
	
		
	// Execute ----------------------------------------------------------------------
	
	logic [I-1:0] A;
	
	address_offset offset_model(
		.address({RD1E[3], RD1E[2], RD1E[1], RD1E[0]}),
		.offset(ImmE),
		.A(A)
	);

	logic [R-1:0][1:0] ALUFlagsE;
	logic [R-1:0][N-1:0] ALUResultE;
	
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
	  .ALUResult(ALUResultE)
	); 

	
//	// Memoria de datos
//	data_mem data_mem(
//	// Entradas
//	.clk(clk), 
//	.WE(MemWrite), 
//	.A(A), 
//	.WD(WriteData),
//	// Salidas
//	.RD(ReadData)
//	);

	
	always begin
		clk = ~clk; #5;
	end

	initial begin
	
		reset = 1;
		#10;
		reset = 0;
		clk = 0;
		RegSrc = 1; // Seleccionar Rd
		#10;
		
		
		
		$display(" Tipo: %b\n OP: %b\n I: %b\n S: %b\n RD: %d\n RA: %d\n Imm: %d\n NULL: %b", InstrF[31:30], InstrF[29:27], InstrF[26],  InstrF[25], InstrF[24:21], InstrF[20:17], InstrF[16:9], InstrF[8:0]);

		
		$display("\n> DECODE ");
		$display(" Ra -> RD1D : %0d %0d %0d %0d %0d %0d", RD1D[5], RD1D[4], RD1D[3], RD1D[2], RD1D[1], RD1D[0]);
		$display(" Rd -> RD2D : %0d %0d %0d %0d %0d %0d", RD2D[5], RD2D[4], RD2D[3], RD2D[2], RD2D[1], RD2D[0]);
		
		
		VSIFlagE = 2'b11;
		ALUControlE = 3'b000;
		#10;
		
		
		$display("\n> EXECUTE ");
		$display(" RD1E : %0d %0d %0d %0d %0d %0d", RD1E[5], RD1E[4], RD1E[3], RD1E[2], RD1E[1], RD1E[0]);
		$display(" RD2E : %0d %0d %0d %0d %0d %0d", RD2E[5], RD2E[4], RD2E[3], RD2E[2], RD2E[1], RD2E[0]);
		$display(" RA2E : %0d", RA2E);
		$display(" ImmE : %0d", ImmE);
		
		$display(" A : %0h", A);

		$display(" ALUFlagsE: ");
		for (int i = R-1; i >= 0; i--) begin
			 $write("  %b ", ALUFlagsE[i]);
		end
		$write("\n");
		  
		$display(" ALUResultE : %0d %0d %0d %0d %0d %0d\n", ALUResultE[5], ALUResultE[4], ALUResultE[3], ALUResultE[2], ALUResultE[1], ALUResultE[0]);


		#10;
//		// save reg 1 an 2
//		WE3 = 1;
//		A3 = 6;
//		WD3 = {8'hF, 8'hE, 8'hD, 8'hC, 8'hB, 8'hA};
//		#10;
//		
//		WE3 = 1;
//		A3 = 7;
//		WD3 = {8'h5, 8'h4, 8'h3, 8'h2, 8'h1, 8'h0};
//		#10;
//	
//		A1 = 6;
//		A2 = 7;
//		#10;
//				
//		$display("rd1E : %0d %0d %0d %0d %0d %0d", rd1E[5], rd1E[4], rd1E[3], rd1E[2], rd1E[1], rd1E[0]);
//		$display("rd2E : %0d %0d %0d %0d %0d %0d", rd2E[5], rd2E[4], rd2E[3], rd2E[2], rd2E[1], rd2E[0]);
//		$display("RD2I : %d", RD2I);
//		$display("");
//		
//		// ADD
//		ALUControlE = 3'b000;
//		#10;
//		$display("- ADD %0d %0d %0d %0d %0d %0d",
//					ALUResult[5][7:0], ALUResult[4][7:0], ALUResult[3][7:0],
//					ALUResult[2][7:0], ALUResult[1][7:0], ALUResult[0][7:0]);
//
//		// SUB
//		ALUControlE = 3'b001;
//		#10;
//		$display("- SUB %0d %0d %0d %0d %0d %0d",
//					ALUResult[5][7:0], ALUResult[4][7:0], ALUResult[3][7:0],
//					ALUResult[2][7:0], ALUResult[1][7:0], ALUResult[0][7:0]);
//		
//		// MOV
//		ALUControlE = 3'b010;
//		#10;
//		$display("- MOV %0d %0d %0d %0d %0d %0d",
//					ALUResult[5][7:0], ALUResult[4][7:0], ALUResult[3][7:0],
//					ALUResult[2][7:0], ALUResult[1][7:0], ALUResult[0][7:0]);
//					
//		// MUL
//		ALUControlE = 3'b011;
//		#10;
//		$display("- MUL %0d %0d %0d %0d %0d %0d",
//					ALUResult[5][7:0], ALUResult[4][7:0], ALUResult[3][7:0],
//					ALUResult[2][7:0], ALUResult[1][7:0], ALUResult[0][7:0]);
	
	end

endmodule
