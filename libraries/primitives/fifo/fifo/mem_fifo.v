//============================================================================//
//                                                                            //
//      Syncronous FIFO                                                       //
//                                                                            //
//      Module name: sync_fifo                                                //
//      Desc: parameterized, syncronous FIFO                                  //
//      Date: Dec 2011                                                        //
//      Developer: Wesley New                                                 //
//      Licence: GNU General Public License ver 3                             //
//      Notes: Developed from a combiniation of fifo implmentations           //
//             Uses the dual port BRAM  module                                //
//                                                                            //
//============================================================================//

module sync_fifo # (
      //=================
      // FIFO parameters
      //==================
      parameter DATA_WIDTH = 32,
      parameter ADDR_WIDTH = 8,
      parameter RAM_DEPTH  = (1 << ADDR_WIDTH)
   ) (
      //===================
      // IO Port
      //===================
      input                       clk,        // Clock input
      input                       rst,        // Active high reset
      input                       rd_en,      // Data input
      input                       wr_en,      // Read enable
      input      [DATA_WIDTH-1:0] data_in,    // Write Enabe
      output reg [DATA_WIDTH-1:0] data_out,   // Data Output
      output                      full,       // FIFO full
      output                      empty       // FIFO empty
   );    
 
   //=====================
   // Internal variables
   //=====================
   reg  [ADDR_WIDTH-1:0] wr_pointer;
   reg  [ADDR_WIDTH-1:0] rd_pointer;
   reg  [ADDR_WIDTH  :0] status_cnt;
   wire [DATA_WIDTH-1:0] data_ram;
   
   //======================
   //Variable assignments
   //======================
   assign full = (status_cnt == (RAM_DEPTH-1));
   assign empty = (status_cnt == 0);
   
   //================
   // Write pointer
   //================
   always @ (posedge clk or posedge rst)
   begin : WRITE_POINTER
      if (rst) begin
         wr_pointer <= 0;
      end else if (wr_en) begin
         wr_pointer <= wr_pointer + 1;
      end
   end
   
   //===============
   // Read pointer
   //===============
   always @ (posedge clk or posedge rst)
   begin : READ_POINTER
      if (rst) begin
         rd_pointer <= 0;
      end else if (rd_en) begin
         rd_pointer <= rd_pointer + 1;
      end
   end
   
   //============
   // Read data 
   //============
   always  @ (posedge clk or posedge rst)
   begin : READ_DATA
      if (rst)
      begin
         data_out <= 0;
      end
      else
      if (rd_en)
      begin
         data_out <= data_ram;
      end
   end
   
   //================
   // Status update 
   //================
   always @ (posedge clk or posedge rst)
   begin : STATUS_COUNTER
      if (rst)
      begin
         status_cnt <= 0;
      end
      else 
      // Read but no write.
      if (rd_en && !wr_en && (status_cnt != 0))
      begin
         status_cnt <= status_cnt - 1;
      end
      else
      // Write but no read.
      if (wr_en && !rd_en && (status_cnt != RAM_DEPTH))
      begin
         status_cnt <= status_cnt + 1;
      end
   end 
   
   //===============================
   // dual port bram instantiation
   //===============================
   bram_sync_dp #(
         .DATA_WIDTH (DATA_WIDTH),
         .ADDR_WIDTH (ADDR_WIDTH)
      ) bram (
         .a_clk      (clk),
         .a_wr       (wr_en),
         .a_addr     (wr_pointer),
         .a_data_in  (data_in),
         .a_data_out (),
         .b_clk      (clk),
         .b_wr       (rd_en),
         .b_addr     (rd_pointer),
         .b_data_in  (),
         .b_data_out (data_ram)
   );

endmodule
