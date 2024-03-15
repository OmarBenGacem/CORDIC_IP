module cordic_pipeline (clk, rst, clk_en, target, start, result, squared, valid, pipeline_cleared);

parameter CORDIC_ADDRESS_WIDTH = 4;
parameter INTEGER_WIDTH = 2;
parameter FRACTIONAL_WIDTH = 20;
parameter DATA_WIDTH = INTEGER_WIDTH + FRACTIONAL_WIDTH;
parameter FLOAT_DATA_WIDTH = 32;

//parameter x_default = 22'b0100110110111010011101; //21 fractional bits
parameter x_default = 22'b0010011011011101001110; //20 fractional bits
parameter y_default = 22'b0;
parameter angle_default = 22'b0;

input                                    clk;
input                                    rst;
input                                    clk_en;
input       [DATA_WIDTH - 1 : 0 ]        target;
input                                    start;
output reg  [DATA_WIDTH - 1 : 0 ]        result;
output reg  [FLOAT_DATA_WIDTH - 1 : 0 ]  squared;
output reg                               valid;
output reg                               pipeline_cleared;





reg         [DATA_WIDTH - 1 : 0 ]  initial_x;
reg         [DATA_WIDTH - 1 : 0 ]  initial_y;
reg         [DATA_WIDTH - 1 : 0 ]  initial_angle;  
reg                                valid;      
wire signed [DATA_WIDTH - 1 : 0 ]  produced_result;
wire signed [DATA_WIDTH - 1 : 0 ]  produced_angle;
wire signed [DATA_WIDTH - 1 : 0 ]  produced_y;
wire signed [DATA_WIDTH - 1 : 0 ]  produced_target;
wire                               valid_out;
wire  [FLOAT_DATA_WIDTH - 1 : 0 ]  squared_out;
wire                               pipeline_cleared_connection;


initial begin

    initial_x <= x_default;   
    initial_y <= y_default;
    initial_angle <= angle_default;
    result <= 22'b0;
    done <= 1'b0;
    

end
assign pipeline_cleared_connection = !(valid_1_to_2 && valid_2_to_3 && valid_3_to_4 && valid_4_to_5 && valid_5_to_6 && valid_6_to_7 && valid_7_to_8 && valid_8_to_9 && valid_9_to_10 && valid_10_to_11 && valid_11_to_12 && valid_12_to_13 && valid_13_to_14 && valid_14_to_15 && valid_15_to_16 && valid_out);

always @(posedge clk) begin

    //if (!clk_en || rst) begin
    if (rst) begin 
        //if clk_en goes low, disable the pipeline
        initial_x <= x_default;   
        initial_y <= y_default;
        initial_angle <= angle_default;
        initial_valid <= 1'0;
        initial_squared <= 32'b0;
        
    end else begin
        result <= produced_result;
        squared <= squared_out;
        valid <= valid_out;
        pipeline_cleared <= pipeline_cleared_connection;
        
    end

end

cordic_info_stage  cordic_1 (

.clk          ( clk ),
.clk_en       ( clk_en ),
.target       ( target ),
.valid_in     ( start ),
.squared_in   ( squared_in ),
.shift_value  ( 4'b0000 ),
.shift_angle  ( 22'b0011001001000011111101 ),
.angle        ( initial_angle ),
.x            ( initial_x ),
.y            ( initial_y ),
.new_angle    ( angle_1_to_2 ),
.new_x        ( x_1_to_2 ),
.new_y        ( y_1_to_2 ),
.target_out   ( target_1_to_2 ),
.valid_out    ( valid_1_to_2 ),
.squared_out  ( valid_1_to_2 ),

);


cordic_info_stage  cordic_2 (

.clk          ( clk ),
.clk_en       ( clk_en ),
.target       ( target_1_to_2 ),
.valid_in     ( valid_1_to_2 ),
.squared_in   ( squared_1_to_2 ),
.shift_value  ( 4'b0001 ),
.shift_angle  ( 22'b0001110110101100011001 ),
.angle        ( angle_1_to_2 ),
.x            ( x_1_to_2 ),
.y            ( y_1_to_2 ),
.new_angle    ( angle_2_to_3 ),
.new_x        ( x_2_to_3 ),
.new_y        ( y_2_to_3 ),
.target_out   ( target_2_to_3 ),
.valid_out    ( valid_2_to_3 ),
.squared_out  ( squared_2_to_3 ),

);


cordic_info_stage  cordic_3 (

.clk          ( clk ),
.clk_en       ( clk_en ),
.target       ( target_2_to_3 ),
.valid_in     ( valid_2_to_3 ),
.squared_in   ( squared_2_to_3 ),
.shift_value  ( 4'b0010 ),
.shift_angle  ( 22'b0000111110101101101110 ),
.angle        ( angle_2_to_3 ),
.x            ( x_2_to_3 ),
.y            ( y_2_to_3 ),
.new_angle    ( angle_3_to_4 ),
.new_x        ( x_3_to_4 ),
.new_y        ( y_3_to_4 ),
.target_out   ( target_3_to_4 ),
.valid_out    ( valid_3_to_4 ),
.squared_out  ( squared_3_to_4 ),

);


cordic_info_stage  cordic_4 (

.clk          ( clk ),
.clk_en       ( clk_en ),
.target       ( target_3_to_4 ),
.valid_in     ( valid_3_to_4 ),
.squared_in   ( squared_3_to_4 ),
.shift_value  ( 4'b0011 ),
.shift_angle  ( 22'b0000011111110101011011 ),
.angle        ( angle_3_to_4 ),
.x            ( x_3_to_4 ),
.y            ( y_3_to_4 ),
.new_angle    ( angle_4_to_5 ),
.new_x        ( x_4_to_5 ),
.new_y        ( y_4_to_5 ),
.target_out   ( target_4_to_5 ),
.valid_out    ( valid_4_to_5 ),
.squared_out  ( squared_4_to_5 ),

);


cordic_info_stage  cordic_5 (

.clk          ( clk ),
.clk_en       ( clk_en ),
.target       ( target_4_to_5 ),
.valid_in     ( valid_4_to_5 ),
.squared_in   ( squared_4_to_5 ),
.shift_value  ( 4'b0100 ),
.shift_angle  ( 22'b0000001111111110101010 ),
.angle        ( angle_4_to_5 ),
.x            ( x_4_to_5 ),
.y            ( y_4_to_5 ),
.new_angle    ( angle_5_to_6 ),
.new_x        ( x_5_to_6 ),
.new_y        ( y_5_to_6 ),
.target_out   ( target_5_to_6 ),
.valid_out    ( valid_5_to_6 ),
.squared_out  ( squared_5_to_6 ),

);


cordic_info_stage  cordic_6 (

.clk          ( clk ),
.clk_en       ( clk_en ),
.target       ( target_5_to_6 ),
.valid_in     ( valid_5_to_6 ),
.squared_in   ( squared_5_to_6 ),
.shift_value  ( 4'b0101 ),
.shift_angle  ( 22'b0000000111111111110101 ),
.angle        ( angle_5_to_6 ),
.x            ( x_5_to_6 ),
.y            ( y_5_to_6 ),
.new_angle    ( angle_6_to_7 ),
.new_x        ( x_6_to_7 ),
.new_y        ( y_6_to_7 ),
.target_out   ( target_6_to_7 ),
.valid_out    ( valid_6_to_7 ),
.squared_out  ( squared_6_to_7 ),

);


cordic_info_stage  cordic_7 (

.clk          ( clk ),
.clk_en       ( clk_en ),
.target       ( target_6_to_7 ),
.valid_in     ( valid_6_to_7 ),
.squared_in   ( squared_6_to_7 ),
.shift_value  ( 4'b0110 ),
.shift_angle  ( 22'b0000000011111111111110 ),
.angle        ( angle_6_to_7 ),
.x            ( x_6_to_7 ),
.y            ( y_6_to_7 ),
.new_angle    ( angle_7_to_8 ),
.new_x        ( x_7_to_8 ),
.new_y        ( y_7_to_8 ),
.target_out   ( target_7_to_8 ),
.valid_out    ( valid_7_to_8 ),
.squared_out  ( squared_7_to_8 ),

);


cordic_info_stage  cordic_8 (

.clk          ( clk ),
.clk_en       ( clk_en ),
.target       ( target_7_to_8 ),
.valid_in     ( valid_7_to_8 ),
.squared_in   ( squared_7_to_8 ),
.shift_value  ( 4'b0111 ),
.shift_angle  ( 22'b0000000001111111111111 ),
.angle        ( angle_7_to_8 ),
.x            ( x_7_to_8 ),
.y            ( y_7_to_8 ),
.new_angle    ( angle_8_to_9 ),
.new_x        ( x_8_to_9 ),
.new_y        ( y_8_to_9 ),
.target_out   ( target_8_to_9 ),
.valid_out    ( valid_8_to_9 ),
.squared_out  ( squared_8_to_9 ),

);


cordic_info_stage  cordic_9 (

.clk          ( clk ),
.clk_en       ( clk_en ),
.target       ( target_8_to_9 ),
.valid_in     ( valid_8_to_9 ),
.squared_in   ( squared_8_to_9 ),
.shift_value  ( 4'b1000 ),
.shift_angle  ( 22'b0000000000111111111111 ),
.angle        ( angle_8_to_9 ),
.x            ( x_8_to_9 ),
.y            ( y_8_to_9 ),
.new_angle    ( angle_9_to_10 ),
.new_x        ( x_9_to_10 ),
.new_y        ( y_9_to_10 ),
.target_out   ( target_9_to_10 ),
.valid_out    ( valid_9_to_10 ),
.squared_out  ( squared_9_to_10 ),

);


cordic_info_stage  cordic_10 (

.clk          ( clk ),
.clk_en       ( clk_en ),
.target       ( target_9_to_10 ),
.valid_in     ( valid_9_to_10 ),
.squared_in   ( squared_9_to_10 ),
.shift_value  ( 4'b1001 ),
.shift_angle  ( 22'b0000000000011111111111 ),
.angle        ( angle_9_to_10 ),
.x            ( x_9_to_10 ),
.y            ( y_9_to_10 ),
.new_angle    ( angle_10_to_11 ),
.new_x        ( x_10_to_11 ),
.new_y        ( y_10_to_11 ),
.target_out   ( target_10_to_11 ),
.valid_out    ( valid_10_to_11 ),
.squared_out  ( squared_10_to_11 ),

);


cordic_info_stage  cordic_11 (

.clk          ( clk ),
.clk_en       ( clk_en ),
.target       ( target_10_to_11 ),
.valid_in     ( valid_10_to_11 ),
.squared_in   ( squared_10_to_11 ),
.shift_value  ( 4'b1010 ),
.shift_angle  ( 22'b0000000000001111111111 ),
.angle        ( angle_10_to_11 ),
.x            ( x_10_to_11 ),
.y            ( y_10_to_11 ),
.new_angle    ( angle_11_to_12 ),
.new_x        ( x_11_to_12 ),
.new_y        ( y_11_to_12 ),
.target_out   ( target_11_to_12 ),
.valid_out    ( valid_11_to_12 ),
.squared_out  ( squared_11_to_12 ),

);


cordic_info_stage  cordic_12 (

.clk          ( clk ),
.clk_en       ( clk_en ),
.target       ( target_11_to_12 ),
.valid_in     ( valid_11_to_12 ),
.squared_in   ( squared_11_to_12 ),
.shift_value  ( 4'b1011 ),
.shift_angle  ( 22'b0000000000000111111111 ),
.angle        ( angle_11_to_12 ),
.x            ( x_11_to_12 ),
.y            ( y_11_to_12 ),
.new_angle    ( angle_12_to_13 ),
.new_x        ( x_12_to_13 ),
.new_y        ( y_12_to_13 ),
.target_out   ( target_12_to_13 ),
.valid_out    ( valid_12_to_13 ),
.squared_out  ( squared_12_to_13 ),

);


cordic_info_stage  cordic_13 (

.clk          ( clk ),
.clk_en       ( clk_en ),
.target       ( target_12_to_13 ),
.valid_in     ( valid_12_to_13 ),
.squared_in   ( squared_12_to_13 ),
.shift_value  ( 4'b1100 ),
.shift_angle  ( 22'b0000000000000011111111 ),
.angle        ( angle_12_to_13 ),
.x            ( x_12_to_13 ),
.y            ( y_12_to_13 ),
.new_angle    ( angle_13_to_14 ),
.new_x        ( x_13_to_14 ),
.new_y        ( y_13_to_14 ),
.target_out   ( target_13_to_14 ),
.valid_out    ( valid_13_to_14 ),
.squared_out  ( squared_13_to_14 ),

);


cordic_info_stage  cordic_14 (

.clk          ( clk ),
.clk_en       ( clk_en ),
.target       ( target_13_to_14 ),
.valid_in     ( valid_13_to_14 ),
.squared_in   ( squared_13_to_14 ),
.shift_value  ( 4'b1101 ),
.shift_angle  ( 22'b0000000000000001111111 ),
.angle        ( angle_13_to_14 ),
.x            ( x_13_to_14 ),
.y            ( y_13_to_14 ),
.new_angle    ( angle_14_to_15 ),
.new_x        ( x_14_to_15 ),
.new_y        ( y_14_to_15 ),
.target_out   ( target_14_to_15 ),
.valid_out    ( valid_14_to_15 ),
.squared_out  ( squared_14_to_15 ),

);


cordic_info_stage  cordic_15 (

.clk          ( clk ),
.clk_en       ( clk_en ),
.target       ( target_14_to_15 ),
.valid_in     ( valid_14_to_15 ),
.squared_in   ( squared_14_to_15 ),
.shift_value  ( 4'b1110 ),
.shift_angle  ( 22'b0000000000000000111111 ),
.angle        ( angle_14_to_15 ),
.x            ( x_14_to_15 ),
.y            ( y_14_to_15 ),
.new_angle    ( angle_15_to_16 ),
.new_x        ( x_15_to_16 ),
.new_y        ( y_15_to_16 ),
.target_out   ( target_15_to_16 ),
.valid_out    ( valid_15_to_16 ),
.squared_out  ( squared_15_to_16 ),

);


cordic_info_stage  cordic_16 (

.clk          ( clk ),
.clk_en       ( clk_en ),
.target       ( target_15_to_16 ),
.valid_in     ( valid_15_to_16 ),
.squared_in   ( squared_15_to_16 ),
.shift_value  ( 4'b1111 ),
.shift_angle  ( 22'b0000000000000000011111 ),
.angle        ( angle_15_to_16 ),
.x            ( x_15_to_16 ),
.y            ( y_15_to_16 ),
.new_angle    ( produced_angle ),
.new_x        ( produced_x ),
.new_y        ( produced_y ),
.target_out   ( produced_target ),
.valid_out    ( valid_out ),
.squared_out  ( squared_out ),

);





endmodule