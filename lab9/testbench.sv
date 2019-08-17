module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

// These signals are internal because the processor will be 
// instantiated as a submodule in testbench.
logic CLK = 0;
logic RESET, AES_START, AES_DONE;
logic [127:0] AES_KEY, AES_MSG_ENC, AES_MSG_DEC, currMessage;
logic [4:0] curr_state, round;

// Instantiating the DUT
// Make sure the module and signal names match with those in your design
AES aes(.*);

always @ *
begin: INTERNAL_SIG_MONITOR
curr_state = aes.curr_state;
round = aes.round;
currMessage = aes.currMessage;
end	

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 CLK = ~CLK;
end

initial begin: CLOCK_INITIALIZATION
    CLK = 0;
end 

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS
RESET = 0;		// Toggle Rest
RESET = 1;

AES_MSG_ENC =	128'hdaec3055df058e1c39e814ea76f6747e;
AES_KEY = 		128'h000102030405060708090a0b0c0d0e0f;
			
AES_START = 0;
#2 AES_START = 1;

#6 RESET = 0;

end
endmodule

