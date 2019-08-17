/************************************************************************
AES Decryption Core Logic

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

module AES (
	input	 logic CLK,
	input  logic RESET,
	input  logic AES_START,
	output logic AES_DONE,
	input  logic [127:0] AES_KEY,
	input  logic [127:0] AES_MSG_ENC,
	output logic [127:0] AES_MSG_DEC
);

	logic [127:0]  muxOut, invShiftRows_out, invSubBytes_out, addRoundKey_out, currMessage, fsmMUX_out, invMixColumns_out, roundKey;
	logic [1407:0] keyExpansion_KeySchedule;
	logic [31:0]   columnToChange_out, columnChanged_out;
	logic [3:0]    round, next_round;
	logic [2:0] 	FSM_select;
	logic [1:0] 	column_select;
	logic 			load_init;
	
//can only be instantiated once
KeyExpansion keyExpansion_inst(
		.clk(CLK),
		.Cipherkey(AES_KEY),
		//output
		.KeySchedule(keyExpansion_KeySchedule)
);

AddRoundKey addRoundKey_inst(
		.state(currMessage),
		.schedule(keyExpansion_KeySchedule),
		.round(round),
		.out(addRoundKey_out),
		.roundKey(roundKey)
);		

InvShiftRows invShiftRows_inst(
		.data_in(currMessage),
		.data_out(invShiftRows_out)
);

choose chooseColumn(
		.in0(currMessage[127:96]),
		.in1(currMessage[95:64]),
		.in2(currMessage[63:32]),
		.in3(currMessage[31:0]),
		.Select(column_select),
		.out(columnToChange_out)
);

//can only be instantiated once
InvMixColumns changeColumn(
		.in(columnToChange_out),
		.out(columnChanged_out)
);

replace replaceColumn(
		.CLK(CLK),
		.in(columnChanged_out),
		.in0(invMixColumns_out[127:96]),
		.in1(invMixColumns_out[95:64]),
		.in2(invMixColumns_out[63:32]),
		.in3(invMixColumns_out[31:0]),
		.Select(column_select),
		.out0(invMixColumns_out[127:96]),
		.out1(invMixColumns_out[95:64]),
		.out2(invMixColumns_out[63:32]),
		.out3(invMixColumns_out[31:0])
);

FsmMUX fsmMUX(
		.in0(addRoundKey_out),
		.in1(invShiftRows_out),
		.in2(invMixColumns_out),
		.in3(invSubBytes_out),
		.in7(currMessage),
		.Select(FSM_select),
		.out(muxOut)
);

//can be instantiated multiple times - sub all bytes in currMessage
InvSubBytes subBytes0(  .clk(CLK),  .in(currMessage[7:0]),      .out(invSubBytes_out[7:0])      );
InvSubBytes subBytes1(  .clk(CLK),  .in(currMessage[15:8]),     .out(invSubBytes_out[15:8])     );
InvSubBytes subBytes2(  .clk(CLK),  .in(currMessage[23:16]),    .out(invSubBytes_out[23:16])    );
InvSubBytes subBytes3(  .clk(CLK),  .in(currMessage[31:24]),    .out(invSubBytes_out[31:24])    );
InvSubBytes subBytes4(  .clk(CLK),  .in(currMessage[39:32]),    .out(invSubBytes_out[39:32])    );
InvSubBytes subBytes5(  .clk(CLK),  .in(currMessage[47:40]),    .out(invSubBytes_out[47:40])    );
InvSubBytes subBytes6(  .clk(CLK),  .in(currMessage[55:48]),    .out(invSubBytes_out[55:48])    );
InvSubBytes subBytes7(  .clk(CLK),  .in(currMessage[63:56]),    .out(invSubBytes_out[63:56])    );
InvSubBytes subBytes8(  .clk(CLK),  .in(currMessage[71:64]),    .out(invSubBytes_out[71:64])    );
InvSubBytes subBytes9(  .clk(CLK),  .in(currMessage[79:72]),    .out(invSubBytes_out[79:72])    );
InvSubBytes subBytesA(  .clk(CLK),  .in(currMessage[87:80]),    .out(invSubBytes_out[87:80])    );
InvSubBytes subBytesB(  .clk(CLK),  .in(currMessage[95:88]),    .out(invSubBytes_out[95:88])    );
InvSubBytes subBytesC(  .clk(CLK),  .in(currMessage[103:96]),   .out(invSubBytes_out[103:96])   );
InvSubBytes subBytesD(  .clk(CLK),  .in(currMessage[111:104]),  .out(invSubBytes_out[111:104])  );
InvSubBytes subBytesE(  .clk(CLK),  .in(currMessage[119:112]),  .out(invSubBytes_out[119:112])  );
InvSubBytes subBytesF(  .clk(CLK),  .in(currMessage[127:120]),  .out(invSubBytes_out[127:120])  );

//21 states
enum logic [4:0] {WAIT, clk1, clk2, clk3, clk4, clk5, clk6, clk7, clk8, init_ARK, shiftRows, subBytes,
				addRoundKey, mixColumns_0, mixColumns_1, mixColumns_2, mixColumns_3, clk9,
				final_SR, final_SB, final_ARK, DONE}  curr_state, next_state;

			  
//assuming RESET is active high from diagram in slides
always_ff @ (posedge CLK) begin
	if (RESET) begin
		curr_state <= WAIT;
		round <= 4'b1010;
	end
	else begin
		curr_state <= next_state;
		round <= next_round;
		if (load_init)
			currMessage <= AES_MSG_ENC;
		else
			currMessage <= muxOut;
	end
end	


always_comb begin

	next_state = curr_state;
	load_init = 1'b0;
	FSM_select = 3'b111;
	next_round = round;
	AES_MSG_DEC = 128'b0;
	column_select = 2'b00;
	AES_DONE = 1'b0;
	

	unique case (curr_state)
	
			WAIT				:		begin
										next_round = 4'b1010;

										if (AES_START)
											begin
											load_init = 1'b1;
											next_state = clk1;
											end
										end
										
			//allow keyschedule to fill
			clk1 : next_state = clk2;
			clk2 : next_state = clk3;
			clk3 : next_state = clk4;
			clk4 : next_state = clk5;
			clk5 : next_state = clk6;
			clk6 : next_state = clk7;
			clk7 : next_state = clk8;
			clk8 : next_state = init_ARK;
			
			init_ARK			:		begin
										next_state = shiftRows;
										next_round = round - 4'b0001;
										FSM_select = 3'b000;
										end
			
			//Begin 9x looping
			shiftRows		:		begin
										next_state = subBytes;
										FSM_select = 3'b001;
										end
			
			subBytes			:		begin
										next_state = addRoundKey;
										FSM_select = 3'b011;
										end
			
			addRoundKey		:		begin
										next_state = mixColumns_0;
										FSM_select = 3'b000;
										end
			
			mixColumns_0	:		begin
										next_state = mixColumns_1;
										column_select = 2'b00;
										end
			
			mixColumns_1	:		begin
										next_state = mixColumns_2;
										column_select = 2'b01;
										end
			
			mixColumns_2	:		begin
										next_state = mixColumns_3;
										column_select = 2'b10;
										end
			
			mixColumns_3	:		begin
										column_select = 2'b11;
										next_round = round - 4'b0001;
										next_state = clk9;
										end
										
			//allow last column to fill
			clk9 : 	begin
						FSM_select = 3'b010;
						if (next_round == 4'b0000)
							next_state = final_SR;
						else
							next_state = shiftRows;
						end
			//end 9x looping

			
			final_SR			:		begin
										next_state = final_SB;
										FSM_select = 3'b001;
										end
			
			final_SB			:		begin
										next_state = final_ARK;
										FSM_select = 3'b011;
										end
			
			final_ARK		:		begin
										next_state = DONE;
										FSM_select = 3'b000;
										end
			
			DONE				:		begin
										AES_DONE = 1'b1;
										AES_MSG_DEC = currMessage;
										if (~AES_START) begin
											next_state = WAIT;
											end
										end
			
	endcase
	
end

endmodule
