package top_params;
	localparam int IMEM_SIZE = 500;
	localparam int DMEM_SIZE = 10930;
endpackage

module top
#(parameter I=32, N=8, R=6)
(
	// Entradas
	input logic clk_50,
	input logic reset, start, pause,
	input logic [1:0] select,
	
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
	
// Importar el paquete de parámetros
	import top_params::*;
	
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
	
	logic clk;

	vga_pll clock_pll (
		.areset(1'b0),
		.inclk0(clk_50),
		.c0(clk),
		.locked()
	);

	logic [5:0][7:0] vram;
	logic [16:0] a_vga;

	VGA display(
		.clk_fpga(clk),
		.clk_out(clk_vga),
		.hsync_out(hsync_out),
		.vsync_out(vsync_out),
		.o_red(o_red),
		.o_blue(o_blue),
		.o_green(o_green),
		.vram_i(vram),
		.a_vga(a_vga)
	);
	
	
	// Instanciar el módulo CPU
	cpu cpu (
	
		// Entradas
		.clk(clk),
		.reset(reset),
		.start(start),
		.pause(pause),
		.select(select),
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
	instr_mem #(IMEM_SIZE) instr_mem(
		// Entradas
		.A(PC),
		
		// Salidas
		.RD(Instr)
	);
	
	
	// DATA MEMORY
	data_ram data_mem(
		// Entradas
		.clk(clk), 
		.WE(MemWriteM), 
		.A(Address), 
		.A_VGA(a_vga),
		.WD(WriteData),
		// Salidas
		.RD(ReadData),
		.vram_o(vram)
	);

	
endmodule
