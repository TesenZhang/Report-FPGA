
module Decoder_2to4
(
input a,
input b,
input enable,

output reg [3:0] y
);

always@(*)
case({b, a, enable})
3'b000 : y = 4'b0000;
3'b010 : y = 4'b0000;
3'b100 : y = 4'b0000;
3'b110 : y = 4'b0000;
3'b001 : y = 4'b0001;
3'b011 : y = 4'b0010;
3'b101 : y = 4'b0100;
3'b111 : y = 4'b1000;
default: y = 4'b0000;
endcase

endmodule