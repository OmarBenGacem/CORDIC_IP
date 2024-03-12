`timescale 1 ns / 100 ps
module a_cordic_pipelined_tb ();

	//Inputs to DUT are reg type
	reg [31:0] dataa;
    wire done;
	reg clk;
    reg start;
	reg clk_en;

	//Output from DUT is wire type
	wire [31:0] result;
    always
	    #10 clk = ~clk;

	//Instantiate the DUT
    //module CORDIC(clk, rst, clk_en, angle_float, result, done);
	CORDIC_unrolled unit(
        .rst            (1'b0),
        .clk_en         (clk_en),
        .clk   	        (clk),
        .start          (start),
        .angle_float    (dataa),
		.result         (result),
        .done  	        (done)
	);

	// ---- If a clock is required, see below ----
	// //Create a 50MHz clock
	// always
	// 	#10 clk = ~clk;
	// -----------------------

	//Initial Block
	initial
	begin
		$display($time, " << Starting Simulation >> ");
		
		// intialise/set input
		clk = 1'b0;
		clk_en <= 1'b1;
        start <= 1'b1;
        
        
		
		// If using a clock

		@(posedge clk); 
		                               

		//dataa <= 32'b00111110001010001111010111000011; // x = 0.165 => 00111111011111001000010111101010 = 0x3f7c85ea
		dataa <= 32'b00111111011111001010110000001000; //0.987
        #30
        start <= 1'b0;
		#720
		clk_en <= 1'b0;
		#100
		clk_en <= 1'b1;
        start <= 1'b1;  
		//dataa <= 32'b00111111000010001011010000111001; //x = 0.534 => 00111111010110101110100110011111 = 0x3F5AE99F
		//dataa <= 32'b0;
		dataa <= 32'b10111101100011110101110000101001;

		#30
        start <= 1'b0;
		#720
		clk_en <= 1'b0;
		#100
		clk_en <= 1'b1;
        start <= 1'b1;
		dataa <= 32'b00111111000010111000010100011111; //x = 0.545 => 00111111010110101110100110011111 = 0x3F5AE99F
		//outputs cesult <= cos(0.545) = 0.85512729078 = 0.110110101110100110011
        #30
        start <= 1'b0;
		#750
		$display($time, "<< Simulation Complete >>");
		$stop;
	end

endmodule
