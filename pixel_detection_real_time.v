`timescale 1ns / 1ns // `timescale time_unit/time_precision

module pixel_sequence_detector (
				input [29:0] 	input_pixel, 
				input 			vsync, 
									hsync,
									clock,
				input [10:0] 	x_curr, 
									y_curr,
				input [8:6]    SW,	
				input [2:0] 	KEY,
				output [10:0] 	x_start, 
									y_start, 
									x_end, 
									y_end, 
									x_center, 
									y_center, 
									x_out,
									y_out,
				output [8:0]	count,
				output [7:0]	counter_wire,
				output [29:0] 	output_pixel,
				output 			object_found,
				output [2:0]	current_state_pixel
);


wire			ld_max_count,
				ld_x_s_max,
				ld_y_s_max,
				ld_x_e_max,
				ld_y_e_max,
				ld_x_s,
				ld_y_s,
				ld_x_e,
				ld_y_e,
				ld_x_curr,
				ld_y_curr,
				ld_count;

control C1 (.input_pixel (input_pixel), 
				.vsync (vsync), 
				.hsync (hsync),
				.clock (clock),
				.ld_max_count (ld_max_count),
				.ld_x_s_max (ld_x_s_max),
				.ld_y_s_max (ld_y_s_max),
				.ld_x_e_max (ld_x_e_max),
				.ld_y_e_max (ld_y_e_max),
				.ld_x_s (ld_x_s),
				.ld_y_s (ld_y_s),
				.ld_x_e (ld_x_e),
				.ld_y_e (ld_y_e),
				.ld_x_curr (ld_x_curr),
				.ld_y_curr (ld_y_curr),
				.ld_count (ld_count));

datapath D1 (
				.input_pixel (input_pixel), 
				.vsync (vsync), 
				.hsync (hsync),
				.clock (clock),
				.ld_max_count (ld_max_count),
				.ld_x_s_max (ld_x_s_max),
				.ld_y_s_max (ld_y_s_max),
				.ld_x_e_max (ld_x_e_max),
				.ld_y_e_max (ld_y_e_max),
				.ld_x_s (ld_x_s),
				.ld_y_s (ld_y_s),
				.ld_x_e (ld_x_e),
				.ld_y_e (ld_y_e),
				.ld_count (ld_count),
				.ld_x_curr (ld_x_curr),
				.ld_y_curr (ld_y_curr),
				.x_curr (x_curr), 
				.y_curr (y_curr),
				.count (count),	
				.x_start (x_start), 
				.y_start (y_start), 
				.x_end (x_end), 
				.y_end (y_end), 
				.x_center (x_center), 
				.y_center (y_center),
				.x_out (x_out),
				.y_out (y_out),
				.output_pixel (output_pixel),
				.object_found (object_found),
				.SW(SW),
				.KEY(KEY),
				.counter_threshold(counter_wire),
				.current_state(current_state_pixel));

endmodule // pixel_sequence_detector

module control (
				input [29:0] 	input_pixel, 
				input 			vsync, 
									hsync,
									clock,
				output reg		ld_max_count,
									ld_x_s_max,
									ld_y_s_max,
									ld_x_e_max,
									ld_y_e_max,
									ld_x_s,
									ld_y_s,
									ld_x_e,
									ld_y_e,
									ld_x_curr,
									ld_y_curr,
									ld_count);

				reg [3:0] current_state, next_state;
				localparam 	READ_PIXEL 	= 3'd0,
								REG_START 	= 3'd1,
								COUNT_PIXEL = 3'd2,
								NEW_PIXEL   = 3'd3,
								REG_END 		= 3'd4;
				
				// state table
				always @(*)
				begin

				case (current_state)
					//
					READ_PIXEL: next_state = (input_pixel > 0) ? REG_START: READ_PIXEL;
					//
					REG_START:	next_state = COUNT_PIXEL;
					//
					COUNT_PIXEL:next_state = (input_pixel > 0) ? NEW_PIXEL : REG_END;
					//
					NEW_PIXEL:  next_state = COUNT_PIXEL;
					//
					REG_END:		next_state = READ_PIXEL;
					//
					default: next_state = READ_PIXEL;
				endcase

				end // state_table

				// output logic for datapath control signals
				always @(*)
				begin
				// all signals are 0 by default, to avoid latches.

					ld_max_count= 1'b0;
					ld_x_s_max 	= 1'b0;
					ld_y_s_max 	= 1'b0;
					ld_x_e_max 	= 1'b0;
					ld_y_e_max 	= 1'b0;
					ld_x_s	  	= 1'b0;
					ld_y_s	  	= 1'b0;
					ld_x_e	  	= 1'b0;
					ld_y_e	  	= 1'b0;
					ld_x_curr	= 1'b0;
					ld_y_curr	= 1'b0;
					ld_count 	= 1'b0;
					
					case (current_state)
						READ_PIXEL:	begin
											// nothing
										end
						
						REG_START:	begin
											ld_x_s 		= 1'b1;
											ld_y_s 		= 1'b1;
										end
						COUNT_PIXEL:begin
											ld_count 	= 1'b1;
										end
						NEW_PIXEL:  begin
											ld_x_curr   = 1'b1;
											ld_y_curr   = 1'b1;
										end
										
						REG_END:		begin
											ld_x_e 		= 1'b1;
											ld_y_e 		= 1'b1;
											ld_max_count= 1'b1;
											ld_x_s_max 	= 1'b1;
											ld_y_s_max 	= 1'b1;
											ld_x_e_max 	= 1'b1;
											ld_y_e_max 	= 1'b1;
										end
						// no default needed; all of our outputs were assigned a value
					endcase		 
				
				end // enable_signals
				
				// current_state registers
				always @(posedge clock)
				begin
					if(vsync == 1'b1)
						current_state <= READ_PIXEL;
					else
						current_state <= next_state;
				end // state_FFS
				
endmodule //control

module datapath (
				input  		[29:0]input_pixel, 
				input 				vsync, 
										hsync,
										clock,
										ld_max_count,
										ld_x_s_max,
										ld_y_s_max,
										ld_x_e_max,
										ld_y_e_max,
										ld_x_s,
										ld_y_s,
										ld_x_e,
										ld_y_e,
										ld_x_curr,
										ld_y_curr,
										ld_count,
				input  		[10:0]x_curr, 
										y_curr,
				input       [8:6] SW,
				input			[2:0] KEY,
				output reg 	[8:0] count,	
				output reg	[10:0]x_start, 
										y_start, 
										x_end, 
										y_end, 
										x_center, 
										y_center,
										x_out,
										y_out,
				output reg  [29:0]output_pixel,
				output reg			object_found,
				output reg [7:0]   counter_threshold,
				output  [2:0]	 current_state
);

				// input registers
				reg [10:0] 	x_s, x_e, x_s_max, x_e_max, 
								y_s, y_e, y_s_max, y_e_max,
								x_curr_reg, y_curr_reg; 
				reg [8:0] 	max_count, vsync_count;
				
				
				localparam 	//counter_threshold = 9'd25,
								X_LIM_START 		= 9'd200,
								X_LIM_END 			= 9'd300,
								Y_LIM_START 		= 9'd250,
								Y_LIM_END 			= 9'd300;
////////////////////////////////////////////////////////
//
//				always @(posedge ~KEY[2])
//				begin
//					if ((counter_threshold ==9'd5))
//						begin
//							counter_threshold <= 9'd30;
//						end
//						
//					else if((counter_threshold >= 9'd100))
//						begin
//							counter_threshold <= 9'd30;
//						end
//						
//					else if ((SW[9] == 1) & (SW[8] == 0) & (SW[7] == 0) & (KEY[1]))
//						begin
//						counter_threshold <= counter_threshold + 9'd5;
//						end
//				end
//
//				always @(posedge ~KEY[1])
//				begin
//					if ((counter_threshold ==9'd5))
//						begin
//							counter_threshold <= 9'd30;
//						end
//						
//					else if((counter_threshold >= 9'd100))
//						begin
//							counter_threshold <= 9'd30;
//						end
//						
//					else if ((SW[9] == 1) & (SW[8] == 0) & (SW[7] == 0) & (KEY[2]))
//						begin
//						counter_threshold <= counter_threshold - 9'd5;
//						end
//				end
//				
//				always @ (posedge clock)
//				begin
//					if ((SW[9] == 1) & (SW[8] == 0) & (SW[7] == 1))
//						begin
//						counter_threshold <= 9'd30;
//						end
//					else if (~KEY[0])
//					begin
//					counter_threshold <= 9'd30;
//					end
//				end


//				always @(posedge ~KEY[1])
//				begin
//					if ((counter_threshold == 9'd5))
//						begin
//							counter_threshold <= 9'd30;
//						end
//						
//					else if((counter_threshold >= 9'd100))
//						begin
//							counter_threshold <= 9'd30;
//						end
//						
//					else if ((SW[9] == 0) & (SW[8] == 1) & (SW[7] == 1) & (SW[6] == 0))
//						begin
//						counter_threshold <= counter_threshold + 9'd5;
//						end
//						
//					else if ((SW[9] == 1) & (SW[8] == 1) & (SW[7] == 0) & (SW[6] == 0))
//						begin
//						counter_threshold <= counter_threshold - 9'd5;
//						end
//
//					else if ((SW[9] == 0) & (SW[8] == 1) & ((SW[7] == 0) | (SW[7] == 1)) & (SW[6] == 1))
//						begin
//						counter_threshold <= 9'd30;
//						end
//					else if ((SW[9] == 1) & (SW[8] == 1) & ((SW[7] == 0) | (SW[7] == 1)) & (SW[6] == 1))
//						begin
//						counter_threshold <= 9'd30;
//						end
//				end


				always @(posedge clock)
				begin
					if ((counter_threshold <= 8'd5))
						begin
							counter_threshold <= 8'd30;
						end
						
					else if((counter_threshold >= 8'd100))
						begin
							counter_threshold <= 8'd30;
						end
						
					else if (enable_pixel_add)
						begin
						counter_threshold <= counter_threshold + 8'd5;
						end
						
					else if (enable_pixel_sub)
						begin
						counter_threshold <= counter_threshold - 8'd5;
						end

					else if (reset_pixel)
						begin
						counter_threshold <= 8'd30;
						end
					
					else
						counter_threshold = counter_threshold;
				end

wire enable_pixel_add,
	  enable_filter_add,
	  enable_pixel_sub,
	  enable_filter_sub,	 
	  reset_pixel,
	  reset_filter; 

calibrate pixel ( .SW(SW),
				.KEY(KEY),
				.clock(clock),
				.enable_pixel_add(enable_pixel_add),
				.enable_filter_add(enable_filter_add),
				.enable_pixel_sub(enable_pixel_sub),
				.enable_filter_sub(enable_filter_sub),
				.reset_pixel(reset_pixel),
				.reset_filter(reset_filter),
				.current_state(current_state));
								 

/////////////////////////////////////////////////////////
				always @(posedge clock)
				begin  
				  if(vsync == 1'b1) 
				  begin
						x_s 		<= 11'd0;
						x_e 		<= 11'd0; 
						x_s_max 	<= 11'd0; 
						x_e_max 	<= 11'd0;
						y_s 		<= 11'd0;
						y_e 		<= 11'd0;
						y_s_max 	<= 11'd0;
						y_e_max 	<= 11'd0;
						x_curr_reg <= 11'd0;
						y_curr_reg <= 11'd0;
						count 	<= 9'd0; 
						max_count<= 9'd0;
						vsync_count <= vsync_count + 1;
				  end
				  else if(hsync == 1'b1) 
				  begin
						count <= 1'b0;
				  end
				  else 
				  begin
						// 
						if ((ld_x_s == 1'b1) & (ld_y_s == 1'b1))
						begin
							 x_s 		<= x_curr;
							 y_s 		<= y_curr;
							 //x_curr_reg <= x_curr;
							 //y_curr_reg <= y_curr;
							 count 	<= 9'd0;
							 max_count <= 9'd0;
							 if (vsync_count > 500)
							 begin
								object_found <= 1'b0;
								vsync_count <= 0;
							 end
						end
						// 
						if (ld_count == 1'b1)
						begin
							 //if (x_curr_reg != x_curr)
							 if ((x_s > X_LIM_START) & (x_s < X_LIM_END) & 
								 (y_s > Y_LIM_START) & (y_s < Y_LIM_END))
								count <= count + 1;
						end
						//
//						if ((ld_x_curr == 1'b1) & (ld_y_curr == 1'b1))
//						begin
//							x_curr_reg <= x_curr;
//							y_curr_reg <= y_curr;
//						end
						//		
//						if (	(ld_max_count 	== 1'b1) &
//								(ld_x_s_max  	== 1'b1) &
//								(ld_y_s_max 	== 1'b1) &
//								(ld_x_e_max  	== 1'b1) &
//								(ld_y_e_max 	== 1'b1) &
//								(ld_x_e     	== 1'b1) &
//								(ld_y_e     	== 1'b1)
//							)
//						begin
//							if (count >= max_count)
//							begin
//								max_count  <= count;
//								x_s_max <= x_s;
//								y_s_max <= y_s;
//								x_e <= x_curr;
//								y_e <= y_curr;
//								x_e_max <= x_e; 
//								y_e_max <= y_e;
//							end
//							if(max_count > threshold)
//							begin
//								x_center <= (x_s_max + ((x_e_max + x_s_max)/2));
//								y_center <= y_e_max;
//								object_found <= 1'b1;
//								output_pixel <= {10'b1111111100, 10'd0, 10'd0};
//							end
//						end
//					end
//					if (object_found == 1'b1)
//					begin
////						x_out <= x_center;
////						y_out <= y_center;
//						output_pixel <= {10'b1111111100, 10'd0, 10'd0};
//						// drawn COM
//						object_found <= 1'b0;
//					end
//					else
//					begin
////						x_out <= x_curr;
////						y_out <= y_curr;
//						output_pixel <= input_pixel;
//					end
					end // for the reset else's
					
					if ((count > counter_threshold) & (input_pixel != 0))
					begin
						output_pixel <= {10'b1111111100, 10'd0, 10'd0};
						object_found <= 1'b1;
					end
					else
					begin
						output_pixel <= input_pixel;
					end
					x_out <= x_curr;
					y_out <= y_curr;
				end

endmodule // datapath