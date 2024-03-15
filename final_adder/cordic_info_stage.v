module cordic_info_stage(clk, clk_en, target, valid_in, shift_value, shift_angle, angle, x, y, new_angle, new_x, new_y, target_out, valid_out);

parameter INTEGER_WIDTH = 2;
parameter DECIMAL_WIDTH = 20;
parameter DATA_WIDTH = DECIMAL_WIDTH + INTEGER_WIDTH;
parameter CORDIC_COUNTER_WIDTH = 4;
parameter FLOAT_DATA_WIDTH = 32;


input      		                                  clk;
input 											  valid_in;
input 		 	  [FLOAT_DATA_WIDTH - 1 : 0]      squared_in;
input      		                                  clk_en;
input      		  [DATA_WIDTH - 1 : 0]            target;
input      		  [CORDIC_COUNTER_WIDTH - 1 : 0]  shift_value;
input  signed     [DATA_WIDTH - 1 : 0]            shift_angle;
input  signed     [DATA_WIDTH - 1 : 0]            angle;
input  signed     [DATA_WIDTH - 1 : 0]            x;
input  signed     [DATA_WIDTH - 1 : 0]            y;
output reg signed [DATA_WIDTH - 1 : 0]            new_angle;
output reg signed [DATA_WIDTH - 1 : 0]            new_x;
output reg signed [DATA_WIDTH - 1 : 0]            new_y;
output reg        [DATA_WIDTH - 1 : 0]            target_out; //used so CORDIC values in the pipeline have memory of their target
output reg										  valid_out;
output reg 		  [FLOAT_DATA_WIDTH - 1 : 0]      squared_out;	

wire signed  [DATA_WIDTH - 1: 0]  		   		  shifted_y;
wire signed  [DATA_WIDTH - 1: 0]     			  shifted_x;
wire signed  [DATA_WIDTH - 1: 0]		   	      computed_y;
wire signed  [DATA_WIDTH - 1: 0]     			  computed_x;
wire signed  [DATA_WIDTH - 1: 0]     			  computed_angle;
wire                                        	  angle_equal_target;
wire                                        	  angle_greater_target;



Fixed_Add_Sub_signed addsub_x (
	.dataa   ( x ),
	.datab   ( shifted_y ),
    .add_sub ( (angle_greater_target) ), //1 for add, 0 for sub
	.result  ( computed_x )
);

Fixed_Add_Sub_signed addsub_y (
	.dataa   ( y ),
	.datab   ( shifted_x ),
    .add_sub ( !(angle_greater_target) ), //1 for add, 0 for sun
	.result  ( computed_y )
);

Fixed_Add_Sub_signed addsub_angle (
	.dataa   ( angle ),
	.datab   ( shift_angle ),
    .add_sub ( !(angle_greater_target) ), //1 for add, 0 for sun
	.result  ( computed_angle )
);

Fixed_Point_gt_signed angle_gt (
	.dataa   ( angle ),
	.datab   ( target ),
	.aeb     ( angle_equal_target ),
	.agb     ( angle_greater_target )
);


initial begin

    new_angle <= 22'b0;
    new_x <= 22'b0;
    new_y <= 22'b0;
	target_out <= 22'b0;

end

assign shifted_y = y >>> shift_value;
assign shifted_x = x >>> shift_value;

always @(posedge clk) begin
    if (clk_en) begin
        new_angle <= computed_angle;
        new_x <= computed_x;
        new_y <= computed_y;
        target_out <= target;
		valid_out <= valid_in;
		squared_out <= squared_in;
	end

end


endmodule