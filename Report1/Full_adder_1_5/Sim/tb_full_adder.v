`timescale 1ns/1ns

module tb_full_adder;
  reg a, b, cin;
  wire out, cout;

  full_adder UUT (
    .a(a),
    .b(b),
    .cin(cin),
    .out(out),
    .cout(cout)
  );

  initial begin

    a = 0; b = 0; cin = 0;
    #10; 
    a = 1; b = 0; cin = 0;
    #10;
    a = 0; b = 1; cin = 0;
    #10;
    a = 1; b = 1; cin = 0;
    #10;
    a = 0; b = 0; cin = 1;
    #10;
    a = 1; b = 0; cin = 1;
    #10;
    a = 0; b = 1; cin = 1;
    #10;
    a = 1; b = 1; cin = 1;
    #10;

    $finish;
  end

endmodule