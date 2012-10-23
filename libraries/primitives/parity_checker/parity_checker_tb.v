//============================================================================//
//                                                                            //
//      Decimator test bench                                                  //
//                                                                            //
//      Module name: decimator_tb                                             //
//      Desc: runs and tests the decimator module, and provides and interface //
//            to test the module from Python (MyHDL)                          //
//      Date: June 2012                                                       //
//      Developer: Wesley New                                                 //
//      Licence: GNU General Public License ver 3                             //
//      Notes: This only tests the basic functionality of the module, more    //
//             comprehensive testing is done in the python test file          //
//                                                                            //
//============================================================================//

module parity_checker_tb;

   //===================
   // local parameters
   //===================
   localparam LOCAL_DATA_WIDTH = `ifdef DATA_WIDTH  `DATA_WIDTH  `else 8 `endif;
   localparam PARITY_TYPE      = `ifdef PARITY_TYPE `PARITY_TYPE `else 0 `endif;

   //=============
   // local regs
   //=============
   reg                        clk;
   reg [LOCAL_DATA_WIDTH-1:0] data_in;
   reg                        parity_in;
   
   //==============
   // local wires
   //==============
   wire valid;

   //=====================================
   // instance, "(d)esign (u)nder (t)est"
   //=====================================
   parity_checker #(
      .DATA_WIDTH   (`ifdef DATA_WIDTH   `DATA_WIDTH   `else 8 `endif),
      .PARITY_TYPE  (`ifdef PARITY_TYPE  `PARITY_TYPE  `else 0 `endif)
   ) dut (
      .data_in    (data_in),
      .parity_in  (parity_in),
      .valid_out  (valid)
   );

//==============
// MyHDL ports
//==============
`ifdef MYHDL
   // define what myhdl takes over
   // only if we're running myhdl   
   initial begin
      $from_myhdl(clk, en, rst);
      $to_myhdl(out);
   end
`else
   
   //=============
   // initialize
   //=============
   initial
   begin
      clk       = 0;
      parity_in = 1'b1;
      data_in   = 8'hFF;
      #4
      parity_in = 1'b1;
      data_in   = 8'b01010100;
   end

   //====================
   // simulate the clock
   //====================
   always #1
   begin
      clk = ~clk;
   end

   //===============
   // print output
   //===============
   always @(posedge clk)
   begin
      //$display(count);
      $display(valid);
   end
   
   //===============================
   // finish after 100 clock cycles
   //===============================
   initial #10 $finish;

`endif
   
endmodule
