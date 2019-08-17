// MUX for the PC input. Either increment counter, or loads value from BUS, or ADDER unit.
module PC_MUX (input  logic [15:0] IN0, IN1, IN2,
					input		 logic [1:0]	 Select,		
					output logic [15:0] OUT);
		
		always_comb
		begin
			case (Select)
			
				2'b00:
					OUT = IN0;
				2'b01:
					OUT = IN1;
				2'b10:
					OUT = IN2;
				2'b11:
					OUT = 16'h0;

			endcase
		end
		
endmodule

// Destination Register MUX. Either sets DR as input or as 111.
module DR_MUX (input  logic [2:0] IN,
					input  logic 		 Select,
					output logic [2:0] OUT);
		
		always_comb
		begin
			case (Select)
			
				1'b0:
					OUT = IN;
				1'b1:
					OUT = 3'b111;
			endcase
		end
	
endmodule

// Source register 1 MUX. Either read Instruction register bits 9-11 or 6-8.
module SR1_MUX (input  logic [2:0] IN0, IN1,
					 input  logic  	  Select,
					 output logic [2:0] OUT);
		
		always_comb
		begin
			case (Select)
			
				1'b0:
					OUT = IN0;
				1'b1:
					OUT = IN1;
			endcase
		end
		
endmodule

// Source register 2 MUX. Either takes value from Register File, or from Instruction Register
module SR2_MUX (input  logic [15:0] IN0, IN1,
					 input  logic 			Select,
					 output logic [15:0] OUT);
					 
		always_comb
		begin
			case (Select)
			
				1'b0:
					OUT = IN0;
				1'b1:
					OUT = IN1;
			endcase
		end
		
endmodule

// Address 1 MUX. Either takes value from PC or Register File
module ADDR1_MUX (input  logic [15:0] IN0, IN1,
						input  logic 			Select,
						output logic [15:0] OUT);
						
		always_comb
		begin
			case (Select)
			
				1'b0:
					OUT = IN0;
				1'b1:
					OUT = IN1;
			endcase
		end
		
endmodule

// Address 2 MUX. Takes the sign extensions of the instruction register or inputs 0.
module ADDR2_MUX (input  logic [15:0] IN0, IN1, IN2,
						input  logic [1:0]  Select,
						output logic [15:0] OUT);
		
		always_comb
		begin
			case (Select)
			
				2'b00:
					OUT = 16'h0;
				2'b01:
					OUT = IN0;
				2'b10:
					OUT = IN1;
				2'b11:
					OUT = IN2;
			endcase
		end
		
endmodule

// Gate MUX to monitor the outputs into the BUS.
module GATE_MUX (input   logic [15:0] IN0, IN1, IN2, IN3,
					  input  logic [3:0]  Select,
					  output logic [15:0] OUT);
		
		always_comb
		begin
			case (Select)
			
				4'b1000:
					OUT = IN0;
				4'b0100:
					OUT = IN1;
				4'b0010:
					OUT = IN2;			
				4'b0001:
					OUT = IN3;
				default: 
					OUT = 16'h0;
			endcase
		end

endmodule

// Memory Data MUX. Either takes inputs from memory or the BUS.
module MDR_MUX (input  logic [15:0] IN0, IN1,
					 input  logic 			Select,
					 output logic [15:0] OUT);
					 
		always_comb
		begin
			case (Select)
			
				1'b0:
					OUT = IN0;
				1'b1:
					OUT = IN1;
			endcase
		end
		
endmodule