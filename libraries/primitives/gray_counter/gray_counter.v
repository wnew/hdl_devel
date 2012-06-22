//==========================================
// Function : Code Gray counter.
// Coder    : Alex Claros F.
// Date     : 15/May/2005.
//=======================================

module gray_counter #(
      parameter DATA_WIDTH = 4
   ) (
      input wire clk,
      input wire en,  //Count enable.
      input wire rst, //Count reset.
   
      output reg [DATA_WIDTH-1:0] count_out  //'Gray' code count output.
   );

   /////////Internal connections & variables///////
   reg [DATA_WIDTH-1:0] binary_count;

   always @ (posedge clk) begin
      if (rst) begin
         binary_count <= {DATA_WIDTH{1'b 0}} + 1;  //Gray count begins @ '1' with
         count_out    <= {DATA_WIDTH{1'b 0}};      // first 'en'.
      end
      else if (en) begin
         binary_count <=  binary_count + 1;
         count_out    <= {binary_count[DATA_WIDTH-1],
                          binary_count[DATA_WIDTH-2:0] ^ binary_count[DATA_WIDTH-1:1]};
      end
   end
    
endmodule
