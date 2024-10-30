module asyn_flip_flop
(
input wire sys_clk,
input wire sys_rst_n,
input wire D,

output reg Q
);

always@(posedge sys_clk or negedge sys_rst_n)

if(sys_rst_n == 1'b0)
	Q <= 1'b0;
else
	Q <= D;
	
endmodule

