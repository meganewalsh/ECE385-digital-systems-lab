module ALU (input  logic [15:0] A, B,
			input  logic [1:0]  Select,
			output logic [15:0] OUT);
				
		always_comb
		begin
			case (Select)
			
				2'b00:
					OUT = A + B;	// add operation
				2'b01:
					OUT = A & B;	// and operation
				2'b10:
					OUT = ~A;		// not operation of A
				2'b11:
					OUT = A;		// pass A through
			endcase
		end
		
endmodule