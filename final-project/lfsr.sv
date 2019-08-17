//This code is not ours. Credit to :
//https://www.nandland.com/vhdl/modules/lfsr-linear-feedback-shift-register.html
module LFSR
  (
   input i_Clk, 
   output [99:0] o_LFSR_Data
   );
 
  reg [100:1] r_LFSR = 0;
  reg r_XNOR;
 
 
  always @(posedge i_Clk) begin
		r_LFSR <= {r_LFSR[99:1], r_XNOR};
  end

  
  always @ (*) begin
      r_XNOR = r_LFSR[100] ^~ r_LFSR[63];
  end
  
  
  assign o_LFSR_Data = r_LFSR[100:1];

endmodule



module stopLFSR8_11D( input StartGame, Clk,
							 input  [99:0] LFSRa,
							 output [99:0] LFSR_result );

reg [99:0] lastLFSR;
							 
always_ff @ (posedge Clk) begin							 
	if (StartGame) begin
		LFSR_result <= LFSRa;
		lastLFSR <= LFSRa;
	end
	else
		LFSR_result <= lastLFSR;
end

endmodule
