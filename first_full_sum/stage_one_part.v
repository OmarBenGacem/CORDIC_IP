module stage_one_part (clk, clk_en, rst, start, x, half, square, x_to_cordic, done);

parameter FLT_DATA_WIDTH = 32;
parameter CRD_DATA_WIDTH = 22; //cordic data width
parameter SIGNED_ONE_LARGER_SUB = 23'b00100000000000000000000;
parameter ONE_TWO_EIGHT = 32'b00111100000000000000000000000000;
parameter HALF = 32'b00111111000000000000000000000000;
parameter CONVERSION_LATANCY = 10'b0000000100;
parameter MUL_LATENCY = 10'b0000000101;
parameter COUNTER_WIDTH = 10;
parameter STATE_WIDTH = 2;

parameter IDLE = 2'b00;
parameter MULTIPLYING =  2'b01;
parameter CONVERTING = 2'b10;
parameter DONE  = 2'b11;


input clk;
input clk_en;
input rst;
input start;
input  [FLT_DATA_WIDTH - 1 : 0]  x;
output reg [FLT_DATA_WIDTH - 1 : 0] half;
output reg [FLT_DATA_WIDTH - 1 : 0] square;
output reg signed [CRD_DATA_WIDTH - 1 : 0] x_to_cordic;
output reg done;


wire  [FLT_DATA_WIDTH - 1 : 0] squared;
wire  [FLT_DATA_WIDTH - 1 : 0] halved;
wire signed  [FLT_DATA_WIDTH - 1 : 0] dived_128;
wire signed [CRD_DATA_WIDTH : 0] cordic_value; //one wider
wire signed [CRD_DATA_WIDTH : 0] conv_to_add;
wire counter_done;


reg [STATE_WIDTH - 1 : 0] state
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

fp_mul div_128 (

    .aclr ( rst ),
    .clk_en ( start_functions ),
    .clock ( clk ),
    .dataa ( x ),
    .datab ( ONE_TWO_EIGHT ),
    .result ( dived_128 )

);

fp_mul square (

    .aclr ( rst ),
    .clk_en ( start_functions ),
    .clock ( clk ),
    .dataa ( x ),
    .datab ( x ),
    .result ( squared )

);


//one bit wider than the cordic one, so that the subtraction can be done single cycle, then just remove MSB
fp_convert_twos_comp converter (

    .clock      ( clk ),
    .aclr       ( rst ),
    .clk_en     ( start_convert ),
    .dataa      ( dived_128 ), // remove the sign bit, and add it again at the end
    .result     ( conv_to_add )

);

Fixed_Add_Sub_signed sub_one (

    .add_sub  ( 1'b0 ), //1 for add, 0 for sub
    .dataa    ( conv_to_add ),
    .datab    ( SIGNED_ONE_LARGER_SUB ),
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
    start_convert <= 1'b1;
    counter_max <= MUL_LATENCY;

end


always @(posedge clk) begin

    if (rst) begin

    start_functions <= 1'b0;
    start_convert <= 1'b1;
    counter_max <= MUL_LATENCY; 

    end else begin

        case(state)

        IDLE: begin

            if(start && clk_en) begin

                start_timer <= 1'b1;
                state <= MULTIPLYING;
            end

        end

        MULTIPLYING: begin

            start_timer <= 1'b0;

            if (counter_done) begin

                start_timer <= 1'b1;
                counter_max <= CONVERSION_LATANCY;
                state <= CONVERTING;

            end

        end

        CONVERTING: begin

            start_timer <= 1'b0;
            if (counter_done) begin
                state <= DONE;
                half <= halved;
                square <= squared;
                x_to_cordic <= cordic_value[CRD_DATA_WIDTH - 1 : 0];
            end

        end

        DONE: begin
            done <= 1'b1;
            state <= IDLE;
        end

        endcase
    end

end



endmodule;