//============================================================================//
//                                                                            //
//      BRAM wishbone test bench                                              //
//                                                                            //
//      Module name: bram_wb_tb                                               //
//      Desc: runs and tests the bram_wb module, and provides and interface   //
//            to test the module from Python (MyHDL)                          //
//            This uses a dual port bram with one ports connected to the      //
//            wishbone bus and the other to the fabric                        //
//      Date: June 2012                                                       //
//      Developer: Wesley New                                                 //
//      Licence: GNU General Public License ver 3                             //
//      Notes: This only tests the basic functionality of the module, more    //
//             comprehensive testing is done in the python test file          //
//                                                                            //
//============================================================================//

module bram_wb_tb;

   //=====================
   // local wires & regs
   //=====================
   reg         wbs_clk_i;
   reg         wbs_rst_i;
   reg         wbs_cyc_i;
   reg         wbs_stb_i;
   reg         wbs_we_i;
   reg   [3:0] wbs_sel_i;
   reg   [7:0] wbs_adr_i;
   reg  [31:0] wbs_dat_i;
   wire [31:0] wbs_dat_o;
   wire        wbs_ack_o;

   reg         fabric_clk;
   reg         fabric_rst;
   reg         fabric_we;
   reg   [7:0] fabric_addr;
   reg  [31:0] fabric_data_in;
   wire [31:0] fabric_data_out;

   //=====================================
   // instance, "(d)esign (u)nder (t)est"
   //=====================================
   bram_wb #(
      .DATA_WIDTH  (32),
      .ADDR_WIDTH  (8),
      .SLEEP_COUNT (4)
      //.C_BASEADDR (32'h00000000),
      //.C_HIGHADDR (32'h0000FFFF)
   ) dut (
      .fabric_clk      (fabric_clk),
      .fabric_rst      (fabric_rst),
      .fabric_we       (fabric_we),
      .fabric_addr     (fabric_addr),
      .fabric_data_in  (fabric_data_in),
      .fabric_data_out (fabric_data_out),
      
      .wbs_clk_i   (wbs_clk_i),
      .wbs_rst_i   (wbs_rst_i),
      .wbs_cyc_i   (wbs_cyc_i),
      .wbs_stb_i   (wbs_stb_i),
      .wbs_we_i    (wbs_we_i),
      .wbs_adr_i   (wbs_adr_i),
      .wbs_dat_i   (wbs_dat_i),
      .wbs_dat_o   (wbs_dat_o),
      .wbs_ack_o   (wbs_ack_o)
   );

//==============
// MyHDL hooks
//==============
`ifdef MYHDL
   // define what myhdl takes over
   // only if we're running myhdl   
   initial begin
      $from_myhdl(fabric_clk, fabric_data_in, wb_clk_i, wb_rst_i, wb_cyc_i, wb_stb_i, wb_we_i, wb_sel_i, wb_adr_i, wb_dat_i);
      $to_myhdl(wb_dat_o,wb_ack_o,wb_err_o);
   end
`else

   //==============
   // Initialize
   //==============
   initial
      begin
         $dumpvars;

         wbs_clk_i = 0;
         wbs_sel_i = 4'hE;
         wbs_stb_i = 1;
         wbs_cyc_i = 1;
         wbs_we_i  = 1;
         wbs_adr_i = 8'h00;
         wbs_dat_i = 32'hEEEEEEEE;

         #5 
         
         wbs_stb_i = 0;
         wbs_cyc_i = 0;
      
         #5
         
         wbs_adr_i = 8'h01;
         wbs_stb_i = 1;
         wbs_cyc_i = 1;
         wbs_we_i  = 0;
         
         
         #20 $finish;
      end

   //=====================
   // Simulate the Clock
   //=====================
   always #1
      wbs_clk_i = ~wbs_clk_i;

`endif

endmodule
