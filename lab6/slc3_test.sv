module slc3_test (input logic [15:0] S,
						input logic	Clk, Reset, Run, Continue,
						output logic [11:0] LED,
						output logic [6:0] HEX0, HEX1, HEX2, HEX3
						);

	logic [19:0] ADDR;
	wire [15:0] Data;
   logic CE, UB, LB, OE, WE;

	//slc CPU directly connected to test memory
	slc3 cpu (.*);
	
	//Test memory simulator
	test_memory test_memory0(
	.Clk(Clk), .Reset(~Reset),
	.I_O(Data), .A(ADDR),
	.*
	);
	
endmodule