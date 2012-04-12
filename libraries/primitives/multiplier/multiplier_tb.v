//============================================================================//
//                                                                            //
//      Multiplier test bench                                                 //
//                                                                            //
//      Module name: multiplier_tb                                            //
//      Desc: runs and tests the multiplier module, and provides and          //
//            interface to test the module from Python (MyHDL)                //
//      Date: April 2012                                                      //
//      Developer: Wesley New                                                 //
//      Licence: GNU General Public License ver 3                             //
//      Notes: This only tests the basic functionality of the module, more    //
//             comprehensive testing should be done in the python test file   //
//                                                                            //
//============================================================================//

module multiplier_tb;

   //===================
   // local parameters
   //===================
   localparam LOCAL_DATA_WIDTH_1 = `ifdef DATA_WIDTH_1 `DATA_WIDTH_1 `else 8 `endif;
   localparam LOCAL_DATA_WIDTH_2 = `ifdef DATA_WIDTH_2 `DATA_WIDTH_2 `else 8 `endif;

   //=============
   // local regs
   //=============
   reg clk;
   reg [LOCAL_DATA_WIDTH_1-1:0] data1_i;
   reg [LOCAL_DATA_WIDTH_2-1:0] data2_i;
   
   //==============
   // local wires
   //==============
   wire [LOCAL_DATA_WIDTH_1+LOCAL_DATA_WIDTH_2-1:0] data_o;

   //=====================================
   // instance, "(d)esign (u)nder (t)est"
   //=====================================
   multiplier #(
      .ARCHITECTURE (`ifdef ARCHITECTURE `ARCHITECTURE `else "BEHAVIORAL" `endif),
      .DATA_WIDTH_1 (`ifdef DATA_WIDTH_1 `DATA_WIDTH_1 `else 8            `endif),
      .DATA_WIDTH_2 (`ifdef DATA_WIDTH_2 `DATA_WIDTH_2 `else 8            `endif)
   ) dut (
      .data1_i (data1_i), 
      .data2_i (data2_i), 
      .data_o  (data_o)
   );

//==============
// MyHDL ports
//==============
`ifdef MYHDL
   // define what myhdl takes over
   // only if we're running myhdl   
   initial begin
      $from_myhdl(clk, data1_i, data2_i);
      $to_myhdl(data_o);
   end
`else
   
   //=============
   // initialize
   //=============
   initial
   begin
      $dumpvars;
      clk = 0;
      data1_i = 8'h3;
      data2_i = 8'h2;
      #2
      data2_i = 8'h9;
      #6
      data1_i = 8'h9;
      #8
      data1_i = 8'hFF;
      data2_i = 8'hFF;

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
   always @(posedge clk) $display(data_o);
   
   //===============================
   // finish after 100 clock cycles
   //===============================
   initial #20 $finish;

`endif
   
endmodule
