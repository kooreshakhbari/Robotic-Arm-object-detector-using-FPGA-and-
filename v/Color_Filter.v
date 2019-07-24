module Color_Filter (
input clk,
input [9:0] oVGA_Red,
input [9:0] oVGA_Green,
input [9:0] oVGA_Blue,
input [8:6] SW,
input [2:0] KEY,
output reg [29:0] filtered_color,
output reg [9:0] counter_threshold,
output [2:0] current_state);
////temp channels for color extraction
//reg [9:0] filtered_Red;
//reg [9:0] filtered_Green;
//reg [9:0] filtered_Blue;
////temp channels for grayscale conversion
//reg [9:0] greyscale_Red;
//reg [9:0] greyscale_Green;
//reg [9:0] greyscale_Blue;
////temp channels for black -> white conversion
//reg [9:0] updated_greyscale_Red;
//reg [9:0] updated_greyscale_Green;
//reg [9:0] updated_greyscale_Blue;
////values for color extraction
//parameter redFilterValue = 150;
//parameter greenFilterValue = 110;
//parameter blueFilterValue = 110;
//parameter white = 10'b1111111111;
//
/////////////
//parameter black = 10'b0;
//parameter thresh = 10'd35;
////reg [7:0]
//
////////////
//
////filter out all color that isn't red
//always @ (posedge clk) begin
//	filtered_Red <= (oVGA_Red >= redFilterValue && oVGA_Green <= greenFilterValue &&
//	oVGA_Blue <= blueFilterValue) ? oVGA_Red : 0;
//	filtered_Green <= (oVGA_Red >= redFilterValue && oVGA_Green <= greenFilterValue &&
//	oVGA_Blue <= blueFilterValue) ? oVGA_Green : 0;
//	filtered_Blue <= (oVGA_Red >= redFilterValue && oVGA_Green <= greenFilterValue &&
//	oVGA_Blue <= blueFilterValue) ? oVGA_Blue : 0;
//end
////RGB->Greyscale
//always @ (posedge clk) begin
//	greyscale_Red <= (filtered_Red>>2) + (filtered_Red>>5) + (filtered_Green>>1) +
//	(filtered_Green>>4) + (filtered_Blue>>4) + (filtered_Blue>>5);
//	greyscale_Green <= (filtered_Red>>2) + (filtered_Red>>5) + (filtered_Green>>1) +
//	(filtered_Green>>4) + (filtered_Blue>>4) + (filtered_Blue>>5);
//	greyscale_Blue <= (filtered_Red>>2) + (filtered_Red>>5) + (filtered_Green>>1) +
//	(filtered_Green>>4) + (filtered_Blue>>4) + (filtered_Blue>>5);
//end
//Changes all greyscale values below 51 to white (black -> whtie)

///////////////////////////


wire enable_pixel_add,
	  enable_filter_add,
	  enable_pixel_sub,
	  enable_filter_sub,	 
	  reset_pixel,
	  reset_filter; 

calibrate filter ( .SW(SW),
				.KEY(KEY),
				.clock(clk),
				.enable_pixel_add(enable_pixel_add),
				.enable_filter_add(enable_filter_add),
				.enable_pixel_sub(enable_pixel_sub),
				.enable_filter_sub(enable_filter_sub),
				.reset_pixel(reset_pixel),
				.reset_filter(reset_filter),
				.current_state(current_state));
								 
				
				
				always @(posedge clk)
				begin
					if ((counter_threshold <= 10'd0))
						begin
							counter_threshold <= 10'd600;
						end
						
					else if((counter_threshold >= 10'd1020))
						begin
							counter_threshold <= 10'd600;
						end
						
					else if (enable_filter_add)
						begin
						counter_threshold <= counter_threshold + 10'd10;
						end
						
					else if (enable_filter_sub)
						begin
						counter_threshold <= counter_threshold - 10'd10;
						end

					else if (reset_filter)
						begin
						counter_threshold <= 10'd600;
						end
					
					else
						counter_threshold <= counter_threshold;
				end


//////////////////////////
always @ (posedge clk) begin
				
				if ((oVGA_Red < counter_threshold) & (oVGA_Green < counter_threshold) & (oVGA_Blue < counter_threshold))
						filtered_color <= 30'd0; // black
				else filtered_color <= 30'b111111110011111111001111111100; // white

//	updated_greyscale_Red = ((oVGA_Red + oVGA_Green + oVGA_Blue)/3 >= thresh) ? white : black;//(greyscale_Red >= 70 ) ? white : black;//greyscale_Red;
//	updated_greyscale_Green = ((oVGA_Red + oVGA_Green + oVGA_Blue)/3 >= thresh) ? white : black;//(greyscale_Green >= 70) ? white : black;//greyscale_Green;
//	updated_greyscale_Blue = ((oVGA_Red + oVGA_Green + oVGA_Blue)/3 >= thresh) ? white : black;//(greyscale_Blue >= 70) ? white : black;//greyscale_Blue;
end
//appends the three channels together to be the output 24 bit image data
//always @ (posedge clk) begin
//
////	filtered_color <= {updated_greyscale_Red, updated_greyscale_Blue, updated_greyscale_Green};
//end
endmodule //