module ff_x (input logic Clk, Load, Reset, D,
				 output logic Q
);
	always_ff @ (posedge Clk)
	begin
			if (Reset)
				Q <= 1'b0;
			else
				if (Load)
					Q <= D;
				else
					Q <= Q;
	end
endmodule
