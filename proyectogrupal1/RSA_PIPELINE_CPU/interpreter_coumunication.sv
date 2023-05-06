module interpreter_coumunication
(
	// Entradas
	input logic clk, reset, MemtoReg, COM,
	input logic [31:0] ReadData,
	
	// Salidas
	output clk_out,
	output logic [7:0] ReadDataOut
);

	always_ff @(posedge clk, posedge reset) begin
	
		if (reset) begin 
			ReadDataOut <= 0; 
		end
		else if(MemtoReg & COM) ReadDataOut <= ReadData[7:0];
		
	end
	
	assign clk_out = !MemtoReg;
	
	
endmodule
