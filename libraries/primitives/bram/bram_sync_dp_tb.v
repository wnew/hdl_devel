//============================================================================//
//                                                                            //
//      BRAM dual port test bench                                             //
//                                                                            //
//      Module name: bram_sync_dp_tb                                          //
//      Desc: runs and tests the BRAM dual port module, and provides and      //
//            interface to test the module from Python (MyHDL)                //
//      Date: Dec 2011                                                        //
//      Developer: Wesley New                                                 //
//      Licence: GNU General Public License ver 3                             //
//      Notes: This only tests the basic functionality of the module, more    //
//             comprehensive testing is done in the python test file          //
//                                                                            //
//============================================================================//

module bram_sync_dp_tb;

   //===================
   // local parameters
   //===================
   localparam LOCAL_DATA_WIDTH = 8;
   localparam LOCAL_ADDR_WIDTH = 4;

   //=============
   // local regs
   //=============
   reg                        clk;
   reg                        rst;
   reg                        en;
   reg                        a_wr;
   reg [LOCAL_ADDR_WIDTH-1:0] a_addr;
   reg [LOCAL_DATA_WIDTH-1:0] a_data_in;
   reg                        b_wr;
   reg [LOCAL_ADDR_WIDTH-1:0] b_addr;
   reg [LOCAL_DATA_WIDTH-1:0] b_data_in;

   //==============
   // local wires 
   //==============
   wire [LOCAL_DATA_WIDTH-1:0] a_data_out;
   wire [LOCAL_DATA_WIDTH-1:0] b_data_out;

   
   //======================================
   // instance, "(d)esign (u)nder (t)est"
   //======================================
   bram_sync_dp #(
      .DATA_WIDTH (`ifdef DATA_WIDTH `DATA_WIDTH `else LOCAL_DATA_WIDTH `endif),
      .ADDR_WIDTH (`ifdef ADDR_WIDTH `ADDR_WIDTH `else LOCAL_ADDR_WIDTH `endif)
   ) dut (

      .rst        (rst),
      .en         (en),

      .a_clk      (clk),
      .a_wr       (a_wr),
      .a_addr     (a_addr),
      .a_data_in  (a_data_in),
      .a_data_out (a_data_out),
      
      .b_clk      (clk),
      .b_wr       (b_wr),
      .b_addr     (b_addr),
      .b_data_in  (b_data_in),
      .b_data_out (b_data_out)
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
         $dumpvars;
         clk    = 0;
         rst    = 0;
         en     = 1;
         a_addr = 4'b0010; 
         a_data_in = 32'b1010101010101;
         a_wr = 1;
         #5 
         a_addr = 4'b0010;
         a_data_in = 32'b0101010101010;
         #5 
         a_addr = 4'b0001;
         a_data_in = 32'b0101010111010;
         #5 
         a_addr = 6;
         a_data_in = 32'b0101010111010;
      end

   //=====================
   // simulate the clock
   //=====================
   always #1
      begin
         clk = ~clk;
      end

   //===============
   // print output
   //===============
   always
      #1 $display(a_data_out);

   //===================
   // finish condition 
   //===================
   // 2 time units = 1 clock cycle
   initial #30 $finish;

`endif

endmodule

