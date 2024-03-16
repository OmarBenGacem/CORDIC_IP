module stage_1 (clk, clk_en, rst, start, x_one, x_two, done, out_one, out_two, half_out_one, half_out_two, square_out_one, square_out_two, working);

parameter FLT_DATA_WIDTH = 32;
parameter CORDIC_DATA_WIDTH = 22;

parameter IDLE = 2'b00;
parameter WORKING = 2'b01;
parameter DONE = 2'b11;


input clk;
input clk_en;
input rst;
input start;
input  [FLT_DATA_WIDTH - 1 : 0]  x_one;
input  [FLT_DATA_WIDTH - 1 : 0]  x_two;
output reg done;
output reg [CORDIC_DATA_WIDTH - 1 : 0] out_one;
output reg [CORDIC_DATA_WIDTH - 1 : 0] out_two;
output reg  [FLT_DATA_WIDTH - 1 : 0] half_out_one;
output reg  [FLT_DATA_WIDTH - 1 : 0] half_out_two;
output reg  [FLT_DATA_WIDTH - 1 : 0] square_out_one;
output reg  [FLT_DATA_WIDTH - 1 : 0] square_out_two;
output reg                           working;



//module stage_one_part (clk, clk_en, rst, start, x, half, square, x_to_cordic, done);



wire                          x_one_done;
wire [FLT_DATA_WIDTH - 1 : 0] x_one_halfed;
wire [FLT_DATA_WIDTH - 1 : 0] x_one_squared;
wire [CORDIC_DATA_WIDTH - 1 : 0] x_one_to_cordic;
wire                          x_two_done;
wire [FLT_DATA_WIDTH - 1 : 0] x_two_halfed;
wire [FLT_DATA_WIDTH - 1 : 0] x_two_squared;
wire [CORDIC_DATA_WIDTH - 1 : 0] x_two_to_cordic;
reg  [1 : 0]                  state;



stage_one_part first (

    .clk         (clk),
    .clk_en      (clk_en),
    .rst         (rst),
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
    .rst         (rst),
    .start       (start),
    .x           (x_two),
    .half        (x_two_halfed),
    .square      (x_two_squared),
    .x_to_cordic (x_two_to_cordic),
    .done        (x_two_done)

);



initial begin
    done <= 1'b0;
    state <= IDLE;

end




always @(posedge clk) begin

    case(state)

        IDLE: begin
            done <= 1'b0;
            if (x_one_done && x_two_done && clk_en) begin

                state <= DONE;
                out_one <= x_one_to_cordic;
                out_two <= x_two_to_cordic;
                half_out_one <= x_one_halfed;
                half_out_two <= x_two_halfed;
                square_out_one <= x_one_squared;
                square_out_two <= x_two_squared;
                working <= 1'b1;

            end else begin
                working <= 1'b0;
            end

        end

        WORKING: begin

        end    


        DONE: begin
            done <= 1'b1;
            state <= IDLE;


        end

    endcase

end




endmodule