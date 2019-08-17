module P2 ( input [12:0]  DrawX, DrawY,

                 output logic  is_P2,
					  output logic [10:0] sprite_addr_P2 );

logic [10:0] start_x = 364;
logic [10:0] start_y = 400;
logic [10:0] size_x = 8;
logic [10:0] size_y = 16;

always_comb begin
	if ( DrawX >= start_x & DrawX < start_x + size_x & DrawY >= start_y & DrawY < start_y + size_y ) begin
		is_P2 = 1'b1;
		sprite_addr_P2 = (DrawY - start_y + 16*'h50);
	end
	else begin
		is_P2 = 1'b0;
		sprite_addr_P2 = 10'b0;
	end
end
	
endmodule

module L2 ( input [12:0]  DrawX, DrawY,

                 output logic  is_L2,
					  output logic [10:0] sprite_addr_L2 );

logic [10:0] start_x = 372;
logic [10:0] start_y = 400;
logic [10:0] size_x = 8;
logic [10:0] size_y = 16;

always_comb begin
	if ( DrawX >= start_x & DrawX < start_x + size_x & DrawY >= start_y & DrawY < start_y + size_y ) begin
		is_L2 = 1'b1;
		sprite_addr_L2 = (DrawY - start_y + 16*'h6c);
	end
	else begin
		is_L2 = 1'b0;
		sprite_addr_L2 = 10'b0;
	end
end
	
endmodule

module A2 ( input [12:0]  DrawX, DrawY,

                 output logic  is_A2,
					  output logic [10:0] sprite_addr_A2 );

logic [10:0] start_x = 380;
logic [10:0] start_y = 400;
logic [10:0] size_x = 8;
logic [10:0] size_y = 16;

always_comb begin
	if ( DrawX >= start_x & DrawX < start_x + size_x & DrawY >= start_y & DrawY < start_y + size_y ) begin
		is_A2 = 1'b1;
		sprite_addr_A2 = (DrawY - start_y + 16*'h61);
	end
	else begin
		is_A2 = 1'b0;
		sprite_addr_A2 = 10'b0;
	end
end
	
endmodule

module Y2 ( input [12:0]  DrawX, DrawY,

                 output logic  is_Y2,
					  output logic [10:0] sprite_addr_Y2 );

logic [10:0] start_x = 388;
logic [10:0] start_y = 400;
logic [10:0] size_x = 8;
logic [10:0] size_y = 16;

always_comb begin
	if ( DrawX >= start_x & DrawX < start_x + size_x & DrawY >= start_y & DrawY < start_y + size_y ) begin
		is_Y2 = 1'b1;
		sprite_addr_Y2 = (DrawY - start_y + 16*'h79);
	end
	else begin
		is_Y2 = 1'b0;
		sprite_addr_Y2 = 10'b0;
	end
end
	
endmodule

module E2 ( input [12:0]  DrawX, DrawY,

                 output logic  is_E2,
					  output logic [10:0] sprite_addr_E2 );

logic [10:0] start_x = 396;
logic [10:0] start_y = 400;
logic [10:0] size_x = 8;
logic [10:0] size_y = 16;

always_comb begin
	if ( DrawX >= start_x & DrawX < start_x + size_x & DrawY >= start_y & DrawY < start_y + size_y ) begin
		is_E2 = 1'b1;
		sprite_addr_E2 = (DrawY - start_y + 16*'h65);
	end
	else begin
		is_E2 = 1'b0;
		sprite_addr_E2 = 10'b0;
	end
end
	
endmodule

module R2 ( input [12:0]  DrawX, DrawY,

                 output logic  is_R2,
					  output logic [10:0] sprite_addr_R2 );

logic [10:0] start_x = 404;
logic [10:0] start_y = 400;
logic [10:0] size_x = 8;
logic [10:0] size_y = 16;

always_comb begin
	if ( DrawX >= start_x & DrawX < start_x + size_x & DrawY >= start_y & DrawY < start_y + size_y ) begin
		is_R2 = 1'b1;
		sprite_addr_R2 = (DrawY - start_y + 16*'h72);
	end
	else begin
		is_R2 = 1'b0;
		sprite_addr_R2 = 10'b0;
	end
end
	
endmodule


module p2 ( input [12:0]  DrawX, DrawY,

                 output logic  is_2,
					  output logic [10:0] sprite_addr_2 );

logic [10:0] start_x = 416;
logic [10:0] start_y = 400;
logic [10:0] size_x = 8;
logic [10:0] size_y = 16;

always_comb begin
	if ( DrawX >= start_x & DrawX < start_x + size_x & DrawY >= start_y & DrawY < start_y + size_y ) begin
		is_2 = 1'b1;
		sprite_addr_2 = (DrawY - start_y + 16*'h32);
	end
	else begin
		is_2 = 1'b0;
		sprite_addr_2 = 10'b0;
	end
end
	
endmodule