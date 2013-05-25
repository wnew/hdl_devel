//============================================================================//
//                                                                            //
//      Parameterize multiplier                                               //
//                                                                            //
//      Module name: multiplier                                               //
//      Desc: parameterized multiplier module                                 //
//      Date: Mar 2012                                                        //
//      Developer: Kaushal Buch                                               //
//      Licence: GNU General Public License ver 3                             //
//      Notes:                                                                //
//                                                                            //
//============================================================================//

module multiplier #(
      //=============================
      // Top level block parameters
      //=============================
      parameter DATA_WIDTH_1 = 16,        // number of input bits (multiplier)
      parameter DATA_WIDTH_2 = 16         // number of input bits (multiplicand)
   ) (
      //==============
      // Input Ports
      //==============
      input wire [DATA_WIDTH_1-1:0] data1_i,
      input wire [DATA_WIDTH_2-1:0] data2_i,
      //===============
      // Output Ports
      //===============
      output [(DATA_WIDTH_1 + DATA_WIDTH_2) -1:0] data_o
   );

   assign data_o = data1_i * data2_i;

endmodule
