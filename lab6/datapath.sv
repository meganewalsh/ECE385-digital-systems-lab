module datapath (input  logic Reset, Clk,	//button input signals
					  input  logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED,	//register load enables
					  input  logic GatePC, GateMDR, GateALU, GateMARMUX,	// gate passage enables
					  input  logic [1:0] PCMUX, ADDR2MUX, ALUK,				// 2-bit select inputs
					  input  logic DRMUX, SR1MUX, SR2MUX, ADDR1MUX, MIO_EN,	// other select inputs
					  input  logic [15:0] MDR_In,									// data from inout source
					  output logic BEN,												// branch enable
					  output logic [11:0] LED,										// for pause instruction
					  output logic [15:0] IR, MDR, MAR);						// output register  values
	
	// internal connection variables
	logic [15:0] PC, PCMUX_OUT, BUS;
	logic [15:0] SEXT5, SEXT7, SEXT10, SEXT11;
	logic [15:0] ADDR2_OUT, ADDR1_OUT, ADDER_OUT;
	logic [15:0] ALU_OUT, MDRMUX_OUT;
	logic [15:0] SR2_OUT, SR1_OUT, SR2MUX_OUT;
	logic [2:0]  DR_IN, SR1_IN, SR2;
	logic N_IN, Z_IN, P_IN;
	logic N_OUT, Z_OUT, P_OUT;
	
	assign SR2 = IR[2:0];	// for add and and instructions
	
	// I/O for the instruction register 
	reg_16 IR_REG (.*, .LoadEn(LD_IR), .IN(BUS), .OUT(IR)); 
	
	//sign extend the outputs of IR
	SEXT_5 S5 (.IN(IR[10:0]), .OUT(SEXT5));
	SEXT_7 S7 (.IN(IR[8:0]), .OUT(SEXT7));
	SEXT_10 S10 (.IN(IR[5:0]), .OUT(SEXT10));
	SEXT_11 S11 (.IN(IR[4:0]), .OUT(SEXT11));
	
	// Adder ALU for address muxes
	ADDR1_MUX ADDR1 (.IN0(PC), .IN1(SR1_OUT), .Select(ADDR1MUX), .OUT(ADDR1_OUT));
	ADDR2_MUX ADDR2 (.IN0(SEXT10), .IN1(SEXT7), .IN2(SEXT5), .Select(ADDR2MUX), .OUT(ADDR2_OUT));
	ALU ADD_ALU (.A(ADDR2_OUT), .B(ADDR1_OUT), .Select(2'b00), .OUT(ADDER_OUT));
	
	// program counter block
	PC_MUX PCMUX_ (.IN0(PC+1), .IN1(BUS), .IN2(ADDER_OUT), .Select(PCMUX), .OUT(PCMUX_OUT));
	reg_16 PC_REG(.*, .LoadEn(LD_PC), .IN(PCMUX_OUT), .OUT(PC));
	
	// Register file block 
	DR_MUX DRMUX_ (.IN(IR[11:9]), .Select(DRMUX), .OUT(DR_IN));
	SR1_MUX SR1MUX_ (.IN0(IR[11:9]), .IN1(IR[8:6]), .Select(SR1MUX), .OUT(SR1_IN));
	REG_FILE REGFILE (.*, .LoadEn(LD_REG), .IN(BUS));
	
	// ALU block for operations
	SR2_MUX SR2MUX_ (.IN0(SR2_OUT), .IN1(SEXT11), .Select(SR2MUX), .OUT(SR2MUX_OUT));
	ALU ALU_ (.A(SR1_OUT), .B(SR2MUX_OUT), .Select(ALUK), .OUT(ALU_OUT));
	
	// Gate MUX to control the BUS
	GATE_MUX gates (.Select({GatePC, GateMDR, GateMARMUX, GateALU}), .IN0(PC), .IN1(MDR), .IN2(ADDER_OUT), .IN3(ALU_OUT), .OUT(BUS));
	
	// NZP logic for condition codes
	NZP_Block NZP(.*);
	BEN_Reg BEN_REG (.*, .N(N_OUT), .Z(Z_OUT), .P(P_OUT), .IN(IR[11:9]));
	
	//Outside of BUS
	MDR_MUX MDRMUX(.IN0(BUS), .IN1(MDR_In), .Select(MIO_EN), .OUT(MDRMUX_OUT));
	reg_16 MDR_REG(.*, .LoadEn(LD_MDR), .IN(MDRMUX_OUT), .OUT(MDR));
	reg_16 MAR_REG(.*, .LoadEn(LD_MAR), .IN(BUS), .OUT(MAR));
	
	// logic for NZP
	always_comb
	begin	
		if (BUS[15])		//negative case
		begin
			N_IN = 1'b1;
			Z_IN = 1'b0;
			P_IN = 1'b0;
		end
		else
		begin
			case (BUS)
			
				16'h0:		//zero case
				begin
					N_IN = 1'b0;
					Z_IN = 1'b1;
					P_IN = 1'b0;
				end
				default:		//positive case
				begin
					N_IN = 1'b0;
					Z_IN = 1'b0;
					P_IN = 1'b1;
				end	
			endcase
		end
	end
	
	//load LED for pause instruction
	always_ff @ (posedge Clk)
	begin
	
		if (LD_LED)
			LED <= IR[11:0];
		else	
			LED <= 12'h0;
	
	end
	
endmodule