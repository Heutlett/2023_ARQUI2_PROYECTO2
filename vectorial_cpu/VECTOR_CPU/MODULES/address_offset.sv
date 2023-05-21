module address_offset (
    input logic [31:0] address,
    input logic [7:0] offset,
    output logic [31:0] A,
	 output logic [5:0][7:0] WD1E
);

    always_comb begin
        A = address + offset;
        WD1E = {16'b0, A[31:24], A[23:16], A[15:8], A[7:0]};
    end

endmodule