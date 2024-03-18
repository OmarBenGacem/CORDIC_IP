module function_evaluation(clk, rst, clk_en, start, done, x_one, x_two, result, n);

//calculates 3 operands in parallel, as this is the most function arguments you can do in one go
parameter FLT_DATA_WIDTH = 32;
parameter N_WIDTH = 2;
parameter CORDIC_DATA_WIDTH = 22;
parameter STATE_WIDTH = 3;

parameter CLEAR = 2'd0;
parameter GO = 2'd1;
parameter READ = 2'd2;

parameter IDLE =       3'b000;
parameter WORKING =    3'b001;
parameter FLUSHING =   3'b010;
parameter DISPLAYING = 3'b011;
parameter GENERATING_OUTPUT    = 3'b100;
parameter DONE =       3'b111;

parameter WAITING = 3'b000;
parameter INPUTING = 3'b001;

parameter WAITING_FOR_HALF_VALUES = 3'b000;
parameter HALF_VALUES_ADDED = 3'b001;

parameter ADD_LATENCY = 10'b0000000101;


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
reg start_stage_3;


//stage 1 done is the done signal
wire stage_1_done;

reg                          rst_internal;
reg [STATE_WIDTH - 1 : 0]    state;
reg [FLT_DATA_WIDTH - 1 : 0] half_sum;
reg [FLT_DATA_WIDTH - 1 : 0] cos_sum;
reg [FLT_DATA_WIDTH - 1 : 0] first_x_halved;
reg [CORDIC_DATA_WIDTH - 1 : 0] temp_value_container;
reg [FLT_DATA_WIDTH - 1 : 0] temp_square_value_container;
reg [STATE_WIDTH - 1 : 0]    state_context_two;
reg                          ready_to_output;
reg                          generate_output;
reg                          start_output_timer;
reg                          clk_en_internal;
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

wire [FLT_DATA_WIDTH - 1 : 0] shorted_new_sum;
wire                          half_short_complete;
wire [FLT_DATA_WIDTH - 1 : 0] full_pipeline_new_sum;

wire                          full_pipeine_complete;

wire                          pipeline_stage_1_in_use;
wire                          cordic_pipeline_cleared;
wire                          pipeline_stage_3_in_use;
wire                          pipeline_stage_4_in_use;
wire                          shorting_stage_4_in_use;
wire [FLT_DATA_WIDTH - 1 : 0] vector_sum;
wire                          output_generated;

stage_1 first_stage (

    .clk                (clk),
    .clk_en             (clk_en_internal),
    .rst                (rst_internal),
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
    .clk_en             (clk_en_internal),
    .rst                (rst_internal),
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
    .clk_en         (clk_en_internal),
    .rst            (rst_internal),
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


//module stage_4(clk, rst, clk_en, start, current_total, to_add_one, to_add_two, new_total, done, working);
stage_4 fourth_stage (

    .clk            (clk),
    .rst            (rst_internal),
    .clk_en         (clk_en_internal),
    .start          (start_final_add),
    .current_total  (cos_sum),
    .to_add_one     (final_add_one),
    .to_add_two     (final_add_two),
    .new_total      (full_pipeline_new_sum),
    .done           (full_pipeine_complete),
    .working        (pipeline_stage_4_in_use)

);

stage_4 short_x_div_2 (

    .clk            (clk),
    .rst            (rst_internal),
    .clk_en         (clk_en_internal),
    .start          (stage_1_done),
    .current_total  (half_sum),
    .to_add_one     (x_one_halved),
    .to_add_two     (x_two_halved),
    .new_total      (shorted_new_sum),
    .done           (half_short_complete),
    .working        (shorting_stage_4_in_use)

);


// Displaying Hardware
delay add_waiter (
		.max  ( ADD_LATENCY ),
		.clk  ( clk ),
		.rst  ( start_output_timer ),
		.done ( output_generated )
);


add output_adder (

    .aclr   (rst_internal),
    .clk_en (generate_output),
    .clock  (clk),
    .dataa  (cos_sum),
    .datab  (half_sum),
    .result (vector_sum)

);



initial begin

    result <= 32'b0;
    done <= 1'b0;
    start_stage_1 <= 1'b0;
    start_stage_3 <= 1'b0;
    half_sum <= 32'b0;
    cos_sum <= 32'b0;
    state <= IDLE;
    state_context_two <= WAITING;
    first_x_halved <= 32'b0;
    temp_value_container <= 22'b0;
    temp_square_value_container <= 32'b0;
    start_stage_3 <= 1'b0;
    ready_to_output <= 1'b0;
    generate_output <= 1'b0;
    start_output_timer <= 1'b0;
    rst_internal <= 1'b0;
    clk_en_internal <= 1'b1;

end

always@(posedge clk) begin



    if (rst_internal) begin
        
        result <= 32'b0;
        done <= 1'b0;
        start_stage_1 <= 1'b0;
        start_stage_3 <= 1'b0;
        half_sum <= 32'b0;
        cos_sum <= 32'b0;
        state <= IDLE;
        state_context_two <= WAITING;
        first_x_halved <= 32'b0;
        temp_value_container <= 22'b0;
        temp_square_value_container <= 32'b0;
        start_stage_3 <= 1'b0;
        ready_to_output <= 1'b0;
        generate_output <= 1'b0;
        start_output_timer <= 1'b0;
        rst_internal <= 1'b0;
        clk_en_internal <= 1'b0;

    end else begin

        ready_to_output <= !pipeline_stage_4_in_use && !shorting_stage_4_in_use && !pipeline_stage_3_in_use && cordic_pipeline_cleared && !pipeline_stage_1_in_use;
        case(state)

        IDLE: begin  //000
            clk_en_internal <= 1'b1;
            done <= 1'b0;
            result <= 32'b0;
            rst_internal <= 1'b0;
            if (clk_en && start) begin

                if (n == GO) begin

                    start_stage_1 <= 1'b1;
                    state <= WORKING;
                    

                end else if ( n == READ ) begin
                    
                    state <= GENERATING_OUTPUT;

                end else if ( n == CLEAR ) begin
                    state <= FLUSHING;
                    rst_internal <= 1'b1;
                end

            end

    

        end

        WORKING: begin //001

            if (start_stage_1) start_stage_1 <= 1'b0;
            if (stage_1_done) begin
                first_x_halved <= x_one_halved;
                state <= DONE;
                result <= 32'b0;
                
            end


        end

        FLUSHING: begin //010
            rst_internal <= 1'b0;
            done <= 1'b1;
            state <= DONE;

        end

        GENERATING_OUTPUT: begin //100
            
            if (ready_to_output) begin 
                state <= DISPLAYING;
                generate_output <= 1'b1;
                start_output_timer <= 1'b1;
            end
        end

        DISPLAYING: begin //011
            start_output_timer <= 1'b0;
            if (output_generated) begin
            
                state <= DONE;
                result <= vector_sum;
                generate_output <= 1'b0;
                done <= 1'b0;
                start_stage_1 <= 1'b0;
                start_stage_3 <= 1'b0;
                half_sum <= 32'b0;
                cos_sum <= 32'b0;
                state_context_two <= WAITING;
                first_x_halved <= 32'b0;
                temp_value_container <= 22'b0;
                temp_square_value_container <= 32'b0;
                start_stage_3 <= 1'b0;
                ready_to_output <= 1'b0;
                start_output_timer <= 1'b0;
                //rst_internal <= 1'b1;
                clk_en_internal <= 1'b0;

            end

        end

        DONE: begin //111   
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
            half_sum <= shorted_new_sum;

        end

        if (full_pipeine_complete) begin

            cos_sum <= full_pipeline_new_sum;

        end
        
    end

end

endmodule