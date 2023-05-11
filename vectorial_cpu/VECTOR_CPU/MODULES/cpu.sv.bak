module vector_processor // Unidades de control y ruta de datos
#(parameter I=32, N=8, R=6)
(
	// Entradas
	input logic clk, reset, start,
	input logic [31:0] Instr,
	input logic [R-1:0][N-1:0] ReadData,
	
	// Salidas
	output logic MemWrite, MemtoReg, EndFlag, COMFlag,
	output logic [I-1:0] PC,
	
	//  -- Data memory
	output logic [I-1:0] Address,
	output logic [R-1:0][N-1:0] WriteData
	
);


	logic [1:0] ALUFlags;

	// PC Control
	pc_control_unit pcu(
		// Entradas
		.clk(clk), 
		.reset(reset),
		.start(start),
		.FlagsW(FlagsWriteW),
		.Id(Instr[31:28]), 
		.ALUFlags(ALUFlags),
		.Imm(Instr[16:9]),
		
		// Salidas
		.EndFlag(EndFlag),
		.COMFlag(COMFlag),
		.PCNext(PC)
	);
	
	
	// Flags Control
	logic [I-1:0] InstrD;
	logic RegWrite, FlagsWrite, RegSrc;
	logic [1:0] VSIFlag;
	logic [2:0] ALUControl;
		
	control_unit cn (
		// Entradas
		.Id(InstrD[31:26]),
		
		// Salidas
		.RegWrite(RegWrite),
		.MemtoReg(MemtoReg),
		.MemWrite(MemWrite),
		.FlagsWrite(FlagsWrite),
		.RegSrc(RegSrc),
		.VSIFlag(VSIFlag),
		.ALUControl(ALUControl)
	);

	

	// Datapath
	logic FlagsWriteW;
		
	datapath_vec dp (
		// Entradas
		.clk(clk),
		.reset(reset),
		.RegWrite(RegWrite),
		.MemtoReg(MemtoReg),
		.MemWrite(MemWrite),
		.FlagsWrite(FlagsWrite),
		.RegSrc(RegSrc),
		.VSIFlag(VSIFlag),
		.ALUControl(ALUControl),
		.InstrF(Instr),
		.ReadData(ReadData),
		
		// Salidas
		.MemWriteM(MemWrite),
		.FlagsWriteW(FlagsWrite),
		.MemtoRegM(MemtoReg),
		.ALUFlagsW(ALUFlags),
		.InstrD(InstrD),
		.AM(Address),
		.WriteDataM(WriteData)
	);


endmodule