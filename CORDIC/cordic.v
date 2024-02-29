module CORDIC(clk, rst, clk_en, unscaled_angle, result, done);



//Data Parameters
parameter FLOAT_DATA_WIDTH = 32;
parameter CORDIC_ADDRESS_WIDTH = 4;
parameter INTEGER_WIDTH = 4;
parameter FRACTIONAL_WIDTH = 20;
parameter CORDIC_DATA_WIDTH = INTEGER_WIDTH + FRACTIONAL_WIDTH;



//Latency Parameters
parameter ANGLE_SCALER_LATENCY = 1;

//Control Parameters
parameter CORDIC_COUNTER_WIDTH = 4;
parameter CORDIC_DEPTH = 8;
parameter COUNTER_WIDTH = 10;
parameter STATE_WIDTH = 5;

parameter IDLE = {STATE_WIDTH{'b0000}}
//parameter STATE_SCALING = {STATE_WIDTH{'b0001}}
parameter SCALING = {STATE_WIDTH{'b0010}}
parameter CORDIC_MAIN = {STATE_WIDTH{'b0001}}
parameter DONE = {STATE_WIDTH{'b0001}}




//IO
input                               
input                               clk;
input                               rst;
input                               clk_en;
input      [FLOAT_DATA_WIDTH - 1:0] unscaled_angle;
output                              done;
output reg [FLOAT_DATA_WIDTH - 1:0] result;


//Control Registers
reg  [COUNTER_WIDTH - 1:0]         counter_max;
reg  [CORDIC_COUNTER_WIDTH - 1: 0] cordic_counter;
reg  [STATE_WIDTH - 1: 0]          state;
reg                                start_scaler;       


//Data Registers (and ROM)
reg  [CORDIC_DATA_WIDTH-1:0]      CORDIC_shifts [2**CORDIC_ADDRESS_WIDTH-1: 0]; //values as fixed point
reg  [CORDIC_DATA_WIDTH - 1: 0]   working_angle;
reg  [CORDIC_DATA_WIDTH - 1: 0]   x; 
reg  [CORDIC_DATA_WIDTH - 1: 0]   y;



initial begin

    working_angle <= {{CORDIC_DATA_WIDTH}'b0};
    y <= {{CORDIC_DATA_WIDTH}'b0};
    x <= {{CORDIC_DATA_WIDTH}'b000010010000110001111100}; //0.607252935 = 0000000 . 100100001100011111000111000111
    cordic_counter <= {{CORDIC_COUNTER_WIDTH}'b0};
    state <= {{STATE_WIDTH}'b0};
    start_scaler <= 1'b0;

end

wire                            sign_result;
wire [FLOAT_DATA_WIDTH - 1:0]   angle;
wire                            scaler_done;

ancle_scaler scaler (

    .clk        (clk),
    .rst        (rst),
    .clk_en     (clk_en),
    .angle      (unscaled_angle),
    .scaled     (angle),
    .sign       (sign_result),
    .done       (scaler_done)

);

delay stopper (

		.max  ( counter_max ),
		.clk  ( clk ),
		.rst  ( delay_reset ),
		.done ( counter_done )

);


always @(posedge clk) begin

    if (rst) begin

    end

    case(state):

        IDLE: begin

            if (clk_en) begin
                state <= 
            end

        end


        SCALING begin


        end:


        CORDIC_MAIN: begin


        end


        DONE: begin


        end

    endcase

end



endmodule