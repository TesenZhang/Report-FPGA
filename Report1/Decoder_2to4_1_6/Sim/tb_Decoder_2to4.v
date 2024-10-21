
module tb_Decoder_2to4;

    reg enable;
    reg a;
    reg b;

    wire [3:0] y;

    Decoder_2to4 Decoder_2to4_inst (
        .enable(enable),
        .a(a),
        .b(b),
        .y(y)
    );

    initial begin

        enable = 0;
        a = 0;
        b = 0;


        $monitor("Time = %0d, Enable = %b, A = %b, B = %b, Y = %b", $time, enable, a, b, y);


        #10 enable = 0; a = 0; b = 0;
        #10 enable = 0; a = 1; b = 0;
        #10 enable = 0; a = 0; b = 1;
        #10 enable = 0; a = 1; b = 1;

        #10 enable = 1; a = 0; b = 0;
        #10 enable = 1; a = 1; b = 0;
        #10 enable = 1; a = 0; b = 1;
        #10 enable = 1; a = 1; b = 1;

        #10 $finish;
    end

endmodule