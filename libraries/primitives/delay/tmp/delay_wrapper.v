// File: delay_wrapper.v
// Generated by MyHDL 0.7
// Date: Tue Apr 10 22:19:20 2012


`timescale 1ns/10ps

module delay_wrapper (
    clk,
    en,
    rst,
    din,
    dout,
    data_valid
);


input clk;
input en;
input rst;
input din;
output dout;
wire dout;
input data_valid;







delay 
#(
   .ARCHITECTURE ("BEHAVIORAL"),
   .DELAY_TYPE   ("FIFO"),
   .DATA_WIDTH   (32),
   .DELAY_CYCLES (1)
) counter_inst (
   .clk        (clk),
   .en         (en),
   .rst        (rst),
   .din        (din)
   .dout       (dout),
   .data_valid (data_valid)
);

endmodule