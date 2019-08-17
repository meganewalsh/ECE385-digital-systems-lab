//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  12-08-2017                               --
//    Spring 2018 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  P1_Board ( input     Clk,                		// 50 MHz clock
                             Reset,              		// Active-high reset signal
                             frame_clk,          		// The clock indicating a new frame (~60Hz)
               input [12:0]  DrawX, DrawY,       		// Current pixel coordinates
					input [2:0]   random_array1 [99:0],
					input integer row_counter1,
               output logic  is_outline1, is_black1, is_white1 );
					
					
	 parameter [12:0] Board_Y_Center = 13'd479;
	 parameter [12:0] Board_X_Center = 10'd99;  // Center position on the X axis
    parameter [12:0] Ball_X_Min = 10'd0;       			// Leftmost point on the X axis
    parameter [12:0] Ball_X_Max = 10'd639;     			// Rightmost point on the X axis
    parameter [12:0] Ball_Y_Min = 10'd0;       			// Topmost point on the Y axis
    parameter [12:0] Ball_Y_Max = 10'd479;     			// Bottommost point on the Y axis
    parameter [12:0] Board_Y_Step = 10'd1;     			// Step size on the Y axis
    parameter [12:0] Cell_Size = 10'd30;       			// Ball size
	 
    
    //////// Do not modify the always_ff block. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    
    // Compute whether the pixel corresponds to the board's outline
    int DistY, Size;
    assign DistY = DrawY - Board_Y_Center;
    assign Size = Cell_Size;
    always_comb begin
        if ( ( (DistY == -1*Size)  & (DrawX <= Board_X_Center+3*Size & DrawX >= Board_X_Center-3*Size) ) |
		       ( (DistY == -2*Size)  & (DrawX <= Board_X_Center+3*Size & DrawX >= Board_X_Center-3*Size) ) |
		       ( (DistY == -3*Size)  & (DrawX <= Board_X_Center+3*Size & DrawX >= Board_X_Center-3*Size) ) |
		       ( (DistY == -4*Size)  & (DrawX <= Board_X_Center+3*Size & DrawX >= Board_X_Center-3*Size) ) |
		       ( (DistY == -5*Size)  & (DrawX <= Board_X_Center+3*Size & DrawX >= Board_X_Center-3*Size) ) |
		       ( (DistY == -6*Size)  & (DrawX <= Board_X_Center+3*Size & DrawX >= Board_X_Center-3*Size) ) |
		       ( (DistY == -7*Size)  & (DrawX <= Board_X_Center+3*Size & DrawX >= Board_X_Center-3*Size) ) |
		       ( (DistY == -8*Size)  & (DrawX <= Board_X_Center+3*Size & DrawX >= Board_X_Center-3*Size) ) |
		       ( (DistY == -9*Size)  & (DrawX <= Board_X_Center+3*Size & DrawX >= Board_X_Center-3*Size) ) |
		       ( (DistY == -10*Size) & (DrawX <= Board_X_Center+3*Size & DrawX >= Board_X_Center-3*Size) ) |
		       ( (DistY == -11*Size) & (DrawX <= Board_X_Center+3*Size & DrawX >= Board_X_Center-3*Size) ) |
		       ( (DistY == -12*Size) & (DrawX <= Board_X_Center+3*Size & DrawX >= Board_X_Center-3*Size) ) |
		       ( (DistY == -13*Size) & (DrawX <= Board_X_Center+3*Size & DrawX >= Board_X_Center-3*Size) ) |
		       ( (DistY == -14*Size) & (DrawX <= Board_X_Center+3*Size & DrawX >= Board_X_Center-3*Size) ) |
		       ( (DistY == -15*Size) & (DrawX <= Board_X_Center+3*Size & DrawX >= Board_X_Center-3*Size) ) |
				 ( (DistY == -16*Size) & (DrawX <= Board_X_Center+3*Size & DrawX >= Board_X_Center-3*Size) ) |
				   (DrawX == Board_X_Center + 13'd90 | DrawX == Board_X_Center - 13'd90) )

				is_outline1 = 1'b1;
        else
            is_outline1 = 1'b0;

    end
 
	 
	 int col_match, row_match, dist_from_left;
	 assign dist_from_left = DrawX - (Board_X_Center - 13'd90);
	 assign col_match = 2 - (dist_from_left / (2*Size));
	 assign row_match = (DistY / (-Size)) + row_counter1;
	
	 //compute whether tile is black or white
	 always_comb begin

		if ( random_array1[row_match][col_match] == 1'b1  & (DrawX < Board_X_Center+3*Size & DrawX > Board_X_Center-3*Size) & DrawY <= Board_Y_Center)
		begin
			is_black1 = 1'b1;
			is_white1 = 1'b0;
		end
		else if ( random_array1[row_match][col_match] == 1'b0  & (DrawX < Board_X_Center+3*Size & DrawX > Board_X_Center-3*Size) & DrawY <= Board_Y_Center)
		begin
			is_black1 = 1'b0;
			is_white1 = 1'b1;
		end
		else
		begin
			is_black1 = 1'b0;
			is_white1 = 1'b0;
		end
		
	 end	
	
endmodule
