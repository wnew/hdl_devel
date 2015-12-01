module fifo_tb;

   localparam LOCAL_DATA_WIDTH = 32;
   localparam LOCAL_ADDR_BITS  = 10;

   reg clk;
   reg en;
   reg rst;
   reg wrreq;
   reg rdreq;

   reg  [LOCAL_DATA_WIDTH-1:0] data_in;

   wire [LOCAL_DATA_WIDTH-1:0] data_out;
   wire [LOCAL_ADDR_BITS-1:0]  usedw;

   fifo dut(
      .clk     (clk),
      //.en      (en),
      .rst     (rst),
      .enq     (wrreq),
      .deq     (rdreq),
      .data_in (data_in),

      .data_out  (data_out)
      //.perc_full (perc_full),
      //.full      (full),
      //.empty     (empty),
      //.usedw     (usedw)
   );

   //defparam dut.DATA_WIDTH = 32;
   //defparam dut.FIFO_DEPTH = 16;
   //defparam dut.ADDR_BITS  = 10;

   initial
      begin
         clk = 0;
         rst = 0;
	      en = 1;
         data_in = 32'b1010101010101;
         #1 rst = 1;
         #2 rst = 0;
         
         #3 wrreq = 1;
         #4 wrreq = 0;

         #5 data_in = 32'b101010101010;

         #5 wrreq = 1;
         #6 wrreq = 0;
         
         #7 rdreq = 1;
         #8 rdreq = 0;

         #9 rdreq = 1;
         #10 rdreq = 0;


      end

   // simulate the clock
   always #1
      begin
         clk = ~clk;
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

