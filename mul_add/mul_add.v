module  mul_add(aclr, clk_en, clk, dataa, datab, result, done) ;
	//outputs result <= (dataa * datab) + datab;
	parameter ADD_LATENCY = 7;
	parameter MUL_LATENCY = 5;	
	parameter COUNTER_WIDTH = 10;
	//parameter MUL_LATENCY_BIN = {COUNTER_WIDTH{4'd5}};
	parameter MUL_LATENCY_BIN = 10'b0000000101;
	parameter ADD_LATENCY_BIN = 10'b0000000111;
	parameter DATA_WIDTH = 32;
	parameter STATE_WIDTH = 3;
	//parameter STARTING = {{STATE_WIDTH}{3'b000}};
	//parameter WAITING_MUL = {STATE_WIDTH{3'b001}};
	//parameter START_ADD = {STATE_WIDTH{3'b010}};
	//parameter WAITING_ADD = {STATE_WIDTH{3'b011}};
	parameter STARTING = 3'b000;
	parameter WAITING_MUL = 3'b001;
	parameter START_ADD = 3'b010;
	parameter WAITING_ADD = 3'b011;
	parameter IDLE = 3'b111;
	parameter DONE = 3'b100;
	
	input   					   aclr;
	input   					   clk_en;
	input   					   clk;
	//input 						   rst;
	input      [DATA_WIDTH - 1:0]  dataa;
	input      [DATA_WIDTH - 1:0]  datab;
	output reg [DATA_WIDTH - 1:0]  result;
	output reg 					   done;

	wire 	   [DATA_WIDTH - 1:0] result_wire;
	wire 	   [DATA_WIDTH - 1:0] result_connection;
	reg  						  enable_add;
	reg 						  enable_mul;	
	reg							  delay_reset;
	reg [COUNTER_WIDTH - 1:0]     counter_max;
	wire 						  counter_done;
	reg [STATE_WIDTH - 1:0] 	  state;

	fp_mul	multiplier (
		.aclr ( aclr ),
		.clk_en ( enable_mul ),
		.clock ( clk ),
		.dataa ( dataa ),
		.datab ( datab ),
		.result ( result_connection )
	);

	delay waiter (

		.max  ( counter_max ),
		.clk  ( clk ),
		.rst  ( delay_reset ),
		.done ( counter_done )

	);

	add	adder (
		.aclr ( aclr ),
		.clk_en ( enable_add ),
		.clock ( clk ),
		.dataa ( result_connection ),
		.datab ( datab ),
		.result ( result_wire )
	);

	initial begin
		state <= IDLE;
		result <= {DATA_WIDTH{1'b0}};
		done <= 1'b0;
		enable_add <= 1'b0;
		enable_mul <= 1'b0;
		delay_reset <= 1'b0;
	end


	always @(posedge clk) begin

		if (aclr) begin

			state <= IDLE;
			result <= {DATA_WIDTH{1'b0}};
			done <= 1'b0;
			enable_add <= 1'b0;
			enable_mul <= 1'b0;
			delay_reset <= 1'b0;

		end else begin

			case(state)

			IDLE: begin // 111
					
					done <= 1'b0;
					enable_add <= 1'b0;
					enable_mul <= 1'b0;
					delay_reset <= 1'b0;
					if (clk_en == 1'b1) state <= STARTING;

				end
			STARTING: begin //000

					enable_mul <= 1'b1;
					state <= WAITING_MUL;
					counter_max <= MUL_LATENCY_BIN;
					delay_reset <= 1'b1;

				end

			WAITING_MUL: begin //001

					if (delay_reset == 1'b1)  delay_reset <= 1'b0; 
					
					if (counter_done == 1'b1) begin
						state <= START_ADD;
						enable_mul <= 1'b0;
					end



				end	

			START_ADD: begin //010

					enable_add <= 1'b1;
					state <= WAITING_ADD;
					counter_max <= ADD_LATENCY_BIN;
					delay_reset <= 1'b1;				

				end


			WAITING_ADD: begin //011

					if (delay_reset == 1'b1) delay_reset <= 1'b0;
					
					if (counter_done == 1'b1) begin
						state <= DONE;
						enable_add <= 1'b0;
						delay_reset <= 1'b1;
					end

				end

			DONE: begin //100
					if (delay_reset == 1'b1) delay_reset <= 1'b0;
					result <= result_wire;
					done <= 1'b1;
					enable_add <= 1'b0;
					enable_mul <= 1'b0;
					state <= IDLE;

				end
			


			default: state <= IDLE;

			endcase

		end

	end 





endmodule