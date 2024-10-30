`timescale 1ns/1ps

module tb_asyn_flip_flop;

reg sys_clk;
reg sys_rst_n;
reg D;
wire Q;


asyn_flip_flop uut (
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .D(D),
    .Q(Q)
);


initial begin
    sys_clk = 0;
    forever #5 sys_clk = ~sys_clk;  
end


initial begin
   
    $monitor("Time=%0d : sys_rst_n=%b, D=%b, Q=%b", $time, sys_rst_n, D, Q);
    
    sys_rst_n = 0; 
    D = 0; 
    
    #10 sys_rst_n = 1;
	 #10 D = 1;
	 #10 D = 0;
    #10 sys_rst_n = 0;
		D=1;
	 
    #10; 
    #10 D = 0;
    #10; 
    #10 D = 1;
    #10;
    #10 D = 0;
    #10; 
    #10 $finish;
end

endmodule