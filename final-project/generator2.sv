module generator2(input		Reset, clk, correct_key2, StartGame,
						input logic  [2:0] array_in[99:0],
					   input integer row_counter2,
						input [99:0] LFSR_result,
						output logic [2:0] array_out[99:0],
						output integer new_row2
						);
						
logic [2:0]  array[99:0];
		
always_ff @ (posedge clk) begin
	if (Reset | StartGame) begin
		array_out <= array;
	end
	else begin
		array_out <= array_in;
	end
end

always_ff @ (posedge clk) begin
  if (Reset | StartGame)
  		new_row2 <= 0;
  else if (correct_key2)
		new_row2 <= row_counter2 + 1;
  else
	  	new_row2 <= row_counter2;
end
		
		
always_comb begin

		for (int i = 0, j = 0; i < 100; i = i + 2, j++) begin
		
			if ( {LFSR_result[i], LFSR_result[i+1]} == 2'b00 ) begin
				array[j] = 3'b010;
			end
			else if ( {LFSR_result[i], LFSR_result[i+1]} == 2'b01 ) begin
				array[j] = 3'b001;
			end	
			else if ( {LFSR_result[i], LFSR_result[i+1]} == 2'b10 ) begin
				array[j] = 3'b100;
			end
			else begin
				if (j == 0)
					array[j] = 3'b100;
				else if (array[j-1] == 3'b100)
					array[j] = 3'b010;
				else if (array[j-1] == 3'b010)
					array[j] = 3'b001;
				else
					array[j] = 3'b100;
			end
		
		end
		
		for (int i = 1, j = 50; i < 99; i = i + 2, j++) begin
		
			if ( {LFSR_result[i], LFSR_result[i+1]} == 2'b00 ) begin
				array[j] = 3'b010;
			end
			else if ( {LFSR_result[i], LFSR_result[i+1]} == 2'b01 ) begin
				array[j] = 3'b001;
			end	
			else if ( {LFSR_result[i], LFSR_result[i+1]} == 2'b10 ) begin
				array[j] = 3'b100;
			end
			else begin
				if (array[j-1] == 3'b100)
					array[j] = 3'b010;
				else if (array[j-1] == 3'b010)
					array[j] = 3'b001;
				else
					array[j] = 3'b100;
			end
		
		end
		
		for (int j = 1; j < 100; j++) begin
				if ( (array[j] == array[j-1]) & (array[j] == 3'b010) )
						array[j] = 3'b100;
				else if ( (array[j] == array[j-1]) & (array[j] == 3'b001) )
						array[j] = 3'b010;
				else if ( (array[j] == array[j-1]) & (array[j] == 3'b100) )
						array[j] = 3'b001;
		end
		
		array[99] = array[97];
				
end
					
endmodule
