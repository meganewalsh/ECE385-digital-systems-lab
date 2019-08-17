module go_G ( input [12:0]  DrawX, DrawY,
              output logic  is_goG,
				  output logic [10:0] sprite_addr_goG );

logic [10:0] start_x = 282;
logic [10:0] start_y = 345;
logic [10:0] size_x = 8;
logic [10:0] size_y = 16;
always_comb begin
	if ( DrawX >= start_x & DrawX < start_x + size_x & DrawY >= start_y & DrawY < start_y + size_y ) begin
		is_goG = 1'b1;
		sprite_addr_goG = (DrawY - start_y + 16*'h47);
	end
	else begin
		is_goG = 1'b0;
		sprite_addr_goG = 10'b0;
	end
end
endmodule

module go_A ( input [12:0]  DrawX, DrawY,
              output logic  is_goA,
				  output logic [10:0] sprite_addr_goA );

logic [10:0] start_x = 290;
logic [10:0] start_y = 345;
logic [10:0] size_x = 8;
logic [10:0] size_y = 16;
always_comb begin
	if ( DrawX >= start_x & DrawX < start_x + size_x & DrawY >= start_y & DrawY < start_y + size_y ) begin
		is_goA = 1'b1;
		sprite_addr_goA = (DrawY - start_y + 16*'h41);
	end
	else begin
		is_goA = 1'b0;
		sprite_addr_goA = 10'b0;
	end
end
endmodule

module go_M ( input [12:0]  DrawX, DrawY,
              output logic  is_goM,
				  output logic [10:0] sprite_addr_goM );

logic [10:0] start_x = 298;
logic [10:0] start_y = 345;
logic [10:0] size_x = 8;
logic [10:0] size_y = 16;
always_comb begin
	if ( DrawX >= start_x & DrawX < start_x + size_x & DrawY >= start_y & DrawY < start_y + size_y ) begin
		is_goM = 1'b1;
		sprite_addr_goM = (DrawY - start_y + 16*'h4d);
	end
	else begin
		is_goM = 1'b0;
		sprite_addr_goM = 10'b0;
	end
end
endmodule

module go_E ( input [12:0]  DrawX, DrawY,
              output logic  is_goE,
				  output logic [10:0] sprite_addr_goE );

logic [10:0] start_x = 306;
logic [10:0] start_y = 345;
logic [10:0] size_x = 8;
logic [10:0] size_y = 16;
always_comb begin
	if ( DrawX >= start_x & DrawX < start_x + size_x & DrawY >= start_y & DrawY < start_y + size_y ) begin
		is_goE = 1'b1;
		sprite_addr_goE = (DrawY - start_y + 16*'h45);
	end
	else begin
		is_goE = 1'b0;
		sprite_addr_goE = 10'b0;
	end
end
endmodule

module go_O ( input [12:0]  DrawX, DrawY,
              output logic  is_goO,
				  output logic [10:0] sprite_addr_goO );

logic [10:0] start_x = 324;
logic [10:0] start_y = 345;
logic [10:0] size_x = 8;
logic [10:0] size_y = 16;
always_comb begin
	if ( DrawX >= start_x & DrawX < start_x + size_x & DrawY >= start_y & DrawY < start_y + size_y ) begin
		is_goO = 1'b1;
		sprite_addr_goO = (DrawY - start_y + 16*'h4f);
	end
	else begin
		is_goO = 1'b0;
		sprite_addr_goO = 10'b0;
	end
end
endmodule

module go_V ( input [12:0]  DrawX, DrawY,
              output logic  is_goV,
				  output logic [10:0] sprite_addr_goV );

logic [10:0] start_x = 332;
logic [10:0] start_y = 345;
logic [10:0] size_x = 8;
logic [10:0] size_y = 16;
always_comb begin
	if ( DrawX >= start_x & DrawX < start_x + size_x & DrawY >= start_y & DrawY < start_y + size_y ) begin
		is_goV = 1'b1;
		sprite_addr_goV = (DrawY - start_y + 16*'h56);
	end
	else begin
		is_goV = 1'b0;
		sprite_addr_goV = 10'b0;
	end
end
endmodule

module go_E2 ( input [12:0]  DrawX, DrawY,
              output logic  is_goE2,
				  output logic [10:0] sprite_addr_goE2 );

logic [10:0] start_x = 340;
logic [10:0] start_y = 345;
logic [10:0] size_x = 8;
logic [10:0] size_y = 16;
always_comb begin
	if ( DrawX >= start_x & DrawX < start_x + size_x & DrawY >= start_y & DrawY < start_y + size_y ) begin
		is_goE2 = 1'b1;
		sprite_addr_goE2 = (DrawY - start_y + 16*'h45);
	end
	else begin
		is_goE2 = 1'b0;
		sprite_addr_goE2 = 10'b0;
	end
end
endmodule

module go_R ( input [12:0]  DrawX, DrawY,
              output logic  is_goR,
				  output logic [10:0] sprite_addr_goR );

logic [10:0] start_x = 348;
logic [10:0] start_y = 345;
logic [10:0] size_x = 8;
logic [10:0] size_y = 16;
always_comb begin
	if ( DrawX >= start_x & DrawX < start_x + size_x & DrawY >= start_y & DrawY < start_y + size_y ) begin
		is_goR = 1'b1;
		sprite_addr_goR = (DrawY - start_y + 16*'h52);
	end
	else begin
		is_goR = 1'b0;
		sprite_addr_goR = 10'b0;
	end
end
endmodule

module go_A1 ( input [12:0]  DrawX, DrawY,
              output logic  is_goA1,
				  output logic [10:0] sprite_addr_goA1 );

logic [10:0] start_x = 267;
logic [10:0] start_y = 380;
logic [10:0] size_x = 8;
logic [10:0] size_y = 16;
always_comb begin
	if ( DrawX >= start_x & DrawX < start_x + size_x & DrawY >= start_y & DrawY < start_y + size_y ) begin
		is_goA1 = 1'b1;
		sprite_addr_goA1 = (DrawY - start_y + 16*'h19);
	end
	else begin
		is_goA1 = 1'b0;
		sprite_addr_goA1 = 10'b0;
	end
end
endmodule

module go_A2 ( input [12:0]  DrawX, DrawY,
              output logic  is_goA2,
				  output logic [10:0] sprite_addr_goA2 );

logic [10:0] start_x = 416;
logic [10:0] start_y = 380;
logic [10:0] size_x = 8;
logic [10:0] size_y = 16;
always_comb begin
	if ( DrawX >= start_x & DrawX < start_x + size_x & DrawY >= start_y & DrawY < start_y + size_y ) begin
		is_goA2 = 1'b1;
		sprite_addr_goA2 = (DrawY - start_y + 16*'h19);
	end
	else begin
		is_goA2 = 1'b0;
		sprite_addr_goA2 = 10'b0;
	end
end
endmodule
