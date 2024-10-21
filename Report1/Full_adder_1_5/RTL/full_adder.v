module full_adder(
	input	a,b,cin,
	output	out,cout
);

assign {cout,out} = a + b + cin;

endmodule