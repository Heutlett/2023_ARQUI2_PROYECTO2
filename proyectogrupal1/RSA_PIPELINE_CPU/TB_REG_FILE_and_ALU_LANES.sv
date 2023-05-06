module TB_REG_FILE_and_ALU_LANES;	
	
	
// REG FILE
	
	logic clk;
	logic [3:0] A1, A2, A3;
	logic [5:0][7:0] WD3;
	logic WE3;
	logic [3:0] RD2I;
	
	// salidas
	logic [5:0][7:0] rd1D, rd2D;
	
	regfile reg_file (
		.clk(clk),
		.WE3(WE3),
		.A1(A1),
		.A2(A2),
		.A3(A3),
		.WD3(WD3),
		.RD1(rd1D),
		.RD2(rd2D),
		.RD2I(RD2I)
	);
	
	
	// entrada
	logic reset, RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, FlagsWriteD;
	logic [2:0] ALUControlD;
	logic [3:0] WA3D;
	logic [7:0] ExtImmD;

	// salida
	logic RegWriteE, MemtoRegE, MemWriteE, ALUSrcE, FlagsWriteE;
	logic [2:0] ALUControlE; 
	logic [3:0] WA3E;
	logic [7:0] ExtImmE;
	logic [5:0][7:0] rd1E, rd2E;
	
// PIPELINE	
	segment_id_ex segment_id_ex_inst (
		.clk(clk),
		.reset(reset),
		.RegWriteD(RegWriteD),
		.MemtoRegD(MemtoRegD),
		.MemWriteD(MemWriteD),
		.ALUSrcD(ALUSrcD),
		.FlagsWriteD(FlagsWriteD),
		.ALUControlD(ALUControlD),
		.WA3D(WA3D),
		.rd1D(rd1D),
		.rd2D(rd2D),
		.ExtImmD(ExtImmD),
		.RegWriteE(RegWriteE),
		.MemtoRegE(MemtoRegE),
		.MemWriteE(MemWriteE),
		.ALUSrcE(ALUSrcE),
		.FlagsWriteE(FlagsWriteE),
		.ALUControlE(ALUControlE),
		.WA3E(WA3E),
		.rd1E(rd1E),
		.rd2E(rd2E),
		.ExtImmE(ExtImmE)
	);
	
	
// ALU LANES
	 
	 // salida
    logic [1:0][5:0] ALUFlags;
    logic [5:0][7:0] vector;
    
    alu_lanes alu (
        .clk(clk),
        .SrcAE(rd1E),
        .SrcBE(rd2E),
        .ALUControl(ALUControlE),
        .ALUFlags(ALUFlags),
        .vector(vector)
    );
	
	
	always begin
		clk = ~clk; #5;
	end

	initial begin
	
		reset = 1;
		#10;
		reset = 0;
		clk = 0; 
		#10;
		
		// save reg 1 an 2
		WE3 = 1;
		A3 = 6;
		WD3 = {8'hF, 8'hE, 8'hD, 8'hC, 8'hB, 8'hA};
		#10;
		
		WE3 = 1;
		A3 = 7;
		WD3 = {8'h5, 8'h4, 8'h3, 8'h2, 8'h1, 8'h0};
		#10;
	
		A1 = 6;
		A2 = 7;
		#10;
				
		$display("rd1E : %0d %0d %0d %0d %0d %0d", rd1E[5], rd1E[4], rd1E[3], rd1E[2], rd1E[1], rd1E[0]);
		$display("rd2E : %0d %0d %0d %0d %0d %0d", rd2E[5], rd2E[4], rd2E[3], rd2E[2], rd2E[1], rd2E[0]);
		$display("RD2I : %d", RD2I);
		$display("");
		
		// ADD
		ALUControlE = 3'b000;
		#10;
		$display("- ADD %0d %0d %0d %0d %0d %0d",
					vector[5][7:0], vector[4][7:0], vector[3][7:0],
					vector[2][7:0], vector[1][7:0], vector[0][7:0]);

		// SUB
		ALUControlE = 3'b001;
		#10;
		$display("- SUB %0d %0d %0d %0d %0d %0d",
					vector[5][7:0], vector[4][7:0], vector[3][7:0],
					vector[2][7:0], vector[1][7:0], vector[0][7:0]);
		
		// MOV
		ALUControlE = 3'b010;
		#10;
		$display("- MOV %0d %0d %0d %0d %0d %0d",
					vector[5][7:0], vector[4][7:0], vector[3][7:0],
					vector[2][7:0], vector[1][7:0], vector[0][7:0]);
					
		// MUL
		ALUControlE = 3'b011;
		#10;
		$display("- MUL %0d %0d %0d %0d %0d %0d",
					vector[5][7:0], vector[4][7:0], vector[3][7:0],
					vector[2][7:0], vector[1][7:0], vector[0][7:0]);
	
	end

endmodule
