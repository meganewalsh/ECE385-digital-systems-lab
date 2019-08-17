module control (input logic Clk, Reset, Run, ClearA_LoadB, M,
					 output logic Clr_Ld, Shift, Add, Sub	
);

	// have synthesis tool pick encoding (recommended)
	enum logic [4:0] {Start, shift1, shift2, shift3, shift4, shift5, shift6, shift7, shift8,
									 add1, add2, add3, add4, add5, add6, add7, add8, Hold}
									 curr_state, next_state;
	
	//Declare register behavior
	always_ff @ (posedge Clk)
	begin
		if (Reset)							// Synchronous Reset
			curr_state <= Start; 		// A is the reset/start state
		else
			curr_state <= next_state;
	end	
	
	always_comb
	begin
	
	   next_state = curr_state;
		
		//next state logic - combinational procedure
		unique case (curr_state)

				Start 	: 	if (Run)
									next_state = add1;
								
				add1		:		next_state = shift1;
	
				shift1	:		next_state = add2;
			
				add2		:		next_state = shift2;
			
				shift2	:		next_state = add3;
			
				add3		:		next_state = shift3;
			
				shift3	:		next_state = add4;
			
				add4		:		next_state = shift4;
			
				shift4	:		next_state = add5;
			
				add5		:		next_state = shift5;
			
				shift5	:		next_state = add6;
			
				add6		:		next_state = shift6;
			
				shift6	:		next_state = add7;
			
				add7		:		next_state = shift7;
			
				shift7	:		next_state = add8;
			
				add8		:		next_state = shift8;
		
				shift8	:		next_state = Hold;
			
				Hold		: 		if (~Run)
									next_state = Start;
		endcase
		
	end
	
	always_comb
	begin
	
		//output logic - combinational procedure
		case (curr_state)
		
				Start, Hold	:
				begin
						Shift = 1'b0;
						Add = 1'b0;
						Sub = 1'b0;
						Clr_Ld = ClearA_LoadB;
				end

				add1, add2, add3, add4, add5, add6, add7	:
				begin
						Clr_Ld = 1'b0;
						Shift = 1'b0;
						
						if (M) 
						begin
							Add = 1'b1;
							Sub = 1'b0;
						end else begin
							Add = 1'b0;
							Sub = 1'b0;
						end
				end
					
				add8 :
				begin
						Clr_Ld = 1'b0;
						Shift = 1'b0;
						
						if (M) begin
							Add = 1'b0;
							Sub = 1'b1;
						end else begin
							Add = 1'b0;
							Sub = 1'b0;
						end
				end
				
				//all shift
				shift1, shift2, shift3, shift4, shift5, shift6, shift7, shift8 :
				begin
						Clr_Ld = 1'b0;
						Shift = 1'b1;
						Add = 1'b0;
						Sub = 1'b0;
				end
		endcase
	end
endmodule
	