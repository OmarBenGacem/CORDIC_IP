module stage_one_part (clk, clk_en, rst, start, x, half, square, x_to_cordic, done);

parameter FLT_DATA_WIDTH = 32;
parameter ACTUAL_CORDIC_WIDTH = 22;
parameter CRD_DATA_WIDTH = 24; //cordic data width
parameter SIGNED_128_24_BITS = 24'b001000000000000000000000;
parameter ONE_TWO_EIGHT = 32'b00111100000000000000000000000000;
parameter HALF = 32'b00111111000000000000000000000000;
parameter CONVERSION_LATANCY = 10'b0000000100;
parameter COUNTER_WIDTH = 10;
parameter STATE_WIDTH = 2;

parameter IDLE = 2'b00;
parameter CONVERTING = 2'b10;
parameter DONE  = 2'b11;


parameter HALF_DEFAULT_VALUE <= 32'b0;
parameter SQUARED_DEFAULT_VALUE <= 32'b0;
parameter CORDIC_DEFAULT_VALUE <= 32'b0;

input clk;
input clk_en;
input rst;
input start;
input  [FLT_DATA_WIDTH - 1 : 0]  x;
output reg [FLT_DATA_WIDTH - 1 : 0] half;
output reg [FLT_DATA_WIDTH - 1 : 0] square;
output reg signed [ACTUAL_CORDIC_WIDTH - 1 : 0] x_to_cordic;
output reg done;


wire  [FLT_DATA_WIDTH - 1 : 0] squared;
wire  [FLT_DATA_WIDTH - 1 : 0] halved;
wire signed [CRD_DATA_WIDTH - 1 : 0] cordic_value; //one wider
wire signed [CRD_DATA_WIDTH - 1 : 0] cordic_value_shifted; //one wider
wire signed [CRD_DATA_WIDTH - 1 : 0] conv_to_add;
wire counter_done;


reg [STATE_WIDTH - 1 : 0] state;
reg [COUNTER_WIDTH - 1 : 0] counter_max; 
reg start_functions;
reg start_convert;
reg start_timer;

fp_mul halfer(

    .aclr ( rst ),
    .clk_en ( start_functions ),
    .clock ( clk ),
    .dataa ( x ),
    .datab ( HALF ),
    .result ( halved )

);



fp_mul square_unit (

    .aclr ( rst ),
    .clk_en ( start_functions ),
    .clock ( clk ),
    .dataa ( x ),
    .datab ( x ),
    .result ( squared )

);


//one bit wider than the cordic one, so that the subtraction can be done single cycle, then just remove MSB
fp_to_10_14_fixed converter (

    .clock      ( clk ),
    .aclr       ( rst ),
    .clk_en     ( start_convert ),
    .dataa      ( x ), 
    .result     ( conv_to_add )

);

addsub_24 sub_one (

    .add_sub  ( 1'b0 ), //1 for add, 0 for sub
    .dataa    ( conv_to_add ),
    .datab    ( SIGNED_128_24_BITS ),
    .result   ( cordic_value )
    
);

delay stopper (

    .clk  (clk),
    .rst  (start_timer),
    .max  (counter_max),
    .done (counter_done)

);


initial begin

    state <= IDLE;
    start_functions <= 1'b0;
    start_convert <= 1'b0;
    counter_max <= CONVERSION_LATANCY;
    half <= HALF_DEFAULT_VALUE;
    squared <= SQUARED_DEFAULT_VALUE;
    x_to_cordic <= CORDIC_DEFAULT_VALUE;
    done <= 1'b0;

end

assign cordic_value_shifted = cordic_value >>> 7;
always @(posedge clk) begin

    if (rst) begin

    start_functions <= 1'b0;
    start_convert <= 1'b0;
    counter_max <= CONVERSION_LATANCY; 

    end else begin

        case(state)

        IDLE: begin
            done <= 1'b0;
            if(start && clk_en) begin

                start_timer <= 1'b1;
                start_functions <= 1'b1;
                start_convert <= 1'b1;
                state <= CONVERTING;
            end

        end

        CONVERTING: begin

            start_timer <= 1'b0;
            if (counter_done) begin
                start_functions <= 1'b0;
                start_convert <= 1'b0;
                state <= DONE;
                half <= halved;
                square <= squared;
                x_to_cordic <= cordic_value_shifted[21:0];
                done <= 1'b1;
            end

        end

        DONE: begin
            done <= 1'b0;
            state <= IDLE;
        end

        default: state <= IDLE;

        endcase
    end

end



endmodule