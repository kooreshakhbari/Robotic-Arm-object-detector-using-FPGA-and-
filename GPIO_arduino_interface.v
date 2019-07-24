`timescale 1ns / 1ns // `timescale time_unit/time_precision

module GPIO_Arduino (input  		reset,
											object_found,
											clock_50,
											SW,
							output [4:0]sig_out,
							/// FOR TESTING
							output 		counted,
											implement, 
											start_ctr
											);
							 


control_ard C0 (.reset(reset),
					 .object_found(object_found),
					 .counted(counted),
					 .clock(clock_50),
					 .send_search(send_search),
					 .send_place(send_place),
					 .send_stop(send_stop),
					 .send_reset_position(send_reset_position),
					 .start_ctr(start_ctr),
					 .SW(SW)
					 );

			 
datapath_ard D0 (.send_search(send_search),
					.send_place(send_place),
					.send_stop(send_stop),
					.send_reset_position(send_reset_position),
					.implement(implement),
					.clock(clock_50),
					.signal_out(sig_out));
								
counter CTR1 (.clock(clock_50), 
				 .start_ctr(start_ctr), 
				 .counted(counted), 
				 .implement(implement));

endmodule 


module control_ard	(input		reset,
											object_found,
											counted,
											clock,
											SW,
							output reg 	send_search, 
											send_place, 
											send_stop, 
											send_reset_position, 
											start_ctr
											);

				reg [3:0] current_state, next_state;
				
				// state_FF assignments
				localparam  START_ROUTINE	= 4'd0,
								SET_RESET  		= 4'd1,
								RESET				= 4'd2,
								SET_SEARCH		= 4'd3,
								SEARCH			= 4'd4,
								SEARCH_META 	= 4'd5,
								SET_PLACE		= 4'd6,
								PLACE				= 4'd7,
								SET_STOP			= 4'd8,
								STOP  			= 4'd9;
								
				// state table
				always @(*)
				begin
				//
					case (current_state)
						// 
						START_ROUTINE:		 	begin
														next_state = SET_RESET;
													end
										  
						SET_RESET:  			begin
														if ((!counted) & (!reset)) 
															next_state = SET_RESET;
														else if (reset)
															next_state = START_ROUTINE;
														else 
															next_state = RESET;
													end
						
						RESET: 					begin
														next_state = (SW == 0) ? RESET : SET_SEARCH;
													end
														
						SET_SEARCH:				begin
														if ((!counted) & (!reset)) 
															next_state = SET_SEARCH;
														else if (reset)
															next_state = START_ROUTINE;
														else 
															next_state = SEARCH;
													end
												  
						SEARCH: 				  	begin
														if ((!object_found) & (!reset)) 
															next_state = SEARCH;
														else if (reset)
															next_state = START_ROUTINE;
														else
															next_state = SEARCH_META;
													end
													
						SEARCH_META:			begin
														next_state = SET_PLACE;
													end
												 
						SET_PLACE:				begin
														if ((!counted) & (!reset))
															next_state = SET_PLACE;
														else if (reset)
															next_state = START_ROUTINE;
														else 
															next_state = PLACE;
													end
												  
						PLACE:  		  			begin
														next_state = SET_STOP;
													end
												  
						SET_STOP:				begin
														if ((!counted) & (!reset)) 
															next_state = STOP;
														else if (reset) 
															next_state = START_ROUTINE;
														else  
															next_state = STOP;
													end
												  
						STOP:						begin
														if (reset)
															next_state = START_ROUTINE;
														else
															next_state = STOP;
													end
													
						default: 				next_state = START_ROUTINE;
						//
					endcase
				end
				
				// output logic
				always @(*)
				begin
					
					send_search				= 1'b0;
					send_place				= 1'b0;
					send_stop				= 1'b0;
					send_reset_position	= 1'b0;
					start_ctr 				= 1'b0;

					
					case (current_state)
						// 
						START_ROUTINE:		begin
													send_reset_position = 1;
													start_ctr = 1;
												end
										  
						SET_RESET:  		begin
													send_reset_position = 1;
												end
						
						RESET: 				begin													
													send_search = 1;
													start_ctr = 1;
												end
												
						SET_SEARCH:			begin
													send_search = 1;
												end
												  
						SEARCH:				begin
													send_search = 1;
													
												end
												
						SEARCH_META: 		begin
													send_place = 1;
													start_ctr = 1;
												end
												 
						SET_PLACE:			begin
													send_place = 1;
													
												end
												  
						PLACE:  		  		begin
													send_stop = 1;
													start_ctr = 1;
													
												end
												  
						SET_STOP:			begin
													send_stop = 1;
													
												end
												  
					   STOP:			  		begin
													send_reset_position = 1;
												end
						// no defaults
					endcase

				end // output logic

				// current_state registers
				always @(posedge clock)
				begin
					if(reset)
						current_state <= START_ROUTINE;
					else
						current_state <= next_state;
				end // state_FFs transition

endmodule // control

/* datapath module */
module datapath_ard (input 				send_search,
													send_place,
													send_stop,
													send_reset_position,
													implement,
													clock,
							output reg [4:0] 	signal_out);

				// 
				localparam	SEARCH			= 4'b1000,
								PLACE				= 4'b0100,
								RESET_POSITION	= 4'b0010,
								STOP				= 4'b0001;
				
				// 
				always @(posedge clock)
				begin
					if(send_reset_position) 
					begin
						signal_out [4:1] <= RESET_POSITION;
				   end
					
					else if (send_search) 
					begin
						signal_out [4:1] <= SEARCH;
				   end
					
					else if (send_place) 
					begin
						signal_out [4:1] <= PLACE;
				   end
					
					else if(send_stop) 
					begin
						signal_out [4:1] <= STOP;
				   end
					
					signal_out[0] <= implement;
				end

endmodule // datapath


/**/
module counter (input clock, start_ctr, output reg counted, implement);
				
				reg [26:0] cycleCount;
				
				always @(posedge clock) // triggered on edges of clock
				begin
				
					if (start_ctr == 1'b1) // synchronous active-high
					begin
						cycleCount <= 27'd50000000;
						counted <= 1'b0;
						implement <= 1'b0;
					end
					else if (cycleCount > 27'd25000000)
					begin
						cycleCount <= cycleCount - 1'b1; // decrement state
						counted <= 1'b0;
						implement <= 1'b0;
					end
					else if (cycleCount == 0)
					begin
						counted <= 1'b1;
						implement <= 1'b1;
					end
					
					if ((cycleCount <= 27'd25000000) & (cycleCount > 27'd0))
					begin
						implement <= 1'b1;
						cycleCount <= cycleCount - 1'b1; // decrement state
						counted <= 1'b0;
					end
				end
endmodule // counter