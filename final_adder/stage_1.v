module stage_1 (clk, clk_en, rst, start, x_one, x_two, done, out_one, out_two, half_out_one, half_out_two, square_out_one, square_out_two);

parameter FLT_DATA_WIDTH = 32;
parameter CORDIC_DATA_WIDTH = 22;
parameter IDLE = 1'b0;
parameter DONE = 1'b1;


input clk;
input clk_en;
input rst;
input start;
input  [FLT_DATA_WIDTH - 1 : 0]  x_one;
input  [FLT_DATA_WIDTH - 1 : 0]  x_two;
output reg done;
output reg out_one;
output reg out_two;
output reg half_out_one;
output reg half_out_two;
output reg square_out_one;
output reg square_out_two;



//module stage_one_part (clk, clk_en, rst, start, x, half, square, x_to_cordic, done);



wire                          x_one_done;
wire [FLT_DATA_WIDTH - 1 : 0] x_one_halfed;
wire [FLT_DATA_WIDTH - 1 : 0] x_one_squared;
wire [FLT_DATA_WIDTH - 1 : 0] x_one_to_cordic;
wire                          x_two_done;
wire [FLT_DATA_WIDTH - 1 : 0] x_two_halfed;
wire [FLT_DATA_WIDTH - 1 : 0] x_two_squared;
wire [FLT_DATA_WIDTH - 1 : 0] x_two_to_cordic;
reg                           state;
reg                           pipeline_flush;


stage_one_part first (

    .clk         (clk),
    .clk_en      (clk_en),
    .rst         (pipeline_flush),
    .start       (start),
    .x           (x_one),
    .half        (x_one_halfed),
    .square      (x_one_squared),
    .x_to_cordic (x_one_to_cordic),
    .done        (x_one_done)

);

stage_one_part second (

    .clk         (clk),
    .clk_en      (clk_en),
    .rst         (pipeline_flush),
    .start       (start),
    .x           (x_one),
    .half        (x_two_halfed),
    .square      (x_two_squared),
    .x_to_cordic (x_two_to_cordic),
    .done        (x_two_done)

);



initial begin
    
    state <= IDLE;

end




always @(posedge clk) begin

    case(state)

        IDLE: begin
            done <= 1'b0;
            if (x_one_done && x_two_done && x_three_done) begin

                state <= done;
                pipeline_flush <= 1'b1;
                out_one <= x_one_to_cordic;
                out_two <= x_two_to_cordic;
                half_out_one <= x_one_halfed;
                half_out_two <= x_two_halfed;
                square_out_one <= x_one_squared;
                square_out_two <= x_two_squared;

            end

        end

        DONE: begin
            done <= 1'b1;
            state <= IDLE;
        end

    endcase

end




endmodule