module FA(
	input 	   x,
	input 	   y,
	input 	c_in,
	output     s, 
	output  c_out
);

	wire sum_1;
	wire carry_1;
	wire carry_2;

	HA ha1(
		.x(x),
		.y(y),
		.s(sum_1),
		.c(carry_1)
	);

	HA ha2(
		.x(c_in),
		.y(sum_1),
		.s(s),
		.c(carry_2)
	);

	assign c_out = carry_1 | carry_2;

endmodule

