module alu_lanes #(parameter N = 8)
(

	 // entradas
    input logic clk,
    input logic [5:0][N-1:0] SrcAE, SrcBE,
    input logic [3:0] SrcBiE,
    input logic [N-1:0] ImmE,
    input logic [2:0] ALUControlE,
    input logic [1:0] VSIFlagE,
	 
	 // salidas
    output logic [5:0][1:0] ALUFlagsE,
    output logic [5:0][N-1:0] ALUOutputE
);

	logic [N-1:0] Aluresult1 = 0;
	logic [N-1:0] Aluresult2 = 0;
	logic [N-1:0] Aluresult3 = 0;
	logic [N-1:0] Aluresult4 = 0;
	logic [N-1:0] Aluresult5 = 0;
	logic [N-1:0] Aluresult6 = 0;

	logic [1:0] ALUFlags1 = 0;
	logic [1:0] ALUFlags2 = 0;
	logic [1:0] ALUFlags3 = 0;
	logic [1:0] ALUFlags4 = 0;
	logic [1:0] ALUFlags5 = 0;
	logic [1:0] ALUFlags6 = 0;

	logic [N-1:0] SrcB1 = 0;
	logic [N-1:0] SrcB2 = 0;
	logic [N-1:0] SrcB3 = 0;
	logic [N-1:0] SrcB4 = 0;
	logic [N-1:0] SrcB5 = 0;
	logic [N-1:0] SrcB6 = 0;


	mux3 #(N) mux3_1    (VSIFlagE, SrcBE[0], SrcBE[SrcBiE], ImmE, SrcB1);
	mux3 #(N) mux3_2    (VSIFlagE, SrcBE[1], SrcBE[SrcBiE], ImmE, SrcB2);
	mux3 #(N) mux3_3    (VSIFlagE, SrcBE[2], SrcBE[SrcBiE], ImmE, SrcB3);
	mux3 #(N) mux3_4    (VSIFlagE, SrcBE[3], SrcBE[SrcBiE], ImmE, SrcB4);
	mux3 #(N) mux3_5    (VSIFlagE, SrcBE[4], SrcBE[SrcBiE], ImmE, SrcB5);
	mux3 #(N) mux3_6    (VSIFlagE, SrcBE[5], SrcBE[SrcBiE], ImmE, SrcB6);

	alu #(N) alu1    (SrcAE[0], SrcB1, ALUControlE, Aluresult1, ALUFlags1);
	alu #(N) alu2    (SrcAE[1], SrcB2, ALUControlE, Aluresult2, ALUFlags2);
	alu #(N) alu3    (SrcAE[2], SrcB3, ALUControlE, Aluresult3, ALUFlags3);
	alu #(N) alu4    (SrcAE[3], SrcB4, ALUControlE, Aluresult4, ALUFlags4);
	alu #(N) alu5    (SrcAE[4], SrcB5, ALUControlE, Aluresult5, ALUFlags5);
	alu #(N) alu6    (SrcAE[5], SrcB6, ALUControlE, Aluresult6, ALUFlags6);

	assign ALUFlagsE = ALUFlags1;
	assign ALUOutputE = {Aluresult6, Aluresult5, Aluresult4, Aluresult3, Aluresult2, Aluresult1};

endmodule
