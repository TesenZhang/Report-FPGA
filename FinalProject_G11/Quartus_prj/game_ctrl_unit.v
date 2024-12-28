

module game_ctrl_unit
(
	input clk,
	input rst_n,
	
	input key0_right,
	input key1_left,
	input key2_down,
	input key3_up,
	
	input hit_wall,
	input hit_body,
	input [11:0]bcd_data,
	
	output reg snake_display,
	output reg [1:0]fact_status,
	output reg [1:0]game_status
);
	

	localparam RESTART = 2'b00;		
	localparam START = 2'b01;			
	localparam PLAY = 2'b10;			
	localparam DIE = 2'b11;				
	
	reg [32:0]cnt_clk;
	reg[25:0]flash_cnt;

	
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			cnt_clk<=0;
			flash_cnt<=0;
			snake_display<=1;
			game_status <= RESTART;	
		end
		
		else begin
			case(game_status)	
				RESTART:begin       
					cnt_clk<=cnt_clk+1;
					if(cnt_clk>150000000)begin
					if(( ~key1_left)||(~key0_right)) begin
							
					if((~key1_left))
							fact_status<=0;
							else if(( ~key0_right))
							fact_status<=1;
							else
							fact_status<=fact_status;
							game_status <= START;
						end
					end
					else begin
						game_status <= RESTART;
					end
				end
				
				START:begin
					if ((~key0_right) ||( ~key1_left) || (~key2_down) ||( ~key3_up))
						game_status <= PLAY;
					else 
					    game_status <= START;
				end
				
				PLAY:begin
					if(hit_wall || hit_body||bcd_data[11:8]>=1'd1)
					   game_status <= DIE;
					else
					   game_status <= PLAY;
				end

				DIE:begin
					if(flash_cnt <= 50_000_000) begin
						flash_cnt <= flash_cnt + 1'b1;	
						if(flash_cnt == 12_500_000)begin
							snake_display <= 1'b0;end
						else if(flash_cnt == 25_000_000)begin
							snake_display <= 1'b1;end
						else if(flash_cnt == 37_500_000)begin
							snake_display <= 1'b0;end
					end

					else if((~key0_right) ||( ~key1_left) || (~key2_down) ||( ~key3_up) ) begin
						cnt_clk<=0;
						flash_cnt<=0;
						game_status <= RESTART;

					end			
					else begin
						game_status <= DIE;
					end
				end 
				
				default:begin                
							game_status <= RESTART;
					end
			endcase	
		end
	end
endmodule

