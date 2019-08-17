// 16 bit register.
module reg_16 (input  logic Clk, LoadEn, Reset,
			   input  logic [15:0] IN,
			   output logic [15:0] OUT);
					
			always_ff @ (posedge Clk)
			begin
				if (~Reset)				// clear on reset
					OUT <= 16'h0;
				else if (LoadEn)		// load input if load is enabled
					OUT <= IN;
			end

endmodule

// 8 16-bit register memory array for CPU
module REG_FILE (input  logic Clk, LoadEn, Reset,
				 input  logic [2:0]  SR1_IN, SR2, DR_IN,
				 input  logic [15:0] IN,
				 output logic [15:0] SR1_OUT, SR2_OUT);
			
			logic [7:0][15:0] OUT;
			
			always_ff @ (posedge Clk)
			begin
				if (~Reset)
				begin
					OUT[0] <= 16'h0;
					OUT[1] <= 16'h0;
					OUT[2] <= 16'h0;
					OUT[3] <= 16'h0;
					OUT[4] <= 16'h0;
					OUT[5] <= 16'h0;
					OUT[6] <= 16'h0;
					OUT[7] <= 16'h0;
				end

				else if (LoadEn)	// if load enabled, load to destination register
					case(DR_IN)
						3'b000: OUT[0] <= IN;
						3'b001: OUT[1] <= IN;
						3'b010: OUT[2] <= IN;
						3'b011: OUT[3] <= IN;
						3'b100: OUT[4] <= IN;
						3'b101: OUT[5] <= IN;
						3'b110: OUT[6] <= IN;
						3'b111: OUT[7] <= IN;
						default: ;
					endcase
			end

			always_comb //Always output a SR1 and SR2
			begin	
				case(SR1_IN) //Output SR1
						3'b000: SR1_OUT <= OUT[0];
						3'b001: SR1_OUT <= OUT[1];
						3'b010: SR1_OUT <= OUT[2];
						3'b011: SR1_OUT <= OUT[3];
						3'b100: SR1_OUT <= OUT[4];
						3'b101: SR1_OUT <= OUT[5];
						3'b110: SR1_OUT <= OUT[6];
						3'b111: SR1_OUT <= OUT[7];
						default: ;
				endcase
				
				case(SR2) //Output SR2
						3'b000: SR2_OUT <= OUT[0];
						3'b001: SR2_OUT <= OUT[1];
						3'b010: SR2_OUT <= OUT[2];
						3'b011: SR2_OUT <= OUT[3];
						3'b100: SR2_OUT <= OUT[4];
						3'b101: SR2_OUT <= OUT[5];
						3'b110: SR2_OUT <= OUT[6];
						3'b111: SR2_OUT <= OUT[7];
						default: ;
				endcase
			end

endmodule