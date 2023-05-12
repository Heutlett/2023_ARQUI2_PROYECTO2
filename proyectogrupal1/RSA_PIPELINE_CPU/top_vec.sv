module top_vec
(
	// Entradas
	
	input logic clk,
//	input logic clk_FPGA, 
	input logic reset,
	input logic start,
	
	// Salidas
//	output logic clk_out,
	output logic EndFlag
);
	
//	logic clk;
	logic COMFlag;

//	// CLOCK SELECTOR
//	clock_manager cm (
//		.clk_FPGA(clk_FPGA),
//		.COMFlag(COMFlag),
//		.clk(clk)
//	);
	
	
	logic [31:0] PC, Instr;
	logic MemWrite;
	logic MemtoReg;
	logic [31:0] Address;
	logic [5:0][7:0] WriteData;
	logic [5:0][7:0] ReadData;

	
	// CPU
	vector_processor vp (
		 // Entradas
		 .clk(clk),
		 .reset(reset),
		 .start(start),
		 .Instr(Instr),
		 .ReadData(ReadData),

		 // Salidas
		 .MemWrite(MemWrite),
		 .MemtoReg(MemtoReg),
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
	data_mem_vect data_mem(
		// Entradas
		.clk(clk), 
		.WE(MemWrite), 
		.A(Address), 
		.WD(WriteData),
		// Salidas
		.RD(ReadData)
	);
	

	
endmodule