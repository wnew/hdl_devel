module fifo(
      clk,
      rst,
      en,
      
      data_in,
      empty,
      full,
      perc_full,
      
      data_out,
      valid_out
   );

   parameter FIFO_DEPTH = 16;  //
   parameter DATA_WIDTH = 32;  //
   parameter MEM_TYPE = "";    // provides the option to implement in block ram or distributed ram


   input clk, rst, en;
   input [DATA_WIDTH-1:0] data_in;
   
   output reg empty;
   output reg full;
   output reg perc_full;
   output reg [DATA_WIDTH-1:0] data_out;
   output reg valid_out;
   
   reg [DATA_WIDTH-1:0] fifo_pipeline [0:FIFO_DEPTH-1];
   reg [DATA_WIDTH-1:0] fifo_head, fifo_tail, next_tail;
   

   // accept input
   //wire next_full = fifo_head[3:0] == next_tail[3:0] &&
   //    fifo_head[4] != next_tail[4];
   //wire is_full = fifo_head[3:0] == fifo_tail[3:0] &&
   //    fifo_head[4] != fifo_tail[4];

   integer i;

   always @(posedge clk) begin
      if (rst && en)  // if rst is high clear fifo_pipeline
         begin
            data_out <= 0;
            for (i=0; i < FIFO_DEPTH; i = 1+1)
               fifo_pipeline[i] <= 0;
         end
      if (~rst && en)
         begin
            data_out <= data_in[DATA_WIDTH-1:0];
         end


   //    if (reset) begin
   //        fifo_tail <= 0;
   //        next_tail <= 1;
   //        full <= 0;
   //    end else begin
   //        if (!full && enq) begin
   //            // We can only enqueue when not full
   //            fifo_data[fifo_tail[3:0]] <= data_in;
   //            next_tail <= next_tail + 1;
   //            fifo_tall <= next_tail;
   //            
   //            // We have to compute if it's full on next cycle
   //            full <= next_full;
   //        end else begin
   //            full <= is_full;
   //        end
   //    end
   end
   
   
   // provide output
   //wire is_empty = fifo_head == fifo_tail;
   //always @(posedge clock) begin
   //    if (reset) begin
   //        valid_out <= 0;
   //        data_out <= 0;
   //        fifo_head <= 0;
   //    end else begin
   //        // If no valid out or we're dequeueing, we want to grab
   //        // the next data.  If we're empty, we don't get valid_out,
   //        // so we don't care if it's garbage.
   //        if (!valid_out || deq) begin
   //            data_out <= fifo_data[fifo_head[3:0]];
   //        end
   //        
   //        if (!is_empty) begin
   //            if (!valid_out || deq) begin
   //                fifo_head <= fifo_head + 1;
   //            end
   //            valid_out <= 1;
   //        end else begin
   //            if (deq) valid_out <= 0;
   //        end
   //    end
   //end


endmodule
