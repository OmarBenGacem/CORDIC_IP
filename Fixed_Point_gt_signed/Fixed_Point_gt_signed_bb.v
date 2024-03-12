// megafunction wizard: %LPM_COMPARE%VBB%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: LPM_COMPARE 

// ============================================================
// File Name: Fixed_Point_gt_signed.v
// Megafunction Name(s):
// 			LPM_COMPARE
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

module Fixed_Point_gt_signed (
	dataa,
	datab,
	aeb,
	agb);

	input	[21:0]  dataa;
	input	[21:0]  datab;
	output	  aeb;
	output	  agb;

endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: AeqB NUMERIC "1"
// Retrieval info: PRIVATE: AgeB NUMERIC "0"
// Retrieval info: PRIVATE: AgtB NUMERIC "1"
// Retrieval info: PRIVATE: AleB NUMERIC "0"
// Retrieval info: PRIVATE: AltB NUMERIC "0"
// Retrieval info: PRIVATE: AneB NUMERIC "0"
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone V"
// Retrieval info: PRIVATE: LPM_PIPELINE NUMERIC "0"
// Retrieval info: PRIVATE: Latency NUMERIC "0"
// Retrieval info: PRIVATE: PortBValue NUMERIC "0"
// Retrieval info: PRIVATE: Radix NUMERIC "10"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
// Retrieval info: PRIVATE: SignedCompare NUMERIC "1"
// Retrieval info: PRIVATE: aclr NUMERIC "0"
// Retrieval info: PRIVATE: clken NUMERIC "0"
// Retrieval info: PRIVATE: isPortBConstant NUMERIC "0"
// Retrieval info: PRIVATE: nBit NUMERIC "22"
// Retrieval info: PRIVATE: new_diagram STRING "1"
// Retrieval info: LIBRARY: lpm lpm.lpm_components.all
// Retrieval info: CONSTANT: LPM_REPRESENTATION STRING "SIGNED"
// Retrieval info: CONSTANT: LPM_TYPE STRING "LPM_COMPARE"
// Retrieval info: CONSTANT: LPM_WIDTH NUMERIC "22"
// Retrieval info: USED_PORT: aeb 0 0 0 0 OUTPUT NODEFVAL "aeb"
// Retrieval info: USED_PORT: agb 0 0 0 0 OUTPUT NODEFVAL "agb"
// Retrieval info: USED_PORT: dataa 0 0 22 0 INPUT NODEFVAL "dataa[21..0]"
// Retrieval info: USED_PORT: datab 0 0 22 0 INPUT NODEFVAL "datab[21..0]"
// Retrieval info: CONNECT: @dataa 0 0 22 0 dataa 0 0 22 0
// Retrieval info: CONNECT: @datab 0 0 22 0 datab 0 0 22 0
// Retrieval info: CONNECT: aeb 0 0 0 0 @aeb 0 0 0 0
// Retrieval info: CONNECT: agb 0 0 0 0 @agb 0 0 0 0
// Retrieval info: GEN_FILE: TYPE_NORMAL Fixed_Point_gt_signed.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL Fixed_Point_gt_signed.inc TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL Fixed_Point_gt_signed.cmp TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL Fixed_Point_gt_signed.bsf TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL Fixed_Point_gt_signed_inst.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL Fixed_Point_gt_signed_bb.v TRUE
// Retrieval info: LIB_FILE: lpm