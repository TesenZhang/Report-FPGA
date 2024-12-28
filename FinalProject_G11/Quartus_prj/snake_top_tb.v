`timescale 1ns / 1ps

module snake_top_tb;

    reg clk;
    reg rst_n;
    reg key0_right;
    reg key1_left;
    reg key2_down;
    reg key3_up;
    
    wire vga_hsync;
    wire vga_vsync;
    wire [15:0] vga_rgb;
	 wire stcp;
    wire shcp;
    wire ds;
    wire oe;

    // Instantiate the top-level module
    snake_top uut (
        .clk(clk),
        .rst_n(rst_n),
        .key_right(key0_right),
        .key_left(key1_left),
        .key_down(key2_down),
        .key_up(key3_up),
        .vga_hsync(vga_hsync),
        .vga_vsync(vga_vsync),
        .vga_rgb(vga_rgb),
	     .stcp(stcp),
        .shcp(shcp),
        .ds(ds),
        .oe(oe)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 50 MHz clock
    end

    // Test stimulus
	initial begin
		rst_n = 0;
		#80;
		rst_n = 1;
	
		key0_right = 1;
		key1_left = 1;
		key2_down = 1;
		key3_up = 1;
	
		#60000000
		
		#2000 key0_right = 0;
		#2000 key0_right = 1;
		#100 key0_right = 0;
		#300000 key0_right = 1;
	
		#2000 key1_left = 0;
		#2000 key1_left = 1;
		#100 key1_left = 0;
		#300000 key1_left = 1;
	
		#2000 key2_down = 0;
		#2000 key2_down = 1;
		#100 key2_down = 0;
		#300000 key2_down = 1;
	
		#2000 key3_up = 0;
		#2000 key3_up = 1;
		#100 key3_up = 0;
		#300000 key3_up = 1;
	

        // Keep simulation running to observe behavior
        #1000;
        $stop;
    end

endmodule
