// ============================================================================
// Copyright (c) 2013 by Terasic Technologies Inc.
// ============================================================================
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// ============================================================================
//           
//  Terasic Technologies Inc
//  9F., No.176, Sec.2, Gongdao 5th Rd, East Dist, Hsinchu City, 30070. Taiwan
//  
//  
//                     web: http://www.terasic.com/  
//                     email: support@terasic.com
//
// ============================================================================
//Date:  Mon Jun 17 20:35:29 2013
// ============================================================================

//`define ENABLE_HPS

module DE1_SoC_TV(

      ///////// ADC /////////
      inout              ADC_CS_N,
      output             ADC_DIN,
      input              ADC_DOUT,
      output             ADC_SCLK,

      ///////// AUD /////////
      input              AUD_ADCDAT,
      inout              AUD_ADCLRCK,
      inout              AUD_BCLK,
      output             AUD_DACDAT,
      inout              AUD_DACLRCK,
      output             AUD_XCK,

      ///////// CLOCK2 /////////
      input              CLOCK2_50,

      ///////// CLOCK3 /////////
      input              CLOCK3_50,

      ///////// CLOCK4 /////////
      input              CLOCK4_50,

      ///////// CLOCK /////////
      input              CLOCK_50,

      ///////// DRAM /////////
      output      [12:0] DRAM_ADDR,
      output      [1:0]  DRAM_BA,
      output             DRAM_CAS_N,
      output             DRAM_CKE,
      output             DRAM_CLK,
      output             DRAM_CS_N,
      inout       [15:0] DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_RAS_N,
      output             DRAM_UDQM,
      output             DRAM_WE_N,

      ///////// FAN /////////
      output             FAN_CTRL,

      ///////// FPGA /////////
      output             FPGA_I2C_SCLK,
      inout              FPGA_I2C_SDAT,

      ///////// GPIO /////////
      output     [8:4]         GPIO_0,
      inout     [35:0]         GPIO_1,
 

      ///////// HEX0 /////////
      output      [6:0]  HEX0,

      ///////// HEX1 /////////
      output      [6:0]  HEX1,

      ///////// HEX2 /////////
      output      [6:0]  HEX2,

      ///////// HEX3 /////////
      output      [6:0]  HEX3,

      ///////// HEX4 /////////
      output      [6:0]  HEX4,

      ///////// HEX5 /////////
      output      [6:0]  HEX5,

`ifdef ENABLE_HPS
      ///////// HPS /////////
      inout              HPS_CONV_USB_N,
      output      [14:0] HPS_DDR3_ADDR,
      output      [2:0]  HPS_DDR3_BA,
      output             HPS_DDR3_CAS_N,
      output             HPS_DDR3_CKE,
      output             HPS_DDR3_CK_N,
      output             HPS_DDR3_CK_P,
      output             HPS_DDR3_CS_N,
      output      [3:0]  HPS_DDR3_DM,
      inout       [31:0] HPS_DDR3_DQ,
      inout       [3:0]  HPS_DDR3_DQS_N,
      inout       [3:0]  HPS_DDR3_DQS_P,
      output             HPS_DDR3_ODT,
      output             HPS_DDR3_RAS_N,
      output             HPS_DDR3_RESET_N,
      input              HPS_DDR3_RZQ,
      output             HPS_DDR3_WE_N,
      output             HPS_ENET_GTX_CLK,
      inout              HPS_ENET_INT_N,
      output             HPS_ENET_MDC,
      inout              HPS_ENET_MDIO,
      input              HPS_ENET_RX_CLK,
      input       [3:0]  HPS_ENET_RX_DATA,
      input              HPS_ENET_RX_DV,
      output      [3:0]  HPS_ENET_TX_DATA,
      output             HPS_ENET_TX_EN,
      inout       [3:0]  HPS_FLASH_DATA,
      output             HPS_FLASH_DCLK,
      output             HPS_FLASH_NCSO,
      inout              HPS_GSENSOR_INT,
      inout              HPS_I2C1_SCLK,
      inout              HPS_I2C1_SDAT,
      inout              HPS_I2C2_SCLK,
      inout              HPS_I2C2_SDAT,
      inout              HPS_I2C_CONTROL,
      inout              HPS_KEY,
      inout              HPS_LED,
      inout              HPS_LTC_GPIO,
      output             HPS_SD_CLK,
      inout              HPS_SD_CMD,
      inout       [3:0]  HPS_SD_DATA,
      output             HPS_SPIM_CLK,
      input              HPS_SPIM_MISO,
      output             HPS_SPIM_MOSI,
      inout              HPS_SPIM_SS,
      input              HPS_UART_RX,
      output             HPS_UART_TX,
      input              HPS_USB_CLKOUT,
      inout       [7:0]  HPS_USB_DATA,
      input              HPS_USB_DIR,
      input              HPS_USB_NXT,
      output             HPS_USB_STP,
`endif /*ENABLE_HPS*/

      ///////// IRDA /////////
      input              IRDA_RXD,
      output             IRDA_TXD,

      ///////// KEY /////////
      input       [3:0]  KEY,

      ///////// LEDR /////////
      output      [9:0]  LEDR,

      ///////// PS2 /////////
      inout              PS2_CLK,
      inout              PS2_CLK2,
      inout              PS2_DAT,
      inout              PS2_DAT2,

      ///////// SW /////////
      input       [9:0]  SW,

      ///////// TD /////////
      input              TD_CLK27,
      input      [7:0]  TD_DATA,
      input             TD_HS,
      output             TD_RESET_N,
      input             TD_VS,

      ///////// VGA /////////
      output      [7:0]  VGA_B,
      output             VGA_BLANK_N,
      output             VGA_CLK,
      output      [7:0]  VGA_G,
      output             VGA_HS,
      output      [7:0]  VGA_R,
      output             VGA_SYNC_N,
      output             VGA_VS
);



//=======================================================
//  REG/WIRE declarations
//=======================================================

wire	CLK_18_4;
wire	CLK_25;

//	For Audio CODEC
wire		AUD_CTRL_CLK;	//	For Audio Controller

//	For ITU-R 656 Decoder
wire	[15:0]	YCbCr;
wire	[9:0]	TV_X;
wire			TV_DVAL;

//	For VGA Controller
wire	[9:0]	mRed;
wire	[9:0]	mGreen;
wire	[9:0]	mBlue;
wire	[10:0]	VGA_X;
wire	[10:0]	VGA_Y;
wire			VGA_Read;	//	VGA data request
wire			m1VGA_Read;	//	Read odd field
wire			m2VGA_Read;	//	Read even field

//	For YUV 4:2:2 to YUV 4:4:4
wire	[7:0]	mY;
wire	[7:0]	mCb;
wire	[7:0]	mCr;

//	For field select
wire	[15:0]	mYCbCr;
wire	[15:0]	mYCbCr_d;
wire	[15:0]	m1YCbCr;
wire	[15:0]	m2YCbCr;
wire	[15:0]	m3YCbCr;

//	For Delay Timer
wire			TD_Stable;
wire			DLY0;
wire			DLY1;
wire			DLY2;

//	For Down Sample
wire	[3:0]	Remain;
wire	[9:0]	Quotient;

wire			mDVAL;

wire	[15:0]	m4YCbCr;
wire	[15:0]	m5YCbCr;
wire	[8:0]	Tmp1,Tmp2;
wire	[7:0]	Tmp3,Tmp4;

wire            NTSC;
wire            PAL;
//=============================================================================
// Structural coding
//=============================================================================


/////////////////////////////////////////////////////////////////////////////////////////////// things commented out here

//	All inout port turn to tri-state 
//assign	AUD_ADCLRCK	=	AUD_DACLRCK;
//assign	GPIO_A	=	36'hzzzzzzzzz;
//assign	GPIO_B	=	36'hzzzzzzzzz;

//	Turn On TV Decoder
assign	TD_RESET_N	=	1'b1;

//assign	AUD_XCK	=	AUD_CTRL_CLK;

assign	LED	=	VGA_Y;


assign	m1VGA_Read	=	VGA_Y[0]		?	1'b0		:	VGA_Read	;
assign	m2VGA_Read	=	VGA_Y[0]		?	VGA_Read	:	1'b0		;
assign	mYCbCr_d	=	!VGA_Y[0]		?	m1YCbCr		:
											      m2YCbCr		;
assign	mYCbCr		=	m5YCbCr;

assign	Tmp1	=	m4YCbCr[7:0]+mYCbCr_d[7:0];
assign	Tmp2	=	m4YCbCr[15:8]+mYCbCr_d[15:8];
assign	Tmp3	=	Tmp1[8:2]+m3YCbCr[7:1];
assign	Tmp4	=	Tmp2[8:2]+m3YCbCr[15:9];
assign	m5YCbCr	=	{Tmp4,Tmp3};

//	7 segment LUT
/*SEG7_LUT_6 			u0	(	.oSEG0(HEX0),
							.oSEG1(HEX1),
							.oSEG2(HEX2),
							.oSEG3(HEX3),
							.oSEG4(HEX4),
							.oSEG5(HEX5),
							.iDIG(SW) );
							*/
//	TV Decoder Stable Check
TD_Detect			u2	(	.oTD_Stable(TD_Stable),
							.oNTSC(NTSC),
							.oPAL(PAL),
							.iTD_VS(TD_VS),
							.iTD_HS(TD_HS),
							.iRST_N(KEY[0])	);

//	Reset Delay Timer
Reset_Delay			u3	(	.iCLK(CLOCK_50),
							.iRST(TD_Stable),
							.oRST_0(DLY0),
							.oRST_1(DLY1),
							.oRST_2(DLY2));

//	ITU-R 656 to YUV 4:2:2
ITU_656_Decoder		u4	(	//	TV Decoder Input
							.iTD_DATA(TD_DATA),
							//	Position Output
							.oTV_X(TV_X),
							//	YUV 4:2:2 Output
							.oYCbCr(YCbCr),
							.oDVAL(TV_DVAL),
							//	Control Signals
							.iSwap_CbCr(Quotient[0]),
							.iSkip(Remain==4'h0),
							.iRST_N(DLY1),
							.iCLK_27(TD_CLK27));

//	For Down Sample 720 to 640
DIV 				u5	(	.aclr(!DLY0),	
							.clock(TD_CLK27),
							.denom(4'h9),
							.numer(TV_X),
							.quotient(Quotient),
							.remain(Remain));

//	SDRAM frame buffer
Sdram_Control_4Port	u6	(	//	HOST Side
						   .REF_CLK(TD_CLK27),
							.CLK_18(AUD_CTRL_CLK),
						   .RESET_N(DLY0),
							//	FIFO Write Side 1
						   .WR1_DATA(YCbCr),
							.WR1(TV_DVAL),
							.WR1_FULL(WR1_FULL),
							.WR1_ADDR(0),
							.WR1_MAX_ADDR(NTSC ? 640*507 : 640*576),		//	525-18
							.WR1_LENGTH(9'h80),
							.WR1_LOAD(!DLY0),
							.WR1_CLK(TD_CLK27),
							//	FIFO Read Side 1
						   .RD1_DATA(m1YCbCr),
				        	.RD1(m1VGA_Read),
				        	.RD1_ADDR(NTSC ? 640*13 : 640*22),			//	Read odd field and bypess blanking
							.RD1_MAX_ADDR(NTSC ? 640*253 : 640*262),
							.RD1_LENGTH(9'h80),
				        	.RD1_LOAD(!DLY0),
							.RD1_CLK(TD_CLK27),
							//	FIFO Read Side 2
						    .RD2_DATA(m2YCbCr),
				        	.RD2(m2VGA_Read),
				        	.RD2_ADDR(NTSC ? 640*267 : 640*310),			//	Read even field and bypess blanking
							.RD2_MAX_ADDR(NTSC ? 640*507 : 640*550),
							.RD2_LENGTH(9'h80),
				        	.RD2_LOAD(!DLY0),
							.RD2_CLK(TD_CLK27),
							//	SDRAM Side
						   .SA(DRAM_ADDR),
						   .BA(DRAM_BA),
						   .CS_N(DRAM_CS_N),
						   .CKE(DRAM_CKE),
						   .RAS_N(DRAM_RAS_N),
				         .CAS_N(DRAM_CAS_N),
				         .WE_N(DRAM_WE_N),
						   .DQ(DRAM_DQ),
				         .DQM({DRAM_UDQM,DRAM_LDQM}),
							.SDR_CLK(DRAM_CLK)	);

//	YUV 4:2:2 to YUV 4:4:4
YUV422_to_444		u7	(	//	YUV 4:2:2 Input
							.iYCbCr(mYCbCr),
							//	YUV	4:4:4 Output
							.oY(mY),
							.oCb(mCb),
							.oCr(mCr),
							//	Control Signals
							.iX(VGA_X-160),
							.iCLK(TD_CLK27),
							.iRST_N(DLY0));

//	YCbCr 8-bit to RGB-10 bit 
YCbCr2RGB 			u8	(	//	Output Side
							.Red(mRed),
							.Green(mGreen),
							.Blue(mBlue),
							.oDVAL(mDVAL),
							//	Input Side
							.iY(mY),
							.iCb(mCb),
							.iCr(mCr),
							.iDVAL(VGA_Read),
							//	Control Signal
							.iRESET(!DLY2),
							.iCLK(TD_CLK27));

//	VGA Controller
wire [9:0] vga_r10;
wire [9:0] vga_g10;
wire [9:0] vga_b10;
assign VGA_R = vga_r10[9:2];
assign VGA_G = vga_g10[9:2];
assign VGA_B = vga_b10[9:2];


//////////////////////////////////////////////////////////////////
// color filter

wire [29:0] filter_out;
wire [9:0] counter_filter;
Color_Filter CF1	(.clk(TD_CLK27),
						 .oVGA_Red(mRed),
						 .oVGA_Green(mGreen),
						 .oVGA_Blue(mBlue),
						 .filtered_color(filter_out),
						 .SW(SW[8:6]),
						 .KEY(KEY[2:0]),
						 .counter_threshold(counter_filter),
						 .current_state(current_state_filter));
							 
//////////////////////////////////////////////////////////////////
wire [10:0] x_curr, y_curr, x_start, y_start, x_end, y_end, x_center, y_center, x_out, y_out;
wire [8:0] count;
wire [7:0] counter_wire;
wire [29:0] output_filtered;
assign x_curr = VGA_X;
assign y_curr = VGA_Y;
wire [2:0] current_state_pixel, current_state_filter;
pixel_sequence_detector P1 (.input_pixel (filter_out), 
									.vsync (TD_VS), 
									.hsync (TD_HS),
									.clock (TD_CLK27),
									.x_curr (x_curr), 
									.y_curr (y_curr), 
									.x_start (x_start), 
									.y_start (y_start), 
									.x_end (x_end), 
									.y_end (y_end), 
									.x_center (x_center), 
									.y_center (y_center), 
									.x_out (x_out),
									.y_out (y_out),
									.count (count),
									.counter_wire(counter_wire),
									.KEY 	 (KEY[2:0]),
									.object_found (object_found),
									.output_pixel (output_filtered),
									.SW(SW[8:6]),
									.current_state_pixel(current_state_pixel));
//////////////////////////////////////////////////////////////////	
wire 			object_found, counted, implement, reset_ctr;
wire [4:0] 	signal_out;

assign GPIO_0[8:4] = signal_out;

GPIO_Arduino ARD1 (.reset(~KEY[3]),
						.object_found(object_found),
						.clock_50(CLOCK_50),
						.sig_out(signal_out), .counted(counted), .implement(implement), .start_ctr(reset_ctr), .SW(SW[9])
							);
//////////////////////////////////////////////////////////////////
reg [23:0] Hex_wire;
always @ (posedge CLOCK_50)
begin
	if ((SW[1] == 0) & (SW[2] == 0))
	begin
	Hex_wire <= {signal_out[4:1], 3'd0, reset_ctr, 3'd0, counted, 3'd0, implement, 3'd0, signal_out[0], 3'd0, object_found};
		
	end
	else if ((SW[1] == 1) & (SW[2] == 0))
	begin
	Hex_wire <= {1'd0, current_state_pixel, 4'd0, 8'd0, counter_wire};
	end
	else if ((SW[2] == 1) & (SW[1] == 0))
	begin
	Hex_wire <= {1'd0, current_state_filter, 8'd0, 2'd0, counter_filter};
	end
end

		SEG7_LUT_6 			u0	(.oSEG0(HEX0),
							.oSEG1(HEX1),
							.oSEG2(HEX2),
							.oSEG3(HEX3),
							.oSEG4(HEX4),
							.oSEG5(HEX5),
							.iDIG(Hex_wire) //// made changes here
							);
/////////////////////////////////////////////////////////////////

// display selector
reg [29:0] output_pixel2;
always @ (posedge CLOCK_50)
	begin
		if (SW[0] == 1) output_pixel2 <= output_filtered;
		else output_pixel2 <= {mRed, mBlue, mGreen};
	end

/////////////////////////////////////////////////////////////////

VGA_Ctrl			u9	(	//	Host Side
							.iRed(output_pixel2[29:20]),
							.iGreen(output_pixel2[9:0]),
							.iBlue(output_pixel2[19:10]),
							.oCurrent_X(VGA_X),
							.oCurrent_Y(VGA_Y),
							.oRequest(VGA_Read),
							//	VGA Side
							.oVGA_R(vga_r10),
							.oVGA_G(vga_g10),
							.oVGA_B(vga_b10),
							.oVGA_HS(VGA_HS),
							.oVGA_VS(VGA_VS),
							.oVGA_SYNC(VGA_SYNC_N),
							.oVGA_BLANK(VGA_BLANK_N),
							.oVGA_CLOCK(VGA_CLK),
							//	Control Signal
							.iCLK(TD_CLK27),
							.iRST_N(DLY2));
							

//	Line buffer, delay one line
Line_Buffer u10 (.aclr(!DLY0),
					.clken(VGA_Read),
					.clock(TD_CLK27),
					.shiftin(mYCbCr_d),
					.shiftout(m3YCbCr));

Line_Buffer u11 (.aclr(!DLY0),
					.clken(VGA_Read),
					.clock(TD_CLK27),
					.shiftin(m3YCbCr),
					.shiftout(m4YCbCr));
	/*
AUDIO_DAC 	u12	(	//	Audio Side
					.oAUD_BCK(AUD_BCLK),
					.oAUD_DATA(AUD_DACDAT),
					.oAUD_LRCK(AUD_DACLRCK),
					//	Control Signals
					.iSrc_Select(2'b01),
			      .iCLK_18_4(AUD_CTRL_CLK),
					.iRST_N(DLY1)	);
*/
//	Audio CODEC and video decoder setting
I2C_AV_Config 	u1	(	//	Host Side
						.iCLK(CLOCK_50),
						.iRST_N(KEY[0]),
						//	I2C Side
						.I2C_SCLK(FPGA_I2C_SCLK),
						.I2C_SDAT(FPGA_I2C_SDAT)	);	
						
////////////////////////////////////////////////////////////////////////////////////////////
Audio_main audio (.CLOCK_50(CLOCK_50), .KEY(KEY[0]), .SW(SW[5:3]), 	

						.AUD_BCLK(AUD_BCLK), 
						.AUD_ADCLRCK(AUD_ADCLRCK), 
						.AUD_DACLRCK(AUD_DACLRCK),
						
						.AUD_ADCDAT(AUD_ADCDAT), 
						.AUD_XCK(AUD_XCK),
						.AUD_DACDAT(AUD_DACDAT)
						//.sig(signal_out)
						//.FPGA_I2C_SDAT(FPGA_I2C_SDAT),
						//.FPGA_I2C_SCLK(FPGA_I2C_SCLK)
						);





























////////////////////////////////////////////////////////////////////////////////////////////


endmodule //