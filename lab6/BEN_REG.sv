module BEN_Reg (input  logic Clk, N, Z, P, LD_BEN,
					 input  logic [2:0] IN,
					 output logic BEN);
					 
		 always_ff @ (posedge Clk)
			begin							// logic for Branch Enable
				if(LD_BEN)				// if load enabled, BEN is 1 when desired conditions are met
					BEN <= (IN[2] & N) + (IN[1] & Z) + (IN[0] & P);
			end
				
endmodule
