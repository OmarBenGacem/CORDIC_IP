module stage_4(clk, rst, clk_en, start, current_total, to_add_one, to_add_two, new_total, done, working);

parameter IDLE = 2'b00;
parameter ADD_ONE = 2'b01;
parameter ADD_TWO = 2'b10;
parameter DONE = 2'b11;

parameter ADD_LATENCY = 10'b0000000101;
parameter STATE_WIDTH = 2;
parameter FLOAT_DATA_WIDTH = 32;


input                                   clk;
input                                   rst;
input                                   clk_en;
input                                   start;
input       [FLOAT_DATA_WIDTH - 1 : 0]  current_total;
input       [FLOAT_DATA_WIDTH - 1 : 0]  to_add_one;
input       [FLOAT_DATA_WIDTH - 1 : 0]  to_add_two;
output reg  [FLOAT_DATA_WIDTH - 1 : 0]  new_total;
output reg                              done;
output reg                              working;

reg         [FLOAT_DATA_WIDTH - 1 : 0]  working_total;
reg         [FLOAT_DATA_WIDTH - 1 : 0]  intermediate_addition;
reg         [STATE_WIDTH - 1 : 0]       state_context_one;
reg         [STATE_WIDTH - 1 : 0]       state_context_two;
reg                                     start_second_add;
reg                                     start_first_add;
reg                                     start_add;
reg                                     start_add_dos;
reg                                     first_done;

wire                                    add_done;
wire                                    add_done_dos;
wire       [FLOAT_DATA_WIDTH - 1 : 0]   first_add_out;
wire       [FLOAT_DATA_WIDTH - 1 : 0]   second_add_out;



delay stopper_convert (
		.max  ( ADD_LATENCY ),
		.clk  ( clk ),
		.rst  ( start_add ),
		.done ( add_done )
);


delay dos (
		.max  ( ADD_LATENCY ),
		.clk  ( clk ),
		.rst  ( start_add_dos ),
		.done ( add_done_dos )
);


add adder_one (

    .aclr   (rst),
    .clk_en (start_first_add),
    .clock  (clk),
    .dataa  (to_add_two),
    .datab  (to_add_one),
    .result (first_add_out)

);

add adder_two (

    .aclr   (rst),
    .clk_en (start_second_add),
    .clock  (clk),
    .dataa  (working_total),
    .datab  (intermediate_addition),
    .result (second_add_out)

);



initial begin

    state_context_one <= IDLE;
    state_context_two <= IDLE;
    start_add <= 1'b0;
    start_first_add <= 1'b0;
    start_second_add <= 1'b0;
    done <= 1'b0;
    working_total <= 32'b0;
    intermediate_addition <= 32'b0;
    first_done <= 1'b0;
    start_add_dos <= 1'b0;
    working <= 1'b0;
    new_total <= 32'b0;

end


always @(posedge clk) begin

    if (rst) begin

        state_context_one <= IDLE;
        state_context_two <= IDLE;
        start_add <= 1'b0;
        start_first_add <= 1'b0;
        start_second_add <= 1'b0;
        done <= 1'b0;
        working_total <= 32'b0;
        intermediate_addition <= 32'b0;
        first_done <= 1'b0;
        start_add_dos <= 1'b0;
        working <= 1'b0;
        new_total <= 32'b0;

    end else begin

        if ((state_context_one == IDLE) && (state_context_two == IDLE)) begin
            working <= 1'b0;
        end else begin
            working <= 1'b1;
        end
        



        case(state_context_one)

            IDLE: begin
                first_done <= 1'b0;
                if (clk_en && start) begin

                    state_context_one <= ADD_ONE;
                    start_add <= 1'b1;
                    start_first_add <= 1'b1;


                end else begin

                    start_first_add <= 1'b0;

                end

            end

            ADD_ONE: begin

                
                if (add_done) begin
                    start_first_add <= 1'b0;
                    start_add <= 1'b0;
                    state_context_one <= DONE;
                    first_done <= 1'b1;

                
                    intermediate_addition <= first_add_out;


                end else begin
                    start_add <= 1'b0;
                end

            end

            DONE: begin
                state_context_one <= IDLE;
            end

        default: state_context_one <= IDLE;

        endcase

        case(state_context_two)

            IDLE: begin
                done <= 1'b0;

                if (first_done) begin
                    state_context_two <= ADD_ONE;
                    start_second_add <= 1'b1;
                    start_add_dos <= 1'b1;

                end else begin
                    start_second_add <= 1'b0;
                end

            end

            ADD_ONE: begin
                start_add_dos <= 1'b0;
                done <= 1'b0;

                if (add_done_dos) begin
                    done <= 1'b1;

                    new_total <= second_add_out;
                    working_total <= second_add_out;
                    state_context_two <= IDLE;
                    

                end

            end

            default: state_context_two <= IDLE;

        endcase
    end

end

endmodule