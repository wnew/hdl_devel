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
      parameter DATA_WIDTH=32
   ) (
      input                   clk,
      input  [3:0]            delay,
      input  [DATA_WIDTH-1:0] din,
      output [DATA_WIDTH-1:0] dout
   );
    
   genvar i;
   generate
      for (i=0;i<DATA_WIDTH;i=i+1)
      begin : gen_delay
         SRL16E
         srl16e(.Q(dout[i]),
         .A0(delay[0]),.A1(delay[1]),.A2(delay[2]),.A3(delay[3]),
         .CE(1),.CLK(clk),.D(din[i]));
      end
   endgenerate
endmodule 
