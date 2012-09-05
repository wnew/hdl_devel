/*Logic to convert binary numbers into Gray coded binary numbers is implemented in the following Verilog Code.
*/



module gray2bin #(
      parameter DATA_WIDTH = 32
   ) (
      input  [DATA_WIDTH-1:0] gray_in,
      output [DATA_WIDTH-1:0] binary_out
   );
   
   // gen vars
   genvar i;

   // Generate according to implementation
   generate 
      for (i=0; i<DATA_WIDTH; i=i+1)
      begin
         assign binary_out[i] = ^ gray_in[DATA_WIDTH-1:i];
      end
   endgenerate

endmodule
