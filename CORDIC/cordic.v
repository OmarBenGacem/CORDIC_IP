module CORDIC(clk, rst, clk_en, angle_float, result, done);



//Data Parameters
parameter FLOAT_DATA_WIDTH = 32;
parameter CORDIC_ADDRESS_WIDTH = 4;
parameter INTEGER_WIDTH = 1;
parameter FRACTIONAL_WIDTH = 21;
parameter CORDIC_DATA_WIDTH = INTEGER_WIDTH + FRACTIONAL_WIDTH;



//Latency Parameters
parameter CONVERSION_LATANCY = 4;
parameter CONVERSION_LATANCY_REV = 4;

//Control Parameters
parameter CORDIC_COUNTER_WIDTH = 4;
parameter CORDIC_DEPTH = 11;
parameter COUNTER_WIDTH = 10;
parameter STATE_WIDTH = 5;

// parameter IDLE = {STATE_WIDTH{'b0000}}
// parameter CONVERTING = {STATE_WIDTH{'b0010}}
// parameter CORDIC_MAIN = {STATE_WIDTH{'b0001}}
// parameter CONVERTING_BACK = 4'b0011;
// parameter DONE = {STATE_WIDTH{'b0001}}

parameter IDLE = 4'b0000;
parameter CONVERTING = 4'b0010;
parameter CORDIC_MAIN = 4'b0111;
parameter CONVERTING_BACK = 4'b0011;
parameter DONE = 4'b0001;





//IO                     
input                               clk;
input                               rst;
input                               clk_en;
input      [FLOAT_DATA_WIDTH - 1:0] angle_float;
output reg                          done;
output reg [FLOAT_DATA_WIDTH - 1:0] result;


//Control Registers
reg  [COUNTER_WIDTH - 1:0]              counter_max;
reg  [CORDIC_COUNTER_WIDTH - 1: 0]      cordic_counter;
reg  [STATE_WIDTH - 1: 0]               state;
reg                                     start_conversion;       
reg                                     delay_reset;


//Data Registers (and ROM)
reg  [CORDIC_DATA_WIDTH - 1:0]    CORDIC_shifts [2**CORDIC_ADDRESS_WIDTH-1: 0]; //values as fixed point
reg  [CORDIC_DATA_WIDTH - 1: 0]   target;
reg  [CORDIC_DATA_WIDTH - 1: 0]   working_angle;
reg  [CORDIC_DATA_WIDTH - 1: 0]   x; 
reg  [CORDIC_DATA_WIDTH - 1: 0]   y;
wire [CORDIC_DATA_WIDTH - 1: 0]   shifted_y;
wire [CORDIC_DATA_WIDTH - 1: 0]   shifted_x;
wire [CORDIC_DATA_WIDTH - 1: 0]   shift_value;

wire [CORDIC_DATA_WIDTH - 1: 0]   angle;
wire [CORDIC_DATA_WIDTH - 1: 0]   new_x;
wire [CORDIC_DATA_WIDTH - 1: 0]   new_y;
wire [CORDIC_DATA_WIDTH - 1: 0]   new_angle;
wire [FLOAT_DATA_WIDTH - 1:0]     result_flt;
wire                              angle_greater_target;
wire                              angle_equal_target;
wire                              counter_done;      


//module convert_fp_fixed (aclr, clk_en, clock, dataa, result)/* synthesis synthesis_clearbox = 1 */;
fp_convert converter_fp_fix (

    .clock      ( clk ),
    .aclr       ( rst ),
    .clk_en     ( start_conversion ),
    .dataa      ( {1'b0, angle_float[FLOAT_DATA_WIDTH - 2:0]} ),
    .result     ( angle )

);



FIXED_Convert converter_fix_fp (

    .clock      ( clk ),
    .aclr       ( rst ),
    .clk_en     ( start_conversion ),
    .dataa      ( x ),
    .result     ( result_flt )

);


delay stopper (

		.max  ( counter_max ),
		.clk  ( clk ),
		.rst  ( delay_reset ),
		.done ( counter_done )

);


Fixed_Add_Sub addsub_x (
	.dataa ( x ),
	.datab ( shifted_y ),
    .add_sub ( (angle_greater_target) ), //1 for add, 0 for sub
	.result ( new_x )
);

Fixed_Add_Sub addsub_y (
	.dataa ( y ),
	.datab ( shifted_x ),
    .add_sub ( !(angle_greater_target) ), //1 for add, 0 for sun
	.result ( new_y )
);

Fixed_Add_Sub addsub_angle (
	.dataa ( working_angle ),
	.datab ( shift_value ),
    .add_sub ( !(angle_greater_target) ), //1 for add, 0 for sun
	.result ( new_angle )
);

Fixed_Point_gt	angle_gt (
	.dataa ( working_angle ),
	.datab ( target ),
	.aeb ( angle_equal_target ),
	.agb ( angle_greater_target )
);


initial begin

    // working_angle <= {{CORDIC_DATA_WIDTH}'b0};
    // y <= {{CORDIC_DATA_WIDTH}'b0};
    // cordic_counter <= {{CORDIC_COUNTER_WIDTH}'b0};
    // state <= {{STATE_WIDTH}'b0};

    working_angle <= 22'b0;
    y <= 22'b0;
    cordic_counter <= 4'b0;
    state <= IDLE;
    result <= 22'b0;
    x <= 22'b0100110110111010011101;
    start_conversion <= 1'b0;
    counter_max <= CONVERSION_LATANCY;
    done <= 1'b0;
    target <= 22'b0;



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
    CORDIC_shifts[4'b1010] <= 22'b0000000000011111111111;


end


//combinational logic signals
assign shift_value =  CORDIC_shifts[cordic_counter];
assign shifted_y = y >>> cordic_counter;
assign shifted_x = x >>> cordic_counter;

//clock syncronous signals
always @(posedge clk) begin    
    
    if (rst) begin
        state  <= IDLE;
    end

    case(state)

        IDLE: begin //0000
            //do nothing unless clock begins
            if (done) done <= 1'b0; // reset done signal
            if (clk_en) begin
                //Shorting out 45 and 0 degrees
                if (angle_float == 32'b00111111010010010000111111011000 || angle_float == 32'b0) begin
                    //short out 45 degrees (and 0)
                    state <= DONE;
                    if (angle_float == 32'b0) result <= 32'b00111111100000000000000000000000; else result <= 32'b00111111001101010000010011110011;  
                end else begin
                    state <= CONVERTING;
                    start_conversion <= 1'b1;
                    delay_reset <= 1'b1; //start delay block
                    cordic_counter <= 4'b0;
                    x <= 22'b0100110110111010011101; //reset value of x
                    working_angle <= 22'b0;
                    y <= 22'b0;
                    result <= 22'b0;
                    done <= 1'b0;
                    target <= 22'b0;
                    
                end
            end 

        end


        CONVERTING: begin //0010
            delay_reset <= 1'b0;
            if (counter_done) 
            begin state <= CORDIC_MAIN; 
            start_conversion <= 1'b0; 
            target <= angle;
            end
        
        end


        CORDIC_MAIN: begin //0111

            if (cordic_counter == CORDIC_DEPTH || angle_equal_target) begin
                delay_reset <= 1'b1; //start delay block
                start_conversion <= 1'b1;
                state <= CONVERTING_BACK;
            end else begin
                x <= new_x;
                y <= new_y;
                working_angle <= new_angle;
                cordic_counter <= cordic_counter + 1;

                //preempting activating the delays
                if (cordic_counter == CORDIC_DEPTH - 1) begin
                    delay_reset <= 1'b1; //start delay block
                    start_conversion <= 1'b1;
                    counter_max <= CONVERSION_LATANCY_REV;
                end
            end

        end

        CONVERTING_BACK: begin //0011
            counter_max <= CONVERSION_LATANCY_REV;
            start_conversion <= 1'b1;
            delay_reset <= 1'b0; //start delay block
            if (counter_done) begin 
                state <= DONE; 
                start_conversion <= 1'b0; 
                result <= {1'b0, result_flt[FLOAT_DATA_WIDTH - 2:0]}; 
            end

    
        end

        DONE: begin //0001
            //need to convert back to floating point
            result <= {1'b0, result_flt[FLOAT_DATA_WIDTH - 2:0]};
            if(!done) done <= 1'b1;  //adding an additional cycle to compensate for error in NIOS II Platform
            if (done) state <= IDLE;

        end

        default: state <= IDLE;

    endcase

end



endmodule