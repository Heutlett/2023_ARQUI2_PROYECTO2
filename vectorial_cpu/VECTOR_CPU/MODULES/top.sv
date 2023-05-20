module top
#(parameter I=32, N=8, R=6)
(
	// Entradas
	input logic clk,
	
//	input logic clk_FPGA, 
	input logic reset,
	input logic start,
	
	// Salidas
//	output logic clk_out,
	output logic EndFlag,
//	output logic [7:0] ReadDataOut

	// VGA outputs
	output clk_vga,
	output hsync_out,
	output vsync_out,
	output [7:0] o_red,
	output [7:0] o_blue,
	output [7:0] o_green
	
);
	
	
//	logic clk; // Es el actual clock del sistema, despues de pasar por el clock manager
	logic [I-1:0] Instr; // Sale de la memoria de instrucciones
	logic [R-1:0][N-1:0] ReadData; // Sale de la memoria de datos
	logic MemWriteM;	// En 1 al escribir en memoria
	logic COMFlag;	// En 1 al recibir la instrucciones respectiva
	logic [I-1:0] PC, Address; // PC para acceder a la memoria de instrucciones, sale del CPU
	logic [R-1:0][N-1:0] WriteData; // Sale del CPU y es el dato a escribir en la memoria de datos
	
// CLOCK SELECTOR
//	clock_manager cm (
//		.clk_FPGA(clk_FPGA),
//		.COMFlag(COMFlag),
//		.clk(clk)
//	);

	VGA display(
		.clk_fpga(clk),
		.clk_out(clk_vga),
		.hsync_out(hsync_out),
		.vsync_out(vsync_out),
		.o_red(o_red),
		.o_blue(o_blue),
		.o_green(o_green)
//		.tex(tex)
	);
	
	
	// Instanciar el módulo CPU
	cpu cpu (
	
		// Entradas
		.clk(clk),
		.reset(reset),
		.start(start),
		.Instr(Instr),
		.ReadData(ReadData),
		// Salidas
		.MemWriteM(MemWriteM),
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
		.WE(MemWriteM), 
		.A(Address), 
		.WD(WriteData),
		// Salidas
		.RD(ReadData)
	);
	
//	// Modulo para comuncacion con interprete
//	interpreter_comunication ic (
//		// Entradas
//		.clk(clk), 
//		.reset(reset), 
//		.MemtoReg(MemtoReg),
//		.COM(COMFlag),
//		.ReadData(ReadData),
//		// Salidas
//		.clk_out(clk_out),
//		.ReadDataOut(ReadDataOut)
//	);

	
endmodule