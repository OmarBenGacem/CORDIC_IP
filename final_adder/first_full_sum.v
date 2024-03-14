module function_evaluation(clk, rst, clk_en, start, done, x_one, x_two, result, n);

//calculates 3 operands in parallel, as this is the most function arguments you can do in one go
parameter FLT_DATA_WIDTH = 32;
parameter N_WIDTH = 2;
parameter CORDIC_DATA_WIDTH = 22;
parameter STATE_WIDTH = 3;

parameter CLEAR = 2'd0;
parameter GO = 2'd1;
parameter READ = 2'd2;

parameter IDLE = 3'b000;
parameter WORKING = 3'b001;
parameter FLUSHING = 3'b010;
parameter DISPLAYING = 3'b011;
parameter DONE = 3'b111;

input                                 clk;
input                                 rst;
input                                 clk_en;
input                                 start;
input       [FLT_DATA_WIDTH - 1 : 0]  x_one;
input       [FLT_DATA_WIDTH - 1 : 0]  x_two;
input       [N_WIDTH - 1 : 0]         n;
output reg  [FLT_DATA_WIDTH - 1 : 0]  result;
output reg                            done;

reg start_stage_1;
reg start_stage_2;
reg start_stage_3;

wire stage_1_done;
wire stage_2_done;
wire stage_3_done;

reg [STATE_WIDTH - 1 : 0] state;
reg [FLT_DATA_WIDTH - 1 : 0] sum;

//module stage_1 (clk, clk_en, rst, start, x_one, x_two, x_three, done, out_one, out_two, out_three, half_out_one, half_out_two, half_out_three, square_out_one, square_out_two, square_out_three);


wire [FLT_DATA_WIDTH - 1 : 0] x_one_squared;
wire [FLT_DATA_WIDTH - 1 : 0] x_two_squared;
wire [FLT_DATA_WIDTH - 1 : 0] x_three_squared;

wire [FLT_DATA_WIDTH - 1 : 0] x_one_halved;
wire [FLT_DATA_WIDTH - 1 : 0] x_two_halved;
wire [FLT_DATA_WIDTH - 1 : 0] x_three_halved;

wire [CORDIC_DATA_WIDTH - 1 : 0] x_one_cordic;
wire [CORDIC_DATA_WIDTH - 1 : 0] x_two_cordic;
wire [CORDIC_DATA_WIDTH - 1 : 0] x_three_cordic;

stage_1 first (

    .clk                (clk),
    .clk_en             (clk_en),
    .rst                (rst),
    .start              (start_stage_1),
    .x_one              (x_one),
    .x_two              (x_two),
    .x_three            (32'b0),
    .done               (stage_1_done),
    .out_one            (x_one_cordic),
    .out_two            (x_two_cordic),
    .out_three          (x_three_cordic),
    .half_out_one       (x_one_halved),
    .half_out_two       (x_two_halved),
    .half_out_three     (x_three_halved),
    .square_out_one     (x_one_squared),
    .square_out_two     (x_two_squared),
    .square_out_three   (x_three_squared)

);


initial begin
    sum <= 32'b0;
    state <= IDLE;

end

always@(posedge clk) begin

    case(state)

    IDLE: begin
        done <= 1'b0;
        if (clk_en && start) begin

            if (n == GO) begin

                start_stage_1 <= 1'b1;
                state <= WORKING;

            end else if ( n == READ ) begin
                
            end else if ( n == CLEAR ) begin
            
            end

        end

    end

    WORKING: begin

        start_stage_1 <= 1'b0;
        if (stage_1_done) begin
            state <= DONE;
            result <= 32'b0;
        end


    end

    FLUSHING: begin
        state <= IDLE;
    end

    DISPLAYING: begin
        state <= IDLE;
    end

    DONE: begin
        done <= 1'b1;
        state <= IDLE;
    end

    default: state <= IDLE;

    endcase

end

endmodule