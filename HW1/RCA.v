module RCA(
	input  [3:0]   x,
	input  [3:0]   y,
	input 		c_in,
	output [3:0]   s,
	output     c_out
);

wire c_01;
wire c_12;
wire c_23;

FA fa0(
	.x(x[0]),
	.y(y[0]),
	.c_in(c_in),
	.s(s[0]),
	.c_out(c_01)
);
FA fa1(
	.x(x[1]),
	.y(y[1]),
	.c_in(c_01),
	.s(s[1]),
	.c_out(c_12)
);
FA fa2(
	.x(x[2]),
	.y(y[2]),
	.c_in(c_12),
	.s(s[2]),
	.c_out(c_23)
);
FA fa3(
	.x(x[3]),
	.y(y[3]),
	.c_in(c_23),
	.s(s[3]),
	.c_out(c_out)
);
endmodule
