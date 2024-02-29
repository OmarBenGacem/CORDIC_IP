module delay(clk, rst, max, done);

    parameter COUNTER_WIDTH = 10;
    parameter STATE_WIDTH = 2;
    parameter RUNNING = {STATE_WIDTH{1'b0}};
    parameter DONE = {STATE_WIDTH{1'b1}};

    input  [COUNTER_WIDTH - 1:0] max;
    input                        clk;
    input                        rst;
    output reg                   done;

    reg [COUNTER_WIDTH - 1:0] counter;
    reg [STATE_WIDTH   - 1:0]  state;


    always @(posedge clk) begin
        
        if (rst) begin
            done <= 1'b0;
            counter <= {COUNTER_WIDTH{1'b0}};
            state <= RUNNING;

        end else begin

            case(state)

            RUNNING: begin
                counter <= counter + 1;
                state <= (counter == max) ? DONE : RUNNING;
            end

            DONE: begin
                done <= 1'b1;
            end
            default: state <= DONE;
            endcase


        end
    
    end


endmodule