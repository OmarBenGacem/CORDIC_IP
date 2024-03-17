`timescale 1 ns / 100 ps
module function_evaluation_tb ();

	//Inputs to DUT are reg type
	reg [31:0] dataa;
    reg [31:0] datab;
    wire done;
	reg clk;
    reg start;
	reg clk_en;
    reg [1:0] n;

	//Output from DUT is wire type
	wire [31:0] result;
    always
	    #10 clk = ~clk;



    parameter CLEAR = 2'd0;
    parameter GO = 2'd1;
    parameter READ = 2'd2;


	//Instantiate the DUT
    //module function_evaluation(clk, rst, clk_en, start, done, x_one, x_two, x_three, result, n);
	function_evaluation unit(
        .rst            (1'b0),
        .clk_en         (clk_en),
        .clk   	        (clk),
        .n              (n),
        .start          (start),
        .x_one          (dataa),
        .x_two          (datab),
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
		clk_en <= 1'b0;
        start <= 1'b0;
        dataa <= 32'b01000000101000000000000000000000; //5
        datab <= 32'b01000001101000000000000000000000; //20
        n <= GO;
		start <= 1'b1;

		
        
        
		
		// If using a clock

		@(posedge clk); 
		                               
		clk_en <= 1'b1;


		#20
		start <= 1'b0;

		#260
		start <= 1'b1;
		dataa <= 32'b010000110011010000000110000000000; //180
        datab <= 32'b11000010011100000000011000000000; //-60


		#20
		start <= 1'b0;

		#260
		start <= 1'b1;
		dataa <= 32'b01000011001101000000000000000000; //180
        datab <= 32'b11000010011100000000000000000000; //-60


		#20
		start <= 1'b0;

        #800
		$display($time, "<< Simulation Complete >>");
		$stop;
	end

endmodule
