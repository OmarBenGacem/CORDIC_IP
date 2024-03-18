module stage_2(clk, clk_en, rst, x_one, x_two, one_sq, two_sq, start, pipeline_cleared, result, valid, squared_pipeline);

parameter CORDIC_DATA_WIDTH = 22;
parameter default_input = 22'b0;
parameter FLOAT_DATA_WIDTH = 32;

parameter IDLE = 2'b00;
parameter NEXT = 2'b01;


input clk;
input clk_en;
input rst;
input [CORDIC_DATA_WIDTH - 1 : 0] x_one;
input [CORDIC_DATA_WIDTH - 1 : 0] x_two;
input [FLOAT_DATA_WIDTH - 1 : 0] one_sq;
input [FLOAT_DATA_WIDTH - 1 : 0] two_sq;
input start;
output reg pipeline_cleared;
output reg [CORDIC_DATA_WIDTH - 1 : 0] result;
output reg valid;
output reg [FLOAT_DATA_WIDTH - 1 : 0] squared_pipeline;

reg [CORDIC_DATA_WIDTH - 1 : 0] input_value;
reg [CORDIC_DATA_WIDTH - 1 : 0] next_value;
reg [FLOAT_DATA_WIDTH - 1 : 0] input_square;
reg [FLOAT_DATA_WIDTH - 1 : 0] next_square;
reg [1 : 0]                     state;
reg                             enter_value;
wire [CORDIC_DATA_WIDTH - 1 : 0] pipeline_out;
wire                            data_valid;
wire                            data_done;
wire                            pipeline_cleared_wire;
wire [FLOAT_DATA_WIDTH - 1 : 0] squared_pipeline_wire;

//module cordic_pipeline (clk, rst, clk_en, target, start, result, squared, valid, pipeline_cleared);
cordic_pipeline cordic_stage(

    .clk                (clk),
    .rst                (rst),
    .clk_en             (clk_en),
    .target             (input_value),
    .start              (enter_value),
    .square_value       (input_square),
    .result             (pipeline_out),
    .squared            (squared_pipeline_wire),
    .valid              (data_valid),
    .pipeline_cleared   (pipeline_cleared_wire)

);

initial begin
    pipeline_cleared <= 1'b0;
    result <= 1'b0;
    valid <= 1'b0;
    squared_pipeline <= 32'b0;
    input_value <= default_input;
    next_value <= default_input;
    next_square <= default_input;
    enter_value <= 1'b0;
    state <= IDLE;
end

always @(posedge clk) begin

    result <= pipeline_out;
    squared_pipeline <= squared_pipeline_wire;
    valid <= data_valid;
    pipeline_cleared <= pipeline_cleared_wire;

    if (rst) begin

        pipeline_cleared <= 1'b0;
        result <= 1'b0;
        valid <= 1'b0;
        squared_pipeline <= 32'b0;
        input_value <= default_input;
        next_value <= default_input;
        next_square <= default_input;
        enter_value <= 1'b0;
        state <= IDLE;

    end else begin

        case (state)
            IDLE: begin
                
                if (start && clk_en) begin
                    enter_value <= 1'b1;
                    input_value <= x_one;
                    next_value <= x_two;
                    input_square <= one_sq;
                    next_square <= two_sq;
                    state <= NEXT;
                    
                end 

            end

            NEXT: begin
                
                input_value <= next_value;
                input_square <= next_square;
                next_value <= default_input;
                state <= IDLE;
                enter_value <= 1'b0;

            end
    
        endcase

    end

end

endmodule