module choose	(	input logic  [31:0]	in0,
														in1,
														in2,
														in3,
							input logic  [1:0]	Select,
							output logic [31:0]	out  );
						
	always_comb begin
			case (Select)
				2'b000		:		out <= in0;
				2'b001		:		out <= in1;
				2'b010		:		out <= in2;
				2'b011		:		out <= in3;
			endcase
	end
	
endmodule







module replace (	input logic CLK,
						input logic  [31:0] 	in,
													in0,
													in1,
													in2,
													in3,
						input logic  [1:0]  	Select,
						output logic [31:0]	out0,
													out1,
													out2,
													out3  );	
	always_ff @ (posedge CLK) begin
			case (Select)
				2'b000		:		begin
										out0 <= in;
										out1 <= in1;
										out2 <= in2;
										out3 <= in3;
										end
										
				2'b001		:		begin
										out0 <= in0;
										out1 <= in;
										out2 <= in2;
										out3 <= in3;
										end
										
				2'b010		:		begin
										out0 <= in0;
										out1 <= in1;
										out2 <= in;
										out3 <= in3;
										end
										
				2'b011		:		begin
										out0 <= in0;
										out1 <= in1;
										out2 <= in2;
										out3 <= in;
										end
				endcase
	end
	
endmodule








module FsmMUX	(	input logic  [127:0]	in0,
													in1,
													in2,
													in3,
													in7,
						input logic  [2:0]	Select,
						output logic [127:0]	out  ); 	

	always_comb begin
			case (Select)
				3'b000		:		out <= in0;
				3'b001		:		out <= in1;
				3'b010		:		out <= in2;
				3'b011		:		out <= in3;
				default		:		out <= in7;
				
			endcase
	end
	
endmodule	
