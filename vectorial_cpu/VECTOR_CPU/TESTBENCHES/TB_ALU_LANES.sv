module TB_ALU_LANES;
	
	localparam N = 8;
	localparam R = 6;

	logic clk;
	logic [R-1:0][N-1:0] SrcAE, SrcBE;
	logic [2:0] SrcBiE;
	logic [N-1:0] imm;
	logic [2:0] ALUControl;
	logic [1:0] vsi_flag;
	logic [R-1:0][1:0] ALUFlags;
	logic [R-1:0][N-1:0] vector;
	
	alu_lanes #(N) alu_lanes_unit (clk, SrcAE, SrcBE, SrcBiE, imm, ALUControl, vsi_flag, ALUFlags, vector);
	
	initial begin
	
		#10; 
		clk = 0; #10;
		
//// MUL
		ALUControl = 3'b011;
		SrcAE = {8'd1, 8'd2, 8'd3, 8'd4, 8'd5, 8'd6};
		SrcBE = {8'd0, 8'd1, 8'd0, 8'd1, 8'd0, 8'd1};
		SrcBiE = 3'd2;
		imm = 8'd5;
		
		
		// Vector
		vsi_flag = 2'd0;
		#10;
		
		// Scalar
		vsi_flag = 2'd1;
		#10;
		
		// Imm -> Nota, sel = 2 del mux NO se está utilizando por comodidad del ISA.
		vsi_flag = 2'd3;
		#10;
	
	end
	
	 always begin
	  clk = ~clk; #5;
	 end
	
endmodule