module shift_module
#(parameter N = 8)
(
	input logic [N-1:0] a,
	input logic [2:0] b,
	output logic [N-1:0] left,
	output logic [N-1:0] right
);

	always_comb begin
	
		// RIGHT
		// [i-1:0][7:i]
		// [3:0][7:4]
		
		// LEFT
		// [7-i:0][7:7-i+1]
		// [7-3:0][7:7-3+1]
		
		case (b)
			3'b000: begin	// No shift
				left  = a;   
				right = a;
			end
			3'b001: begin // Shift by 1 bit
				left  = { a[0], a[N-1:1] };     			
				right = { a[N-2:0], a[N-1] };
			end
			
			3'b010: begin
				left  = { a[2-1:0], a[N-1:2] };   			
				right = { a[N-1-2:0], a[N-1:N-1-2+1] };
			end
			
			3'b011: begin
				left  = { a[3-1:0], a[N-1:3] };   			
				right = { a[N-1-3:0], a[N-1:N-1-3+1] };
				
			end
			
			3'b100: begin
				left  = { a[4-1:0], a[N-1:4] };   			
				right = { a[N-1-4:0], a[N-1:N-1-4+1] };	
			end
			
			3'b101: begin
				left  = { a[5-1:0], a[N-1:5] };   			
				right = { a[N-1-5:0], a[N-1:N-1-5+1] };
			end
			
			3'b110: begin
				left  = { a[6-1:0], a[N-1:6] };   			
				right = { a[N-1-6:0], a[N-1:N-1-6+1] };
			end
			
			3'b111: begin
				left  = { a[7-1:0], a[N-1:7] };   			
				right = { a[N-1-7:0], a[N-1:N-1-7+1] };
			end
			
			default: begin
				left = 'z;         // Invalid shift value, output all zeros
				right = 'z;
			end
			
		endcase
	end
	

endmodule
