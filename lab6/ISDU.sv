//------------------------------------------------------------------------------
// Company: 		 UIUC ECE Dept.
// Engineer:		 Stephen Kempf
//
// Create Date:    17:44:03 10/08/06
// Design Name:    ECE 385 Lab 6 Given Code - Incomplete ISDU
// Module Name:    ISDU - Behavioral
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 02-13-2017
//    Spring 2017 Distribution
//------------------------------------------------------------------------------


module ISDU ( 	input logic			Clk, 
                        			Reset,
									Run,
									Continue,
									
				input logic[3:0] 	Opcode, 
				input logic     	IR_5,
				input logic     	IR_11,
				input logic 		BEN,
				  
				output logic 		LD_MAR,
									LD_MDR,
									LD_IR,
									LD_BEN,
									LD_CC,
									LD_REG,
									LD_PC,
									LD_LED, // for PAUSE instruction
									
				output logic 		GatePC,
									GateMDR,
									GateALU,
									GateMARMUX,
									
				output logic [1:0] 	PCMUX,
				output logic        DRMUX,
									SR1MUX,
									SR2MUX,
									ADDR1MUX,
				output logic [1:0] 	ADDR2MUX,
									ALUK,
				  
				output logic 		Mem_CE,
									Mem_UB,
									Mem_LB,
									Mem_OE,
									Mem_WE
				);
				
	 logic OE, WE; //ouput and write enable for synchornizer

    enum logic [4:0] {	Halted, 
    					PauseIR1, Pause,
    					PauseIR2, Pause2,	
    					S_18, S_33_1, S_33_2, S_35, S_32, 
    					S_01,
						S_05,
						S_09,
						S_06, S_25_1, S_25_2, S_27,
						S_07, S_23, S_16_1, S_16_2,
						S_00, S_22,
						S_12,
						S_04, S_21}   State, Next_state;   // Internal state logic
	    
    always_ff @ (posedge Clk)
    begin : Assign_Next_State
        if (Reset) 
            State <= Halted;
        else 
            State <= Next_state;
    end
   
	always_comb
    begin 
    	// Default next state is staying at current state
	    Next_state = State;
	 
        unique case (State)
            Halted : 
	            if (Run) 
					Next_state <= S_18;					  
            S_18 : 
                Next_state <= S_33_1;
            // Any states involving SRAM require more than one clock cycles.
            // The exact number will be discussed in lecture.
            S_33_1 : 
                Next_state <= S_33_2;
            S_33_2 : 
                Next_state <= S_35;
            S_35 : 
                Next_state <= S_32;
            // PauseIR1 and PauseIR2 are only for Week 1 such that TAs can see 
            // the values in IR. They should be removed in Week 2
            PauseIR1 : 
	            if (~Continue) 
	                Next_state <= PauseIR1;
	            else 
	                Next_state <= PauseIR2;
            PauseIR2 : 
                if (Continue) 
                    Next_state <= PauseIR2;
                else 
                    Next_state <= S_32;
		    Pause : 
                if (~Continue) 
                    Next_state <= Pause;
                else 
                    Next_state <= Pause2;
            Pause2 : 
                if (Continue) 
                    Next_state <= Pause2;
                else 
                    Next_state <= S_18;
            S_32 : 
				case (Opcode)
					4'b0001 : //ADD
					    Next_state <= S_01;
					4'b0101 : //AND
					    Next_state <= S_05;
				   4'b1001 : //NOT
					    Next_state <= S_09;
					4'b0000 : //BR
					    Next_state <= S_00;
					4'b1100 : //JMP
					    Next_state <= S_12;
					4'b0100 : //JSR
					    Next_state <= S_04;
					4'b0110 : //LDR
					    Next_state <= S_06;
					4'b0111 : //STR
					    Next_state <= S_07;
				   4'b1101 : //PSE
					    Next_state <= Pause;
					default : 
					    Next_state <= S_18;
				endcase
            S_01 : //ADD
				Next_state <= S_18;
			S_05 : //AND
				Next_state <= S_18;
			S_09 : //NOT
				Next_state <= S_18;
			S_06 : //LDR
				Next_state <= S_25_1;
			S_25_1 : 
				Next_state <= S_25_2;
			S_25_2 : 
				Next_state <= S_27;
			S_27 : 
				Next_state <= S_18;
			S_07 : //STR
				Next_state <= S_23;
			S_23 : 
				Next_state <= S_16_1;
			S_16_1 : 
				Next_state <= S_16_2;
			S_16_2 : 
				Next_state <= S_18;
			S_00 : //BR
				if(BEN)
					Next_state <= S_22;
				else
					Next_state <= S_18;
			S_22 : 
				Next_state <= S_18;
			S_12 : //JMP
				Next_state <= S_18;
			S_04 : //JSR
				Next_state <= S_21;
			S_21 : 
				Next_state <= S_18;
			default : ;

	     endcase
    end
   
    always_comb
    begin 
        // default controls signal values; within a process, these can be
        // overridden further down (in the case statement, in this case)
	    LD_MAR = 1'b0; //NO
	    LD_MDR = 1'b0; //NO
	    LD_IR = 1'b0;  //NO 
	    LD_BEN = 1'b0; //NO
	    LD_CC = 1'b0;  //NO
	    LD_REG = 1'b0; //NO
	    LD_PC = 1'b0;  //NO
	    LD_LED = 1'b0; //NO
		 
	    GatePC = 1'b0; //NO
	    GateMDR = 1'b0; //NO
	    GateALU = 1'b0; //NO
	    GateMARMUX = 1'b0; //NO
		 
		ALUK = 2'b00; //ADD
		 
	    PCMUX = 2'b00; //PC + 1
	    DRMUX = 1'b0;  //IR[11:9]
	    SR1MUX = 1'b0; //IR[11:9]
	    SR2MUX = 1'b0; //SR2 OUT
	    ADDR1MUX = 1'b0;//PC
	    ADDR2MUX = 2'b00;//ZERO
		
		// Assign control signals based on current state
	    case (State)
			Halted:
			begin
				Mem_OE = 1'b1;
				Mem_WE = 1'b1;
			end
			S_18 : //MAR <- PC
			       //PC <- PC + 1
			begin 
				GatePC = 1'b1;
				LD_MAR = 1'b1;
				PCMUX = 2'b00;
				LD_PC = 1'b1;

				Mem_OE = 1'b1;
				Mem_WE = 1'b1;
			end
			S_33_1 : //MDR <- M[MAR]
			begin
				Mem_OE = 1'b0;
				Mem_WE = 1'b1;
			end
			S_33_2 : //MDR <- M[MAR]
			begin
				Mem_OE = 1'b0;
				Mem_WE = 1'b1;
				LD_MDR = 1'b1;
			end
            S_35 : //IR <- MDR
            begin 
				GateMDR = 1'b1;
				LD_IR = 1'b1;

				Mem_OE = 1'b1;
				Mem_WE = 1'b1;
			end
			PauseIR1:
			begin
				Mem_OE = 1'b1;
				Mem_WE = 1'b1;
			end
            PauseIR2:
            begin
            	Mem_OE = 1'b1;
				Mem_WE = 1'b1;
			end
            Pause: 
            begin
				LD_LED = 1'b1;

				Mem_OE = 1'b1;
				Mem_WE = 1'b1;
			end
            Pause2:
            begin
            	Mem_OE = 1'b1;
				Mem_WE = 1'b1;
			end
            S_32 : //BEN <- IR[11] & N + IR[10] & Z + IR[9] & P
			       //[IR[15:12]]
			begin
                LD_BEN = 1'b1;

                Mem_OE = 1'b1;
				Mem_WE = 1'b1;
            end
            S_01 : //ADD (DR <- SR1 + OP2, setCC)
            begin 
				SR2MUX = IR_5; //SR2 or imm5
				SR1MUX = 1'b1; //IR[8:6]
				ALUK = 2'b00;
				GateALU = 1'b1; 
				LD_REG = 1'b1; 
				LD_CC = 1'b1;

				Mem_OE = 1'b1;
				Mem_WE = 1'b1;
            end
			S_05 : //AND (DR <- SR1 & OP2, setCC)
            begin 
				SR2MUX = IR_5; //SR2 or imm5
				SR1MUX = 1'b1; //IR[8:6]
				ALUK = 2'b01;  //AND
				GateALU = 1'b1;
				LD_REG = 1'b1;
				LD_CC = 1'b1;

				Mem_OE = 1'b1;
				Mem_WE = 1'b1;
            end
			S_09 : //NOT (DR <- NOT(SR1), setCC)
			begin 
				SR1MUX = 1'b1; //IR[8:6]
				ALUK = 2'b10;  //NOT
				GateALU = 1'b1;
				LD_REG = 1'b1;
				LD_CC = 1'b1;

				Mem_OE = 1'b1;
				Mem_WE = 1'b1;
            end
			S_00 ://BR ([BEN])
			begin
				Mem_OE = 1'b1;
				Mem_WE = 1'b1;
			end
			S_22 : //PC <- PC + off9
			begin 
				ADDR1MUX = 1'b0;
				ADDR2MUX = 2'b10; // off9 IR[8:0] sext7
				PCMUX = 2'b10;    // ADDER
				LD_PC = 1'b1;

				Mem_OE = 1'b1;
				Mem_WE = 1'b1;
            end
		    S_12 : //JMP (PC <- BaseR)
			begin
				SR1MUX = 1'b1; //IR[8:6]
				ADDR1MUX = 1'b1; //BaseR
				ADDR2MUX = 2'b00;
				PCMUX = 2'b10; //ADDER
				LD_PC = 1'b1;

				Mem_OE = 1'b1;
				Mem_WE = 1'b1;
			end
			S_04 : //JSR (R7 <- PC)
			begin
				GatePC = 1'b1;
				DRMUX = IR_11; //R7 (111)
				LD_REG = 1'b1;

				Mem_OE = 1'b1;
				Mem_WE = 1'b1;
			end
			S_21 : //PC <- PC + off11
			begin
				ADDR1MUX = 1'b0;
				ADDR2MUX = 2'b11; //off11 IR[10:0] sext5
				PCMUX = 2'b10; //ADDER
				LD_PC = 1'b1;

				Mem_OE = 1'b1;
				Mem_WE = 1'b1;
			end
			S_06 : //LDR (MAR <- B + off6)
			begin
				SR1MUX = 1'b1; //IR[8:6]
				ADDR1MUX = 1'b1; //BaseR SR1 OUT
				ADDR2MUX = 2'b01; //off6 IR[5:0] sext10
				GateMARMUX = 1'b1;
				LD_MAR = 1'b1;

				Mem_OE = 1'b1;
				Mem_WE = 1'b1;
			end	
			S_25_1: //MDR <- M[MAR]
			begin
				Mem_WE = 1'b1;
				Mem_OE = 1'b0; //Active	
			end
			S_25_2: //MDR <- M[MAR]
			begin
				Mem_OE = 1'b0;
				Mem_WE = 1'b1;
				LD_MDR = 1'b1;
			end
			S_27 : //DR <- MDR, setCC
			begin
				GateMDR = 1'b1;
				LD_REG = 1'b1;
				LD_CC = 1'b1;

				Mem_OE = 1'b1;
				Mem_WE = 1'b1;
			end
			S_07 : //STR (MAR <- B + off6)
			begin
				SR1MUX = 1'b1; //IR[8:6]
				ADDR1MUX = 1'b1; //BaseR SR1 OUT
				ADDR2MUX = 2'b01; //off6 IR[5:0] sext10
				GateMARMUX = 1'b1;
				LD_MAR = 1'b1;

				Mem_OE = 1'b1;
				Mem_WE = 1'b1;
			end
			S_23 : //MDR <- SR
			begin
				SR1MUX = 1'b0;
				ALUK = 2'b11; //PASSA
				GateALU = 1'b1;
				LD_MDR = 1'b1;

				Mem_OE = 1'b1;
				Mem_WE = 1'b1;
			end
			S_16_1 : //M[MAR] <- MDR
			begin
				Mem_OE = 1'b1;
				Mem_WE = 1'b0;
			end
			S_16_2 : //M[MAR] <- MDR
			begin
				Mem_OE = 1'b1;
				Mem_WE = 1'b0;
			end
            default :
            begin
            	Mem_OE = 1'b1;
				Mem_WE = 1'b1;
			end
        endcase
    end 

 	// These should always be active
	assign Mem_CE = 1'b0;
	assign Mem_UB = 1'b0;
	assign Mem_LB = 1'b0;
	
endmodule