module stage_4(clk, rst, clk_en, start, val_1, val_2, current_val_1, current_val_2, new_val_1, new_val_2, done, working);

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
input       [FLOAT_DATA_WIDTH - 1 : 0]  val_1;
input       [FLOAT_DATA_WIDTH - 1 : 0]  val_2;
input       [FLOAT_DATA_WIDTH - 1 : 0]  current_val_1;
input       [FLOAT_DATA_WIDTH - 1 : 0]  current_val_2;
output reg  [FLOAT_DATA_WIDTH - 1 : 0]  new_val_1;
output reg  [FLOAT_DATA_WIDTH - 1 : 0]  new_val_2;
output reg                              done;
output reg                              working;

reg         [STATE_WIDTH - 1 : 0]       state;
reg                                     start_second_add;
reg                                     start_first_add;
reg                                     start_add;
wire                                    add_done;
wire       [FLOAT_DATA_WIDTH - 1 : 0]   first_add_out;
wire       [FLOAT_DATA_WIDTH - 1 : 0]   second_add_out;



delay stopper_convert (
		.max  ( ADD_LATENCY ),
		.clk  ( clk ),
		.rst  ( start_add ),
		.done ( add_done )
);

add adder_one (

    .aclr   (rst),
    .clk_en (start_first_add),
    .clock  (clk),
    .dataa  (val_1),
    .datab  (current_val_1),
    .result (first_add_out)

);

add adder_two (

    .aclr   (rst),
    .clk_en (start_first_add),
    .clock  (clk),
    .dataa  (val_2),
    .datab  (current_val_2),
    .result (second_add_out)

);



initial begin

    state <= IDLE;
    start_add <= 1'b0;
    start_first_add <= 1'b0;
    start_second_add <= 1'b0;
    done <= 1'b0;

end


always @(posedge clk) begin

    case(state)

        IDLE: begin
            done <= 1'b0;
            if (clk_en && start) begin

                state <= ADD_ONE;
                start_add <= 1'b1;
                start_first_add <= 1'b1;
                working <= 1'b1;

            end else begin
                working <= 1'b0;
            end

        end

        ADD_ONE: begin

            
            if (add_done) begin
                start_first_add <= 1'b0;
                start_add <= 1'b0;
                start_second_add <= 1'b0;
                state <= DONE;
                
                new_val_1 <= first_add_out;
                new_val_2 <= second_add_out;


            end else begin
                start_add <= 1'b0;
            end

        end
        //CURRENTLY UNUSED
        ADD_TWO: begin
            start_add <= 1'b0;
            if (add_done) begin

                state <= DONE;
                done <= 1'b1;
                start_second_add <= 1'b0;
                start_add <= 1'b0;
                new_val_1 <= first_add_out;
                new_val_2 <= second_add_out;

                end
            end

        DONE: begin
            done <= 1'b1;
            state <= IDLE;
        end

    default: state <= IDLE;

    endcase

end

endmodule