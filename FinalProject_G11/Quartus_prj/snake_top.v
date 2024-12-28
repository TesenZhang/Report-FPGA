
module snake_top
(
   input clk,		
	input rst_n,	
	
	input key_right,  		
	input key_left, 		
	input key_down,    	
	input key_up, 		 	

	output vga_hsync,	
	output vga_vsync,	
	output [15:0]vga_rgb,
	 output wire stcp , 
    output wire shcp , 
    output wire ds ,
    output wire oe 
);


	wire clk_25m;
	wire pll_locked;
	wire [1:0]snake_show;
	
	wire [9:0]pos_x;
	wire [9:0]pos_y;
	
	wire [5:0]apple_x;
	wire [4:0]apple_y;
	
	wire [5:0]head_x;
	wire [5:0]head_y;
	
	wire add_cube;
	
	wire[1:0]game_status;
	wire [1:0]fact_status;
	
	wire hit_wall;
	wire hit_body;
	wire snake_display;
	
	wire [11:0]bcd_data;
	
	wire key0_right;  	
	wire key1_left	;		
	wire key2_down ;  	
	wire key3_up	; 
	parameter CNT_MAX = 20'd999_999 ;

    pll pll_inst (
    
			.areset             (~rst_n),
			.inclk0          (clk),
			.c0        (clk_25m),
			.locked          (pll_locked)
    );
	 
assign vga_clk = clk_25m;
assign vga_sync_n=1'b0; 
	
    game_ctrl_unit U0 (
       .clk(clk_25m),
	    .rst_n(rst_n),
	    .key0_right(~key0_right),
	    .key1_left(~key1_left),
	    .key2_down(~key2_down),
	    .key3_up(~key3_up),
       .game_status(game_status),
		 .fact_status(fact_status),
		 .snake_display(snake_display),
		 .hit_wall(hit_wall),
		 .hit_body(hit_body),
		 .bcd_data(bcd_data)
	);
	
	apple_generate U1 (
		.clk(clk_25m),
		.rst_n(rst_n),
		.apple_x(apple_x),
		.apple_y(apple_y),
		.head_x(head_x),
		.head_y(head_y),
		.fact_status(fact_status),
		.add_cube(add_cube)	
	);
	
	snake U2 (
	   .clk(clk_25m),
		.rst_n(rst_n),
		.key0_right(key_right),
		.key1_left(key_left),
		.key2_down(key_down),
		.key3_up(key_up),
		.snake_show(snake_show),
		.pos_x(pos_x),
		.pos_y(pos_y),
		.head_x(head_x),
		.head_y(head_y),
		.add_cube(add_cube),
		.game_status(game_status),
		.hit_body(hit_body),
		.fact_status(fact_status),
		.snake_display(snake_display),
		.hit_wall(hit_wall)
	);

	VGA_control U3 (
		.clk(clk_25m),
		.rst_n(rst_n),
		.game_status(game_status),
		.snake_show(snake_show),
		.bcd_data(bcd_data),
		.pos_x(pos_x),
		.pos_y(pos_y),
		.apple_x(apple_x),
		.apple_y(apple_y),
		.vga_rgb(vga_rgb),
      .vga_hs(vga_hsync),
      .vga_blank_n(vga_blank_n),
      .vga_vs(vga_vsync)
	);

	score_ctrl U4(
		.clk(clk_25m),
		.rst_n(rst_n),
		.add_cube(add_cube),
		.game_status(game_status),
		.bcd_data(bcd_data) 
);
    key_debounce #(
        .CNT_MAX(CNT_MAX)
    ) key_debounce_inst1 (
        .sys_clk(clk),
        .sys_rst_n(rst_n),
        .key_in(key_right),
        .key_flag(key0_right)
    );
    key_debounce #(
        .CNT_MAX(CNT_MAX)
    ) key_debounce_inst2 (
        .sys_clk(clk),
        .sys_rst_n(rst_n),
        .key_in(key_left),
        .key_flag(key1_left)
    );
    key_debounce #(
        .CNT_MAX(CNT_MAX)
    ) key_debounce_inst3 (
        .sys_clk(clk),
        .sys_rst_n(rst_n),
        .key_in(key_down),
        .key_flag(key2_down)
    );
    key_debounce #(
        .CNT_MAX(CNT_MAX)
    ) key_debounce_inst4 (
        .sys_clk(clk),
        .sys_rst_n(rst_n),
        .key_in(key_up),
        .key_flag(key3_up)
    );	 
	top_seg_595 U6
(
        .sys_clk (clk), 
        .sys_rst_n(rst_n),
        .bcd_data(bcd_data),
        .clear_signal(clear_signal), 
        .start_signal(start_signal), 
        .stcp(stcp),
        .shcp(shcp), 
        .ds(ds),
        .oe(oe)
);

		
endmodule
