`timescale  1ns/1ns

module  tb_vga_rom_pic();

wire            hsync       ;
wire    [15:0]  rgb         ;
wire            vsync       ;

reg             sys_clk     ;
reg             sys_rst_n   ;


initial
    begin
        sys_clk     =   1'b1;
        sys_rst_n   <=  1'b0;
        #200
        sys_rst_n   <=  1'b1;
    end

wire [9:0] pix_x= vga_char_inst.vga_pic_inst.pix_x;
wire [9:0] pix_y= vga_char_inst.vga_pic_inst.pix_y;
wire [15:0] pix_data= vga_char_inst.vga_pic_inst.pix_data;
wire [9:0] char_x= vga_char_inst.vga_pic_inst.char_x;
wire [9:0] char_y= vga_char_inst.vga_pic_inst.char_y;

always  #10 sys_clk = ~sys_clk  ;

vga_rom_pic vga_rom_pic_inst
(
    .sys_clk    (sys_clk    ),  
    .sys_rst_n  (sys_rst_n  ),  

    .hsync      (hsync      ),  
    .vsync      (vsync      ),  
    .rgb        (rgb        )   
);

endmodule

