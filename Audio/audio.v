module Audio_main(input CLOCK_50, input [0:0] KEY, input [5:3] SW, 	

						inout AUD_BCLK, 
						AUD_ADCLRCK, 
						AUD_DACLRCK,
						
						input AUD_ADCDAT,
						output 
						AUD_XCK,
						AUD_DACDAT

						
						//inout				FPGA_I2C_SDAT,
						//output				FPGA_I2C_SCLK
						);
						
	


/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
// Internal Wires
wire				audio_in_available;
wire		[31:0]	left_channel_audio_in;
wire		[31:0]	right_channel_audio_in;
wire				read_audio_in;

wire				audio_out_allowed;
wire		[31:0]	left_channel_audio_out;
wire		[31:0]	right_channel_audio_out;
wire				write_audio_out;

	
	
	wire [5:0] audio_out_ram;
	wire [15:0] address_count;
	
	assign read_audio_in = audio_in_available & audio_out_allowed;
	//assign left_channel_audio_out = {audio_out_ram, 26'b0};
	//assign right_channel_audio_out = 32'b0;
	assign write_audio_out = audio_in_available & audio_out_allowed;
	

				reg [15:0] address; // initialize this where?????
				reg [15:0] cycleCount; // 11 bit will workkkkk change to 11 bit
				reg [15:0] address_start, address_end;
				always @(posedge CLOCK_50) // triggered on edges of clock
				begin
					if (~KEY[0])
					begin
						address_start <= 16'd0;
						address_end <= 16'd0;
						cycleCount <= 16'd0;
						address <= address_start;
					end
					
					if (SW[5] == 1)
					begin
						address_start <= 16'd0;
						address_end <= 16'd27100;
						cycleCount <= 16'd0;
						address <= address_start;
					end
					
					else if (SW[4] == 1)
					begin
						address_start <= 16'd27101;
						address_end <= 16'd43830;
						cycleCount <= 16'd0;
						address <= address_start;
					end
					
					else if (SW[3] == 1)
					begin
						address_start <= 16'd43831;
						address_end <= 16'd54300;
						cycleCount <= 16'd0;
						address <= address_start;
					end
					
					
					
					
				// when reach depth, eof. reset
					if (cycleCount  == 16'd2000) // synchronous active-high
					begin
						address <= address + 16'd1;
						cycleCount <= 16'd0;
					end
					
					else 
					begin
						cycleCount <= cycleCount + 16'd1;
					end
					
					if (address == address_end)
					begin
						cycleCount <= 16'd0;
						address <= address_start;
					end
					
				end
				 
				
assign address_count = address;


audio_ram2 ar (
	.address(address_count),
	.clock(CLOCK_50),
	.data(),
	.wren(1'b0),
	.q(audio_out_ram));




Audio_Controller  AC (

	// Inputs
	.CLOCK_50(CLOCK_50),
	.reset(~KEY[0]),

	.clear_audio_in_memory(),	
	.read_audio_in(read_audio_in),

	.clear_audio_out_memory(),
	.left_channel_audio_out({audio_out_ram, 26'b0}),
	.right_channel_audio_out(32'b0),
	.write_audio_out(1'b1),

	.AUD_ADCDAT(AUD_ADCDAT),

	// Bidirectionals
	.AUD_BCLK(AUD_BCLK),
	.AUD_ADCLRCK(AUD_ADCLRCK),
	.AUD_DACLRCK(AUD_DACLRCK),

	// Outputs
	.left_channel_audio_in(left_channel_audio_in),
	.right_channel_audio_in(right_channel_audio_in),
	.audio_in_available(audio_in_available),

	.audio_out_allowed(audio_out_allowed),
	.AUD_DACDAT(AUD_DACDAT),
	.AUD_XCK(AUD_XCK)
	
);
/*
avconf #(.USE_MIC_INPUT(1)) avc (
	.FPGA_I2C_SCLK					(FPGA_I2C_SCLK),
	.FPGA_I2C_SDAT					(FPGA_I2C_SDAT),
	.CLOCK_50					(CLOCK_50),
	.reset						(~KEY[0])
);
*/
	
endmodule //