`timescale 1 ns / 100 ps
module a_mac_tb ();

	//Inputs to DUT are reg type
	reg [31:0] dataa;
    reg [31:0] datab;
    reg [4:0] n;
    wire done;
	reg clk;
    reg start;
	reg clk_en;


    parameter CLEAR = 5'b00000;
    parameter ADD = 5'b00001;
    parameter READ = 5'b00010;

	//Output from DUT is wire type
	wire [31:0] result;
    always
	    #10 clk = ~clk;

	//Instantiate the DUT
    //module  mul_add(aclr, clk_en, start, clk, dataa, datab, result, done, n) ;
	mul_add unit(
        .aclr           (1'b0),
        .clk_en         (clk_en),
        .clk   	        (clk),
        .start          (start),
        .dataa          (dataa),
        .datab          (datab),
		.result         (result),
        .done  	        (done),
        .n              (n)
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
        n <= ADD;
        
        
		
		// If using a clock

		@(posedge clk); 
		                               

		dataa <= 32'b01000000110000000000000000000000; //6
        datab <= 32'b01000000100000000000000000000000; //4
        n <= ADD;
        #30
        start <= 1'b0;
		#720
		clk_en <= 1'b0;
		#100
		clk_en <= 1'b1;
        start <= 1'b1;  

		dataa <= 32'b01000000000000000000000000000000; //2
        datab <= 32'b01000000010000000000000000000000; //3

		#30
        start <= 1'b0;
		#720
		clk_en <= 1'b0;
        n <= READ;
		#100
		clk_en <= 1'b1;
        start <= 1'b1;
		dataa <= 32'b01000000000000000000000000000000; //2
        datab <= 32'b01000000010000000000000000000000; //3
        #30
        start <= 1'b0;
		#750
        n <= CLEAR;
		#100
		clk_en <= 1'b1;
        start <= 1'b1;
		dataa <= 32'b01000000000000000000000000000000; //2
        datab <= 32'b01000000010000000000000000000000; //3
        #750
		$display($time, "<< Simulation Complete >>");
		$stop;
	end

endmodule
