`timescale 1 ns / 100 ps
module a_convert_tb ();

	//Inputs to DUT are reg type
	reg [31:0] dataa;
    wire done;
	reg clk;


	//Output from DUT is wire type
	wire [21:0] result;
    always
	    #10 clk = ~clk;

	//Instantiate the DUT
    //module CORDIC(clk, rst, clk_en, angle_float, result, done);
    fp_convert	fp_convert_inst (
        .aclr ( 1'b0 ),
        .clk_en ( 1'b1 ),
        .clock ( clk ),
        .dataa ( dataa ),
        .result ( result )
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
		
		// If using a clock
		@(posedge clk); 
		
		// set dataa and datab                                 
		dataa <= 32'b00111111000010111000010100011111; //x = 0.545 => 00111111010110101110100110011111 = 0x3F5AE99F
        
		//outputs result <= (dataa + datab) + datab = 2.9017653 + 5.32434 = 8.2261053


		#100
		$display($time, "<< Simulation Complete >>");
		$stop;
	end

endmodule
