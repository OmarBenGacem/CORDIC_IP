module CORDIC(clk, rst, clk_en, angle_float, result, done);



//Data Parameters
parameter FLOAT_DATA_WIDTH = 32;
parameter CORDIC_ADDRESS_WIDTH = 4;
parameter INTEGER_WIDTH = 4;
parameter FRACTIONAL_WIDTH = 20;
parameter CORDIC_DATA_WIDTH = INTEGER_WIDTH + FRACTIONAL_WIDTH;



//Latency Parameters
parameter CONVERSION_LATANCY = {{COUNTER_WIDTH}'b1};

//Control Parameters
parameter CONVERSION_COUNTER_WIDTH = 3;
parameter CORDIC_COUNTER_WIDTH = 4;
parameter CORDIC_DEPTH = 8;
parameter COUNTER_WIDTH = 10;
parameter STATE_WIDTH = 5;

parameter IDLE = {STATE_WIDTH{'b0000}}
parameter CONVERTING = {STATE_WIDTH{'b0010}}
parameter CORDIC_MAIN = {STATE_WIDTH{'b0001}}
parameter DONE = {STATE_WIDTH{'b0001}}




//IO
input                               
input                               clk;
input                               rst;
input                               clk_en;
input      [FLOAT_DATA_WIDTH - 1:0] angle_float;
output                              done;
output reg [FLOAT_DATA_WIDTH - 1:0] result;


//Control Registers
reg  [COUNTER_WIDTH - 1:0]              counter_max;
reg  [CORDIC_COUNTER_WIDTH - 1: 0]      cordic_counter;
reg  [CONVERSION_COUNTER_WIDTH - 1: 0]  conversion_counter;
reg  [STATE_WIDTH - 1: 0]               state;
reg                                     start_conversion;       


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
    start_conversion <= 1'b0;
    counter_max <= CONVERSION_LATANCY;

end


wire                            sign_result;
wire [FLOAT_DATA_WIDTH - 1:0]   angle;
wire                            conversion_done;

//module convert_fp_fixed (aclr, clk_en, clock, dataa, result)/* synthesis synthesis_clearbox = 1 */;
float_to_fixed converter (

    .clock      ( clk ),
    .aclr       ( rst ),
    .clk_en     ( start_conversion ),
    .dataa      ( angle_float ),
    .result     ( angle )

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
                state <= CONVERTING;
                start_conversion <= 1'b1;
                delay_reset <= 1'b0; //start delay block
            end

        end


        SCALING begin

            if (conversion_counter == CONVERSION_LATANCY) state <= CORDIC_MAIN; start_conversion <= 1'b0;
            else conversion_counter <= conversion_counter + 1;
        
        end:


        CORDIC_MAIN: begin

            

        end


        DONE: begin


        end

    endcase

end



endmodule