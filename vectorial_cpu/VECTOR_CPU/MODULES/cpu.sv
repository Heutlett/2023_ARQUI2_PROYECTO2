module cpu // Unidades de control y ruta de datos
#(parameter I=32, N=8, R=6)
(
	// Entradas
	input logic clk, reset, start, pause,
	input logic [1:0] select,
	input logic [31:0] Instr,
	input logic [R-1:0][N-1:0] ReadData,
	
	// Salidas
	output logic MemWriteM, EndFlag, COMFlag,
	output logic [I-1:0] PC,
	
	//  -- Data memory
	output logic [I-1:0] Address,
	output logic [R-1:0][N-1:0] WriteData
);

	logic FlagsWriteW;
	logic [1:0] ALUFlagsW;

	// PC Control
	pc_control_unit pcu(
		// Entradas
		.clk(clk),
		.reset(reset),
		.start(start),
		.pause(pause),
		.select(select),
		.FlagsWrite(FlagsWriteW),
		.Id(Instr[31:28]),
		.ALUFlags(ALUFlagsW),
		.Address(Instr[27:0]),
		.Imm(Instr[27:26]),
		// Salidas
		.EndFlag(EndFlag),
		.COMFlag(COMFlag),
		.PCNext(PC)
	);
	
	
	// Flags Control
	logic [I-1:0] InstrD;
	logic RegWriteD, SPWriteD, MemtoRegD, MemWriteD, FlagsWriteD, RegSrcD;
	logic [1:0] VSIFlagD;
	logic LDSFlagD;
	logic [2:0] ALUControlD;
		
	control_unit cn (
		// Entradas
		.Id(InstrD[31:25]),
		
		// Salidas
		.RegWrite(RegWriteD),
		.SPWrite(SPWriteD),
		.MemtoReg(MemtoRegD),
		.MemWrite(MemWriteD),
		.FlagsWrite(FlagsWriteD),
		.RegSrc(RegSrcD),
		.VSIFlag(VSIFlagD),
		.LDSFlag(LDSFlagD),
		.ALUControl(ALUControlD)
	);


	
	// Datapath		
	datapath dp (
		// Entradas
		.clk(clk),
		.reset(reset),
		.RegWriteD(RegWriteD),
		.SPWriteD(SPWriteD),
		.MemtoRegD(MemtoRegD),
		.MemWriteD(MemWriteD),
		.FlagsWriteD(FlagsWriteD),
		.RegSrcD(RegSrcD),
		.VSIFlagD(VSIFlagD),
		.LDSFlagD(LDSFlagD),
		.ALUControlD(ALUControlD),
		.InstrF(Instr),
		.ReadData(ReadData),
		
		// Salidas
		.MemWriteM(MemWriteM),
		.FlagsWriteW(FlagsWriteW),
		.ALUFlagsW(ALUFlagsW),
		.InstrD(InstrD),
		.AddressM(Address),
		.WriteDataM(WriteData)
	);

endmodule