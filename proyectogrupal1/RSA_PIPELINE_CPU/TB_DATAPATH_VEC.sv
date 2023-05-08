module TB_DATAPATH_VEC;

  // Parámetros
  parameter I = 32;
  parameter N = 8;

  // Señales de entrada
  logic clk;
  logic reset;
  logic RegWrite;
  logic [1:0] VSIFlag;
  logic MemtoReg;
  logic MemWrite;
  logic FlagsWrite;
  logic RegSrc;
  logic [2:0] ALUControl;
  logic [I-1:0] InstrF;
  logic [I-1:0] ReadData;
  logic [I-1:0] PCNext;

  // Señales de salida
  logic MemWriteM;
  logic FlagsWriteW;
  logic MemtoRegM;
  logic [5:0][1:0] ALUFlagsW;
  logic [I-1:0] InstrD;
  logic [N-1:0] ALUOutM;
  logic [N-1:0] WriteDataM;
  logic [I-1:0] A;


	// Diseño bajo prueba
	datapath_vec datapath (
		.clk(clk),
		.reset(reset),
		.RegWrite(RegWrite),
		.VSIFlag(VSIFlag),
		.MemtoReg(MemtoReg),
		.MemWrite(MemWrite),
		.FlagsWrite(FlagsWrite),
		.RegSrc(RegSrc),
		.ALUControl(ALUControl),
		.InstrF(InstrF),
		.ReadData(ReadData),
		.PCNext(PCNext),
		.MemWriteM(MemWriteM),
		.FlagsWriteW(FlagsWriteW),
		.MemtoRegM(MemtoRegM),
		.ALUFlagsW(ALUFlagsW),
		.InstrD(InstrD),
		.ALUOutM(ALUOutM),
		.WriteDataM(WriteDataM),
		.A(A)
	);

	// Genera un clock de prueba
	 always begin
	  clk = ~clk; #5;
	 end
	

	// Establece valores para las señales de entrada
	initial begin
		clk = 0;
		#10;
		reset = 1;
		RegWrite = 0;
		VSIFlag = 'b00;
		MemtoReg = 0;
		MemWrite = 0;
		FlagsWrite = 0;
		RegSrc = 0;
		ALUControl = 0;
		InstrF = '0;
		ReadData = '0;
		PCNext = '0;
		#10 reset = 0;
		#10 InstrF = 'b01000110000000000000000000000000; // Ejemplo de valor para la instrucción
		#100 $finish; // Termina la simulación después de 100 unidades de tiempo
	end

	// Imprime los valores de las señales de salida
	always @(posedge clk) begin
		$display("A = %h", A);
//		$display("MemWriteM=%b, FlagsWriteW=%b, MemtoRegM=%b, ALUFlagsW=%b, InstrD=%d, ALUOutM=%h, WriteDataM=%h", MemWriteM, FlagsWriteW, MemtoRegM, ALUFlagsW, InstrD, ALUOutM, WriteDataM);
	end

endmodule
