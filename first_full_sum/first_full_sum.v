module first_full_sum(clk, rst, clk_en, start, done, x_val, writec, c);

parameter FLT_DATA_WIDTH = 32;


input clk;
input rst;
input clk_en;
input start;
input writec; //If writerc is high, the Nios II processor writes the value on the result port to register c. If writerc is low, custom instruction logic writes to internal register c.
input x_val
output result;
output done;


endmodule