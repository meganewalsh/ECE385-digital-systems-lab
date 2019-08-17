/************************************************************************
Avalon-MM Interface for AES Decryption IP Core

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department

Register Map:

 0-3 : 4x 32bit AES Key
 4-7 : 4x 32bit AES Encrypted Message
 8-11: 4x 32bit AES Decrypted Message
   12: Not Used
	13: Not Used
   14: 32bit Start Register
   15: 32bit Done Register

************************************************************************/

module avalon_aes_interface (
	// Avalon Clock Input
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,						// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,		// Avalon-MM Byte Enable
	input  logic [3:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,	// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,	// Avalon-MM Read Data
	
	// Exported Conduit
	output logic [31:0] EXPORT_DATA		// Exported Conduit Signal to LEDs
);

	logic [127:0] aes_msg_dec;
	logic [31:0] regfile [16];
	

	always_ff @ (posedge CLK) begin
	
		if (RESET) begin
			for (int i = 0; i < 32; i++)
				regfile[i] <= 16'b0;
		end
		
		else if (AVL_WRITE && AVL_CS) begin
		
			if(AVL_BYTE_EN == 4'b1111)
				regfile[AVL_ADDR] <= AVL_WRITEDATA;
				
			if(AVL_BYTE_EN == 4'b1100)
				regfile[AVL_ADDR][31:16] <= AVL_WRITEDATA[31:16];
				
			if(AVL_BYTE_EN == 4'b0011)
				regfile[AVL_ADDR][15:0] <= AVL_WRITEDATA[15:0];
				
			if(AVL_BYTE_EN == 4'b1000)
				regfile[AVL_ADDR][31:24] <= AVL_WRITEDATA[31:24];
				
			if(AVL_BYTE_EN == 4'b0100)
				regfile[AVL_ADDR][23:16] <= AVL_WRITEDATA[23:16];
				
			if(AVL_BYTE_EN == 4'b0010)
				regfile[AVL_ADDR][15:8] <= AVL_WRITEDATA[15:8];
				
			if(AVL_BYTE_EN == 4'b0001)
				regfile[AVL_ADDR][7:0] <= AVL_WRITEDATA[7:0];	
		end	
		
	end
	
	always_comb begin
		if(AVL_READ && AVL_CS)
			AVL_READDATA = regfile[AVL_ADDR];
		else
			AVL_READDATA = 16'b0;
	end
	
	//first 2 and last 2 bytes of decrypted message
	//assign EXPORT_DATA = {regfile[8][31:16], regfile[11][15:0]};
	//first 2 and last 2 bytes of decrypted message
	assign EXPORT_DATA = {regfile[4][31:16], regfile[7][15:0]};
	
	AES(
		.CLK(CLK),
		.RESET(RESET),
		.AES_START(regfile[14][0]),
		.AES_DONE(regfile[15][0]),
		.AES_KEY( {regfile[0], regfile[1], regfile[2], regfile[3]} ),
		.AES_MSG_ENC( {regfile[4], regfile[5], regfile[6], regfile[7]} ),
		.AES_MSG_DEC(aes_msg_dec)
	);

	always_comb begin
		regfile[8]  <= aes_msg_dec[127:96];
		regfile[9]  <= aes_msg_dec[95:64];
		regfile[10] <= aes_msg_dec[63:32];
		regfile[11] <= aes_msg_dec[31:0];
	end
	
	
endmodule
