module game(	input logic 			Clk, Reset, middleKey, leftKey,
					output logic 			row_counter);


	enum logic [3:0] {START, Row0, Row1, Row2, Row3, Row4, Row5, DONE}  state, next_state;

	
	always_ff @ (posedge Clk) begin
		if (Reset)
			state <= Row0;
		else
			state <= next_state;
	end


	always_comb begin
	
		next_state = state;
		row_counter = 0;

		unique case (state)
						
			Row0		:		begin
									row_counter = 0;
									if (middleKey)
										next_state = Row1;
								end
								
			Row1		:		begin
									row_counter = 0;
									if (leftKey)
										next_state = Row2;
								end
			
			Row2		:		begin
									row_counter = 0;
									if (middleKey)
										next_state = Row3;
								end
			
			Row3		:		begin
									row_counter = 0;
									if (middleKey)
										next_state = Row4;
								end
								
			Row4		:		begin
									row_counter = 0;
									if (middleKey)
										next_state = Row5;
								end

			Row5		:		begin
									row_counter = 0;
									if (middleKey)
										next_state = DONE;
								end
			DONE		:		begin
									if (Reset)
										next_state = Row0;
								end
			/*Row6
			Row7
			Row8
			Row9
			Row10
			Row11
			Row12
			Row13
			Row14
			Row15
			Row16
			Row17
			Row18
			Row19
			Row20
			Row21
			Row22
			Row23
			Row24
			Row25
			Row26
			Row27
			Row28
			Row29*/
	

		endcase
	
	end
	
endmodule

