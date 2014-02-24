//============================================================================//
//                                                                            //
//      Parameterize Delay Line                                               //
//                                                                            //
//      Module name: delay_line                                               //
//      Desc: parameterized delay, using generate statements to create a      //
//            varible length delay of variable width                          //
//      Date: April 2012                                                      //
//      Developer: Wesley New                                                 //
//      Licence: GNU General Public License ver 3                             //
//      Notes:                                                                //
//                                                                            //
//============================================================================//

module delay_line #(
      parameter DATA_WIDTH   = 32,
      parameter DELAY_CYLCES = 1
   ) (
      input                   clk,
      input  [3:0]            delay,
      input  [DATA_WIDTH-1:0] din,
      output [DATA_WIDTH-1:0] dout
   );

   reg [DATA_WIDTH * DELAY_CYCLES:0] delays;
    
   genvar i;
   generate
      for (i = 0; i < DELAY_CYCLES; i = i + 1)
      begin : gen_delay
         assign delays [(DELAY_CYCLES + 3) * i: i(DELAY_CYCLES + 2) * i] = delays [(DELAY_CYCLES + 1) * i: DELAY_CYCLES * i];
      end
   endgenerate
endmodule 
