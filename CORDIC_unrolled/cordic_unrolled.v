module CORDIC_unrolled(clk, rst, clk_en, angle_float, result, done);



//Data Parameters
parameter FLOAT_DATA_WIDTH = 32;
parameter CORDIC_ADDRESS_WIDTH = 4;
parameter INTEGER_WIDTH = 2;
parameter FRACTIONAL_WIDTH = 20;
parameter CORDIC_DATA_WIDTH = INTEGER_WIDTH + FRACTIONAL_WIDTH;

//parameter x_default = 22'b0100110110111010011101; //21 fractional bits
parameter x_default = 22'b0010011011011101001110; //20 fractional bits

//Latency Parameters
parameter CONVERSION_LATANCY = 4;
parameter CONVERSION_LATANCY_REV = 4;
parameter CORDIC_LATENCY = 18;

//Control Parameters
parameter CORDIC_COUNTER_WIDTH = 4;
parameter CORDIC_DEPTH = 15;
parameter COUNTER_WIDTH = 10;
parameter STATE_WIDTH = 5;

//State Parameters
parameter IDLE = 4'b0000;
parameter CONVERTING = 4'b0010;
parameter CORDIC_MAIN = 4'b0111;
parameter CONVERTING_BACK = 4'b0011;
parameter DONE = 4'b0001;





//IO Registers             
input                               clk;
input                               rst;
input                               clk_en;
input      [FLOAT_DATA_WIDTH - 1:0] angle_float;
output reg                          done;
output reg [FLOAT_DATA_WIDTH - 1:0] result;


//Control Registers
reg  [COUNTER_WIDTH - 1:0]                cordic_latency;
reg                                       start_cordic;
reg                                       cordic_reset;
reg  [COUNTER_WIDTH - 1:0]                counter_max;
reg  [STATE_WIDTH - 1: 0]                 state;
reg                                       start_conversion;       
reg                                       delay_reset;


//Data Registers (and ROM)
reg  signed  [CORDIC_DATA_WIDTH - 1: 0]   target;
reg  signed  [CORDIC_DATA_WIDTH - 1: 0]   working_angle;
reg  signed  [CORDIC_DATA_WIDTH - 1: 0]   x; 
reg  signed  [CORDIC_DATA_WIDTH - 1: 0]   y;


wire         [FLOAT_DATA_WIDTH - 1:0]     result_flt;
wire         [FLOAT_DATA_WIDTH - 1:0]     cordic_res;
wire                                      counter_done;      
wire                                      cordic_done;    
wire                                      cordic_reset;


//module convert_fp_fixed (aclr, clk_en, clock, dataa, result)/* synthesis synthesis_clearbox = 1 */;
fp_convert_twos_comp converter_fp_fix (

    .clock      ( clk ),
    .aclr       ( rst ),
    .clk_en     ( start_conversion ),
    .dataa      ( {1'b0, angle_float[FLOAT_DATA_WIDTH - 2:0]} ), // remove the sign bit, and add it again at the end
    .result     ( angle )

);

FIXED_Convert_twos_comp converter_fix_fp (
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

delay stopper_cordic (
		.max  ( cordic_latency ),
		.clk  ( clk ),
		.rst  ( cordic_reset ),
		.done ( cordic_done )
);


//module cordic_frame (clk, clk_en, rst, target, result);

cordic_frame cordic (

    .clk        ( clk ),
    .clk_en     ( start_cordic ),
    .rst        ( rst ),
    .target     ( angle ),
    .result     ( cordic_res )

);


initial begin

    working_angle <= 22'b0;
    y <= 22'b0;
    cordic_counter <= 4'b0;
    state <= IDLE;
    result <= 22'b0;
    x <= x_default;
    start_conversion <= 1'b0;
    counter_max <= CONVERSION_LATANCY;
    done <= 1'b0;
    target <= 22'b0;

    start_cordic <= 1'b0;
    cordic_reset <= 1'b0;
    cordic_latency <= CORDIC_LATENCY;


end



//clock syncronous signals
always @(posedge clk) begin    
    
    if (rst) begin
        state  <= IDLE;

        working_angle <= 22'b0;
        y <= 22'b0;
        cordic_counter <= 4'b0;
        state <= IDLE;
        result <= 22'b0;
        x <= x_default;
        start_conversion <= 1'b0;
        counter_max <= CONVERSION_LATANCY;
        done <= 1'b0;
        target <= 22'b0;
        
    end

    if (!clk_en) begin
        state <= IDLE;
    end

    case(state)

        IDLE: begin //0000
            //do nothing unless clock begins
            done <= 1'b0; // reset done signal
            if (clk_en) begin

                //Shorting out 45 and 0 degrees
    
                    if (angle_float == 32'b10111111010010010000111111011000 || angle_float == 32'b00111111010010010000111111011000 || angle_float == 32'b0) begin  
                        // short out 0 and +/-45 degrees
                        state <= DONE;                                                              
                        result <= (angle_float == 32'b0) ? 32'b00111111100000000000000000000000 : 32'b00111111001101010000010011110011; 
                    end else begin                
                        state <= CONVERTING;
                        start_conversion <= 1'b1;
                        delay_reset <= 1'b1; //start delay block
                        cordic_counter <= 4'b0;
                        x <= x_default; //reset value of x
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
            start_cordic <= 1'b1;
            cordic_reset <= 1'b1;
            start_conversion <= 1'b0; 
            target <= angle;
            end
        
        end


        CORDIC_MAIN: begin //0111

            cordic_reset <= 1'b0;
            if (cordic_done) begin
                x <= cordic_res;
                start_cordic <= 1'b0;
                delay_reset <= 1'b1; //start delay block
                start_conversion <= 1'b1;
                state <= CONVERTING_BACK;
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
            if(!done) done <= 1'b1;  //adding an additional cycle to compensate for error in NIOS II Platform
            if (done) state <= IDLE;

        end

        default: state <= IDLE;

    endcase

end



endmodule