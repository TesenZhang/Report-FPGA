`timescale 1ns / 1ps

module tb_Vending_machine;

    reg sys_clk;
    reg sys_rst_n;
    reg pi_money_one;
    reg pi_money_half;

    wire po_money_one;
    wire po_money_half;
    wire po_cola;
	 wire [3:0] state =Vending_machine_inst.state;
    Vending_machine Vending_machine_inst (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .pi_money_one(pi_money_one),
        .pi_money_half(pi_money_half),
        .po_money_one(po_money_one),
        .po_money_half(po_money_half),
        .po_cola(po_cola)
    );

    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;
    end

    initial begin

        sys_rst_n = 0;
        pi_money_one = 0;
        pi_money_half = 0;

        #10 sys_rst_n = 1;



        #10 pi_money_one = 0; pi_money_half = 1;
        #10 pi_money_one = 0; pi_money_half = 0; 

        #10 pi_money_one = 1; pi_money_half = 0;
        #10 pi_money_one = 0; pi_money_half = 0;

        #10 pi_money_one = 1; pi_money_half = 0; 
        #10 pi_money_one = 0; pi_money_half = 0; 

        #10 pi_money_one = 0; pi_money_half = 1; 
        #10 pi_money_one = 0; pi_money_half = 0;

        #20 $stop;
    end
endmodule