//============================================================================//
//                                                                            //
//      Software Reg test bench                                               //
//                                                                            //
//      Module name: sw_reg_tb                                                //
//      Desc: runs and tests the sw_reg module, and provides and interface    //
//            to test the module from Python (MyHDL)                          //
//      Date: Dec 2011                                                        //
//      Developer: Wesley New                                                 //
//      Licence: GNU General Public License ver 3                             //
//      Notes: This only tests the basic functionality of the module, more    //
//             comprehensive testing is done in the python test file          //
//                                                                            //
//============================================================================//

module sw_reg_r_tb;

   //=====================
   // local wires & regs
   //=====================
   reg         wbs_clk_i;
   reg         wbs_rst_i;
   reg         wbs_cyc_i;
   reg         wbs_stb_i;
   reg         wbs_we_i;
   reg   [3:0] wbs_sel_i;
   reg  [31:0] wbs_adr_i;
   reg  [31:0] wbs_dat_i;
   wire [31:0] wbs_dat_o;
   wire        wbs_ack_o;
   wire        wbs_err_o;

   reg         fabric_clk;
   reg [31:0]  fabric_data_in;

   //=====================================
   // instance, "(d)esign (u)nder (t)est"
   //=====================================
   sw_reg_r #(
      .C_BASEADDR (32'h00000000),
      .C_HIGHADDR (32'h0000FFFF)
   ) dut (
      .wbs_clk_i   (wbs_clk_i),
      .wbs_rst_i   (wbs_rst_i),
      .wbs_cyc_i   (wbs_cyc_i),
      .wbs_stb_i   (wbs_stb_i),
      .wbs_we_i    (wbs_we_i),
      
      .wbs_adr_i   (wbs_adr_i),
      .wbs_dat_i   (wbs_dat_i),
      .wbs_dat_o   (wbs_dat_o),
      .wbs_ack_o   (wbs_ack_o),
      .wbs_err_o   (wbs_err_o),
   
      .fabric_clk     (fabric_clk),
      .fabric_data_in (fabric_data_in)
   );

//==============
// MyHDL hooks
//==============
`ifdef MYHDL
   // define what myhdl takes over
   // only if we're running myhdl   
   initial begin
      $from_myhdl(fabric_clk, fabric_data_in, wbs_clk_i, wbs_rst_i, wbs_cyc_i, wbs_stb_i, wbs_we_i, wbs_sel_i, wbs_adr_i, wbs_dat_i);
      $to_myhdl(wbs_dat_o,wbs_ack_o,wbs_err_o);
   end
`else

   //==============
   // Initialize
   //==============
   initial
      begin
         $dumpvars;
	 fabric_clk     = 0;
         fabric_data_in = 32'hEEEEFFFF;

         wbs_we_i  = 0;
         
         wbs_rst_i = 1;
         #1
         wbs_rst_i = 0;
         wbs_clk_i = 0;
         //wbs_sel_i = 4'hE;
         //wbs_stb_i = 1;
         //wbs_cyc_i = 1;
         //wbs_adr_i = 32'h00000000;
         //wbs_dat_i = 32'hEEEEEEEE;

         //#5 
         //
         //wbs_stb_i = 0;
         //wbs_cyc_i = 0;
      
         //#5
         //
         //wbs_adr_i = 32'h00000000;
         //wbs_stb_i = 1;
         //wbs_cyc_i = 1;
         //
         #10 $finish;
      end

   //=====================
   // Simulate the Clock
   //=====================
   always #1
   begin
      wbs_clk_i   = ~wbs_clk_i;
      fabric_clk = ~fabric_clk;
   end

`endif

endmodule
