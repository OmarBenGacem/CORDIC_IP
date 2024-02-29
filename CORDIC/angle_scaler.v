module angle_scaler (clk, rst, clk_en, angle, scaled, sign);

parameter DATA_WIDTH = 32;

input                            clk;
input                            rst;
input                            clk_en;
input       [DATA_WIDTH - 1 : 0] angle;
output reg  [DATA_WIDTH - 1 : 0] scaled;
output reg                       sign;

//to be finished later
always (@posedge clk) begin

    scaled <= angle;
    sign <= 1'b1

end






endmodule