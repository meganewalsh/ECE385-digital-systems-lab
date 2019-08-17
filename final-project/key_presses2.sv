module key_presses2 (	input [2:0] random_array2[99:0],
							input Clk,
							input integer row_counter2,
							input logic [15:0] keycode,
							output logic correct_key2);

always_comb begin

	correct_key2 = 1'b0;

	case( keycode[15:0] )
	
			16'h0000, 16'h0520																			:		;

	 //J = left
			16'h000d, 16'h040d, 16'h160d, 16'h070d, 16'h0d00, 16'h0d04, 16'h0d16,	16'h0d07,	:
																	begin
																	if (random_array2[row_counter2] == 3'b100) begin
																		correct_key2 = 1'b1;
																	end
																	end
	 //k = middle
			16'h000e, 16'h040e, 16'h160e, 16'h070e, 16'h0e00, 16'h0e04, 16'h0e16,	16'h0e07,		:
																	begin
																	if (random_array2[row_counter2] == 3'b010) begin
																		correct_key2 = 1'b1;
																	end
																	end
	 //L = right
			16'h000f, 16'h040f, 16'h160f, 16'h070f, 16'h0f00, 16'h0f04, 16'h0f16,	16'h0f07,		:
																	begin
																	if (random_array2[row_counter2] == 3'b001) begin
																		correct_key2 = 1'b1;
																	end
																	end
	endcase		
	
end
		
endmodule
