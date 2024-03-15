module stage_3(clk, clk_en, rst, start, result_one, one_squared, result_two, two_squared, to_add_one, to_add_two, done);

parameter FLOAT_DATA_WIDTH = 32;
parameter INTEGER_WIDTH = 1;
parameter FRACTIONAL_WIDTH = 21;
parameter CORDIC_DATA_WIDTH = INTEGER_WIDTH + FRACTIONAL_WIDTH;


parameter CONVERSION_LATANCY = 10'b0000000100;
parameter MULTIPLY_LATENCY = 10'b0000000110;


parameter IDLE = 2'b00;
parameter CONVERT = 2'b01;
parameter MULTIPLY = 2'b10;
parameter DONE = 2'b11;


input clk;
input clk_en;
input rst;
input start;
input result_one;
input one_squared;
input result_two;
input two_squared;
output reg to_add_one;
output reg to_add_two;
output reg done;


reg state;
reg start_convert;
reg start_multiply;
reg go_mult;
reg go_convert;

wire convert_done;
wire multiply_done;
wire cordic_one_float;
wire cordic_two_float;
wire one_out;
wire two_out;

delay stopper_convert (
		.max  ( CONVERSION_LATANCY ),
		.clk  ( clk ),
		.rst  ( start_convert ),
		.done ( convert_done )
);

delay stopper_multiply (
		.max  ( MULTIPLY_LATENCY ),
		.clk  ( clk ),
		.rst  ( go_mult ),
		.done ( multiply_done )
);

FIXED_Convert_twos_comp converter_fixed_fp_one (

    .clock      (clk),
    .aclr       (rst),
    .clk_en     (go_convert),
    .dataa      (result_one),
    .results    (cordic_one_float)

);


FIXED_Convert_twos_comp converter_fixed_fp_one (

    .clock      (clk),
    .aclr       (rst),
    .clk_en     (start_convert),
    .dataa      (result_one),
    .results    (cordic_two_float)

);

fp_mul x_one_mul (

    .aclr   (rst),
    .clk_en (start_multiply),
    .clock  (clk),
    .dataa  (one_squared),
    .datab  (cordic_one_float),
    .result (one_out)

);


fp_mul x_two_mul (

    .aclr   (rst),
    .clk_en (start_multiply),
    .clock  (clk),
    .dataa  (two_squared),
    .datab  (cordic_two_float),
    .result (two_out)

);

initial begin

    go_convert <= 1'b0;
    start_multiply <= 1'b0;
    state <= IDLE;
    done <= 1'b0;

end

always @(posedge clk) begin

    if (rst) begin
    
    
    end else begin

        case(state)

            IDLE: begin
                
                if (clk_en && start) begin

                        state <= CONVERT;
                        start_convert <= 1'b1;
                        go_convert <= 1'b1;
                        

                end

            end

            CONVERT: begin
                go_convert <= 1'b0;
                if (convert_done) begin
                    state <= MULTIPLY;
                    go_convert <= 1'b0;
                    start_convert <= 1'b0;

                    go_mult <= 1'b1;
                    start_multiply <= 1'b1;
                end

            end

            MULTIPLY: begin
                go_mult <= 1'b0;
                if (multiply_done) begin
                    done <= 1'b1;
                    state <= IDLE;
                    go_mult <= 1'b0;
                    start_multiply <= 1'b0;
                    to_add_one <= one_out;
                    to_add_two <= two_out;

                end

            end

            DONE: begin
                done <= 1'b0;
                state <= IDLE;
            end


        endcase

    end

end



endmodule