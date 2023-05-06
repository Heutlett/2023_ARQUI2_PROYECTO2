module alu_lanes
(
	input logic clk,
	input logic [5:0][7:0] SrcAE, SrcBE,
	input logic [2:0] ALUControl,
	output logic [1:0][5:0] ALUFlags,
	output logic [5:0][7:0] vector
);
				
	logic [7:0] Aluresult1;
	logic [7:0] Aluresult2;
	logic [7:0] Aluresult3;
	logic [7:0] Aluresult4;
	logic [7:0] Aluresult5;
	logic [7:0] Aluresult6;
	
	logic [1:0] ALUFlags1;
	logic [1:0] ALUFlags2;
	logic [1:0] ALUFlags3;
	logic [1:0] ALUFlags4;
	logic [1:0] ALUFlags5;
	logic [1:0] ALUFlags6;
	
	
	alu #(8) alu1	(SrcAE[0], SrcBE[0], ALUControl, Aluresult1, ALUFlags1);
	
	alu #(8) alu2	(SrcAE[1], SrcBE[1], ALUControl, Aluresult2, ALUFlags2);
	
	alu #(8) alu3	(SrcAE[2], SrcBE[2], ALUControl, Aluresult3, ALUFlags3);
	
	alu #(8) alu4	(SrcAE[3], SrcBE[3], ALUControl, Aluresult4, ALUFlags4);
	
	alu #(8) alu5	(SrcAE[4], SrcBE[4], ALUControl, Aluresult5, ALUFlags5);
	
	alu #(8) alu6	(SrcAE[5], SrcBE[5], ALUControl, Aluresult6, ALUFlags6);
				
	
	assign ALUFlags = {ALUFlags6, ALUFlags5, ALUFlags4, ALUFlags3, ALUFlags2, ALUFlags1};
	assign vector = {Aluresult6, Aluresult5, Aluresult4, Aluresult3, Aluresult2, Aluresult1};

				
endmodule