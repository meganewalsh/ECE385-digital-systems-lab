module key_presses1 (input [2:0] random_array1[99:0],
							input Clk,
							input integer row_counter1,
							input logic [15:0] keycode,
							output logic correct_key1 );

always_comb begin

	correct_key1 = 1'b0;

	case( keycode[15:0] )
	
			16'h0000, 16'h0520																			:		;

	
	 //A = left
			16'h0004, 16'h0d04, 16'h0e04, 16'h0f04,16'h0400, 16'h040d, 16'h040e,	16'h040f,	:
																	begin
																	if (random_array1[row_counter1] == 3'b100) begin
																		correct_key1 = 1'b1;
																	end
																	end
	 //S = middle
			16'h0016, 16'h0d16, 16'h0e16, 16'h0f16, 16'h1600, 16'h160d, 16'h160e,	16'h160f,	:
																	begin
																	if (random_array1[row_counter1] == 3'b010) begin
																		correct_key1 = 1'b1;
																	end
																	end
	 //D = right
			16'h0007, 16'h0d07, 16'h0e07, 16'h0f07, 16'h0700, 16'h070d, 16'h070e,	16'h070f,	:
																	begin
																	if (random_array1[row_counter1] == 3'b001) begin
																		correct_key1 = 1'b1;
																	end
																	end

	endcase		
	
end
		
endmodule
