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

parameter WAITING = 3'b000;
parameter INPUTING = 3'b001;

parameter WAITING_FOR_HALF_VALUES = 3'b000;
parameter HALF_VALUES_ADDED = 3'b001;


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


//stage 1 done is the done signal
wire stage_1_done;
wire stage_2_done;
wire stage_3_done;

reg [STATE_WIDTH - 1 : 0]    state;
reg [FLT_DATA_WIDTH - 1 : 0] sum_one;
reg [FLT_DATA_WIDTH - 1 : 0] sum_two;
reg [FLT_DATA_WIDTH - 1 : 0] first_x_halved;
reg [FLT_DATA_WIDTH - 1 : 0] temp_value_container;
reg [FLT_DATA_WIDTH - 1 : 0] temp_square_value_container;
reg [STATE_WIDTH - 1 : 0]    state_context_two;
//reg [STATE_WIDTH - 1 : 0]    state_short;

//module stage_1 (clk, clk_en, rst, start, x_one, x_two, x_three, done, out_one, out_two, out_three, half_out_one, half_out_two, half_out_three, square_out_one, square_out_two, square_out_three);


wire [FLT_DATA_WIDTH - 1 : 0] x_one_squared;
wire [FLT_DATA_WIDTH - 1 : 0] x_two_squared;

wire [FLT_DATA_WIDTH - 1 : 0] x_one_halved;
wire [FLT_DATA_WIDTH - 1 : 0] x_two_halved;

wire [CORDIC_DATA_WIDTH - 1 : 0] x_one_cordic;
wire [CORDIC_DATA_WIDTH - 1 : 0] x_two_cordic;


wire [FLT_DATA_WIDTH - 1 : 0] squared_out_cordic;
wire [CORDIC_DATA_WIDTH - 1 : 0] cordic_out; 
wire cordic_data_valid;


wire [FLT_DATA_WIDTH - 1 : 0] final_add_one;
wire [FLT_DATA_WIDTH - 1 : 0] final_add_two;
wire start_final_add;

wire [FLT_DATA_WIDTH - 1 : 0] shorted_new_sum_1;
wire [FLT_DATA_WIDTH - 1 : 0] shorted_new_sum_2;
wire                          half_short_complete;
wire [FLT_DATA_WIDTH - 1 : 0] full_pipeline_new_sum_1;
wire [FLT_DATA_WIDTH - 1 : 0] full_pipeline_new_sum_2;
wire                          full_pipeine_complete;

wire                          pipeline_stage_1_in_use;
wire                          cordic_pipeline_cleared;
wire                          pipeline_stage_3_in_use;
wire                          pipeline_stage_4_in_use;
wire                          shorting_stage_4_in_use;

wire pipeline_empty;

assign pipeline_empty = !( pipeline_stage_1_in_use || cordic_pipeline_cleared || pipeline_stage_3_in_use || pipeline_stage_4_in_use || shorting_stage_4_in_use );

stage_1 first_stage (

    .clk                (clk),
    .clk_en             (clk_en),
    .rst                (rst),
    .start              (start_stage_1),
    .x_one              (x_one),
    .x_two              (x_two),
    .done               (stage_1_done),
    .out_one            (x_one_cordic),
    .out_two            (x_two_cordic),
    .half_out_one       (x_one_halved),
    .half_out_two       (x_two_halved),
    .square_out_one     (x_one_squared),
    .square_out_two     (x_two_squared),
    .working            (pipeline_stage_1_in_use)

);

//module stage_2(clk, clk_en, rst, x_one, x_two, start, pipeline_cleared, result, valid, squared_pipeline);
stage_2 second_stage (

    .clk                (clk),
    .clk_en             (clk_en),
    .rst                (rst),
    .x_one              (x_one_cordic),
    .x_two              (x_two_cordic),
    .one_sq             (x_one_squared),
    .two_sq             (x_two_squared),
    .start              (stage_1_done),
    .pipeline_cleared   (cordic_pipeline_cleared),
    .result             (cordic_out),
    .valid              (cordic_data_valid),
    .squared_pipeline   (squared_out_cordic)

);

//stage_3(clk, clk_en, rst, start, result_one, one_squared, result_two, two_squared, to_add_one, to_add_two, done);
stage_3 third_stage (

    .clk            (clk),
    .clk_en         (clk_en),
    .rst            (rst),
    .start          (start_stage_3),
    .result_one     (temp_value_container),
    .one_squared    (temp_square_value_container),
    .result_two     (cordic_out),
    .two_squared    (squared_out_cordic),
    .to_add_one     (final_add_one),
    .to_add_two     (final_add_two),
    .done           (start_final_add),
    .working        (pipeline_stage_3_in_use)

);


//module stage_4(clk, rst, clk_en, start, val_1, val_2, current_val_1, current_val_2, new_val_1, new_val_2, done);
stage_4 fourth_stage (

    .clk            (clk),
    .rst            (rst),
    .clk_en         (clk_en),
    .start          (start_final_add),
    .val_1          (sum_one),
    .val_2          (sum_two),
    .current_val_1  (final_add_one),
    .current_val_2  (final_add_two),
    .new_val_1      (full_pipeline_new_sum_1),
    .new_val_2      (full_pipeline_new_sum_2),
    .done           (full_pipeine_complete),
    .working        (pipeline_stage_4_in_use)

);

stage_4 short_x_div_2 (

    .clk            (clk),
    .rst            (rst),
    .clk_en         (clk_en),
    .start          (stage_1_done),
    .val_1          (sum_one),
    .val_2          (sum_two),
    .current_val_1  (x_one_halved),
    .current_val_2  (x_two_halved),
    .new_val_1      (shorted_new_sum_1),
    .new_val_2      (shorted_new_sum_2),
    .done           (half_short_complete),
    .working        (shorting_stage_4_in_use)

);


initial begin
    sum_one <= 32'b0;
    sum_two <= 32'b0;
    state <= IDLE;
    state_context_two <= WAITING;
    first_x_halved <= 32'b0;
    temp_value_container <= 32'b0;
    temp_square_value_container <= 32'b0;
    start_stage_3 <= 1'b0;
    //state_short <= WAITING_FOR_HALF_VALUES;

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

        if (start_stage_1) start_stage_1 <= 1'b0;
        if (stage_1_done) begin
            first_x_halved <= x_one_halved;
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



    case (state_context_two) 

        WAITING: begin // 0
            start_stage_3 <= 1'b0;
            if (cordic_data_valid) begin
                state_context_two <= INPUTING;
                temp_value_container <= cordic_out;
                temp_square_value_container <= squared_out_cordic;
            end
        end

        INPUTING: begin // 1
            start_stage_3 <= 1'b1;
            state_context_two <= WAITING;

        end

        default: state_context_two <= WAITING;

    endcase

    //add x/2 to result subroutine

    if (half_short_complete) begin

        sum_one <= shorted_new_sum_1;
        sum_two <= shorted_new_sum_2;

    end

    if (full_pipeine_complete) begin

        sum_one <= full_pipeline_new_sum_1;
        sum_two <= full_pipeline_new_sum_2;

    end
/*
    case (state_short)

        WAITING_FOR_HALF_VALUES: begin

        end

        HALF_VALUES_ADDED: begin

        end

        default: state_short <= WAITING_FOR_HALF_VALUES

    endcase
*/
end

endmodule