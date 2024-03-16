module stage_3(clk, clk_en, rst, start, result_one, one_squared, result_two, two_squared, to_add_one, to_add_two, done, working);

parameter FLOAT_DATA_WIDTH = 32;
parameter INTEGER_WIDTH = 2;
parameter FRACTIONAL_WIDTH = 20;
parameter CORDIC_DATA_WIDTH = INTEGER_WIDTH + FRACTIONAL_WIDTH;
parameter STATE_WIDTH = 2;


parameter CONVERSION_LATANCY = 10'b0000000011;
parameter MULTIPLY_LATENCY = 10'b0000000011;


parameter IDLE = 2'b00;
parameter CONVERT = 2'b01;
parameter MULTIPLY = 2'b10;
parameter DONE = 2'b11;


input                                    clk;
input                                    clk_en;
input                                    rst;
input                                    start;
input       [CORDIC_DATA_WIDTH - 1 : 0]  result_one;
input       [FLOAT_DATA_WIDTH - 1 : 0]   one_squared;
input       [CORDIC_DATA_WIDTH - 1 : 0]  result_two;
input       [FLOAT_DATA_WIDTH - 1 : 0]   two_squared;
output reg  [FLOAT_DATA_WIDTH - 1 : 0]   to_add_one;
output reg  [FLOAT_DATA_WIDTH - 1 : 0]   to_add_two;
output reg                               done;
output reg                               working;


reg         [STATE_WIDTH - 1 : 0]       state;
reg                                     start_convert;
reg                                     start_multiply;
reg                                     go_mult;
reg                                     go_convert;

wire                                    convert_done;
wire                                    multiply_done;
wire       [FLOAT_DATA_WIDTH - 1 : 0]   cordic_one_float;
wire       [FLOAT_DATA_WIDTH - 1 : 0]   cordic_two_float;
wire       [FLOAT_DATA_WIDTH - 1 : 0]   one_out;
wire       [FLOAT_DATA_WIDTH - 1 : 0]   two_out;

delay stopper_convert (
		.max  ( CONVERSION_LATANCY ),
		.clk  ( clk ),
		.rst  ( go_convert ),
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
    .clk_en     (start_convert),
    .dataa      (result_one),
    .result     (cordic_one_float)

);


FIXED_Convert_twos_comp converter_fixed_fp_two (

    .clock      (clk),
    .aclr       (rst),
    .clk_en     (start_convert),
    .dataa      (result_two),
    .result     (cordic_two_float)

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
    to_add_one <= 32'b0;
    to_add_two <= 32'b0;

end

always @(posedge clk) begin

    if (rst) begin
    
    
    end else begin

        case(state)

            IDLE: begin
                done <= 1'b0;
                if (clk_en && start) begin

                    state <= CONVERT;
                    start_convert <= 1'b1;
                    go_convert <= 1'b1;
                    working <= 1'b1;

                end else begin

                    working <= 1'b0;

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
                    
                    state <= DONE;
                    go_mult <= 1'b0;
                    start_multiply <= 1'b0;
                    to_add_one <= one_out;
                    to_add_two <= two_out;

                end

            end

            DONE: begin
                done <= 1'b1;
                state <= IDLE;
            end


        endcase

    end

end



endmodule