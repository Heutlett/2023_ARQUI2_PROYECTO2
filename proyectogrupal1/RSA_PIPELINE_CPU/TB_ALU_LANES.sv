module TB_ALU_LANES;
	
	localparam N = 8;

	logic clk;
	logic [5:0][7:0] SrcAE, SrcBE;
	logic [2:0] ALUControl;
	logic [1:0][5:0] ALUFlags;
	logic [5:0][7:0] vector;
	
	alu_lanes alu_lanes_unit (clk, SrcAE, SrcBE, ALUControl, ALUFlags, vector);
	
	initial begin
	
		#10; 
		clk = 0; #10;
	
		// ADD
		ALUControl = 3'b000;
		SrcAE = 48'd1;
		SrcBE = 48'd10;
		#10;
		// SUB
		ALUControl = 3'b001;
		SrcAE = 48'd10;
		SrcBE = 48'd5;
		#10;
		// MOV
		ALUControl = 3'b010;
		SrcAE = 48'd11;
		SrcBE = 48'd11;
		#10;
		// MUL
		ALUControl = 3'b011;
		SrcAE = 48'd5;
		SrcBE = 48'd5;
		#10;
	end
	
	 always begin
	  clk = ~clk; #5;
	 end
	
endmodule