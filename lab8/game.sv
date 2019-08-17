module game(	input logic CLK, RESET );


enum logic [4:0] {START, WAIT, MOVE, DONE}  state, next_state;
logic [3:0] round, next_round;
logic move_board;


always_ff @ (posedge CLK) begin
	if (RESET) begin
		state <= START;
		round <= 4'b0000;
	end
	else begin
		state <= next_state;
		round <= next_round;
	end
end


always_comb begin

	next_state = state;
	next_round = round;

	unique case (state)

		START		:		next_state = WAIT;
	
		WAIT		:		begin
							case(keycode[7:0])
								//A = left
								8'h04 	:
								begin
										if( left is black )
											next_state = MOVE;
								end
								
								//S = middle
								8'h16		:
								begin
										if( middle is black )
											next_state = MOVE;
								end
								
								//D = right
								8'h07		:
								begin
										if( right is black )
											next_state = MOVE;
								end
								
								//none	
								default	:		;
							
							end case
							
						end
	
		MOVE		:	next_round = round + 4'b0001;
						move_board = 1'b1;
						if(round == 4'd30)
							next_state = DONE;
						else
							next_state = WAIT;

		DONE		:

	end case
	
end
endmodule
	