//============================================================================//
//                                                                            //
//      Accumulator test bench                                                //
//                                                                            //
//      Module name: accumulator_tb                                           //
//      Desc: runs and tests the accumulator module                           //
//      Date: Nov 2012                                                        //
//      Developer: Wesley New                                                 //
//      Licence: GNU General Public License ver 3                             //
//      Notes: This only tests the basic functionality of the module, more    //
//             comprehensive testing is done in the python test file          //
//                                                                            //
//============================================================================//

module accumulator_tb;

   //===================
   // local parameters
   //===================
   localparam LOCAL_INPUT_DATA_WIDTH  = `ifdef INPUT_DATA_WIDTH  `INPUT_DATA_WIDTH  `else 8 `endif;
   localparam LOCAL_OUTPUT_DATA_WIDTH = `ifdef OUTPUT_DATA_WIDTH `OUTPUT_DATA_WIDTH `else 8 `endif;

   //=============
   // local regs
   //=============
   reg clk;
   reg en;
   reg rst;
   reg [LOCAL_INPUT_DATA_WIDTH-1:0] data_in;
   
   //==============
   // local wires
   //==============
   wire data_valid;
   wire [LOCAL_OUTPUT_DATA_WIDTH-1:0] data_out;

   //=====================================
   // instance, "(d)esign (u)nder (t)est"
   //=====================================
   accumulator #(
      .INPUT_DATA_WIDTH  (`ifdef INPUT_DATA_WIDTH  `INPUT_DATA_WIDTH  `else 8 `endif),
      .OUTPUT_DATA_WIDTH (`ifdef OUTPUT_DATA_WIDTH `OUTPUT_DATA_WIDTH `else 8 `endif)
   ) dut (
      .clk        (clk),
      .en         (en),
      .rst        (rst),
      .data_in    (data_in),
      .data_out   (data_out)
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
   
   wire [31:0] count;   

   counter #(
      .ARCHITECTURE ("BEHAVIORAL"),
      .DATA_WIDTH   (32),
      .COUNT_FROM   (0),
      .COUNT_TO     (65000),
      .STEP         (1)
   ) counter_inst (
      .clk (clk),
      .en  (1),
      .rst (rst),
      .out (count)
   );
   

   //=============
   // initialize
   //=============
   initial
   begin
      $dumpvars;
      clk     = 1;
      en      = 1;
      rst     = 1;
      data_in = count;
      #4
      rst     = 0;
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
      data_in = count;
      $display(data_out);
   end
   
   //===============================
   // finish after 100 clock cycles
   //===============================
   initial #20 $finish;

`endif
   
endmodule
