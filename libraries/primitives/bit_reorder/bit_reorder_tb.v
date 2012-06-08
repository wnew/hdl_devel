//============================================================================//
//                                                                            //
//      Bit Reorder test bench                                                //
//                                                                            //
//      Module name: bit_reorder_tb                                           //
//      Desc: runs and tests the bit_reorder module, and provides an          //
//            interface to test the module from Python (MyHDL)                //
//      Date: June 2012                                                       //
//      Developer: Wesley New                                                 //
//      Licence: GNU General Public License ver 3                             //
//      Notes: This only tests the basic functionality of the module, more    //
//             comprehensive testing is done in the python test file          //
//                                                                            //
//============================================================================//

module bit_reorder_tb;

   //===================
   // local paramters
   //===================
   localparam LOCAL_DATA_WIDTH = `ifdef DATA_WIDTH `DATA_WIDTH `else 32 `endif;

   //=============
   // local regs
   //=============
   reg [LOCAL_DATA_WIDTH-1:0] in;
   
   //==============
   // local wires
   //==============
   wire [LOCAL_DATA_WIDTH-1:0] out;

   //=====================================
   // instance, "(d)esign (u)nder (t)est"
   //=====================================
   bit_reorder #(
      .ARCHITECTURE (`ifdef ARCHITECTURE `ARCHITECTURE `else "BEHAVIORAL" `endif),
      .DATA_WIDTH   (`ifdef DATA_WIDTH   `DATA_WIDTH   `else 32           `endif)
   ) dut (
      .in  (in), 
      .out (out)
   );

//==============
// MyHDL ports
//==============
`ifdef MYHDL
   // define what myhdl takes over
   // only if we're running myhdl   
   initial begin
      $from_myhdl(in);
      $to_myhdl(out);
   end
`else
   
   //=============
   // initialize
   //=============
   initial
   begin
      $dumpvars;
      in  = 32'b00000000000000000000000000000001;
   end

   //===============
   // print output
   //===============
   always #1
      $display(out);
   
   //===============================
   // finish after 100 clock cycles
   //===============================
   initial #10 $finish;

`endif
   
endmodule
