//============================================================================//
//                                                                            //
//      Wishbone slave template test bench                                    //
//                                                                            //
//      Module name: bram_wb_tb                                               //
//      Desc: runs and tests the wbs_template module,                         //
//      Date: Jule 2012                                                       //
//      Developer: Wesley New                                                 //
//      Licence: GNU General Public License ver 3                             //
//      Notes:                                                                //
//                                                                            //
//============================================================================//

module sw_reg_wr_tb;

   localparam BUS_DATA_WIDTH = 32;  // 8, 16, 32, 64
   localparam BUS_ADDR_WIDTH = 8;   // 4, 8, 16, 32
   localparam DEV_BASE_ADDR  = 32'h0;
   localparam DEV_HIGH_ADDR  = 8'h0F;
   localparam BYTE_EN_WIDTH  = BUS_DATA_WIDTH / 8;

   //=====================
   // local wires & regs
   //=====================
   reg                       wb_clk_i;
   reg                       wb_rst_i;
   reg                       wbs_cyc_i;
   reg                       wbs_stb_i;
   reg                       wbs_we_i;
   reg   [BYTE_EN_WIDTH-1:0] wbs_sel_i;
   reg  [BUS_ADDR_WIDTH-1:0] wbs_adr_i;
   reg  [BUS_DATA_WIDTH-1:0] wbs_dat_i;
   wire [BUS_DATA_WIDTH-1:0] wbs_dat_o;
   wire                      wbs_ack_o;
   wire                      wbs_int_o;

   reg                       fabric_clk_i;
   wire [BUS_DATA_WIDTH-1:0] fabric_data_o;

   //=====================================
   // instance, "(d)esign (u)nder (t)est"
   //=====================================
   sw_reg_wr #(
      .DEV_BASE_ADDR  (DEV_BASE_ADDR),
      .DEV_HIGH_ADDR  (DEV_HIGH_ADDR),
      .BUS_DATA_WIDTH (BUS_DATA_WIDTH),
      .BUS_ADDR_WIDTH (BUS_ADDR_WIDTH)
   ) dut (
      .fabric_clk_i  (fabric_clk_i),
      .fabric_data_o (fabric_data_o),
      
      .wb_clk_i  (wb_clk_i),
      .wb_rst_i  (wb_rst_i),
      .wbs_cyc_i (wbs_cyc_i),
      .wbs_stb_i (wbs_stb_i),
      .wbs_we_i  (wbs_we_i),
      .wbs_sel_i (wbs_sel_i),
      .wbs_adr_i (wbs_adr_i),
      .wbs_dat_i (wbs_dat_i),
      .wbs_dat_o (wbs_dat_o),
      .wbs_ack_o (wbs_ack_o),
      .wbs_int_o (wbs_int_o)
   );

//==============
// MyHDL hooks
//==============
`ifdef MYHDL
   // define what myhdl takes over
   // only if we're running myhdl   
   initial begin
      $from_myhdl(fabric_clk_i, fabric_data_o, wb_clk_i, wb_rst_i, wb_cyc_i, wb_stb_i, wb_we_i, wb_sel_i, wb_adr_i, wb_dat_i);
      $to_myhdl(wb_dat_o,wb_ack_o,wb_err_o);
   end
`else

   //==============
   // Initialize
   //==============
   initial
      begin
         $dumpvars;

         fabric_clk_i = 0;

         // write to device 
         wb_clk_i  = 0;
         wb_rst_i  = 1;
         wbs_sel_i = 4'hA;
         wbs_stb_i = 1;
         wbs_cyc_i = 1;
         wbs_we_i  = 1;
         wbs_adr_i = 8'h00;
         wbs_dat_i = 32'hEEEEEEEE;

         #2 

         wb_rst_i  = 0;

         #5

         wbs_stb_i = 0;
         wbs_cyc_i = 0;

         #5
         
         // read from device
         wbs_adr_i = 8'h00;
         wbs_stb_i = 1;
         wbs_cyc_i = 1;
         wbs_we_i  = 0;

         #5
         
         wbs_stb_i = 0;

         if (wbs_dat_o == 32'hEE00EE00) begin
            $display("PASSES: Wishbone write with byte enable");
            $display("PASSED: Wishbone read");
         end
         else
            $display("Failed: Wishbone read or write");
         if (fabric_data_o == 32'hEE00EE00)
            $display("PASSED: Fabric read");
         else
            $display("Failed: Fabric read");

         #20 $finish;
      end

   //=====================
   // Simulate the Clock
   //=====================
   always #1
   begin
      wb_clk_i     = ~wb_clk_i;
      fabric_clk_i = ~fabric_clk_i;
   end

`endif

endmodule
