module TB_CPU;

	// Definir los tamaños de los buses de entrada y salida
	parameter I = 32;
	parameter N = 8;
	parameter R = 6;
	
	// Definir los nombres de las señales de entrada y salida
	logic clk, reset, start;
	logic [I-1:0] Instr;
	logic [R-1:0][N-1:0] ReadData;
	logic MemWriteM, EndFlag, COMFlag;
	logic [I-1:0] PC, Address;
	logic [R-1:0][N-1:0] WriteData;
	
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
	
	always begin
		clk = ~clk; #5;
	end

	
	// Definir los estímulos de entrada
	initial begin
		// Ciclo de reloj inicial
		clk = 0;
		
		// Reset inicial
		reset = 1;
		start = 0;
		#10;
		
		// Lanzar una instrucción
		reset = 0;
		start = 1;
		#10;
		$display(" Instr\t\t: %0b", Instr);
		$display(" COMFlag\t: %0b", COMFlag);
		$display(" EndFlag\t: %0b", EndFlag);
		$display(" PC\t\t: %0b", PC);
		$display(" MemWriteM\t: %0b", MemWriteM);
		$display(" Address\t: %0h", Address);
		$display(" WriteData\t: %0d %0d %0d %0d %0d %0d", WriteData[5], WriteData[4], WriteData[3], WriteData[2], WriteData[1], WriteData[0]);



		#100; $finish;
	end
	
endmodule
