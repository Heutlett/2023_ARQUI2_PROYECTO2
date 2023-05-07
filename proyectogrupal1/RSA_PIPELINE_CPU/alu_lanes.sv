module alu_lanes #(parameter WIDTH = 8)
(
    input logic clk,
    input logic [5:0][WIDTH-1:0] SrcAE, SrcBE,
    input logic [2:0] SrcBiE,
    input logic [WIDTH-1:0] imm,
    input logic [2:0] ALUControl,
    input logic [1:0] vsi_flag,
    output logic [5:0][1:0] ALUFlags,
    output logic [5:0][WIDTH-1:0] vector
);

	logic [WIDTH-1:0] Aluresult1;
	logic [WIDTH-1:0] Aluresult2;
	logic [WIDTH-1:0] Aluresult3;
	logic [WIDTH-1:0] Aluresult4;
	logic [WIDTH-1:0] Aluresult5;
	logic [WIDTH-1:0] Aluresult6;

	logic [1:0] ALUFlags1;
	logic [1:0] ALUFlags2;
	logic [1:0] ALUFlags3;
	logic [1:0] ALUFlags4;
	logic [1:0] ALUFlags5;
	logic [1:0] ALUFlags6;

	logic [WIDTH-1:0] SrcB1;
	logic [WIDTH-1:0] SrcB2;
	logic [WIDTH-1:0] SrcB3;
	logic [WIDTH-1:0] SrcB4;
	logic [WIDTH-1:0] SrcB5;
	logic [WIDTH-1:0] SrcB6;

	mux3 #(WIDTH) mux3_1    (vsi_flag, SrcBE[0], SrcBE[SrcBiE], imm, SrcB1);
	mux3 #(WIDTH) mux3_2    (vsi_flag, SrcBE[1], SrcBE[SrcBiE], imm, SrcB2);
	mux3 #(WIDTH) mux3_3    (vsi_flag, SrcBE[2], SrcBE[SrcBiE], imm, SrcB3);
	mux3 #(WIDTH) mux3_4    (vsi_flag, SrcBE[3], SrcBE[SrcBiE], imm, SrcB4);
	mux3 #(WIDTH) mux3_5    (vsi_flag, SrcBE[4], SrcBE[SrcBiE], imm, SrcB5);
	mux3 #(WIDTH) mux3_6    (vsi_flag, SrcBE[5], SrcBE[SrcBiE], imm, SrcB6);

	alu #(WIDTH) alu1    (SrcAE[0], SrcB1, ALUControl, Aluresult1, ALUFlags1);
	alu #(WIDTH) alu2    (SrcAE[1], SrcB2, ALUControl, Aluresult2, ALUFlags2);
	alu #(WIDTH) alu3    (SrcAE[2], SrcB3, ALUControl, Aluresult3, ALUFlags3);
	alu #(WIDTH) alu4    (SrcAE[3], SrcB4, ALUControl, Aluresult4, ALUFlags4);
	alu #(WIDTH) alu5    (SrcAE[4], SrcB5, ALUControl, Aluresult5, ALUFlags5);
	alu #(WIDTH) alu6    (SrcAE[5], SrcB6, ALUControl, Aluresult6, ALUFlags6);

	assign ALUFlags = {ALUFlags6, ALUFlags5, ALUFlags4, ALUFlags3, ALUFlags2, ALUFlags1};
	assign vector = {Aluresult6, Aluresult5, Aluresult4, Aluresult3, Aluresult2, Aluresult1};

endmodule
