//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper ( input 					is_outline1, is_black1, is_pink1, is_white1, is_red1, is_title,
														is_P, is_L, is_A, is_Y, is_E, is_R, is_1, is_n1p1, is_n2p1,
														is_P2, is_L2, is_A2, is_Y2, is_E2, is_R2, is_2, is_n1p2, is_n2p2,
														is_outline2, is_black2, is_pink2, is_white2,
														is_goG, is_goA, is_goM, is_goE, is_goO, is_goV, is_goE2, is_goR, is_goA1, is_goA2,
							  input logic [10:0] sprite_addr_goG, sprite_addr_goA, sprite_addr_goM, sprite_addr_goE, sprite_addr_goO, sprite_addr_goV, sprite_addr_goE2, sprite_addr_goR, sprite_addr_goA1, sprite_addr_goA2,// sprite_addr_title,													
                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
							  input integer winner, winner2, winner3, is_GameOver, OVERALL_winner,
							  input logic [10:0] sprite_addr_P, sprite_addr_L, sprite_addr_A, sprite_addr_Y, sprite_addr_E, sprite_addr_R, sprite_addr_1, sprite_addr_n1p1, sprite_addr_n2p1,
							  input logic [10:0] sprite_addr_P2, sprite_addr_L2, sprite_addr_A2, sprite_addr_Y2, sprite_addr_E2, sprite_addr_R2, sprite_addr_2, sprite_addr_n1p2, sprite_addr_n2p2,
                       output logic [7:0] VGA_R, VGA_G, VGA_B, // VGA RGB output//
							  input logic [1:0] data_R, data_G
                     );
    logic [10:0] sprite_addr_title;
    logic [7:0] Red, Green, Blue;
	 logic [7:0] sprite_data_P, sprite_data_L, sprite_data_A, sprite_data_Y, sprite_data_E, sprite_data_R, sprite_data_1, sprite_data_n1p1, sprite_data_n2p1;
	 logic [7:0] sprite_data_P2, sprite_data_L2, sprite_data_A2, sprite_data_Y2, sprite_data_E2, sprite_data_R2, sprite_data_2, sprite_data_n1p2, sprite_data_n2p2;
	 logic [7:0] sprite_data_goG, sprite_data_goA, sprite_data_goM, sprite_data_goE, sprite_data_goO, sprite_data_goV, sprite_data_goE2, sprite_data_goR, sprite_data_goA1, sprite_data_goA2;

	 font_rom P (.addr(sprite_addr_P), .data(sprite_data_P));
    font_rom L (.addr(sprite_addr_L), .data(sprite_data_L));
	 font_rom A (.addr(sprite_addr_A), .data(sprite_data_A));
    font_rom Y (.addr(sprite_addr_Y), .data(sprite_data_Y));
	 font_rom E (.addr(sprite_addr_E), .data(sprite_data_E));
    font_rom R (.addr(sprite_addr_R), .data(sprite_data_R));
	 font_rom p1 (.addr(sprite_addr_1), .data(sprite_data_1));
	 
	 font_rom P2 (.addr(sprite_addr_P2), .data(sprite_data_P2));
    font_rom L2 (.addr(sprite_addr_L2), .data(sprite_data_L2));
	 font_rom A2 (.addr(sprite_addr_A2), .data(sprite_data_A2));
    font_rom Y2 (.addr(sprite_addr_Y2), .data(sprite_data_Y2));
	 font_rom E2 (.addr(sprite_addr_E2), .data(sprite_data_E2));
    font_rom R2 (.addr(sprite_addr_R2), .data(sprite_data_R2));
	 font_rom p2 (.addr(sprite_addr_2), .data(sprite_data_2));
	 
	 font_rom n1p1_ (.addr(sprite_addr_n1p1), .data(sprite_data_n1p1));
	 font_rom n2p1_ (.addr(sprite_addr_n2p1), .data(sprite_data_n2p1));
	 font_rom n1p2_ (.addr(sprite_addr_n1p2), .data(sprite_data_n1p2));
	 font_rom n2p2_ (.addr(sprite_addr_n2p2), .data(sprite_data_n2p2));

    font_rom goG  (.addr(sprite_addr_goG),  .data(sprite_data_goG));
	 font_rom goA  (.addr(sprite_addr_goA),  .data(sprite_data_goA));
	 font_rom goM  (.addr(sprite_addr_goM),  .data(sprite_data_goM));
	 font_rom goE  (.addr(sprite_addr_goE),  .data(sprite_data_goE));
	 font_rom goO  (.addr(sprite_addr_goO),  .data(sprite_data_goO));
	 font_rom goV  (.addr(sprite_addr_goV),  .data(sprite_data_goV));
	 font_rom goE2 (.addr(sprite_addr_goE2), .data(sprite_data_goE2));
	 font_rom goR  (.addr(sprite_addr_goR),  .data(sprite_data_goR));
	 font_rom goA1 (.addr(sprite_addr_goA1), .data(sprite_data_goA1));
	 font_rom goA2 (.addr(sprite_addr_goA2), .data(sprite_data_goA2));

	// title_rom tit (.addr(sprite_addr_title), .data(sprite_data_title));


    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
    
    // Assign color based on is_ball signal
    always_comb
    begin
	     if (is_pink1 | is_pink2)
		  begin
				Red = 8'hff;
				Green = 8'h69;
				Blue = 8'hb4;
		  end
		  else if (is_red1)
		  begin
				Red = 8'hff;
				Green = 8'had;
				Blue = 8'hb5;
		  end
		  // Outline and black tiles
        else if ( ((is_outline1 | is_black1 | is_outline2 | is_black2)) |
		             (is_P & sprite_data_P[7-(DrawX - 10'd215)] == 1'b1) |
						 (is_L & sprite_data_L[7-(DrawX - 10'd223)] == 1'b1) |
						 (is_A & sprite_data_A[7-(DrawX - 10'd231)] == 1'b1) |
						 (is_Y & sprite_data_Y[7-(DrawX - 10'd239)] == 1'b1) |
						 (is_E & sprite_data_E[7-(DrawX - 10'd247)] == 1'b1) |
						 (is_R & sprite_data_R[7-(DrawX - 10'd255)] == 1'b1) |
						 (is_1 & sprite_data_1[7-(DrawX - 10'd267)] == 1'b1) |
		             (is_P2 & sprite_data_P2[7-(DrawX - 10'd364)] == 1'b1) |
						 (is_L2 & sprite_data_L2[7-(DrawX - 10'd372)] == 1'b1) |
						 (is_A2 & sprite_data_A2[7-(DrawX - 10'd380)] == 1'b1) |
						 (is_Y2 & sprite_data_Y2[7-(DrawX - 10'd388)] == 1'b1) |
						 (is_E2 & sprite_data_E2[7-(DrawX - 10'd396)] == 1'b1) |
						 (is_R2 & sprite_data_R2[7-(DrawX - 10'd404)] == 1'b1) |
						 (is_2  & sprite_data_2[7-(DrawX - 10'd416)] == 1'b1)  |
						 
						 (is_n1p1 & ((winner == 1) | ((winner == 2) & (winner2 == 1))) & sprite_data_n1p1[7-(DrawX - 10'd239)] == 1'b1) |
						 (is_n2p1 & (((winner == 1) & ((winner2 == 1) | (winner3 == 1))) | ((winner2 == 1) & (winner3 == 1)) ) & sprite_data_n2p1[7-(DrawX - 10'd247)] == 1'b1) |
						 
						 (is_n1p2 & ((winner == 2) | ((winner == 1) & (winner2 == 2))) & sprite_data_n1p2[7-(DrawX - 10'd388)] == 1'b1) |
						 (is_n2p2 & (((winner == 2) & ((winner2 == 2) | (winner3 == 2))) | ((winner2 == 2) & (winner3 == 2)) ) &sprite_data_n2p2[7-(DrawX - 10'd396)] == 1'b1) )
	 
		  begin
				Red = 8'h00;
				Green = 8'h00;
				Blue = 8'h00;
		  end
		  //Red GAME OVER
		  else if ( (is_GameOver & sprite_data_goG[7-(DrawX - 10'd282)] == 1'b1) |
						(is_GameOver & sprite_data_goA[7-(DrawX - 10'd290)] == 1'b1) |
						(is_GameOver & sprite_data_goM[7-(DrawX - 10'd298)] == 1'b1) |
						(is_GameOver & sprite_data_goE[7-(DrawX - 10'd306)] == 1'b1) |
						(is_GameOver & sprite_data_goO[7-(DrawX - 10'd324)] == 1'b1) |
						(is_GameOver & sprite_data_goV[7-(DrawX - 10'd332)] == 1'b1) |
						(is_GameOver & sprite_data_goE2[7-(DrawX - 10'd340)] == 1'b1)|
						(is_GameOver & sprite_data_goR[7-(DrawX - 10'd348)] == 1'b1) |
						(is_GameOver & (OVERALL_winner == 1) & sprite_data_goA1[7-(DrawX - 10'd267)] == 1'b1) |
						(is_GameOver & (OVERALL_winner == 2) & sprite_data_goA2[7-(DrawX - 10'd416)] == 1'b1) )
		  begin
		      Red = 8'hff; 
            Green = 8'h00;
            Blue = 8'h00;
		  end
		  //title
		  /*else if (is_title)
		  begin
		      Red = data_R; 
            Green = data_G;
            Blue = 8'h00;
		  end*/
		  //White tiles
		  else if ( (is_white1 | is_white2) )
		  begin
		      Red = 8'hff; 
            Green = 8'hff;
            Blue = 8'hff;
		  end				
		  //blue background
		  else		  
        begin
            Red = 8'had; 
            Green = 8'hff;
            Blue = 8'hf0;
        end
    end 
    
endmodule
