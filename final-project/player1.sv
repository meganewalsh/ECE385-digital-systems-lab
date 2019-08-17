module P1 ( input [12:0]  DrawX, DrawY,

                 output logic  is_P,
					  output logic [10:0] sprite_addr_P );

logic [10:0] start_x = 215;
logic [10:0] start_y = 400;
logic [10:0] size_x = 8;
logic [10:0] size_y = 16;

always_comb begin
	if ( DrawX >= start_x & DrawX < start_x + size_x & DrawY >= start_y & DrawY < start_y + size_y ) begin
		is_P = 1'b1;
		sprite_addr_P = (DrawY - start_y + 16*'h50);
	end
	else begin
		is_P = 1'b0;
		sprite_addr_P = 10'b0;
	end
end
	
endmodule

module L1 ( input [12:0]  DrawX, DrawY,

                 output logic  is_L,
					  output logic [10:0] sprite_addr_L );

logic [10:0] start_x = 223;
logic [10:0] start_y = 400;
logic [10:0] size_x = 8;
logic [10:0] size_y = 16;

always_comb begin
	if ( DrawX >= start_x & DrawX < start_x + size_x & DrawY >= start_y & DrawY < start_y + size_y ) begin
		is_L = 1'b1;
		sprite_addr_L = (DrawY - start_y + 16*'h6c);
	end
	else begin
		is_L = 1'b0;
		sprite_addr_L = 10'b0;
	end
end
	
endmodule

module A1 ( input [12:0]  DrawX, DrawY,

                 output logic  is_A,
					  output logic [10:0] sprite_addr_A );

logic [10:0] start_x = 231;
logic [10:0] start_y = 400;
logic [10:0] size_x = 8;
logic [10:0] size_y = 16;

always_comb begin
	if ( DrawX >= start_x & DrawX < start_x + size_x & DrawY >= start_y & DrawY < start_y + size_y ) begin
		is_A = 1'b1;
		sprite_addr_A = (DrawY - start_y + 16*'h61);
	end
	else begin
		is_A = 1'b0;
		sprite_addr_A = 10'b0;
	end
end
	
endmodule

module Y1 ( input [12:0]  DrawX, DrawY,

                 output logic  is_Y,
					  output logic [10:0] sprite_addr_Y );

logic [10:0] start_x = 239;
logic [10:0] start_y = 400;
logic [10:0] size_x = 8;
logic [10:0] size_y = 16;

always_comb begin
	if ( DrawX >= start_x & DrawX < start_x + size_x & DrawY >= start_y & DrawY < start_y + size_y ) begin
		is_Y = 1'b1;
		sprite_addr_Y = (DrawY - start_y + 16*'h79);
	end
	else begin
		is_Y = 1'b0;
		sprite_addr_Y = 10'b0;
	end
end
	
endmodule

module E1 ( input [12:0]  DrawX, DrawY,

                 output logic  is_E,
					  output logic [10:0] sprite_addr_E );

logic [10:0] start_x = 247;
logic [10:0] start_y = 400;
logic [10:0] size_x = 8;
logic [10:0] size_y = 16;

always_comb begin
	if ( DrawX >= start_x & DrawX < start_x + size_x & DrawY >= start_y & DrawY < start_y + size_y ) begin
		is_E = 1'b1;
		sprite_addr_E = (DrawY - start_y + 16*'h65);
	end
	else begin
		is_E = 1'b0;
		sprite_addr_E = 10'b0;
	end
end
	
endmodule

module R1 ( input [12:0]  DrawX, DrawY,

                 output logic  is_R,
					  output logic [10:0] sprite_addr_R );

logic [10:0] start_x = 255;
logic [10:0] start_y = 400;
logic [10:0] size_x = 8;
logic [10:0] size_y = 16;

always_comb begin
	if ( DrawX >= start_x & DrawX < start_x + size_x & DrawY >= start_y & DrawY < start_y + size_y ) begin
		is_R = 1'b1;
		sprite_addr_R = (DrawY - start_y + 16*'h72);
	end
	else begin
		is_R = 1'b0;
		sprite_addr_R = 10'b0;
	end
end
	
endmodule


module p1 ( input [12:0]  DrawX, DrawY,

                 output logic  is_1,
					  output logic [10:0] sprite_addr_1 );

logic [10:0] start_x = 267;
logic [10:0] start_y = 400;
logic [10:0] size_x = 8;
logic [10:0] size_y = 16;

always_comb begin
	if ( DrawX >= start_x & DrawX < start_x + size_x & DrawY >= start_y & DrawY < start_y + size_y ) begin
		is_1 = 1'b1;
		sprite_addr_1 = (DrawY - start_y + 16*'h31);
	end
	else begin
		is_1 = 1'b0;
		sprite_addr_1 = 10'b0;
	end
end
	
endmodule