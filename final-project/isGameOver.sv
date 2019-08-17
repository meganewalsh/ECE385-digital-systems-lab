module checkGameOver (  input Clk,
								input integer winner, winner2, winner3,
								output integer is_GameOver );
											
always_comb begin

	if ( ((winner == 1) & (winner2 == 1)) | ((winner == 2) & (winner2 == 2)) |
			(winner3 == 1 | winner3 == 2))
			is_GameOver = 1;
	else
			is_GameOver = 0;

end

endmodule 