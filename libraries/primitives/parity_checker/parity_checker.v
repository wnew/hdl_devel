//============================================================================//
//                                                                            //
//      Parameterize Decimator                                                //
//                                                                            //
//      Module name: decimator                                                //
//      Desc: parameterized decimator, current implementation decimates only  //
//            whole factors                                                   //
//      Date: June 2012                                                       //
//      Developer: Wesley New                                                 //
//      Licence: GNU General Public License ver 3                             //
//      Notes:                                                                //
//                                                                            //
//============================================================================//

module parity_checker #(
      //=============
      // Parameters
      //=============
      parameter DATA_WIDTH  = 32,
      parameter PARITY_TYPE = 0   // 0 - Even Parity, 1 - Odd Parity
   ) (
      //==============
      // Input Ports
      //==============
      input  [DATA_WIDTH-1:0] data_in,
      input                   parity_in,

      //===============
      // Input Ports
      //===============
      output reg              valid_out
   );


   always @(*)
   begin
      valid_out = PARITY_TYPE ? !(^data_in[DATA_WIDTH-1:0] == parity_in) : (^data_in[DATA_WIDTH-1:0] == parity_in);
   end

endmodule
