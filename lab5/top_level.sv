module top_level (input  logic [7:0] S,
						input logic Clk, Reset, Run, ClearA_LoadB,
						output logic X,
                  output logic [6:0] AhexU, AhexL, BhexU, BhexL,
						output logic [7:0] Aval, Bval
);
				  
	logic A0; 												//bit shift A to B, most significant bit
	logic Clr_Ld, Shift, Add, Subtract; 			//control output
	logic [7:0] A, B, Sum; 								//regA contents, regB contents, adder output
	logic [8:0] XA; 										//9 bit X and A combined (for adder)
   logic syncReset, syncRun, syncClearA_LoadB;	//async buttons to sync
   logic[7:0] AhexU_comb, AhexL_comb, BhexU_comb, BhexL_comb;

	
	 //Synchronize the asynchronous signals
	 sync Sync (Clk, {~Reset, ~Run, ~ClearA_LoadB}, {syncReset, syncRun, syncClearA_LoadB});
	
	 always_ff @(posedge Clk) begin
        AhexU <= AhexU_comb;
        AhexL <= AhexL_comb;
        BhexU <= BhexU_comb;
        BhexL <= BhexL_comb;
    end
	
	//Instantiate control
	control controller(.Clk(Clk), .Reset(syncReset), .Run(syncRun), .ClearA_LoadB(syncClearA_LoadB), .M(B[0]),
							 .Clr_Ld(Clr_Ld), .Shift(Shift), .Add(Add), .Sub(Subtract)
   );
	
	//Instantiate adder - addition and subtraction
	Nine_bit_adder adder(.A(A), .B(S), .fn(Subtract),
								.Sum(XA)
	);
	
	//Instantiate X flip flop
	ff_x ff_x  (.Clk(Clk), .Load(Add | Subtract), .Reset(syncReset | Clr_Ld), .D(XA[8]),
					 .Q(X)
	);
	
	//Instantiate both shift registers
	reg_8 regA (.Clk(Clk), .Reset(syncReset | Clr_Ld), .Shift_In(X), .Load(Add | Subtract), .Shift_En(Shift), .D(XA[7:0]),
				   .Shift_Out(A0), .Data_Out(A)
	);
	
	reg_8 regB (.Clk(Clk), .Reset(syncReset), .Shift_In(A0), .Load(Clr_Ld), .Shift_En(Shift), .D(S),
					.Shift_Out(), .Data_Out(B)
	);
	
	//Instantiate all hex drivers
	HexDriver AhexU_inst
   (
       .In0(A[7:4]),
       .Out0(AhexU_comb)
   );
	
   HexDriver AhexL_inst
   (
       .In0(A[3:0]),
       .Out0(AhexL_comb)
   );
    
   HexDriver BhexU_inst
   (
       .In0(B[7:4]),
       .Out0(BhexU_comb)
   );
    
   HexDriver BhexL_inst
   (
       .In0(B[3:0]),
       .Out0(BhexL_comb)
   );
	
   assign Aval = A;
   assign Bval = B;
	
endmodule
