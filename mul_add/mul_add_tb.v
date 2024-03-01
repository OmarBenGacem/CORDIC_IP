`timescale 1 ns / 100 ps
module tb ();

	//Inputs to DUT are reg type
	reg [31:0] dataa;
    reg [31:0] datab;
    wire done;
	reg clk;


	//Output from DUT is wire type
	wire [31:0] result;
    always
	    #10 clk = ~clk;

	//Instantiate the DUT
	//mul refers to the verilog module defined by the LPM_MULT ip
    //module  mul_add(aclr, clk_en, clk, dataa, datab, result, done) ;
	mul_add unit(
        .aclr (1'b0),
        .clk_en (1'b1),
		
        .clk   (clk),
        .dataa     (dataa),
        .datab     (datab),
		.result     (result),
        .done  (done)
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
        datab <= 32'b01000000101010100110000011111110; //x = 5.32434 => 00111111000100110001000000101100 = 0x3F13102C 
		
		//outputs result <= (dataa + datab) + datab = 2.9017653 + 5.32434 = 8.2261053


		#100
		$display($time, "<< Simulation Complete >>");
		$stop;
	end

endmodule
