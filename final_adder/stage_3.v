module stage_3(clk, clk_en, rst, start, result_one, one_squared, result_two, two_squared, to_add_one, to_add_two, done, working);

parameter FLOAT_DATA_WIDTH = 32;
parameter INTEGER_WIDTH = 2;
parameter FRACTIONAL_WIDTH = 20;
parameter CORDIC_DATA_WIDTH = INTEGER_WIDTH + FRACTIONAL_WIDTH;
parameter STATE_WIDTH = 2;


parameter CONVERSION_LATANCY = 10'b0000000100;
parameter MULTIPLY_LATENCY = 10'b0000000100;


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


reg         [STATE_WIDTH - 1 : 0]       state_context_one;
reg         [STATE_WIDTH - 1 : 0]       state_context_two;

reg         [FLOAT_DATA_WIDTH - 1 : 0]  intermediate_one;
reg         [FLOAT_DATA_WIDTH - 1 : 0]  intermediate_two;
reg         [FLOAT_DATA_WIDTH - 1 : 0]  intermediate_one_squared;
reg         [FLOAT_DATA_WIDTH - 1 : 0]  intermediate_two_squared;
reg                                     context_one_working;
reg                                     context_two_working;


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
    .dataa  (intermediate_one_squared),
    .datab  (intermediate_one),
    .result (one_out)

);


fp_mul x_two_mul (

    .aclr   (rst),
    .clk_en (start_multiply),
    .clock  (clk),
    .dataa  (intermediate_two_squared),
    .datab  (intermediate_two),
    .result (two_out)

);

initial begin
    working <= 1'b0;
    go_convert <= 1'b0;
    start_convert <= 1'b0;
    go_mult <= 1'b0;
    start_multiply <= 1'b0;
    state_context_one <= IDLE;
    state_context_two <= IDLE;
    done <= 1'b0;
    to_add_one <= 32'b0;
    to_add_two <= 32'b0;
    context_one_working <= 1'b0;
    context_two_working <= 1'b0;
    intermediate_one <= 32'b0;
    intermediate_two <= 32'b0;
    intermediate_one_squared <= 32'b0;
    intermediate_two_squared <= 32'b0;

end

always @(posedge clk) begin

    working <= context_one_working || context_two_working;
    context_one_working <= (state_context_one == IDLE) ? 1'b0 : 1'b1;
    context_two_working <= (state_context_two == IDLE) ? 1'b0 : 1'b1;
    
    if (rst) begin
    
        working <= 1'b0;
        go_convert <= 1'b0;
        start_convert <= 1'b0;
        go_mult <= 1'b0;
        start_multiply <= 1'b0;
        state_context_one <= IDLE;
        state_context_two <= IDLE;
        done <= 1'b0;
        to_add_one <= 32'b0;
        to_add_two <= 32'b0;
        context_one_working <= 1'b0;
        context_two_working <= 1'b0;
        intermediate_one <= 32'b0;
        intermediate_two <= 32'b0;
        intermediate_one_squared <= 32'b0;
        intermediate_two_squared <= 32'b0;

    end else begin

        case(state_context_one)

            IDLE: begin
                done <= 1'b0;
                if (clk_en && start) begin

                    state_context_one <= CONVERT;
                    start_convert <= 1'b1;
                    go_convert <= 1'b1;


                end else begin



                end

            end

            CONVERT: begin
                go_convert <= 1'b0;
                if (convert_done) begin
                    state_context_one <= IDLE;
                    start_convert <= 1'b0;
                    go_mult <= 1'b1;
                    intermediate_one <= cordic_one_float;
                    intermediate_two <= cordic_two_float;
                    intermediate_one_squared <= one_squared;
                    intermediate_two_squared <= two_squared;

                end

            end




        endcase


        case(state_context_two)

        IDLE: begin
            done <= 1'b0;
            if (go_mult) begin
                state_context_two <= MULTIPLY;
                start_multiply <= 1'b1;


            end else begin

            end
        end
        
        MULTIPLY: begin
            done <= 1'b0;
            go_mult <= 1'b0;
            if (multiply_done) begin
                    
                state_context_two <= DONE;
                go_mult <= 1'b0;
                start_multiply <= 1'b0;
                to_add_one <= one_out;
                to_add_two <= two_out;
                state_context_two <= IDLE;
                done <= 1'b1;

            end
        end


        default: state_context_two <= IDLE;
        endcase

    end

end



endmodule