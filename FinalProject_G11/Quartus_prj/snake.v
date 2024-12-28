
module snake(
	input clk,		
	input rst_n,	
	
	input key0_right,	
	input key1_left,	
	input key2_down,	
	input key3_up,		
	
	input [9:0]pos_x,	
	input [9:0]pos_y,	
	input [1:0]fact_status,
	
	output [5:0]head_x,	
	output [5:0]head_y,	
	
	input add_cube,		  
	input [1:0]game_status,
	input snake_display,
	
	output reg hit_body,
	output reg hit_wall, 
	
	output reg [1:0]snake_show
);
	
	localparam UP = 2'b00;
	localparam DOWN = 2'b01;
	localparam LEFT = 2'b10;
	localparam RIGHT = 2'b11;
	
	localparam NONE = 2'b00;
	localparam HEAD = 2'b01;
	localparam BODY = 2'b10;
	localparam WALL = 2'b11;
	
   localparam RESTART = 2'b00;
	localparam PLAY = 2'b10;
	localparam DIE = 2'b11;	
	
	reg [4:0]cube_num;
	reg [5:0]cube_x[15:0];
	reg [5:0]cube_y[15:0];
	reg [15:0]is_exist;   
	
	reg addcube_state;
	
	reg[31:0]clk_cnt;
	reg[23:0] speed;     
	
	reg[1:0]direct_r;		
	reg[1:0]direct_next;	

	
	assign head_x = cube_x[0];
	assign head_y = cube_y[0]; 
	
	always @(posedge clk or negedge rst_n) begin		
		if(!rst_n) begin
			speed<= 24'd12500000;
			direct_r<=RIGHT;
		end
		else if(game_status==RESTART) begin
			speed<= 24'd12500000;
			direct_r<=RIGHT;
		end
		else begin
			direct_r <= direct_next;
			case (fact_status)   
				0  : speed <= 24'd12500000;
				1  : speed <= 24'd4166666;//0.04us*4166666=0.167s 5.98moves/second
			
				default:  speed <= 24'd12500000;
			endcase
		end		
	end
    
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			clk_cnt <= 0;
								
			cube_x[0] <= 20;	
			cube_y[0] <= 20;
					
			cube_x[1] <= 19;	
			cube_y[1] <= 20;
					
			cube_x[2] <= 18;	
			cube_y[2] <= 20;

			cube_x[3] <= 17;
			cube_y[3] <= 20;
					
			cube_x[4] <= 16;
			cube_y[4] <= 20;
					
			cube_x[5] <= 0;
			cube_y[5] <= 0;
					
			cube_x[6] <= 0;
			cube_y[6] <= 0;
					
			cube_x[7] <= 0;
			cube_y[7] <= 0;
					
			cube_x[8] <= 0;
			cube_y[8] <= 0;
					
			cube_x[9] <= 0;
			cube_y[9] <= 0;					
					
			cube_x[10] <= 0;
			cube_y[10] <= 0;
					
			cube_x[11] <= 0;
			cube_y[11] <= 0;
					
         cube_x[12] <= 0;
			cube_y[12] <= 0;
					
			cube_x[13] <= 0;
			cube_y[13] <= 0;
					
			cube_x[14] <= 0;
			cube_y[14] <= 0;
					
			cube_x[15] <= 0;
			cube_y[15] <= 0;

			hit_wall <= 0;
			hit_body <= 0;
		end	
		else if(game_status==RESTART) begin
			clk_cnt <= 0;
                                                    
			cube_x[0] <= 10;	
			cube_y[0] <= 20;
					
			cube_x[1] <= 9;	
			cube_y[1] <= 20;
					
			cube_x[2] <= 8;	
			cube_y[2] <= 20;

			cube_x[3] <= 7;
			cube_y[3] <= 20;
					
			cube_x[4] <= 6;
			cube_y[4] <= 20;
					
			cube_x[5] <= 0;
			cube_y[5] <= 0;
					
			cube_x[6] <= 0;
			cube_y[6] <= 0;
					
			cube_x[7] <= 0;
			cube_y[7] <= 0;
					
			cube_x[8] <= 0;
			cube_y[8] <= 0;
					
			cube_x[9] <= 0;
			cube_y[9] <= 0;					
					
			cube_x[10] <= 0;
			cube_y[10] <= 0;
					
			cube_x[11] <= 0;
			cube_y[11] <= 0;
					
         cube_x[12] <= 0;
			cube_y[12] <= 0;
					
			cube_x[13] <= 0;
			cube_y[13] <= 0;
					
			cube_x[14] <= 0;
			cube_y[14] <= 0;
					
			cube_x[15] <= 0;
			cube_y[15] <= 0;
                    
			hit_wall <= 0;
			hit_body <= 0; 
		end
		else begin
			clk_cnt <= clk_cnt + 1;
				if(clk_cnt == speed) begin
					clk_cnt <= 0;
					if(game_status==PLAY) begin
						if((direct_r==UP && cube_y[0] == 1)||(direct_r==DOWN && cube_y[0] == 28)||(direct_r==LEFT && cube_x[0] == 1)||(direct_r==RIGHT && cube_x[0] == 38))begin
							hit_wall <= 1; end//撞到墙壁				
							
							
							
							
											
						else if((cube_y[0] == cube_y[1] && cube_x[0] == cube_x[1] && is_exist[1] == 1)||
								(cube_y[0] == cube_y[2] && cube_x[0] == cube_x[2] && is_exist[2] == 1)||
								(cube_y[0] == cube_y[3] && cube_x[0] == cube_x[3] && is_exist[3] == 1)||
								(cube_y[0] == cube_y[4] && cube_x[0] == cube_x[4] && is_exist[4] == 1)||
								(cube_y[0] == cube_y[5] && cube_x[0] == cube_x[5] && is_exist[5] == 1)||
								(cube_y[0] == cube_y[6] && cube_x[0] == cube_x[6] && is_exist[6] == 1)||
								(cube_y[0] == cube_y[7] && cube_x[0] == cube_x[7] && is_exist[7] == 1)||
								(cube_y[0] == cube_y[8] && cube_x[0] == cube_x[8] && is_exist[8] == 1)||
								(cube_y[0] == cube_y[9] && cube_x[0] == cube_x[9] && is_exist[9] == 1)||
								(cube_y[0] == cube_y[10] && cube_x[0] == cube_x[10] && is_exist[10] == 1)||
								(cube_y[0] == cube_y[11] && cube_x[0] == cube_x[11] && is_exist[11] == 1)||
								(cube_y[0] == cube_y[12] && cube_x[0] == cube_x[12] && is_exist[12] == 1)||
								(cube_y[0] == cube_y[13] && cube_x[0] == cube_x[13] && is_exist[13] == 1)||
								(cube_y[0] == cube_y[14] && cube_x[0] == cube_x[14] && is_exist[14] == 1)||
								(cube_y[0] == cube_y[15] && cube_x[0] == cube_x[15] && is_exist[15] == 1)) begin
								hit_body <= 1; end
							else begin
								cube_x[1] <= cube_x[0];
								cube_y[1] <= cube_y[0];
															
								cube_x[2] <= cube_x[1];
								cube_y[2] <= cube_y[1];
															
								cube_x[3] <= cube_x[2];
								cube_y[3] <= cube_y[2];
															
								cube_x[4] <= cube_x[3];
								cube_y[4] <= cube_y[3];
															
								cube_x[5] <= cube_x[4];
								cube_y[5] <= cube_y[4];
															
								cube_x[6] <= cube_x[5];
								cube_y[6] <= cube_y[5];
															
								cube_x[7] <= cube_x[6];
								cube_y[7] <= cube_y[6];
															
								cube_x[8] <= cube_x[7];
								cube_y[8] <= cube_y[7];
															
								cube_x[9] <= cube_x[8];
								cube_y[9] <= cube_y[8];
															
								cube_x[10] <= cube_x[9];
								cube_y[10] <= cube_y[9];
															
								cube_x[11] <= cube_x[10];
								cube_y[11] <= cube_y[10];
															
								cube_x[12] <= cube_x[11];
								cube_y[12] <= cube_y[11];
															 
								cube_x[13] <= cube_x[12];
								cube_y[13] <= cube_y[12];
															
								cube_x[14] <= cube_x[13];
								cube_y[14] <= cube_y[13];
															
								cube_x[15] <= cube_x[14];
								cube_y[15] <= cube_y[14];
								
								if(direct_r==UP)begin
										if(cube_y[0] == 1)
										hit_wall <= 1;
										else
											cube_y[0] <= cube_y[0]-1;
										end
																
								else if(direct_r==DOWN)begin
										if(cube_y[0] == 28)
											hit_wall <= 1;
										else
											cube_y[0] <= cube_y[0] + 1;
										end
																	
								else if(direct_r==LEFT)begin
										if(cube_x[0] == 1)
											hit_wall <= 1;
										else
											cube_x[0] <= cube_x[0] - 1;											
										end

								else if(direct_r==RIGHT)begin
										if(cube_x[0] == 38)
											hit_wall <= 1;
										else
											cube_x[0] <= cube_x[0] + 1;
										end
								
							end
						end
						end
					end
				end

	
	always @(*) begin  
		case(direct_r)	
			UP: begin  
				if(~key1_left)
					direct_next = LEFT;
				else if(~key0_right)
					direct_next = RIGHT;
				else
					direct_next = UP;			
				end		
			DOWN: begin
				if(~key1_left)
					direct_next = LEFT;
				else if(~key0_right)
					direct_next = RIGHT;
				else
					direct_next = DOWN;			
				end		
				LEFT: begin
				if(~key3_up)
					direct_next = UP;
				else if(~key2_down)
					direct_next = DOWN;
				else
					direct_next = LEFT;			
				end
				RIGHT: begin
				if(~key3_up)
					direct_next = UP;
				else if(~key2_down)
					direct_next = DOWN;
				else
					direct_next = RIGHT;
				end	
		endcase
	end
	
	always @(posedge clk or negedge rst_n) begin

		if(!rst_n) begin
			is_exist <= 16'd31;
			cube_num <= 5;  
			addcube_state <= 0;
		end  
		else if (game_status == RESTART) begin
		      is_exist <= 16'd31;
              cube_num <= 5;
              addcube_state <= 0;
         end
		else begin			
			case(addcube_state) 
				0:begin
					if(add_cube) begin
						cube_num <= cube_num + 1;
						is_exist[cube_num] <= 1;
						addcube_state <= 1;
					end						
				end
				1:begin
					if(!add_cube)
						addcube_state <= 0;				
				end
			endcase
		end
	end

	always @(pos_x or pos_y ) begin				
		if(pos_x >= 0 && pos_x < 640 && pos_y >= 0 && pos_y < 480) begin
			if(pos_x[9:4] == 0 || pos_y[9:4] == 0 || pos_x[9:4] == 39 || pos_y[9:4] == 29 )
				snake_show = WALL;
				
			else if(pos_x[9:4] == cube_x[0] && pos_y[9:4] == cube_y[0] && is_exist[0] == 1) 
				snake_show = (snake_display == 1) ? HEAD : NONE;
			else if
				((pos_x[9:4] == cube_x[1] && pos_y[9:4] == cube_y[1] && is_exist[1] == 1)|
				 (pos_x[9:4] == cube_x[2] && pos_y[9:4] == cube_y[2] && is_exist[2] == 1)|
				 (pos_x[9:4] == cube_x[3] && pos_y[9:4] == cube_y[3] && is_exist[3] == 1)|
				 (pos_x[9:4] == cube_x[4] && pos_y[9:4] == cube_y[4] && is_exist[4] == 1)|
				 (pos_x[9:4] == cube_x[5] && pos_y[9:4] == cube_y[5] && is_exist[5] == 1)|
				 (pos_x[9:4] == cube_x[6] && pos_y[9:4] == cube_y[6] && is_exist[6] == 1)|
				 (pos_x[9:4] == cube_x[7] && pos_y[9:4] == cube_y[7] && is_exist[7] == 1)|
				 (pos_x[9:4] == cube_x[8] && pos_y[9:4] == cube_y[8] && is_exist[8] == 1)|
				 (pos_x[9:4] == cube_x[9] && pos_y[9:4] == cube_y[9] && is_exist[9] == 1)|
				 (pos_x[9:4] == cube_x[10] && pos_y[9:4] == cube_y[10] && is_exist[10] == 1)|
				 (pos_x[9:4] == cube_x[11] && pos_y[9:4] == cube_y[11] && is_exist[11] == 1)|
				 (pos_x[9:4] == cube_x[12] && pos_y[9:4] == cube_y[12] && is_exist[12] == 1)|
				 (pos_x[9:4] == cube_x[13] && pos_y[9:4] == cube_y[13] && is_exist[13] == 1)|
				 (pos_x[9:4] == cube_x[14] && pos_y[9:4] == cube_y[14] && is_exist[14] == 1)|
				 (pos_x[9:4] == cube_x[15] && pos_y[9:4] == cube_y[15] && is_exist[15] == 1))
				 snake_show = (snake_display == 1) ? BODY : NONE;
			else snake_show = NONE;
		end
	end
endmodule