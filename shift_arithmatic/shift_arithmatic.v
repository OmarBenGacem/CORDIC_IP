// megafunction wizard: %LPM_CLSHIFT%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: LPM_CLSHIFT 

// ============================================================
// File Name: shift_arithmatic.v
// Megafunction Name(s):
// 			LPM_CLSHIFT
//
// Simulation Library Files(s):
// 			
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


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module shift_arithmatic (
	data,
	distance,
	result);

	input	[21:0]  data;
	input	[4:0]  distance;
	output	[21:0]  result;

	wire  sub_wire0 = 1'h1;
	wire [21:0] sub_wire1;
	wire [21:0] result = sub_wire1[21:0];

	lpm_clshift	LPM_CLSHIFT_component (
				.data (data),
				.direction (sub_wire0),
				.distance (distance),
				.result (sub_wire1)
				// synopsys translate_off
				,
				.aclr (),
				.clken (),
				.clock (),
				.overflow (),
				.underflow ()
				// synopsys translate_on
				);
	defparam
		LPM_CLSHIFT_component.lpm_shifttype = "ARITHMETIC",
		LPM_CLSHIFT_component.lpm_type = "LPM_CLSHIFT",
		LPM_CLSHIFT_component.lpm_width = 22,
		LPM_CLSHIFT_component.lpm_widthdist = 5;


endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone V"
// Retrieval info: PRIVATE: LPM_SHIFTTYPE NUMERIC "1"
// Retrieval info: PRIVATE: LPM_WIDTH NUMERIC "22"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
// Retrieval info: PRIVATE: lpm_widthdist NUMERIC "5"
// Retrieval info: PRIVATE: lpm_widthdist_style NUMERIC "0"
// Retrieval info: PRIVATE: new_diagram STRING "1"
// Retrieval info: PRIVATE: port_direction NUMERIC "1"
// Retrieval info: LIBRARY: lpm lpm.lpm_components.all
// Retrieval info: CONSTANT: LPM_SHIFTTYPE STRING "ARITHMETIC"
// Retrieval info: CONSTANT: LPM_TYPE STRING "LPM_CLSHIFT"
// Retrieval info: CONSTANT: LPM_WIDTH NUMERIC "22"
// Retrieval info: CONSTANT: LPM_WIDTHDIST NUMERIC "5"
// Retrieval info: USED_PORT: data 0 0 22 0 INPUT NODEFVAL "data[21..0]"
// Retrieval info: USED_PORT: distance 0 0 5 0 INPUT NODEFVAL "distance[4..0]"
// Retrieval info: USED_PORT: result 0 0 22 0 OUTPUT NODEFVAL "result[21..0]"
// Retrieval info: CONNECT: @data 0 0 22 0 data 0 0 22 0
// Retrieval info: CONNECT: @direction 0 0 0 0 VCC 0 0 0 0
// Retrieval info: CONNECT: @distance 0 0 5 0 distance 0 0 5 0
// Retrieval info: CONNECT: result 0 0 22 0 @result 0 0 22 0
// Retrieval info: GEN_FILE: TYPE_NORMAL shift_arithmatic.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL shift_arithmatic.inc TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL shift_arithmatic.cmp TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL shift_arithmatic.bsf TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL shift_arithmatic_inst.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL shift_arithmatic_bb.v TRUE
