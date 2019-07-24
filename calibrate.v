`timescale 1ns / 1ns // `timescale time_unit/time_precision

module calibrate (input [8:6] SW,
						input [2:0] KEY,
						input clock,
						output enable_pixel_add,
								 enable_filter_add,
								 enable_pixel_sub,
								 enable_filter_sub,
								 reset_pixel,
								 reset_filter,
						output [2:0]		 current_state);

control_calibration  C1 (.SW(SW), .KEY(KEY), .enable_pixel_add(enable_pixel_add),
								 .enable_filter_add(enable_filter_add), .enable_pixel_sub(enable_pixel_sub),
								 .enable_filter_sub(enable_filter_sub), .reset_pixel(reset_pixel),
								 .reset_filter(reset_filter), .clock(clock), .current_state(current_state));		
						
endmodule // calibrate


module control_calibration (input [8:6] SW,
									 input [2:0] KEY,
									 input clock,
									 output reg  enable_pixel_add,
													 enable_filter_add,
													 enable_pixel_sub,
													 enable_filter_sub,
													 reset_pixel,
													 reset_filter,
									output reg [2:0] current_state);

				reg [2:0] next_state;
				
				localparam 	KEY_WAIT 		= 3'd0,
								CALIBRATE		= 3'd1,
								CALIBRATE_WAIT	= 3'd2,
								RESET 			= 3'd3,
								RESET_WAIT 		= 3'd4;

				// state table
				always @(*)
				begin
					//
					case (current_state)
						//
						KEY_WAIT: 			if ((KEY[2] ^ KEY[1]) & (SW[6] == 0))
												begin
													next_state = CALIBRATE;
												end
												
												else if (SW[6] == 1)
												begin
													next_state = RESET;
												end
												
												else
												begin
													next_state = KEY_WAIT;
												end
						//
						CALIBRATE:			next_state = CALIBRATE_WAIT;
						//
						CALIBRATE_WAIT:	next_state = ((KEY[2] == 1) & (KEY[1] == 1)) ? KEY_WAIT : CALIBRATE_WAIT;
						//
						RESET:  				next_state = RESET_WAIT;
						//
						RESET_WAIT:			next_state = (SW[6] == 0) ? KEY_WAIT: RESET_WAIT;												
						//
						default: next_state = KEY_WAIT;
					endcase
					//
					
				end // state_table
				
				// output logic for datapath control signals
				always @(*)
				begin
				// all signals are 0 by default, to avoid latches.

					enable_pixel_add 	= 1'd0;
					enable_filter_add	= 1'd0;
					enable_pixel_sub 	= 1'd0;
					enable_filter_sub = 1'd0;
					reset_pixel			= 1'd0;
					reset_filter 		= 1'd0;
					
					case (current_state)
						//
						KEY_WAIT:		; // nothing
						//
						CALIBRATE:		if ((SW[8] == 1) & (SW[7] == 0) & (KEY[2] == 0))
												enable_filter_add = 1'd1;
											
											else if ((SW[8] == 1) & (SW[7] == 0) & (KEY[1] == 0))
												enable_filter_sub = 1'd1;
												
											else if ((SW[8] == 0) & (SW[7] == 1) & (KEY[2] == 0))
												enable_pixel_add = 1'd1;
											
											else if ((SW[8] == 0) & (SW[7] == 1) & (KEY[1] == 0))
												enable_pixel_sub = 1'd1;
						//
						CALIBRATE_WAIT: ; // nothing
						//
						RESET:			// global reset happens if sw 7 is up with both down.
											// else only the selected is reset
											if ((SW[8] == 1) & (SW[7] == 0))
												reset_filter = 1'd1;
											
											else if ((SW[8] == 0) & (SW[7] == 1))
												reset_pixel = 1'd1;
											
											else if ((SW[8] == 0) & (SW[7] == 0))
											begin
												reset_pixel = 1'd1;
												reset_filter = 1'd1;
											end
						//
						RESET_WAIT:		; // nothing
						
						// no default needed; all of our outputs were assigned a value
					endcase		 
				
				end // enable_signals
				
				// current_state registers
				always @(posedge clock)
				begin
					if(~KEY[0] == 1)
						current_state <= KEY_WAIT;
					else
						current_state <= next_state;
				end // state_FFS
				
endmodule // control_calibration