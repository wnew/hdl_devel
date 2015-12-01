module fifo_tb;

   localparam LOCAL_DATA_WIDTH = 32;
   localparam LOCAL_ADDR_BITS  = 10;

   reg clk;
   reg en;
   reg rst;
   reg wr_en;
   reg rd_en;

   reg  [LOCAL_DATA_WIDTH-1:0] data_in;

   wire [LOCAL_DATA_WIDTH-1:0] data_out;
   wire [LOCAL_ADDR_BITS-1:0]  usedw;

   sync_fifo # (
      .DATA_WIDTH (32),
      .ADDR_WIDTH (8)
   ) dut (
      .clk     (clk),
      .rst     (rst),
      .wr_en   (wr_en),
      .rd_en   (rd_en),
      .data_in (data_in),

      .data_out  (data_out),
      //.perc_full (perc_full),
      .full      (full),
      .empty     (empty)
      //.usedw     (usedw)
   );

   initial
      begin
         clk = 0;
         rst = 0;
	      en = 1;
         data_in = 32'b1010101010101;
         #1 rst = 1;
         #2 rst = 0;
         
         #3 wr_en = 1;
         #4 wr_en = 0;

         #5 data_in = 32'b101010101010;

         #5 wr_en = 1;
         #6 wr_en = 0;
         
         #7 rd_en = 1;
         #8 rd_en = 0;

         //#9 rd_en = 1;
         //#10 rd_en = 0;


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

