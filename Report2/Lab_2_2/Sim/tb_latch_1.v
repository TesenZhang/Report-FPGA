`timescale 1ns/1ps

module tb_latch_1;

reg in1;
reg in2;
reg in3;
wire [7:0] out;

latch_1 uut (
    .in1(in1),
    .in2(in2),
    .in3(in3),
    .out(out)
);

initial begin

    $monitor("Time=%0d : in1=%b, in2=%b, in3=%b, out=%b", $time, in1, in2, in3, out);
repeat (100) begin

    {in1, in2, in3} = $random % 8;
        #10;
end
    $finish;
end

endmodule