module arm // Unidades de control y datapath
(
	input logic clk, reset, start,
	output logic [31:0] PC,
	input logic [31:0] Instr,
	output logic MemWrite,
	output logic [31:0] ALUResult, WriteData,
	input logic [31:0] ReadData,
	output logic FlagZero
);

	
	
	// Control_unit
	logic [1:0] RegSrc, ImmSrc;
	logic [2:0] ALUControl;
	logic RegW, MemtoReg, ALUSrc, Branch, MemWriteD, FlagsWriteD;
	
	
	// Datapath
	logic [31:0] InstrD;
	logic [3:0] ALUFlagsW;
	logic FlagsWriteW;
	
	
	pc_control_unit pcu(
					// Entradas
					.clk(clk), 
					.reset(reset),
					.start(start),
					.Branch(Instr[27:26]), 
					.FlagsWrite(FlagsWriteW),
					.Cond(Instr[31:28]), 
					.ALUFlags(ALUFlagsW),
					.Imm(Instr[23:0]),
					// Salidas
					.PCNext(PC),
					.FlagZero(FlagZero)
					

	);
	
	control_unit c(
					// Entradas
					InstrD[27:26], InstrD[25:20],
					// Salidas
					RegW, MemtoReg, 
					MemWriteD, ALUControl, ALUSrc, 
					ImmSrc, RegSrc, FlagsWriteD);
					
					
	datapath dp(
					.clk(clk), 
					.reset(reset),
					.RegSrc(RegSrc),
					.RegWrite(RegW),
					.ImmSrc(ImmSrc),
					.ALUSrc(ALUSrc),
					.ALUControl(ALUControl),
					.MemtoReg(MemtoReg), 
					.MemWrite(MemWriteD), 
					.FlagsWriteD(FlagsWriteD), 
					.InstrF(Instr),
					.ALUOutM(ALUResult), 
					.WriteDataM(WriteData),
					.ReadData(ReadData),
					.InstrD(InstrD),
					.MemWriteM(MemWrite), 
					.FlagsWriteW(FlagsWriteW), 
					.ALUFlagsW(ALUFlagsW),
					.PCNext(PC)
					);
	
endmodule