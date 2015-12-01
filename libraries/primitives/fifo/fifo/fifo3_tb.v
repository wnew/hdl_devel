module fifo_tb;

   localparam LOCAL_DATA_WIDTH = 8;
   localparam LOCAL_ADDR_BITS  = 10;

   reg clk;
   reg en;
   reg rst;
   reg wrreq;
   reg rdreq;

   reg  [LOCAL_DATA_WIDTH-1:0] data_in;

   wire [LOCAL_DATA_WIDTH-1:0] data_out;
   wire [LOCAL_ADDR_BITS-1:0]  usedw;

   sync_fifo dut(
      .clk     (clk),
      //.en      (en),
      .reset     (rst),
      .wr_en   (wrreq),
      .rd_en   (rdreq),
      .din (data_in),

      .dout  (data_out),
      //.perc_full (perc_full),
      .full      (full),
      .empty     (empty)
      //.usedw     (usedw)
   );

   //defparam dut.DATA_WIDTH = 32;
   //defparam dut.FIFO_DEPTH = 16;
   //defparam dut.ADDR_BITS  = 10;

   initial
      begin
         $dumpvars;
         
         clk = 0;
         rst = 0;
	      en = 1;
         //data_in = 32'b1010101010101;
         data_in = 1;
         #1 rst = 1;
         #1 rst = 0;
         
         #3 wrreq = 1;
         #3 wrreq = 0;

         #10 wrreq = 1;
         #10 wrreq = 0;
         
         #15 rdreq = 1;
         #15 rdreq = 0;

         #20 rdreq = 1;
         #20 rdreq = 0;

      end

   // simulate the clock
   always #1
      begin
         clk = ~clk;
         data_in = data_in + 1;
      end

   //always #40
   //   begin
   //      rst = ~rst;
   //   end

   // print the output
   always @(posedge clk) $display(data_out);
  
   // run for 30 time units = 15 clock cycles
   initial #100 $finish;

endmodule

