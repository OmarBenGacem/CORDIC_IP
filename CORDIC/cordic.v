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
parameter CONVERTING_BACK = 4'b0011;
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
reg  [CORDIC_DATA_WIDTH - 1: 0]   target;
reg  [CORDIC_DATA_WIDTH - 1: 0]   working_angle;
reg  [CORDIC_DATA_WIDTH - 1: 0]   x; 
reg  [CORDIC_DATA_WIDTH - 1: 0]   y;
reg  [CORDIC_DATA_WIDTH - 1: 0]   shifted_y;
reg  [CORDIC_DATA_WIDTH - 1: 0]   shifted_x;

wire [CORDIC_DATA_WIDTH - 1: 0]   new_x;
wire [CORDIC_DATA_WIDTH - 1: 0]   new_y;
wire [CORDIC_DATA_WIDTH - 1: 0]   new_angle;
wire                              sign_result;
wire [FLOAT_DATA_WIDTH - 1:0]     angle;
wire                              conversion_done;
wire                              angle_greater_target;
wire                              a_equal_x_lt;
wire                              a_greater_than_x;
wire                              a_less_than_x;

//module convert_fp_fixed (aclr, clk_en, clock, dataa, result)/* synthesis synthesis_clearbox = 1 */;
FP_Convert converter_fp_fix (

    .clock      ( clk ),
    .aclr       ( rst ),
    .clk_en     ( start_conversion ),
    .dataa      ( angle_float ),
    .result     ( angle )

);



FIXED_Convert converter_fix_fp (

    .clock      ( clk ),
    .aclr       ( rst ),
    .clk_en     ( start_conversion ),
    .dataa      (  ),
    .result     (  )

);


delay stopper (

		.max  ( counter_max ),
		.clk  ( clk ),
		.rst  ( delay_reset ),
		.done ( counter_done )

);


Fixed_Add_Sub addsub_x (
	.dataa ( x ),
	.datab ( shifted_x ),
    .addsub ( (a_greater_than_x) ), //1 for add, 0 for sub
	.result ( new_x )
);

Fixed_Add_Sub addsub_y (
	.dataa ( y ),
	.datab ( shifted_y ),
    .addsub ( !(a_greater_than_x) ), //1 for add, 0 for sun
	.result ( new_y )
);

Fixed_Point_gt	angle_gt (
	.dataa ( angle ),
	.datab ( working_angle ),
	.aeb ( angle_equal_target ),
	.agb ( angle_greater_target )
);


initial begin

    working_angle <= {{CORDIC_DATA_WIDTH}'b0};
    y <= {{CORDIC_DATA_WIDTH}'b0};
    x <= 22'b0100110110111010011101;
    cordic_counter <= {{CORDIC_COUNTER_WIDTH}'b0};
    state <= {{STATE_WIDTH}'b0};
    start_conversion <= 1'b0;
    counter_max <= CONVERSION_LATANCY;
    shifted_y <= y >>> cordic_counter;
    shifted_x <= x >>> cordic_counter;


    CORDIC_shifts[4'b0000] <= 22'b0110010010000111111011;
    CORDIC_shifts[4'b0001] <= 22'b0011101101011000110011;
    CORDIC_shifts[4'b0010] <= 22'b0001111101011011011101;
    CORDIC_shifts[4'b0011] <= 22'b0000111111101010110111;
    CORDIC_shifts[4'b0100] <= 22'b0000011111111101010101;
    CORDIC_shifts[4'b0101] <= 22'b0000001111111111101010;
    CORDIC_shifts[4'b0110] <= 22'b0000000111111111111101;
    CORDIC_shifts[4'b0111] <= 22'b0000000011111111111111;
    CORDIC_shifts[4'b1000] <= 22'b0000000001111111111111;
    CORDIC_shifts[4'b1001] <= 22'b0000000000111111111111;


end

always @(posedge clk) begin

    if (rst) begin
        state  <= IDLE;
    end

    case(state):

        IDLE: begin

            if (clk_en) begin
                //Shorting out 45 and 0 degrees
                if (angle_float == 32'b00111111010010010000111111011000 || angle_float == 32'b0) begin
                    state <= DONE
                    if (angle_float == 32'b0) result <= 32'b00111111100000000000000000000000; else result <= 00111111001101010000010011110011;  
                end else begin
                    state <= CONVERTING;
                    start_conversion <= 1'b1;
                    delay_reset <= 1'b1; //start delay block
                    
                end
            end else begin
                //assign initial values
                x <= 22'b0100110110111010011101;
                cordic_counter <= 4'b0;

            end

        end


        CONVERTING begin
            delay_reset <= 1'b0;
            if (counter_done) state <= CORDIC_MAIN; start_conversion <= 1'b0; working_angle <= angle; 
        
        end:


        CORDIC_MAIN: begin

            if (cordic_counter == CORDIC_DEPTH) begin
                state <= DONE;
            end else begin
                

                case(angle_greater_target)

                    1'b1: begin
                        //the angle equals the approximation being made
                        x <= x_new;
                        y <= y_new;
                        angle <= angle_new;
                    end

                    1'b0: begin

                        x <= x_new;
                        y <= y_new;
                        angle <= angle_new;

                    end
                    
                endcase
                cordic_counter = cordic_counter + 1;
            end

        end

        CONVERTING_BACK: begin
            start_conversion <= 1'b1;
            delay_reset <= 1'b0; //start delay block
            if (counter_done) state <= DONE; start_conversion <= 1'b0; 

    
        end

        DONE: begin
            //need to convert back to floating point
            done <= 1'b1;
            result <= x;
            if (!clk_en) state <= IDLE;

        end

    endcase

end



endmodule