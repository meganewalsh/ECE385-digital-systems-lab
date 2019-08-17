//-------------------------------------------------------------------------
//    Board.sv                                                            --
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


module  Board ( input        Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input [7:0]   keycode,				 // direction pressed
               output logic  is_outline, is_black
              );
    
    parameter [9:0] Board_X_Center = 10'd260;  // Center position on the X axis
    parameter [9:0] Board_Y_Center = 10'd1040;  // Center position on the Y axis
    parameter [9:0] Board_Y_Step = 10'd1;      // Step size on the Y axis
    parameter [9:0] Cell_Size = 10'd15;        // Board size
    
    logic [9:0] Board_X_Pos, Board_Y_Pos, Board_Y_Motion;
    logic [9:0] Board_X_Pos_in, Board_Y_Pos_in, Board_Y_Motion_in;
    
	 //DO NOT MODIFY
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
	 
	 
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            Board_X_Pos <= Board_X_Center;
            Board_Y_Pos <= Board_Y_Center;
            Board_Y_Motion <= 10'b0;
        end
        else
        begin
            Board_X_Pos <= Board_X_Pos_in;
            Board_Y_Pos <= Board_Y_Pos_in;
            Board_Y_Motion <= 10'b0;//Board_Y_Motion_in;
        end
    end
	 
	 
    always_comb
	 begin
	 // By default, keep motion and position unchanged
    Board_X_Pos_in = Board_X_Pos;
    Board_Y_Pos_in = Board_Y_Pos;
    Board_Y_Motion_in = Board_Y_Motion;

        
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
		  
					case (keycode[7:0])
					//A = left
							8'h04 	:
							begin
									Board_Y_Motion_in = Board_Y_Step;
							end
					//S = middle
							8'h16		:
							begin
									Board_Y_Motion_in = Board_Y_Step;
							end
					//D = right
							8'h07		:
							begin
									Board_Y_Motion_in = Board_Y_Step;
							end
					//none	
							default	:		;
							
					endcase
			end
				
            // Update the Board's position with its motion
            Board_Y_Pos_in = Board_Y_Pos + Board_Y_Motion;
        
    end
    
	 
	 
	 
    int DistX, DistY, Size;
    assign DistX = DrawX - Board_X_Pos;
    assign DistY = DrawY - Board_Y_Pos;
    assign Size = Cell_Size;

	 // Compute whether the pixel outlines the board
    always_comb begin
        if ( ( (DistY == Board_Y_Pos + Size | DistY == Board_Y_Pos - Size) & (DistX <= Board_X_Pos+6*Size & DistX >= Board_X_Pos-6*Size) ) |
				 //Vertical lines
			    ( (DistX == Board_X_Pos + 6*Size | DistX == Board_X_Pos - 6*Size | DistX == Board_X_Pos + 2*Size | DistX == Board_X_Pos - 2*Size)  &
				 //Vertical boundaries
				   (DistY <= Board_Y_Pos + Size & DistY >= Board_Y_Pos - Size ) ) )
				is_outline = 1'b1;

        else
            is_outline = 1'b0;

    end
	 
	 //Compute whether the pixel is black
	 always_comb begin
        if ( DistY < Board_Y_Pos + Size & DistY > Board_Y_Pos - Size & DistX < Board_X_Pos + 2*Size & DistX > Board_X_Pos - 2*Size )
				is_black = 1'b1;
				
        else
				is_black = 1'b0;

    end
    
endmodule
