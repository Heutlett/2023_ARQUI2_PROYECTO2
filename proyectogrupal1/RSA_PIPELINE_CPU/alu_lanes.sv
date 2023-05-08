module alu_lanes #(parameter N = 8)
(

	 // entradas
    input logic clk,
    input logic [5:0][N-1:0] SrcAE, SrcBE,
    input logic [3:0] SrcBiE,
    input logic [N-1:0] Imm,
    input logic [2:0] ALUControl,
    input logic [1:0] VSIFlag,
	 
	 // salidas
    output logic [5:0][1:0] ALUFlags,
    output logic [5:0][N-1:0] ALUResult
);

	logic [N-1:0] Aluresult1;
	logic [N-1:0] Aluresult2;
	logic [N-1:0] Aluresult3;
	logic [N-1:0] Aluresult4;
	logic [N-1:0] Aluresult5;
	logic [N-1:0] Aluresult6;

	logic [1:0] ALUFlags1;
	logic [1:0] ALUFlags2;
	logic [1:0] ALUFlags3;
	logic [1:0] ALUFlags4;
	logic [1:0] ALUFlags5;
	logic [1:0] ALUFlags6;

	logic [N-1:0] SrcB1;
	logic [N-1:0] SrcB2;
	logic [N-1:0] SrcB3;
	logic [N-1:0] SrcB4;
	logic [N-1:0] SrcB5;
	logic [N-1:0] SrcB6;

	mux3 #(N) mux3_1    (VSIFlag, SrcBE[0], SrcBE[SrcBiE], Imm, SrcB1);
	mux3 #(N) mux3_2    (VSIFlag, SrcBE[1], SrcBE[SrcBiE], Imm, SrcB2);
	mux3 #(N) mux3_3    (VSIFlag, SrcBE[2], SrcBE[SrcBiE], Imm, SrcB3);
	mux3 #(N) mux3_4    (VSIFlag, SrcBE[3], SrcBE[SrcBiE], Imm, SrcB4);
	mux3 #(N) mux3_5    (VSIFlag, SrcBE[4], SrcBE[SrcBiE], Imm, SrcB5);
	mux3 #(N) mux3_6    (VSIFlag, SrcBE[5], SrcBE[SrcBiE], Imm, SrcB6);

	alu #(N) alu1    (SrcAE[0], SrcB1, ALUControl, Aluresult1, ALUFlags1);
	alu #(N) alu2    (SrcAE[1], SrcB2, ALUControl, Aluresult2, ALUFlags2);
	alu #(N) alu3    (SrcAE[2], SrcB3, ALUControl, Aluresult3, ALUFlags3);
	alu #(N) alu4    (SrcAE[3], SrcB4, ALUControl, Aluresult4, ALUFlags4);
	alu #(N) alu5    (SrcAE[4], SrcB5, ALUControl, Aluresult5, ALUFlags5);
	alu #(N) alu6    (SrcAE[5], SrcB6, ALUControl, Aluresult6, ALUFlags6);

	assign ALUFlags = {ALUFlags6, ALUFlags5, ALUFlags4, ALUFlags3, ALUFlags2, ALUFlags1};
	assign ALUResult = {Aluresult6, Aluresult5, Aluresult4, Aluresult3, Aluresult2, Aluresult1};

endmodule
