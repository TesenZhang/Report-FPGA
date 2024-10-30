
module flip_flop
(
input wire sys_clk ,


input wire sys_rst_n, 


input wire D , 

output reg Q 
);


always@(posedge sys_clk) 


if(sys_rst_n == 1'b0) 


 Q <= 1'b0; 

else
Q <= D;

endmodule