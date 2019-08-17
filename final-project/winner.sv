module determine_winners( input Reset_h, StartGame, Clk,
								 input integer row_counter1, row_counter2, game,
								 input integer winner_in, winner2_in, winner3_in,
								 output integer winner, winner2, winner3 );

always_ff @ (posedge Clk) begin

if (Reset_h | (StartGame & (game == 3)) | (StartGame & (winner == winner2)) ) begin
	winner <= 0;
	winner2 <= 0;
	winner3 <= 0;
end
else if ( (row_counter1 == 100) & (winner_in == 0) & (game == 1) ) begin
	winner <= 1;
	winner2 <= 0;
	winner3 <= 0;
end
else if ( (row_counter2 == 100) & (winner_in == 0) & (game == 1) ) begin
   winner <= 2;
	winner2 <= 0;
	winner3 <= 0;
end
else if ( (row_counter1 == 100) & (winner2_in == 0) & (game == 2) ) begin
	winner <= winner_in;
	winner2 <= 1;
	winner3 <= 0;
end
else if ( (row_counter2 == 100) & (winner2_in == 0) & (game == 2) ) begin
   winner <= winner_in;
	winner2 <= 2;
	winner3 <= 0;
end
else if ( (row_counter1 == 100) & (winner3_in == 0) & (game == 3) ) begin
	winner <= winner_in;
	winner2 <= winner2_in;
	winner3 <= 1;
end
else if ( (row_counter2 == 100) & (winner3_in == 0) & (game == 3) ) begin
   winner <= winner_in;
	winner2 <= winner2_in;
	winner3 <= 2;
end
else begin
	winner <= winner_in;
	winner2 <= winner2_in;
	winner3 <= winner3_in;	
end
end
	
endmodule


module overall_winner( input Reset_h, Clk, StartGame,
							  input integer winner, winner2, winner3, game,
							  output integer OVERALL_winner );
							  
always_ff @ (posedge Clk) begin
	if (Reset_h | (StartGame & (game == 3)) | (StartGame & (winner == winner2)) )
		OVERALL_winner <= 0;
	else if ( (winner == 1 & winner2 == 1) | (winner3 == 1) )
		OVERALL_winner <= 1;
	else if ( (winner == 2 & winner2 == 2) | (winner3 == 2) )
		OVERALL_winner <= 2;
	else 
		OVERALL_winner <= 0;
end		
			
endmodule



module note1_player1 ( input [12:0]  DrawX, DrawY,
           output logic  is_n1p1,
			  output logic [10:0] sprite_addr_n1p1 );

logic [10:0] start_x = 239;
logic [10:0] start_y = 380;
logic [10:0] size_x = 8;
logic [10:0] size_y = 16;

always_comb begin
	if ( DrawX >= start_x & DrawX < start_x + size_x & DrawY >= start_y & DrawY < start_y + size_y ) begin
		is_n1p1 = 1'b1;
		sprite_addr_n1p1 = (DrawY - start_y + 16*'h0d);
	end
	else begin
		is_n1p1 = 1'b0;
		sprite_addr_n1p1 = 10'b0;
	end
end
	
endmodule

module note2_player2 ( input [12:0]  DrawX, DrawY,
           output logic  is_n2p2,
			  output logic [10:0] sprite_addr_n2p2 );

logic [10:0] start_x = 396;
logic [10:0] start_y = 380;
logic [10:0] size_x = 8;
logic [10:0] size_y = 16;

always_comb begin
	if ( DrawX >= start_x & DrawX < start_x + size_x & DrawY >= start_y & DrawY < start_y + size_y ) begin
		is_n2p2 = 1'b1;
		sprite_addr_n2p2 = (DrawY - start_y + 16*'h0d);
	end
	else begin
		is_n2p2 = 1'b0;
		sprite_addr_n2p2 = 10'b0;
	end
end
	
endmodule

module note2_player1 ( input [12:0]  DrawX, DrawY,
           output logic  is_n2p1,
			  output logic [10:0] sprite_addr_n2p1 );

logic [10:0] start_x = 247;
logic [10:0] start_y = 380;
logic [10:0] size_x = 8;
logic [10:0] size_y = 16;

always_comb begin
	if ( DrawX >= start_x & DrawX < start_x + size_x & DrawY >= start_y & DrawY < start_y + size_y ) begin
		is_n2p1 = 1'b1;
		sprite_addr_n2p1 = (DrawY - start_y + 16*'h0d);
	end
	else begin
		is_n2p1 = 1'b0;
		sprite_addr_n2p1 = 10'b0;
	end
end
	
endmodule

module note1_player2 ( input [12:0]  DrawX, DrawY,
           output logic  is_n1p2,
			  output logic [10:0] sprite_addr_n1p2 );

logic [10:0] start_x = 388;
logic [10:0] start_y = 380;
logic [10:0] size_x = 8;
logic [10:0] size_y = 16;

always_comb begin
	if ( DrawX >= start_x & DrawX < start_x + size_x & DrawY >= start_y & DrawY < start_y + size_y ) begin
		is_n1p2 = 1'b1;
		sprite_addr_n1p2 = (DrawY - start_y + 16*'h0d);
	end
	else begin
		is_n1p2 = 1'b0;
		sprite_addr_n1p2 = 10'b0;
	end
end
	
endmodule
