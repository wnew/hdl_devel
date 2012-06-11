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

module decimator_tb;

   //===================
   // local parameters
   //===================
   localparam LOCAL_DATA_WIDTH = `ifdef DATA_WIDTH `DATA_WIDTH `else 8 `endif;

   //=============
   // local regs
   //=============
   reg clk;
   reg en;
   reg rst;
   reg [LOCAL_DATA_WIDTH-1:0] data_in;
   
   //==============
   // local wires
   //==============
   wire data_valid;
   wire [LOCAL_DATA_WIDTH-1:0] data_out;

   //=====================================
   // instance, "(d)esign (u)nder (t)est"
   //=====================================
   decimator #(
      .ARCHITECTURE (`ifdef ARCHITECTURE `ARCHITECTURE `else "BEHAVIORAL" `endif),
      .DATA_WIDTH   (`ifdef DATA_WIDTH   `DATA_WIDTH   `else 8            `endif)
   ) dut (
      .clk1_i     (clk),
      .clk2_i     (clk),
      .en         (en),
      .rst        (rst),
      .data_in    (data_in),
      .data_valid (data_valid),
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
      .rst (0),
      .out (count)
   );
   

   //=============
   // initialize
   //=============
   initial
   begin
      clk     = 0;
      en      = 1;
      rst     = 0;
      data_in = count;
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
      data_in = count;
      $display(data_out);
      $display(data_valid);
   end
   
   //===============================
   // finish after 100 clock cycles
   //===============================
   initial #200 $finish;

`endif
   
endmodule
