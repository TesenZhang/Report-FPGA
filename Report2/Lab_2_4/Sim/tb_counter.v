`timescale 1ns / 1ns
module tb_counter();

reg sys_clk;
reg sys_rst_n;

wire led_out;

// Instantiate the counter module with a reduced CNT_MAX for faster simulation
counter #(
    .CNT_MAX (25'd24) // Reduced count for quick testing
) uut (
    .sys_clk (sys_clk), 
    .sys_rst_n (sys_rst_n),
    .led_out (led_out)
);

// Clock generation (50 MHz clock, period of 20 ns)
initial begin
    sys_clk = 1'b1;
    sys_rst_n = 1'b0;  // Initial reset state
    #20;
    sys_rst_n = 1'b1;  // Release reset after 20 ns
end

always #10 sys_clk = ~sys_clk; // Toggle clock every 10 ns

endmodule