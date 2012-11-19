//============================================================================//
//                                                                            //
//      Parameterize Accumulator                                              //
//                                                                            //
//      Module name: accumulator                                              //
//      Desc: parameterized accumulator                                       //
//      Date: Nov 2012                                                        //
//      Developer: Wesley New                                                 //
//      Licence: GNU General Public License ver 3                             //
//      Notes:                                                                //
//                                                                            //
//============================================================================//

module accumulator #(
      //=============
      // Parameters
      //=============
      parameter INPUT_DATA_WIDTH   = 32,
      parameter OUTPUT_DATA_WIDTH  = 32
   ) (
      //==============
      // Input Ports
      //==============
      input                        clk,
      input                        en,
      input                        rst,
      input [INPUT_DATA_WIDTH-1:0] data_in,

      //===============
      // Input Ports
      //===============
      output [OUTPUT_DATA_WIDTH-1:0] data_out
   );

   reg [OUTPUT_DATA_WIDTH-1:0] tmp;

   always @(posedge clk)
   begin
      if (en)
      begin
         if (`ifdef ACTIVE_LOW_RST !rst `else rst `endif)
         begin
            tmp <= {OUTPUT_DATA_WIDTH{1'b0}};
         end
         else
         begin
            tmp <= tmp + data_in;
         end
      end
   end
   assign data_out = tmp;

endmodule
