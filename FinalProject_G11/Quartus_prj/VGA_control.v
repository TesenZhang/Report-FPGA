

module VGA_control (
    input clk,
    input rst_n,
    input [1:0] snake_show,
    input [1:0] game_status,
    input [11:0] bcd_data,
    input [5:0] apple_x,
    input [4:0] apple_y,
    output [9:0] pos_x,
    output [9:0] pos_y,
    output reg vga_hs,
    output reg vga_vs,
    output reg [15:0] vga_rgb,
    output vga_blank_n
);

    localparam RESTART = 2'b00, START = 2'b01, PLAY = 2'b10, DIE = 2'b11;
    localparam NONE = 2'b00, HEAD = 2'b01, BODY = 2'b10, WALL = 2'b11;
    localparam RED = 16'hF800, GREEN = 16'h07E0, BLUE = 16'h001F, GOLDEN = 16'hFEC0; 
    localparam YELLOW = 16'hFFE0, PINK = 16'hF81F, WHITE = 16'hFFFF, BLACK = 16'h0000;

    parameter HS_A = 96, HS_B = 48, HS_C = 640, HS_D = 16, HS_E = 800;
    parameter VS_A = 2, VS_B = 33, VS_C = 480, VS_D = 10, VS_E = 525;
    parameter BLOCK_W = 11'd16, HEIGHT = 120, WIDTH = 160;
	 parameter CHAR_B_H= 10'd192 , 
	 CHAR_B_V= 10'd208 ; 

	 parameter CHAR_W = 10'd256 , 
	 CHAR_H = 10'd64 ; 
    reg [9:0] cnt_hs, cnt_vs;
    reg [27:0] cnt_clk;
	 reg [14:0] cnt_rom_address;
	 wire [15:0] pic_data;
	 reg [15:0] pix_data ;
	 reg [15:0] pix_data_1 ;
	 wire [9:0] char_x ; 
	 wire [9:0] char_y ;
	 wire [9:0] char_x2 ; 
	 wire [9:0] char_y2 ;
	 wire    [9:0]   char_x1  ;   
	 wire    [9:0]   char_y1  ;   
	 reg     [159:0] char_layer1   [31:0]  ;

	 wire    [9:0]   char_x3  ;   
	 wire    [9:0]   char_y3  ;   
	 reg     [159:0] char_layer3   [31:0]  ;
 
	 wire clk_25m;
	 reg [159:0] char [59:0] ;
	 reg [159:0] char_1 [59:0] ;
	 reg [2:0] rand_num;
    wire en_hs = (cnt_hs >= HS_A + HS_B) && (cnt_hs < HS_E - HS_D);
    wire en_vs = (cnt_vs >= VS_A + VS_B) && (cnt_vs < VS_E - VS_D);
    wire en = en_hs && en_vs;
    wire picture_flag_enable = (((pos_x >= (((640 - WIDTH)/2) - 1'b1))
                && (pos_x < (((640 - WIDTH)/2) + WIDTH - 1'b1))) 
                &&((pos_y >= ((480 - HEIGHT)/2))
                && ((pos_y < (((480 - HEIGHT)/2) + HEIGHT)))));
    assign vga_blank_n = en;
    assign pos_x = en ? (cnt_hs - (HS_A + HS_B)) : 0;
    assign pos_y = en ? (cnt_vs - (VS_A + VS_B)) : 0;
	 assign clk_25m = clk;
	 always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rand_num <= 3'b001; 
    end 
	 else begin
        rand_num <= {rand_num[1:0], rand_num[2] ^ rand_num[1]};
    end
	 end
	 
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt_hs <= 0;
        else cnt_hs <= (cnt_hs == HS_E - 1) ? 0 : cnt_hs + 1;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt_vs <= 0;
        else if (cnt_hs == HS_E - 1) cnt_vs <= (cnt_vs == VS_E - 1) ? 0 : cnt_vs + 1;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) vga_hs <= 1;
        else vga_hs <= (cnt_hs < HS_A);
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) vga_vs <= 1;
        else vga_vs <= (cnt_vs < VS_A);
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_clk <= 0;
            cnt_rom_address <= 0;
            vga_rgb <= BLACK;
        end else begin
            case (game_status)
                RESTART: begin
                    if (cnt_clk < 150_000_000)begin
					cnt_clk <= cnt_clk+1;	
					vga_rgb <= pix_data_1; end 
						  else if(150000000 <= cnt_clk && cnt_clk < 300000000) begin
					cnt_clk <= cnt_clk+1;	
					if(pos_x[9:4] >=15 && pos_x[9:4] < 25 && pos_y[9:4] >= 8 && pos_y[9:4] < 10&& char[char_y][159-char_x] == 1'b1) begin
						vga_rgb<= WHITE; end
					else if(pos_x[9:4] >=15 && pos_x[9:4] < 25 && pos_y[9:4] >= 13 && pos_y[9:4] < 15 && char_layer1[char_y1][159-char_x1] == 1'b1)begin
				      vga_rgb<= GREEN; end

					else if(pos_x[9:4] >=15 && pos_x[9:4] < 25 && pos_y[9:4] >= 16 && pos_y[9:4] < 18 && char_layer3[char_y3][159-char_x3] == 1'b1)begin
						vga_rgb<= RED;end
					else begin
						vga_rgb<= BLACK;end
			
				end
						  else begin
                        cnt_clk <= cnt_clk;
                        cnt_rom_address <= 0;
                        vga_rgb <= BLACK;
                    end
                end
                PLAY, START: begin
                    cnt_clk <= 0;
                    cnt_rom_address <= 0;
                    if (pos_x[9:4] == apple_x && pos_y[9:4] == apple_y)
                        vga_rgb <= RED;
                    else if (snake_show == WALL)
                        vga_rgb <= PINK;
                    else if (snake_show == HEAD)
                        vga_rgb <= GREEN;
                    else if (snake_show == BODY) begin
							case (rand_num)
							3'b000: vga_rgb <= RED;
							3'b001: vga_rgb <= GREEN;
							3'b010: vga_rgb <= BLUE;
							3'b011: vga_rgb <= GOLDEN;
							3'b100: vga_rgb <= YELLOW;
							3'b101: vga_rgb <= PINK;
							3'b110: vga_rgb <= WHITE;
							3'b111: vga_rgb <= BLACK;
							default: vga_rgb <= BLACK;
							endcase
						  end
						  else
                        vga_rgb <= BLACK;
                end
                DIE: begin
                    if (cnt_clk < 100_000_000) begin
                        cnt_clk <= cnt_clk + 1;
                        vga_rgb <= pix_data;
                    end else begin
                        cnt_clk <= cnt_clk;
                        vga_rgb <= YELLOW;
                    end
                    cnt_rom_address <= 0;
                end
                default: begin
                    cnt_clk <= 0;
                    cnt_rom_address <= 0;
                    vga_rgb <= BLACK;
                end
            endcase
        end
    end

    /*rom rom_inst (
        .address(cnt_rom_address),
        .clock(clk),
		  .rden(picture_flag_enable),
        .q(pic_data) 
    );*/
	 
assign char_x=(((pos_x>=CHAR_B_H) && (pos_y<(CHAR_B_H+CHAR_W)))
					&&((pos_y>=CHAR_B_V) &&(pos_y<(CHAR_B_V+CHAR_H)) ))
					? (pos_x - CHAR_B_H) :10'h3ff;
assign char_y = (((pos_x >= CHAR_B_H) && (pos_x < (CHAR_B_H + CHAR_W)))
&&((pos_y >= CHAR_B_V)&&(pos_y < (CHAR_B_V + CHAR_H))))
? (pos_y - CHAR_B_V) : 10'h3FF;

assign char_x2=(((pos_x>=CHAR_B_H) && (pos_y<(CHAR_B_H+CHAR_W)))
					&&((pos_y>=CHAR_B_V) &&(pos_y<(CHAR_B_V+CHAR_H)) ))
					? (pos_x - CHAR_B_H) :10'h3ff;
assign char_y2 = (((pos_x >= CHAR_B_H) && (pos_x < (CHAR_B_H + CHAR_W)))
&&((pos_y >= CHAR_B_V)&&(pos_y < (CHAR_B_V + CHAR_H))))
? (pos_y - CHAR_B_V) : 10'h3FF;
always@(posedge clk)
    begin
        char[0]  <= 160'h0000000000000000000000000000000000000000;
        char[1]  <= 160'h0000000000000000000000000000000000000000;
        char[2]  <= 160'h0000000000000000000000000000000000000000;
        char[3]  <= 160'h0000000000000000000000000000000000000000;
        char[4]  <= 160'h0000000000000000000000000000000000000000;
        char[5]  <= 160'h0000000000000000000000000000000000000000;
        char[6]  <= 160'h0000000000000000000000000000000000000000;
        char[7]  <= 160'h0000000000000000000000000000000000000000;
        char[8]  <= 160'h00000000000000000000FFFFFFFF000000000000;
        char[9]  <= 160'h00000000000000000000FFFFFFFF000000000000;
        char[10] <= 160'h00000000000000000000FFFFFFFF000000000000;
        char[11] <= 160'h00000000000000000000FFFFFFFF000000000000;
        char[12] <= 160'h00000000000000000000FFFFFFFF000000000000;
        char[13] <= 160'h0000000000000000000000000000000000000000;
        char[14] <= 160'h0000000000000000000000000000000000000000;
        char[15] <= 160'h0000000000000000000000000000000000000000;
        char[16] <= 160'h0000000000000000000000000000000000000000;
        char[17] <= 160'h0000000000000000000000000000000000000000;
        char[18] <= 160'h0000000000000000000000000000000000000000;
        char[19] <= 160'h03c00018000c3000ff0003c000c3000ff000fc00; 
        char[20] <= 160'h07e0003c000c3000ff0007e000c3000ff000fe00; 
        char[21] <= 160'h0e700066000e7000c0000e7000c3000c0000c700; 
        char[22] <= 160'h0c0000c3000e7000c0000c3000c3000c0000c300; 
        char[23] <= 160'h0c0000c3000ff000c0000c3000c3000c0000c300; 
        char[24] <= 160'h0c0000c3000ff000fc000c3000c3000fc000c700; 
        char[25] <= 160'h0cf000c3000db000fc000c3000c3000fc000fe00; 
        char[26] <= 160'h0cf000ff000db000c0000c3000c3000c0000fc00; 
        char[27] <= 160'h0c3000ff000c3000c0000c3000c3000c0000c600; 
        char[28] <= 160'h0e7000c3000c3000c0000e700066000c0000c300; 
        char[29] <= 160'h07f000c3000c3000ff0007e0003c000ff000c300; 
        char[30] <= 160'h03b000c3000c3000ff0003c00018000ff000c300; 
        char[31] <= 160'h0000000000000000000000000000000000000000;
        char[32] <= 160'h0000000000000000000000000000000000000000;
        char[33] <= 160'h0000000000000000000000000000000000000000;
        char[34] <= 160'h0000000000000000000000000000000000000000;
        char[35] <= 160'h0000000000000000000000000000000000000000;
        char[36] <= 160'h0000000000000000000000000000000000000000;
        char[37] <= 160'h0000000000000000000000000000000000000000;
        char[38] <= 160'h0000000000000000000000000000000000000000;
        char[39] <= 160'h00000000000FFFFFFFF000000000000000000000;
        char[40] <= 160'h00000000000FFFFFFFF000000000000000000000;
        char[41] <= 160'h00000000000FFFFFFFF000000000000000000000;
        char[42] <= 160'h00000000000FFFFFFFF000000000000000000000;
        char[43] <= 160'h00000000000FFFFFFFF000000000000000000000;
        char[44] <= 160'h0000000000000000000000000000000000000000;
        char[45] <= 160'h0000000000000000000000000000000000000000;
        char[46] <= 160'h0000000000000000000000000000000000000000;
        char[47] <= 160'h0000000000000000000000000000000000000000;
        char[48] <= 160'h0000000000000000000000000000000000000000;
        char[49] <= 160'h0000000000000000000000000000000000000000;
        char[50] <= 160'h0000000000000000000000000000000000000000;
        char[51] <= 160'h0000000000000000000000000000000000000000;
        char[52] <= 160'h0000000000000000000000000000000000000000;
        char[53] <= 160'h0000000000000000000000000000000000000000;
        char[54] <= 160'h0000000000000000000000000000000000000000;
        char[55] <= 160'h0000000000000000000000000000000000000000;
        char[56] <= 160'h0000000000000000000000000000000000000000;
        char[57] <= 160'h0000000000000000000000000000000000000000;
        char[58] <= 160'h0000000000000000000000000000000000000000;
        char[59] <= 160'h0000000000000000000000000000000000000000;

    end    
always@(posedge clk)
    begin
        char_1[0]  <= 160'h0000000000000000000000000000000000000000;
        char_1[1]  <= 160'h0000000000000000000000000000000000000000;
        char_1[2]  <= 160'h0000000000000000000000000000000000000000;
        char_1[3]  <= 160'h0000000000000000000000000000000000000000;
        char_1[4]  <= 160'h0000000000000000000000000000000000000000;
        char_1[5]  <= 160'h0000000000000000000000000000000000000000;
        char_1[6]  <= 160'h000F800000000000000000000000000000000000;
        char_1[7]  <= 160'h001FC0000000071C000000E000000738000007FC;
        char_1[8]  <= 160'h003DF1C00000079C000001F000000778000007FC;
        char_1[9]  <= 160'h003C1363C000079C000003B8000007F000000700;
        char_1[10] <= 160'h001E1E3C000007DC0000071C000007E000000700;
        char_1[11] <= 160'h000F0000000007DC0000071C000007C000000700;
        char_1[12] <= 160'h00038000000007FC0000071C00000780000007F0;
        char_1[13] <= 160'h0001C000000007FC0000071C000007C0000007F0;
        char_1[14] <= 160'h0001E0000000077C000007FC000007E000000700;
        char_1[15] <= 160'h003DE0000000077C000007FC000007F000000700;
        char_1[16] <= 160'h001FC0000000073C0000071C0000077800000700;
        char_1[17] <= 160'h000F80000000073C0000071C0000073C000007FC;
        char_1[18] <= 160'h000000000000071C0000071C0000071C000007FC;
        char_1[19] <= 160'h0000000000000000000000000000000000000000; 
        char_1[20] <= 160'h0000000000000000000000000000000000000000; 
        char_1[21] <= 160'h0000000000000000000000000000000000000000; 
        char_1[22] <= 160'h0000000000000000000000000000000000000000; 
        char_1[23] <= 160'h0000000000000000000000000000000000000000; 
        char_1[24] <= 160'h000000000000FE00006006000000000000000000; 
        char_1[25] <= 160'h000000000003838000E00E000000000000000000; 
        char_1[26] <= 160'h0000000000060080002002000000000000000000; 
        char_1[27] <= 160'h0000000000040000002002000000000000000000; 
        char_1[28] <= 160'h00000000000C0000002002000000000000000000; 
        char_1[29] <= 160'h0000000000080000002002000000000000000000; 
        char_1[30] <= 160'h0000000000180000002002000000000000000000; 
        char_1[31] <= 160'h0000000000100000002002000000000000000000;
        char_1[32] <= 160'h0000000000100000002002000000000000000000;
        char_1[33] <= 160'h0000000000100000002002000000000000000000;
        char_1[34] <= 160'h0000000000100080002002000000000000000000;
        char_1[35] <= 160'h0000000000100180002002000000000000000000;
        char_1[36] <= 160'h0000000000180380002002000000000000000000;
        char_1[37] <= 160'h0000000000080280002002000000000000000000;
        char_1[38] <= 160'h00000000000C0680002002000000000000000000;
        char_1[39] <= 160'h0000000000061C80002002000000000000000000;
        char_1[40] <= 160'h000000000003F080000000000000000000000000;
        char_1[41] <= 160'h0000000000000000000000000000000000000000;
        char_1[42] <= 160'h0000000000000000000000000000000000000000;
        char_1[43] <= 160'h0000000000000000000000000000000000000000;
        char_1[44] <= 160'h0000000000000000000000000000000000000000;
        char_1[45] <= 160'h0000000000000003B80078000000000000000000;
        char_1[46] <= 160'h000000000003F004A40084000000000000000000;
        char_1[47] <= 160'h0000000000003008E20080000000000000000000;
        char_1[48] <= 160'h0000000000006008420080000000000000000000;
        char_1[49] <= 160'h000000000000C0080200FC000000000000000000;
        char_1[50] <= 160'h0000000000018004040004000000000000000000;
        char_1[51] <= 160'h0000000000030002080004000000000000000000;
        char_1[52] <= 160'h000000000003F001100084000000000000000000;
        char_1[53] <= 160'h0000000000000001E00078000000000000000000;
        char_1[54] <= 160'h0000000000000000000000000000000000000000;
        char_1[55] <= 160'h0000000000000000000000000000000000000000;
        char_1[56] <= 160'h0000000000000000000000000000000000000000;
        char_1[57] <= 160'h0000000000000000000000000000000000000000;
        char_1[58] <= 160'h0000000000000000000000000000000000000000;
        char_1[59] <= 160'h0000000000000000000000000000000000000000;

    end 
/*
0F80000000000000000000000000000000000000;
1FC0000000071C000000E000000738000007FC00;
3DF1C00000079C000001F000000778000007FC00;
3C1363C000079C000003B8000007F00000070000;
1E1E3C000007DC0000071C000007E00000070000;
0F0000000007DC0000071C000007C00000070000;
038000000007FC0000071C00000780000007F000;
01C000000007FC0000071C000007C0000007F000;
01E0000000077C000007FC000007E00000070000;
3DE0000000077C000007FC000007F00000070000;
1FC0000000073C0000071C000007780000070000;
0F80000000073C0000071C0000073C000007FC00;
0000000000071C0000071C0000071C000007FC00;
0000000000000000000000000000000000000000;
0000000000000000000000000000000000000000;
0000000000000000000000000000000000000000;
0000000000000000000000000000000000000000;
0000000000000000000000000000000000000000;
0000000000FE0000600600000000000000000000;
0000000003838000E00E00000000000000000000;
0000000006008000200200000000000000000000;
0000000004000000200200000000000000000000;
000000000C000000200200000000000000000000;
0000000008000000200200000000000000000000;
0000000018000000200200000000000000000000;
000000001000000020020000000003B800780000;
00000000100000002002000003F004A400840000;
000000001000000020020000003008E200800000;
0000000010008000200200000060084200800000;
00000000100180002002000000C0080200FC0000;
0000000018038000200200000180040400040000;
0000000008028000200200000300020800040000;
000000000C0680002002000003F0011000840000;
00000000061C800020020000000001E000780000;
0000000003F08000000000000000000000000000;
0000000000000000000000000000000000000000;
0000000000000000000000000000000000000000;



*/
always@(posedge clk or negedge rst_n)
 if(rst_n == 1'b0)
 pix_data <= BLACK;
 else if((((pos_x >= (CHAR_B_H - 1'b1))
 && (pos_x < (CHAR_B_H + CHAR_W -1'b1)))
 && ((pos_y >= CHAR_B_V) && (pos_y < (CHAR_B_V + CHAR_H))))
 && (char[char_y][10'd159 - char_x] == 1'b1))
 pix_data <= GOLDEN;
 else
 pix_data <= BLACK;

 always@(posedge clk or negedge rst_n)
 if(rst_n == 1'b0)
 pix_data_1 <= BLACK;
 else if((((pos_x >= (CHAR_B_H - 1'b1))
 && (pos_x < (CHAR_B_H + CHAR_W -1'b1)))
 && ((pos_y >= CHAR_B_V) && (pos_y < (CHAR_B_V + CHAR_H))))
 && (char_1[char_y2][10'd159 - char_x2] == 1'b1))
 pix_data_1 <= PINK;
 else
 pix_data_1 <= BLACK;

 
assign  char_x1  =   (pos_x[9:4] >=15 && pos_x[9:4] < 25 && pos_y[9:4] >= 13 && pos_y[9:4] < 15)? (pos_x - 15*16) : 0;
assign  char_y1  =   (pos_x[9:4] >=15 && pos_x[9:4] < 25 && pos_y[9:4] >= 13 && pos_y[9:4] < 15)? (pos_y - 13*16) : 0;

assign  char_x3  =   (pos_x[9:4] >=15 && pos_x[9:4] < 25 && pos_y[9:4] >= 16 && pos_y[9:4] < 18)? (pos_x - 15*16) : 0;
assign  char_y3  =   (pos_x[9:4] >=15 && pos_x[9:4] < 25 && pos_y[9:4] >= 16 && pos_y[9:4] < 18)? (pos_y - 16*16) : 0;
 
 always@(posedge clk)
    begin
        char_layer1[0]     <=  160'h0000000000000000000000000000000000000000;
        char_layer1[1]     <=  160'h0000000000000000000000000000000000000000; 
        char_layer1[2]     <=  160'h0000000000000000000000000000000000000000; 
        char_layer1[3]     <=  160'h0000000000000000000000000000000000000000; 
        char_layer1[4]     <=  160'h0000000000000000000000000000000000000000;
        char_layer1[5]     <=  160'h0000000000000000000000000000000000000000; 
        char_layer1[6]     <=  160'h0000000000000000000000000000000000000000; 
        char_layer1[7]     <=  160'h0000000000000000000000000000000000000000; 
        char_layer1[8]     <=  160'h0000000000000000000000000000000000000000; 
        char_layer1[9]     <=  160'h0000FFFFFFFFFFFFFF0000000000000000000000; 
        char_layer1[10]    <=  160'h0000FFFFFFFFFFFFFF0000000000000000000000;
        char_layer1[11]    <=  160'h0000FFFFFFFFFFFFFF0000000000000000000000; 
        char_layer1[12]    <=  160'h0300FFFFFFFFFFFFFF0000000000000000000600; 
        char_layer1[13]    <=  160'h0300FFFFFFFFFFFFFF0000000000000000000E00; 
        char_layer1[14]    <=  160'h0300FFFFFFFFFFFFFF0000000000000000003E00; 
        char_layer1[15]    <=  160'h0300FFFFFFFFFFFFFF0000000000000000000600; 
        char_layer1[16]    <=  160'h0300FFFFFFFFFFFFFF0000000000000000000600; 
        char_layer1[17]    <=  160'h0300FFFFFFFFFFFFFF0000000000000000000600; 
        char_layer1[18]    <=  160'h0300FFFFFFFFFFFFFF0000000000000000000600; 
        char_layer1[19]    <=  160'h0300FFFFFFFFFFFFFF0000000000000000000600; 
        char_layer1[20]    <=  160'h03F0FFFFFFFFFFFFFF0000000000000000000600; 
        char_layer1[21]    <=  160'h0000FFFFFFFFFFFFFF0000000000000000000000;
        char_layer1[22]    <=  160'h0000FFFFFFFFFFFFFF0000000000000000000000; 
        char_layer1[23]    <=  160'h0000FFFFFFFFFFFFFF0000000000000000000000; 
        char_layer1[24]    <=  160'h0000FFFFFFFFFFFFFF0000000000000000000000; 
        char_layer1[25]    <=  160'h0000000000000000000000000000000000000000; 
        char_layer1[26]    <=  160'h0000000000000000000000000000000000000000; 
        char_layer1[27]    <=  160'h0000000000000000000000000000000000000000; 
        char_layer1[28]    <=  160'h0000000000000000000000000000000000000000; 
        char_layer1[29]    <=  160'h0000000000000000000000000000000000000000; 
        char_layer1[30]    <=  160'h0000000000000000000000000000000000000000; 
        char_layer1[31]    <=  160'h0000000000000000000000000000000000000000;
    end                         
	                              
 always@(posedge clk)
    begin
        char_layer3[0]     <=  160'h0000000000000000000000000000000000000000;
        char_layer3[1]     <=  160'h0000000000000000000000000000000000000000; 
        char_layer3[2]     <=  160'h0000000000000000000000000000000000000000; 
        char_layer3[3]     <=  160'h0000000000000000000000000000000000000000; 
        char_layer3[4]     <=  160'h0000000000000000000000000000000000000000;
        char_layer3[5]     <=  160'h0000000000000000000000000000000000000000; 
        char_layer3[6]     <=  160'h0000000000000000000000000000000000000000; 
        char_layer3[7]     <=  160'h0000000000000000000000000000000000000000; 
        char_layer3[8]     <=  160'h00000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000; 
        char_layer3[9]     <=  160'h00000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000; 
        char_layer3[10]    <=  160'h01800FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000F00;
        char_layer3[11]    <=  160'h01800FFFFFFFFFFFFFFFFFFFFFFFFFFFFF001980; 
        char_layer3[12]    <=  160'h01800FFFFFFFFFFFFFFFFFFFFFFFFFFFFF001980; 
        char_layer3[13]    <=  160'h01800FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000180; 
        char_layer3[14]    <=  160'h01800FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000700; 
        char_layer3[15]    <=  160'h01800FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000180; 
        char_layer3[16]    <=  160'h01800FFFFFFFFFFFFFFFFFFFFFFFFFFFFF001980; 
        char_layer3[17]    <=  160'h01800FFFFFFFFFFFFFFFFFFFFFFFFFFFFF001980; 
        char_layer3[18]    <=  160'h01F80FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000F00; 
        char_layer3[19]    <=  160'h00000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000; 
        char_layer3[20]    <=  160'h00000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000; 
        char_layer3[21]    <=  160'h00000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000;
        char_layer3[22]    <=  160'h00000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000; 
        char_layer3[23]    <=  160'h0000000000000000000000000000000000000000; 
        char_layer3[24]    <=  160'h0000000000000000000000000000000000000000; 
        char_layer3[25]    <=  160'h0000000000000000000000000000000000000000; 
        char_layer3[26]    <=  160'h0000000000000000000000000000000000000000; 
        char_layer3[27]    <=  160'h0000000000000000000000000000000000000000; 
        char_layer3[28]    <=  160'h0000000000000000000000000000000000000000; 
        char_layer3[29]    <=  160'h0000000000000000000000000000000000000000; 
        char_layer3[30]    <=  160'h0000000000000000000000000000000000000000; 
        char_layer3[31]    <=  160'h0000000000000000000000000000000000000000;
    end  
endmodule
