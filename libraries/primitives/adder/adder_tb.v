//============================================================================//
//                                                                            //
//      Adder test bench                                                      //
//                                                                            //
//      Module name: adder_tb                                                 //
//      Desc: runs and tests the adder module, and provides and               //
//            interface to test the module from Python (MyHDL)                //
//      Date: April 2012                                                      //
//      Developer: Wesley New                                                 //
//      Licence: GNU General Public License ver 3                             //
//      Notes: This only tests the basic functionality of the module, more    //
//             comprehensive testing should be done in the python test file   //
//                                                                            //
//============================================================================//

//TODO: Include functionality to subtract in this module

module adder_tb;

   //===================
   // local parameters
   //===================
   localparam LOCAL_DATA_WIDTH_1 = `ifdef DATA_WIDTH_1 `DATA_WIDTH_1 `else 16 `endif;
   localparam LOCAL_DATA_WIDTH_2 = `ifdef DATA_WIDTH_2 `DATA_WIDTH_2 `else 16 `endif;

   //=============
   // local regs
   //=============
   reg                          clk;
   reg [LOCAL_DATA_WIDTH_1-1:0] data1_i;
   reg [LOCAL_DATA_WIDTH_2-1:0] data2_i;
   
   //==============
   // local wires
   //==============
   `ifdef LOCAL_DATA_WIDTH_1 > LOCAL_DATA_WIDTH_2
   wire [LOCAL_DATA_WIDTH_1:0] data_o;
   `else
   wire [LOCAL_DATA_WIDTH_2:0] data_o;
   `endif

   //=====================================
   // instance, "(d)esign (u)nder (t)est"
   //=====================================
   adder #(
      .DATA_WIDTH_1   (`ifdef DATA_WIDTH_1   `DATA_WIDTH_1   `else 16 `endif),
      .DATA_WIDTH_2   (`ifdef DATA_WIDTH_2   `DATA_WIDTH_2   `else 16 `endif)
   ) dut (
      .clk     (clk),
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
      data1_i = 16'h52F2;
      data2_i = 16'h3671;
      #2
      data2_i = 16'h2234;
      #6
      data1_i = 16'h8929;
      #8
      data1_i = 16'h8712;
      data2_i = 16'h4142;

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
   always @(posedge clk) begin
      $display(data_o);
   end
   
   //===============================
   // finish after 100 clock cycles
   //===============================
   initial #20 $finish;

`endif
   
endmodule
