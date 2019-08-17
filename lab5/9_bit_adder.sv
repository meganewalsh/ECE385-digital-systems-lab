module Nine_bit_adder (input logic [7:0] A, 
							  input logic [7:0] B,
							  input logic fn,
							  output logic [8:0] Sum
);

	logic c1, c2, c3, c4, c5, c6, c7, c8;
	logic [7:0] BB; //BB = B complement
	logic A8, BB8;
	
	assign BB = (B ^ {8{fn}});
	assign A8 = A[7];
	assign BB8 = BB[7];
	
	
	full_adder FA0(.x(A[0]), .y(BB[0]), .z(fn), .s(Sum[0]), .c(c0));
	full_adder FA1(.x(A[1]), .y(BB[1]), .z(c0), .s(Sum[1]), .c(c1));
	full_adder FA2(.x(A[2]), .y(BB[2]), .z(c1), .s(Sum[2]), .c(c2));
	full_adder FA3(.x(A[3]), .y(BB[3]), .z(c2), .s(Sum[3]), .c(c3));
	full_adder FA4(.x(A[4]), .y(BB[4]), .z(c3), .s(Sum[4]), .c(c4));
	full_adder FA5(.x(A[5]), .y(BB[5]), .z(c4), .s(Sum[5]), .c(c5));
	full_adder FA6(.x(A[6]), .y(BB[6]), .z(c5), .s(Sum[6]), .c(c6));
	full_adder FA7(.x(A[7]), .y(BB[7]), .z(c6), .s(Sum[7]), .c(c7));
	full_adder FA8(.x(A8), .y(BB8), .z(c7), .s(Sum[8]), .c()); //throw out any extra leading bits

endmodule
