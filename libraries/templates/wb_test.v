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

module wb_test;

   localparam BUS_DATA_WIDTH       = 32;  // 8, 16, 32, 64
   localparam BUS_ADDR_WIDTH       = 8;   // 4, 8, 16, 32
   localparam SYS_BLOCK_BASE_ADDR  = 32'h00;
   localparam SYS_BLOCK_HIGH_ADDR  = 32'h08;
   localparam REG_BASE_ADDR        = 32'h09;
   localparam REG_HIGH_ADDR        = 32'h09;
   localparam BYTE_EN_WIDTH        = BUS_DATA_WIDTH / 8;

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

   reg                       fabric_clk;
   wire [BUS_DATA_WIDTH-1:0] fabric_data_in;

   //=====================================
   // instance, "(d)esign (u)nder (t)est"
   //=====================================
   sys_block #(
      .DEV_BASE_ADDR  (SYS_BLOCK_BASE_ADDR),
      .DEV_HIGH_ADDR  (SYS_BLOCK_HIGH_ADDR),
      .BUS_DATA_WIDTH (BUS_DATA_WIDTH),
      .BUS_ADDR_WIDTH (BUS_ADDR_WIDTH)
   ) dut_sys_block (
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
      .wbs_err_o (wbs_err_o),
      .wbs_int_o (wbs_int_o)
   );
   
   //=====================================
   // instance, "(d)esign (u)nder (t)est"
   //=====================================
   sw_reg_wr #(
      .DEV_BASE_ADDR  (REG_BASE_ADDR),
      .DEV_HIGH_ADDR  (REG_HIGH_ADDR),
      .BUS_DATA_WIDTH (BUS_DATA_WIDTH),
      .BUS_ADDR_WIDTH (BUS_ADDR_WIDTH)
   ) dut_sw_reg_wr (
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
      .wbs_err_o (wbs_err_o),
      .wbs_int_o (wbs_int_o)
   );

   integer i;

   //==============
   // Initialize
   //==============
   initial
      begin
         $dumpvars;

         wb_clk_i  = 0;
         wb_rst_i  = 1;

         // write to the devices
         for (i=0; i < 16; i=i+1) begin
            #2
            wbs_dat_i = 32'hEEEEEEEE+i;
            wb_rst_i  = 0;
            wbs_adr_i = 8'h00+i;
            wbs_sel_i = 4'hF;
            wbs_stb_i = 1;
            wbs_cyc_i = 1;
            wbs_we_i  = 1;
         end
         #1 

         wb_rst_i  = 0;

         #5

         wbs_stb_i = 0;
         wbs_cyc_i = 0;

         #5
         
         // read from devices
         for (i=0; i < 16; i=i+1) begin
            wbs_adr_i = 8'h00+i;
            wbs_stb_i = 1;
            wbs_cyc_i = 1;
            wbs_we_i  = 0;
            #6
            wbs_stb_i = 0;
         end

         if (wbs_dat_o == 32'hEE00EE00)
            $display("Write with byte enable pass");
            $display("Read pass");

         $finish;
      end

   //=====================
   // Simulate the Clock
   //=====================
   always #1
      wb_clk_i = ~wb_clk_i;

endmodule
