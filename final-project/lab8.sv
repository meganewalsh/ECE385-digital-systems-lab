//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab8( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1, HEX2, HEX4, HEX6,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK      //SDRAM Clock
                    );
    
    logic Reset_h, Clk, StartGame, Start, correct_key1, correct_key2;
	 logic [1:0] data_R, data_G;
	 reg [99:0] LFSR_result, LFSRa;
    logic [15:0] keycode;
	 logic [9:0] X, Y;
	 logic is_outline1, is_black1, is_pink1, is_white1, is_red1;
	 logic is_outline2, is_black2, is_pink2, is_white2, is_title;
	 logic is_P, is_L, is_A, is_Y, is_E, is_R, is_1, is_n1p1;
	 logic is_P2, is_L2, is_A2, is_Y2, is_E2, is_R2, is_2, is_n2p2;
	 logic is_goG, is_goA, is_goM, is_goE, is_goO, is_goV, is_goE2, is_goR, is_goA1, is_goA2;
	 logic [10:0] sprite_addr_goG, sprite_addr_goA, sprite_addr_goM, sprite_addr_goE, sprite_addr_goO, sprite_addr_goV, sprite_addr_goE2, sprite_addr_goR, sprite_addr_goA1, sprite_addr_goA2;
	 logic [2:0] random_array1 [99:0];
	 logic [2:0] random_array2 [99:0];
	 integer row_counter1, row_counter2, current_row, winner, winner2, winner3, game, is_GameOver, OVERALL_winner;
	 logic [10:0] sprite_addr_L, sprite_addr_P, sprite_addr_A, sprite_addr_Y, sprite_addr_E, sprite_addr_R, sprite_addr_1, sprite_addr_n1p1, sprite_addr_n1p2, sprite_addr_title;
	 logic [10:0] sprite_addr_L2, sprite_addr_P2, sprite_addr_A2, sprite_addr_Y2, sprite_addr_E2, sprite_addr_R2, sprite_addr_2, sprite_addr_n2p2, sprite_addr_n2p1; 
 
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
		  Start <= (KEY[3]);
    end
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
    
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     nios_system nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode),  
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset)
    );
    
    // Use PLL to generate the 25MHZ VGA_CLK.
    // You will have to generate it on your own in simulation.
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
	 
    // TODO: Fill in the connections for the rest of the modules 
    VGA_controller vga_controller_instance(
						.*,
						.Reset(Reset_h),
						.DrawX(X),
						.DrawY(Y)
	 );
   
	 generator gen1(
						.*,
						.clk(VGA_CLK),
						.Reset(Reset_h),
						.array_in(random_array1),
						.array_out(random_array1),
						.new_row1(row_counter1),
						.game_in(game)
	 );
	 
	 generator2 gen2(
						.*,
						.clk(VGA_CLK),
						.Reset(Reset_h),
						.array_in(random_array2),
						.array_out(random_array2),
						.new_row2(row_counter2)
	 );
	 
    P1_Board board1(
						.*,
						.Reset(Reset_h),
						.frame_clk(VGA_VS),
						.DrawX(X),
						.DrawY(Y)
	);
	  
	P2_Board board2(
						.*,
						.Reset(Reset_h),
						.frame_clk(VGA_VS),
						.DrawX(X),
						.DrawY(Y)
	);
	
	key_presses1 P1_Presses (.*);
	
   key_presses2 P2_Presses (.*);
	 
    color_mapper color_instance(.*, .DrawX(X), .DrawY(Y) );
	 
	 P1 P1 ( .*, .DrawX(X), .DrawY(Y), .is_P(is_P) );
	 L1 L1 ( .*, .DrawX(X), .DrawY(Y), .is_L(is_L) );
	 A1 A1 ( .*, .DrawX(X), .DrawY(Y), .is_A(is_A) );
	 Y1 Y1 ( .*, .DrawX(X), .DrawY(Y), .is_Y(is_Y) );
	 E1 E1 ( .*, .DrawX(X), .DrawY(Y), .is_E(is_E) );
	 R1 R1 ( .*, .DrawX(X), .DrawY(Y), .is_R(is_R) );
	 p1 p1 ( .*, .DrawX(X), .DrawY(Y), .is_1(is_1) );

	 P2 P2 ( .*, .DrawX(X), .DrawY(Y), .is_P2(is_P2) );
	 L2 L2 ( .*, .DrawX(X), .DrawY(Y), .is_L2(is_L2) );
	 A2 A2 ( .*, .DrawX(X), .DrawY(Y), .is_A2(is_A2) );
	 Y2 Y2 ( .*, .DrawX(X), .DrawY(Y), .is_Y2(is_Y2) );
	 E2 E2 ( .*, .DrawX(X), .DrawY(Y), .is_E2(is_E2) );
	 R2 R2 ( .*, .DrawX(X), .DrawY(Y), .is_R2(is_R2) );
	 p2 p2 ( .*, .DrawX(X), .DrawY(Y), .is_2(is_2) );
	 
	 note1_player1 n1p1_inst ( .*, .DrawX(X), .DrawY(Y), .is_n1p1(is_n1p1) );
	 note2_player2 n2p2_inst ( .*, .DrawX(X), .DrawY(Y), .is_n2p2(is_n2p2) );
	 note2_player1 n2p1_inst ( .*, .DrawX(X), .DrawY(Y), .is_n2p1(is_n2p1) );
	 note1_player2 n1p2_inst ( .*, .DrawX(X), .DrawY(Y), .is_n1p2(is_n1p2) );
	 
	 determine_winners Winner( .*, .winner_in(winner), .winner2_in(winner2), .winner3_in(winner3) );
	 overall_winner OW( .* );
	 checkGameOver cGO ( .* );
	 go_G  G_inst(  .*, .DrawX(X), .DrawY(Y) );
	 go_A  A_inst(  .*, .DrawX(X), .DrawY(Y) );
	 go_M  M_inst(  .*, .DrawX(X), .DrawY(Y) );
 	 go_E  E_inst(  .*, .DrawX(X), .DrawY(Y) );
 	 go_O  O_inst(  .*, .DrawX(X), .DrawY(Y) );
	 go_V  V_inst(  .*, .DrawX(X), .DrawY(Y) );
	 go_E2 E2_inst( .*, .DrawX(X), .DrawY(Y) );
	 go_R  R_inst(  .*, .DrawX(X), .DrawY(Y) );
	 go_A1  A1_inst(  .*, .DrawX(X), .DrawY(Y) );
	 go_A2  A2_inst(  .*, .DrawX(X), .DrawY(Y) );

	// title  title_inst(  .*, .DrawX(X), .DrawY(Y) );

	 
	 LFSR lfsr ( .i_Clk(Clk), .o_LFSR_Data(LFSRa) );
    stopLFSR8_11D stop( .* );
	 PushButton_Debouncer ( .clk(Clk), .PB(Start), .PB_down(StartGame) );
    
    HexDriver hex_inst_0 ( winner, HEX0);
    HexDriver hex_inst_1 ( winner2, HEX1);
    HexDriver hex_inst_2 ( winner3, HEX2);
	 HexDriver hex_inst_4 ( game, HEX4);
	 HexDriver hex_inst_6 ( is_GameOver, HEX6);

	 
	/* HexDriver hex_inst_0 ( keycode[3:0], HEX0);
    HexDriver hex_inst_1 ( keycode[7:4], HEX1);
    HexDriver hex_inst_2 ( keycode[11:8], HEX2);
	 HexDriver hex_inst_3 ( keycode[15:12], HEX3);*/


endmodule
