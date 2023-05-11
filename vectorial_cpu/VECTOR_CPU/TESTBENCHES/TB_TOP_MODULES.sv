module TB_TOP_MODULES();

	// Entradas
	
	logic clk;
	logic reset;
	logic start;
	
	// Salidas
	logic EndFlag;
	
	
	
	// Body
	logic COMFlag;
	
	logic [31:0] PC, Instr;
	logic MemWrite;
	logic [31:0] Address;
	logic [5:0][7:0] WriteData;
	logic [5:0][7:0] ReadData;

	
	// CPU
	cpu cpu (
		 // Entradas
		 .clk(clk),
		 .reset(reset),
		 .start(start),
		 .Instr(Instr),
		 .ReadData(ReadData),

		 // Salidas
		 .MemWriteM(MemWrite),
		 .EndFlag(EndFlag),
		 .COMFlag(COMFlag),
		 .PC(PC),
		 .Address(Address),
		 .WriteData(WriteData)
	);

			
	// INSTRUCTIONS MEMORY
	instr_mem instr_mem(
		// Entradas
		.A(PC),
		
		// Salidas
		.RD(Instr)
	);


	// DATA MEMORY
	data_mem data_mem(
		// Entradas
		.clk(clk), 
		.WE(MemWrite), 
		.A(Address), 
		.WD(WriteData),
		// Salidas
		.RD(ReadData)
	);


endmodule