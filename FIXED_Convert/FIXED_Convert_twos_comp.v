// megafunction wizard: %ALTFP_CONVERT%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: ALTFP_CONVERT 

// ============================================================
// File Name: FIXED_Convert_twos_comp.v
// Megafunction Name(s):
// 			ALTFP_CONVERT
//
// Simulation Library Files(s):
// 			lpm
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 18.1.0 Build 625 09/12/2018 SJ Lite Edition
// ************************************************************


//Copyright (C) 2018  Intel Corporation. All rights reserved.
//Your use of Intel Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Intel Program License 
//Subscription Agreement, the Intel Quartus Prime License Agreement,
//the Intel FPGA IP License Agreement, or other applicable license
//agreement, including, without limitation, that your use is for
//the sole purpose of programming logic devices manufactured by
//Intel and sold by Intel or its authorized distributors.  Please
//refer to the applicable agreement for further details.


//altfp_convert CBX_AUTO_BLACKBOX="ALL" DEVICE_FAMILY="Cyclone V" OPERATION="FIXED2FLOAT" ROUNDING="TO_NEAREST" WIDTH_DATA=22 WIDTH_EXP_INPUT=8 WIDTH_EXP_OUTPUT=8 WIDTH_INT=2 WIDTH_MAN_INPUT=23 WIDTH_MAN_OUTPUT=23 WIDTH_RESULT=32 aclr clk_en clock dataa result
//VERSION_BEGIN 18.1 cbx_altbarrel_shift 2018:09:12:13:04:24:SJ cbx_altera_syncram_nd_impl 2018:09:12:13:04:24:SJ cbx_altfp_convert 2018:09:12:13:04:24:SJ cbx_altpriority_encoder 2018:09:12:13:04:24:SJ cbx_altsyncram 2018:09:12:13:04:24:SJ cbx_cycloneii 2018:09:12:13:04:24:SJ cbx_lpm_abs 2018:09:12:13:04:24:SJ cbx_lpm_add_sub 2018:09:12:13:04:24:SJ cbx_lpm_compare 2018:09:12:13:04:24:SJ cbx_lpm_decode 2018:09:12:13:04:24:SJ cbx_lpm_divide 2018:09:12:13:04:24:SJ cbx_lpm_mux 2018:09:12:13:04:24:SJ cbx_mgl 2018:09:12:13:10:36:SJ cbx_nadder 2018:09:12:13:04:24:SJ cbx_stratix 2018:09:12:13:04:24:SJ cbx_stratixii 2018:09:12:13:04:24:SJ cbx_stratixiii 2018:09:12:13:04:24:SJ cbx_stratixv 2018:09:12:13:04:24:SJ cbx_util_mgl 2018:09:12:13:04:24:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



//altbarrel_shift CBX_AUTO_BLACKBOX="ALL" DEVICE_FAMILY="Cyclone V" PIPELINE=2 SHIFTDIR="LEFT" SHIFTTYPE="LOGICAL" WIDTH=22 WIDTHDIST=5 aclr clk_en clock data distance result
//VERSION_BEGIN 18.1 cbx_altbarrel_shift 2018:09:12:13:04:24:SJ cbx_mgl 2018:09:12:13:10:36:SJ  VERSION_END

//synthesis_resources = reg 48 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  FIXED_Convert_twos_comp_altbarrel_shift_eof
	( 
	aclr,
	clk_en,
	clock,
	data,
	distance,
	result) ;
	input   aclr;
	input   clk_en;
	input   clock;
	input   [21:0]  data;
	input   [4:0]  distance;
	output   [21:0]  result;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri0   aclr;
	tri1   clk_en;
	tri0   clock;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

	reg	[1:0]	dir_pipe;
	reg	[21:0]	sbit_piper1d;
	reg	[21:0]	sbit_piper2d;
	reg	sel_pipec3r1d;
	reg	sel_pipec4r1d;
	wire  [5:0]  dir_w;
	wire  direction_w;
	wire  [15:0]  pad_w;
	wire  [131:0]  sbit_w;
	wire  [4:0]  sel_w;
	wire  [109:0]  smux_w;

	// synopsys translate_off
	initial
		dir_pipe = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) dir_pipe <= 2'b0;
		else if  (clk_en == 1'b1)   dir_pipe <= {dir_w[4], dir_w[2]};
	// synopsys translate_off
	initial
		sbit_piper1d = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) sbit_piper1d <= 22'b0;
		else if  (clk_en == 1'b1)   sbit_piper1d <= smux_w[65:44];
	// synopsys translate_off
	initial
		sbit_piper2d = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) sbit_piper2d <= 22'b0;
		else if  (clk_en == 1'b1)   sbit_piper2d <= smux_w[109:88];
	// synopsys translate_off
	initial
		sel_pipec3r1d = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) sel_pipec3r1d <= 1'b0;
		else if  (clk_en == 1'b1)   sel_pipec3r1d <= distance[3];
	// synopsys translate_off
	initial
		sel_pipec4r1d = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) sel_pipec4r1d <= 1'b0;
		else if  (clk_en == 1'b1)   sel_pipec4r1d <= distance[4];
	assign
		dir_w = {dir_pipe[1], dir_w[3], dir_pipe[0], dir_w[1:0], direction_w},
		direction_w = 1'b0,
		pad_w = {16{1'b0}},
		result = sbit_w[131:110],
		sbit_w = {sbit_piper2d, smux_w[87:66], sbit_piper1d, smux_w[43:0], data},
		sel_w = {sel_pipec4r1d, sel_pipec3r1d, distance[2:0]},
		smux_w = {((({22{(sel_w[4] & (~ dir_w[4]))}} & {sbit_w[93:88], pad_w[15:0]}) | ({22{(sel_w[4] & dir_w[4])}} & {pad_w[15:0], sbit_w[109:104]})) | ({22{(~ sel_w[4])}} & sbit_w[109:88])), ((({22{(sel_w[3] & (~ dir_w[3]))}} & {sbit_w[79:66], pad_w[7:0]}) | ({22{(sel_w[3] & dir_w[3])}} & {pad_w[7:0], sbit_w[87:74]})) | ({22{(~ sel_w[3])}} & sbit_w[87:66])), ((({22{(sel_w[2] & (~ dir_w[2]))}} & {sbit_w[61:44], pad_w[3:0]}) | ({22{(sel_w[2] & dir_w[2])}} & {pad_w[3:0], sbit_w[65:48]})) | ({22{(~ sel_w[2])}} & sbit_w[65:44])), ((({22{(sel_w[1] & (~ dir_w[1]))}} & {sbit_w[41:22], pad_w[1:0]}) | ({22{(sel_w[1] & dir_w[1])}} & {pad_w[1:0], sbit_w[43:24]})) | ({22{(~ sel_w[1])}} & sbit_w[43:22])), ((({22{(sel_w[0] & (~ dir_w[0]))}} & {sbit_w[20:0], pad_w[0]}) | ({22{(sel_w[0] & dir_w[0])}} & {pad_w[0], sbit_w[21:1]})) | ({22{(~ sel_w[0])}} & sbit_w[21:0]))};
endmodule //FIXED_Convert_twos_comp_altbarrel_shift_eof


//altpriority_encoder CBX_AUTO_BLACKBOX="ALL" WIDTH=32 WIDTHAD=5 data q
//VERSION_BEGIN 18.1 cbx_altpriority_encoder 2018:09:12:13:04:24:SJ cbx_mgl 2018:09:12:13:10:36:SJ  VERSION_END


//altpriority_encoder CBX_AUTO_BLACKBOX="ALL" LSB_PRIORITY="NO" WIDTH=16 WIDTHAD=4 data q
//VERSION_BEGIN 18.1 cbx_altpriority_encoder 2018:09:12:13:04:24:SJ cbx_mgl 2018:09:12:13:10:36:SJ  VERSION_END


//altpriority_encoder CBX_AUTO_BLACKBOX="ALL" LSB_PRIORITY="NO" WIDTH=8 WIDTHAD=3 data q
//VERSION_BEGIN 18.1 cbx_altpriority_encoder 2018:09:12:13:04:24:SJ cbx_mgl 2018:09:12:13:10:36:SJ  VERSION_END


//altpriority_encoder CBX_AUTO_BLACKBOX="ALL" LSB_PRIORITY="NO" WIDTH=4 WIDTHAD=2 data q
//VERSION_BEGIN 18.1 cbx_altpriority_encoder 2018:09:12:13:04:24:SJ cbx_mgl 2018:09:12:13:10:36:SJ  VERSION_END


//altpriority_encoder CBX_AUTO_BLACKBOX="ALL" LSB_PRIORITY="NO" WIDTH=2 WIDTHAD=1 data q
//VERSION_BEGIN 18.1 cbx_altpriority_encoder 2018:09:12:13:04:24:SJ cbx_mgl 2018:09:12:13:10:36:SJ  VERSION_END

//synthesis_resources = 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  FIXED_Convert_twos_comp_altpriority_encoder_3v7
	( 
	data,
	q) ;
	input   [1:0]  data;
	output   [0:0]  q;


	assign
		q = {data[1]};
endmodule //FIXED_Convert_twos_comp_altpriority_encoder_3v7


//altpriority_encoder CBX_AUTO_BLACKBOX="ALL" LSB_PRIORITY="NO" WIDTH=2 WIDTHAD=1 data q zero
//VERSION_BEGIN 18.1 cbx_altpriority_encoder 2018:09:12:13:04:24:SJ cbx_mgl 2018:09:12:13:10:36:SJ  VERSION_END

//synthesis_resources = 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  FIXED_Convert_twos_comp_altpriority_encoder_3e8
	( 
	data,
	q,
	zero) ;
	input   [1:0]  data;
	output   [0:0]  q;
	output   zero;


	assign
		q = {data[1]},
		zero = (~ (data[0] | data[1]));
endmodule //FIXED_Convert_twos_comp_altpriority_encoder_3e8

//synthesis_resources = 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  FIXED_Convert_twos_comp_altpriority_encoder_6v7
	( 
	data,
	q) ;
	input   [3:0]  data;
	output   [1:0]  q;

	wire  [0:0]   wire_altpriority_encoder10_q;
	wire  [0:0]   wire_altpriority_encoder11_q;
	wire  wire_altpriority_encoder11_zero;

	FIXED_Convert_twos_comp_altpriority_encoder_3v7   altpriority_encoder10
	( 
	.data(data[1:0]),
	.q(wire_altpriority_encoder10_q));
	FIXED_Convert_twos_comp_altpriority_encoder_3e8   altpriority_encoder11
	( 
	.data(data[3:2]),
	.q(wire_altpriority_encoder11_q),
	.zero(wire_altpriority_encoder11_zero));
	assign
		q = {(~ wire_altpriority_encoder11_zero), ((wire_altpriority_encoder11_zero & wire_altpriority_encoder10_q) | ((~ wire_altpriority_encoder11_zero) & wire_altpriority_encoder11_q))};
endmodule //FIXED_Convert_twos_comp_altpriority_encoder_6v7


//altpriority_encoder CBX_AUTO_BLACKBOX="ALL" LSB_PRIORITY="NO" WIDTH=4 WIDTHAD=2 data q zero
//VERSION_BEGIN 18.1 cbx_altpriority_encoder 2018:09:12:13:04:24:SJ cbx_mgl 2018:09:12:13:10:36:SJ  VERSION_END

//synthesis_resources = 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  FIXED_Convert_twos_comp_altpriority_encoder_6e8
	( 
	data,
	q,
	zero) ;
	input   [3:0]  data;
	output   [1:0]  q;
	output   zero;

	wire  [0:0]   wire_altpriority_encoder12_q;
	wire  wire_altpriority_encoder12_zero;
	wire  [0:0]   wire_altpriority_encoder13_q;
	wire  wire_altpriority_encoder13_zero;

	FIXED_Convert_twos_comp_altpriority_encoder_3e8   altpriority_encoder12
	( 
	.data(data[1:0]),
	.q(wire_altpriority_encoder12_q),
	.zero(wire_altpriority_encoder12_zero));
	FIXED_Convert_twos_comp_altpriority_encoder_3e8   altpriority_encoder13
	( 
	.data(data[3:2]),
	.q(wire_altpriority_encoder13_q),
	.zero(wire_altpriority_encoder13_zero));
	assign
		q = {(~ wire_altpriority_encoder13_zero), ((wire_altpriority_encoder13_zero & wire_altpriority_encoder12_q) | ((~ wire_altpriority_encoder13_zero) & wire_altpriority_encoder13_q))},
		zero = (wire_altpriority_encoder12_zero & wire_altpriority_encoder13_zero);
endmodule //FIXED_Convert_twos_comp_altpriority_encoder_6e8

//synthesis_resources = 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  FIXED_Convert_twos_comp_altpriority_encoder_bv7
	( 
	data,
	q) ;
	input   [7:0]  data;
	output   [2:0]  q;

	wire  [1:0]   wire_altpriority_encoder8_q;
	wire  [1:0]   wire_altpriority_encoder9_q;
	wire  wire_altpriority_encoder9_zero;

	FIXED_Convert_twos_comp_altpriority_encoder_6v7   altpriority_encoder8
	( 
	.data(data[3:0]),
	.q(wire_altpriority_encoder8_q));
	FIXED_Convert_twos_comp_altpriority_encoder_6e8   altpriority_encoder9
	( 
	.data(data[7:4]),
	.q(wire_altpriority_encoder9_q),
	.zero(wire_altpriority_encoder9_zero));
	assign
		q = {(~ wire_altpriority_encoder9_zero), (({2{wire_altpriority_encoder9_zero}} & wire_altpriority_encoder8_q) | ({2{(~ wire_altpriority_encoder9_zero)}} & wire_altpriority_encoder9_q))};
endmodule //FIXED_Convert_twos_comp_altpriority_encoder_bv7


//altpriority_encoder CBX_AUTO_BLACKBOX="ALL" LSB_PRIORITY="NO" WIDTH=8 WIDTHAD=3 data q zero
//VERSION_BEGIN 18.1 cbx_altpriority_encoder 2018:09:12:13:04:24:SJ cbx_mgl 2018:09:12:13:10:36:SJ  VERSION_END

//synthesis_resources = 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  FIXED_Convert_twos_comp_altpriority_encoder_be8
	( 
	data,
	q,
	zero) ;
	input   [7:0]  data;
	output   [2:0]  q;
	output   zero;

	wire  [1:0]   wire_altpriority_encoder14_q;
	wire  wire_altpriority_encoder14_zero;
	wire  [1:0]   wire_altpriority_encoder15_q;
	wire  wire_altpriority_encoder15_zero;

	FIXED_Convert_twos_comp_altpriority_encoder_6e8   altpriority_encoder14
	( 
	.data(data[3:0]),
	.q(wire_altpriority_encoder14_q),
	.zero(wire_altpriority_encoder14_zero));
	FIXED_Convert_twos_comp_altpriority_encoder_6e8   altpriority_encoder15
	( 
	.data(data[7:4]),
	.q(wire_altpriority_encoder15_q),
	.zero(wire_altpriority_encoder15_zero));
	assign
		q = {(~ wire_altpriority_encoder15_zero), (({2{wire_altpriority_encoder15_zero}} & wire_altpriority_encoder14_q) | ({2{(~ wire_altpriority_encoder15_zero)}} & wire_altpriority_encoder15_q))},
		zero = (wire_altpriority_encoder14_zero & wire_altpriority_encoder15_zero);
endmodule //FIXED_Convert_twos_comp_altpriority_encoder_be8

//synthesis_resources = 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  FIXED_Convert_twos_comp_altpriority_encoder_r08
	( 
	data,
	q) ;
	input   [15:0]  data;
	output   [3:0]  q;

	wire  [2:0]   wire_altpriority_encoder6_q;
	wire  [2:0]   wire_altpriority_encoder7_q;
	wire  wire_altpriority_encoder7_zero;

	FIXED_Convert_twos_comp_altpriority_encoder_bv7   altpriority_encoder6
	( 
	.data(data[7:0]),
	.q(wire_altpriority_encoder6_q));
	FIXED_Convert_twos_comp_altpriority_encoder_be8   altpriority_encoder7
	( 
	.data(data[15:8]),
	.q(wire_altpriority_encoder7_q),
	.zero(wire_altpriority_encoder7_zero));
	assign
		q = {(~ wire_altpriority_encoder7_zero), (({3{wire_altpriority_encoder7_zero}} & wire_altpriority_encoder6_q) | ({3{(~ wire_altpriority_encoder7_zero)}} & wire_altpriority_encoder7_q))};
endmodule //FIXED_Convert_twos_comp_altpriority_encoder_r08


//altpriority_encoder CBX_AUTO_BLACKBOX="ALL" LSB_PRIORITY="NO" WIDTH=16 WIDTHAD=4 data q zero
//VERSION_BEGIN 18.1 cbx_altpriority_encoder 2018:09:12:13:04:24:SJ cbx_mgl 2018:09:12:13:10:36:SJ  VERSION_END

//synthesis_resources = 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  FIXED_Convert_twos_comp_altpriority_encoder_rf8
	( 
	data,
	q,
	zero) ;
	input   [15:0]  data;
	output   [3:0]  q;
	output   zero;

	wire  [2:0]   wire_altpriority_encoder16_q;
	wire  wire_altpriority_encoder16_zero;
	wire  [2:0]   wire_altpriority_encoder17_q;
	wire  wire_altpriority_encoder17_zero;

	FIXED_Convert_twos_comp_altpriority_encoder_be8   altpriority_encoder16
	( 
	.data(data[7:0]),
	.q(wire_altpriority_encoder16_q),
	.zero(wire_altpriority_encoder16_zero));
	FIXED_Convert_twos_comp_altpriority_encoder_be8   altpriority_encoder17
	( 
	.data(data[15:8]),
	.q(wire_altpriority_encoder17_q),
	.zero(wire_altpriority_encoder17_zero));
	assign
		q = {(~ wire_altpriority_encoder17_zero), (({3{wire_altpriority_encoder17_zero}} & wire_altpriority_encoder16_q) | ({3{(~ wire_altpriority_encoder17_zero)}} & wire_altpriority_encoder17_q))},
		zero = (wire_altpriority_encoder16_zero & wire_altpriority_encoder17_zero);
endmodule //FIXED_Convert_twos_comp_altpriority_encoder_rf8

//synthesis_resources = 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  FIXED_Convert_twos_comp_altpriority_encoder_qb6
	( 
	data,
	q) ;
	input   [31:0]  data;
	output   [4:0]  q;

	wire  [3:0]   wire_altpriority_encoder4_q;
	wire  [3:0]   wire_altpriority_encoder5_q;
	wire  wire_altpriority_encoder5_zero;

	FIXED_Convert_twos_comp_altpriority_encoder_r08   altpriority_encoder4
	( 
	.data(data[15:0]),
	.q(wire_altpriority_encoder4_q));
	FIXED_Convert_twos_comp_altpriority_encoder_rf8   altpriority_encoder5
	( 
	.data(data[31:16]),
	.q(wire_altpriority_encoder5_q),
	.zero(wire_altpriority_encoder5_zero));
	assign
		q = {(~ wire_altpriority_encoder5_zero), (({4{wire_altpriority_encoder5_zero}} & wire_altpriority_encoder4_q) | ({4{(~ wire_altpriority_encoder5_zero)}} & wire_altpriority_encoder5_q))};
endmodule //FIXED_Convert_twos_comp_altpriority_encoder_qb6

//synthesis_resources = lpm_add_sub 2 lpm_compare 1 reg 180 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  FIXED_Convert_twos_comp_altfp_convert_61o
	( 
	aclr,
	clk_en,
	clock,
	dataa,
	result) ;
	input   aclr;
	input   clk_en;
	input   clock;
	input   [21:0]  dataa;
	output   [31:0]  result;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri0   aclr;
	tri1   clk_en;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

	wire  [21:0]   wire_altbarrel_shift3_result;
	wire  [4:0]   wire_altpriority_encoder2_q;
	reg	[7:0]	exponent_bus_pre_reg;
	reg	[7:0]	exponent_bus_pre_reg2;
	reg	[7:0]	exponent_bus_pre_reg3;
	reg	[20:0]	mag_int_a_reg;
	reg	[20:0]	mag_int_a_reg2;
	reg	[23:0]	mantissa_pre_round_reg;
	reg	[4:0]	priority_encoder_reg;
	reg	[31:0]	result_reg;
	reg	sign_int_a_reg1;
	reg	sign_int_a_reg2;
	reg	sign_int_a_reg3;
	reg	sign_int_a_reg4;
	reg	sign_int_a_reg5;
	wire  [20:0]   wire_add_sub1_result;
	wire  [7:0]   wire_exponent_value_result;
	wire  wire_below_bias_value_alb;
	wire  [7:0]  bias_value_w;
	wire  [7:0]  const_bias_value_add_width_int_w;
	wire  [7:0]  exceptions_value;
	wire  [7:0]  exponent_bus;
	wire  [7:0]  exponent_bus_pre;
	wire  [7:0]  exponent_output_w;
	wire  [7:0]  exponent_rounded;
	wire  [7:0]  exponent_zero_w;
	wire  [20:0]  int_a;
	wire  [20:0]  int_a_2s;
	wire  [20:0]  invert_int_a;
	wire  [4:0]  leading_zeroes;
	wire  [20:0]  mag_int_a;
	wire  [22:0]  mantissa_bus;
	wire  [23:0]  mantissa_pre_round;
	wire  [23:0]  mantissa_rounded;
	wire  max_neg_value_selector;
	wire  [7:0]  max_neg_value_w;
	wire  [7:0]  minus_leading_zero;
	wire  [21:0]  prio_mag_int_a;
	wire  [9:0]  priority_pad_one_w;
	wire  [31:0]  result_w;
	wire  [20:0]  shifted_mag_int_a;
	wire  sign_bus;
	wire  sign_int_a;
	wire  [2:0]  zero_padding_w;

	FIXED_Convert_twos_comp_altbarrel_shift_eof   altbarrel_shift3
	( 
	.aclr(aclr),
	.clk_en(clk_en),
	.clock(clock),
	.data({1'b0, mag_int_a_reg2}),
	.distance(leading_zeroes),
	.result(wire_altbarrel_shift3_result));
	FIXED_Convert_twos_comp_altpriority_encoder_qb6   altpriority_encoder2
	( 
	.data({prio_mag_int_a, priority_pad_one_w}),
	.q(wire_altpriority_encoder2_q));
	// synopsys translate_off
	initial
		exponent_bus_pre_reg = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) exponent_bus_pre_reg <= 8'b0;
		else if  (clk_en == 1'b1)   exponent_bus_pre_reg <= exponent_bus_pre_reg2;
	// synopsys translate_off
	initial
		exponent_bus_pre_reg2 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) exponent_bus_pre_reg2 <= 8'b0;
		else if  (clk_en == 1'b1)   exponent_bus_pre_reg2 <= exponent_bus_pre_reg3;
	// synopsys translate_off
	initial
		exponent_bus_pre_reg3 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) exponent_bus_pre_reg3 <= 8'b0;
		else if  (clk_en == 1'b1)   exponent_bus_pre_reg3 <= exponent_bus_pre;
	// synopsys translate_off
	initial
		mag_int_a_reg = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) mag_int_a_reg <= 21'b0;
		else if  (clk_en == 1'b1)   mag_int_a_reg <= mag_int_a;
	// synopsys translate_off
	initial
		mag_int_a_reg2 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) mag_int_a_reg2 <= 21'b0;
		else if  (clk_en == 1'b1)   mag_int_a_reg2 <= mag_int_a_reg;
	// synopsys translate_off
	initial
		mantissa_pre_round_reg = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) mantissa_pre_round_reg <= 24'b0;
		else if  (clk_en == 1'b1)   mantissa_pre_round_reg <= mantissa_pre_round;
	// synopsys translate_off
	initial
		priority_encoder_reg = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) priority_encoder_reg <= 5'b0;
		else if  (clk_en == 1'b1)   priority_encoder_reg <= wire_altpriority_encoder2_q;
	// synopsys translate_off
	initial
		result_reg = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) result_reg <= 32'b0;
		else if  (clk_en == 1'b1)   result_reg <= result_w;
	// synopsys translate_off
	initial
		sign_int_a_reg1 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) sign_int_a_reg1 <= 1'b0;
		else if  (clk_en == 1'b1)   sign_int_a_reg1 <= sign_int_a;
	// synopsys translate_off
	initial
		sign_int_a_reg2 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) sign_int_a_reg2 <= 1'b0;
		else if  (clk_en == 1'b1)   sign_int_a_reg2 <= sign_int_a_reg1;
	// synopsys translate_off
	initial
		sign_int_a_reg3 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) sign_int_a_reg3 <= 1'b0;
		else if  (clk_en == 1'b1)   sign_int_a_reg3 <= sign_int_a_reg2;
	// synopsys translate_off
	initial
		sign_int_a_reg4 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) sign_int_a_reg4 <= 1'b0;
		else if  (clk_en == 1'b1)   sign_int_a_reg4 <= sign_int_a_reg3;
	// synopsys translate_off
	initial
		sign_int_a_reg5 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) sign_int_a_reg5 <= 1'b0;
		else if  (clk_en == 1'b1)   sign_int_a_reg5 <= sign_int_a_reg4;
	lpm_add_sub   add_sub1
	( 
	.cout(),
	.dataa(invert_int_a),
	.datab(21'b000000000000000000001),
	.overflow(),
	.result(wire_add_sub1_result)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.aclr(1'b0),
	.add_sub(1'b1),
	.cin(),
	.clken(1'b1),
	.clock(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	);
	defparam
		add_sub1.lpm_direction = "ADD",
		add_sub1.lpm_width = 21,
		add_sub1.lpm_type = "lpm_add_sub",
		add_sub1.lpm_hint = "ONE_INPUT_IS_CONSTANT=YES";
	lpm_add_sub   exponent_value
	( 
	.cout(),
	.dataa(const_bias_value_add_width_int_w),
	.datab(minus_leading_zero),
	.overflow(),
	.result(wire_exponent_value_result)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.aclr(1'b0),
	.add_sub(1'b1),
	.cin(),
	.clken(1'b1),
	.clock(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	);
	defparam
		exponent_value.lpm_direction = "SUB",
		exponent_value.lpm_width = 8,
		exponent_value.lpm_type = "lpm_add_sub",
		exponent_value.lpm_hint = "ONE_INPUT_IS_CONSTANT=YES";
	lpm_compare   below_bias_value
	( 
	.aeb(),
	.agb(),
	.ageb(),
	.alb(wire_below_bias_value_alb),
	.aleb(),
	.aneb(),
	.dataa(exponent_output_w),
	.datab(bias_value_w)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.aclr(1'b0),
	.clken(1'b1),
	.clock(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	);
	defparam
		below_bias_value.lpm_representation = "UNSIGNED",
		below_bias_value.lpm_width = 8,
		below_bias_value.lpm_type = "lpm_compare";
	assign
		bias_value_w = 8'b01101011,
		const_bias_value_add_width_int_w = 8'b01111111,
		exceptions_value = (({8{(~ max_neg_value_selector)}} & exponent_zero_w) | ({8{max_neg_value_selector}} & max_neg_value_w)),
		exponent_bus = exponent_rounded,
		exponent_bus_pre = (({8{(~ wire_below_bias_value_alb)}} & exponent_output_w) | ({8{wire_below_bias_value_alb}} & exceptions_value)),
		exponent_output_w = wire_exponent_value_result,
		exponent_rounded = exponent_bus_pre_reg,
		exponent_zero_w = {8{1'b0}},
		int_a = dataa[20:0],
		int_a_2s = wire_add_sub1_result,
		invert_int_a = (~ int_a),
		leading_zeroes = (~ priority_encoder_reg),
		mag_int_a = (({21{(~ sign_int_a)}} & int_a) | ({21{sign_int_a}} & int_a_2s)),
		mantissa_bus = mantissa_rounded[22:0],
		mantissa_pre_round = {shifted_mag_int_a[20:0], {3{1'b0}}},
		mantissa_rounded = mantissa_pre_round_reg,
		max_neg_value_selector = (wire_below_bias_value_alb & sign_int_a_reg2),
		max_neg_value_w = 8'b10000000,
		minus_leading_zero = {zero_padding_w, leading_zeroes},
		prio_mag_int_a = {mag_int_a_reg, 1'b1},
		priority_pad_one_w = {10{1'b1}},
		result = result_reg,
		result_w = {sign_bus, exponent_bus, mantissa_bus},
		shifted_mag_int_a = wire_altbarrel_shift3_result[20:0],
		sign_bus = sign_int_a_reg5,
		sign_int_a = dataa[21],
		zero_padding_w = {3{1'b0}};
endmodule //FIXED_Convert_twos_comp_altfp_convert_61o
//VALID FILE


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module FIXED_Convert_twos_comp (
	aclr,
	clk_en,
	clock,
	dataa,
	result);

	input	  aclr;
	input	  clk_en;
	input	  clock;
	input	[21:0]  dataa;
	output	[31:0]  result;

	wire [31:0] sub_wire0;
	wire [31:0] result = sub_wire0[31:0];

	FIXED_Convert_twos_comp_altfp_convert_61o	FIXED_Convert_twos_comp_altfp_convert_61o_component (
				.aclr (aclr),
				.clk_en (clk_en),
				.clock (clock),
				.dataa (dataa),
				.result (sub_wire0));

endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone V"
// Retrieval info: CONSTANT: INTENDED_DEVICE_FAMILY STRING "Cyclone V"
// Retrieval info: CONSTANT: LPM_HINT STRING "UNUSED"
// Retrieval info: CONSTANT: LPM_TYPE STRING "altfp_convert"
// Retrieval info: CONSTANT: OPERATION STRING "FIXED2FLOAT"
// Retrieval info: CONSTANT: ROUNDING STRING "TO_NEAREST"
// Retrieval info: CONSTANT: WIDTH_DATA NUMERIC "22"
// Retrieval info: CONSTANT: WIDTH_EXP_INPUT NUMERIC "8"
// Retrieval info: CONSTANT: WIDTH_EXP_OUTPUT NUMERIC "8"
// Retrieval info: CONSTANT: WIDTH_INT NUMERIC "2"
// Retrieval info: CONSTANT: WIDTH_MAN_INPUT NUMERIC "23"
// Retrieval info: CONSTANT: WIDTH_MAN_OUTPUT NUMERIC "23"
// Retrieval info: CONSTANT: WIDTH_RESULT NUMERIC "32"
// Retrieval info: USED_PORT: aclr 0 0 0 0 INPUT NODEFVAL "aclr"
// Retrieval info: CONNECT: @aclr 0 0 0 0 aclr 0 0 0 0
// Retrieval info: USED_PORT: clk_en 0 0 0 0 INPUT NODEFVAL "clk_en"
// Retrieval info: CONNECT: @clk_en 0 0 0 0 clk_en 0 0 0 0
// Retrieval info: USED_PORT: clock 0 0 0 0 INPUT NODEFVAL "clock"
// Retrieval info: CONNECT: @clock 0 0 0 0 clock 0 0 0 0
// Retrieval info: USED_PORT: dataa 0 0 22 0 INPUT NODEFVAL "dataa[21..0]"
// Retrieval info: CONNECT: @dataa 0 0 22 0 dataa 0 0 22 0
// Retrieval info: USED_PORT: result 0 0 32 0 OUTPUT NODEFVAL "result[31..0]"
// Retrieval info: CONNECT: result 0 0 32 0 @result 0 0 32 0
// Retrieval info: GEN_FILE: TYPE_NORMAL FIXED_Convert_twos_comp.v TRUE FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL FIXED_Convert_twos_comp.qip TRUE FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL FIXED_Convert_twos_comp.bsf TRUE TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL FIXED_Convert_twos_comp_inst.v TRUE TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL FIXED_Convert_twos_comp_bb.v TRUE TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL FIXED_Convert_twos_comp.inc TRUE TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL FIXED_Convert_twos_comp.cmp TRUE TRUE
// Retrieval info: LIB_FILE: lpm
