module NZP_Block (input  logic Clk, N_IN, Z_IN, P_IN, LD_CC,
						output logic N_OUT, Z_OUT, P_OUT);
						
			always_ff @ (posedge Clk)
			begin
				if(LD_CC)	// load values if load enable is on
				begin
					N_OUT <= N_IN;
					Z_OUT <= Z_IN;
					P_OUT <= P_IN;
				end
			end
			
endmodule