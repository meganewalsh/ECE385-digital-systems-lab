module AddRoundKey ( 	input			[127:0] state,
								input			[1407:0] schedule,
								input		   [3:0] round,
								output		[127:0] out,
								output 		[127:0] roundKey);

		logic [127:0] key;
		//assign KeySchedule[1407:0] = {Cipherkey, key0, key1, key2, key3, key4, key5, key6, key7, key8, key9};
		
		always_comb begin
			case (round)
				4'b1010:			key = schedule[127:0];
				4'b1001:			key = schedule[255:128];
				4'b1000:			key = schedule[383:256];
				4'b0111:			key = schedule[511:384];
				4'b0110:			key = schedule[639:512];
				4'b0101:			key = schedule[767:640];
				4'b0100:			key = schedule[895:768];
				4'b0011:			key = schedule[1023:896];
				4'b0010:			key = schedule[1151:1024];
				4'b0001:			key = schedule[1279:1152];
				4'b0000:			key = schedule[1407:1280];			
				default:			key = 128'b0;
			
			endcase
		end
		
		assign roundKey = key;
		assign out = state ^ key;
		
endmodule
