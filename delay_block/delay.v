module delay(clk, rst, max, done);

    parameter COUNTER_WIDTH = 10;
    parameter STATE_WIDTH = 2;
    // parameter RUNNING = {STATE_WIDTH{1'b01}};
    // parameter DONE = {STATE_WIDTH{1'b10}};
    // parameter IDLE = {STATE_WIDTH{1'b00}};
    parameter RUNNING = 2'b01;
    parameter DONE = 2'b10;
    parameter IDLE = 1'b00;

    input  [COUNTER_WIDTH - 1:0] max;
    input                        clk;
    input                        rst;
    output reg                   done;

    reg [COUNTER_WIDTH - 1:0] counter;
    reg [STATE_WIDTH   - 1:0]  state;

    initial state <= IDLE;

    always @(posedge clk) begin
        
        if (rst) begin
            done <= 1'b0;
            counter <= {COUNTER_WIDTH{1'b0}};
            state <= RUNNING;

        end else begin

            case(state)

            IDLE: begin //00
                done <= 1'b0;
                counter <= {COUNTER_WIDTH{1'b0}};
            end

            RUNNING: begin //01
                counter <= counter + 1;
                if (counter == max) done <= 1'b1;
                state <= (counter == max) ? DONE : RUNNING;
            end

            DONE: begin //10
                if (done == 1'b0) done <= 1'b1;
                else state <= IDLE;
                
            end
            default: state <= IDLE;
            endcase


        end
    
    end


endmodule