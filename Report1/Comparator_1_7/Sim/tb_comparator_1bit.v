`timescale 1ns / 1ps

module tb_comparator_1bit;

    reg A;
    reg B;

    wire LED1;
    wire LED2;
    wire LED3;

    comparator_1bit UUT (
        .A(A), 
        .B(B), 
        .LED1(LED1), 
        .LED2(LED2), 
        .LED3(LED3)
    );

    initial begin
        A = 0;
        B = 0;

        #100;  
        A = 0; B = 0; 
        #10;   
        A = 0; B = 1;
        #10;
        A = 1; B = 0;
        #10;
        A = 1; B = 1; 
        #10;
        A = 0; B = 0;
        #10;

   
        #50;
        
        $finish;
    end
    
    initial begin
        $monitor("At time %t, A = %b, B = %b -> LED1 = %b, LED2 = %b, LED3 = %b", 
                 $time, A, B, LED1, LED2, LED3);
    end

endmodule