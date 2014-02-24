// Model of FIFO

module fifo(
      clk,
      en,
      rst,
      wrreq,
      rdreq,
      data_in,

      data_out,
      perc_full,
      full,
      empty,
      usedw
   );
   

   //=======================
   //   fifo parameters
   //=======================
   
   parameter DATA_WIDTH = 16;
   parameter FIFO_DEPTH = 1024;
   parameter ADDR_BITS  = 10;
   
   //`define rd_req 0;  // Set this to 0 for rd_ack, 1 for rd_req
   
   //=======================
   //   input ports
   //=======================
   input  clk;
   input  en;
   input  rst;
   input  wrreq;
   input  rdreq;
   input  [DATA_WIDTH-1:0] data_in;
   
   //=======================
   //   output ports
   //=======================
   output [DATA_WIDTH-1:0] data_out;
   output perc_full;
   output full;
   output empty;
   output reg [ADDR_BITS-1:0]  usedw;
   
   //=======================
   //   internal variables
   //=======================
   reg [DATA_WIDTH-1:0] mem [0:FIFO_DEPTH-1];
   reg [ADDR_BITS-1:0] 	rdptr;
   reg [ADDR_BITS-1:0] 	wrptr;
   
//`ifdef rd_req
   reg [DATA_WIDTH-1:0]    data_out;
//`else
   //wire [DATA_WIDTH-1:0]   data_out;
//`endif
   
   integer i;
   
   always @(rst)
      begin
         wrptr <= #1 0;
         rdptr <= #1 0;
         for(i=0;i<FIFO_DEPTH;i=i+1)
            mem[i] <= 0;
     end
   
   always @(posedge clk)
      if(wrreq)
         begin
            wrptr <= wrptr+1;
            mem[wrptr] <= data_in;
         end
     
      else if(rdreq)
         begin
            rdptr <= rdptr+1;
//`ifdef rd_req
            data_out <= mem[rdptr];
//`endif
         end
   
//`ifdef rd_req
//`else
//   assign data_out = mem[rdptr];
//`endif
   
   // Fix these
   //always @(posedge clk)
   //   usedw <= wrptr - rdptr;
   
   //assign empty = (usedw == 0);
   //assign full =  (usedw == FIFO_DEPTH-1);
   
endmodule //fifo
