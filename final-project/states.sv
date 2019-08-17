module game(	input logic 	Clk, Reset );


	enum logic [4:0] {START, Round1, Round2, Round3, DONE}  state, next_state;
	logic [3:0] round, next_round;


	always_ff @ (posedge CLK) begin
		if (RESET) begin
			state <= START;
		end
		else begin
			state <= next_state;
		end
	end


	always_comb begin
	
		next_state = state;

		unique case (state)

			START		:		if(Reset)
								begin
									next_state = Round1;
								end
	
			Round1	:		begin
									display_board1 = 1'b1;
									display_board2 = 1'b1;
								
									if ( )
										next_state = DONE;
							
								end
	

			DONE		:	

		end case
	
	end
	
endmodule

