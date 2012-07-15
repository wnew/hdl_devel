//============================================================================//
//                                                                            //
//      EPB WB Bridge test bench                                              //
//                                                                            //
//      Module name: epb_wb_tb                                                //
//      Desc: tests the epb_wb_bridge and wbs_arbiter but connecting 3        //
//            wishbone slaves and checking the full data path                 //
//      Date: July 2012                                                       //
//      Developer: Wesley New                                                 //
//      Licence: GNU General Public License ver 3                             //
//      Notes:                                                                //
//                                                                            //
//============================================================================//
`timescale 1ns/1ns
`include "include/build_parameters.v"
`include "include/mem_layout.v"
`include "../../controllers/bram_wb/bram_wb.v"
`include "../../controllers/sw_reg/sw_reg_wr.v"
`include "../../primitives/bram/bram_sync_dp.v"
`include "../../../base_designs/roach2/wbs_arbiter/wbs_arbiter.v"
`include "../../../base_designs/roach2/wbs_arbiter/timeout.v"
`include "../../../base_designs/roach2/epb_wb_bridge/epb_wb_bridge.v"
`include "../../../base_designs/roach2/sys_block/sys_block.v"

module epb_wb_tb;

   localparam ARCHITECTURE   = "BEHAVIORAL";
   localparam BUS_DATA_WIDTH = 32;  // 8, 16, 32, 64
   localparam BUS_ADDR_WIDTH = 32;  // 4, 8, 16, 32
   localparam NUM_SLAVES     = 3;
   localparam SLAVE_BASE     = {`BRAM_BASE_ADDR, `REG_BASE_ADDR, `SYS_BLOCK_BASE_ADDR};
   localparam SLAVE_HIGH     = {`BRAM_HIGH_ADDR, `REG_HIGH_ADDR, `SYS_BLOCK_HIGH_ADDR};
   localparam SYS_BLOCK_SLI  = 0;
   localparam REG_SLI        = 1;
   localparam BRAM_SLI       = 2;
   localparam BYTE_EN_WIDTH  = BUS_DATA_WIDTH / 8;

   //=====================
   // local wires & regs
   //=====================
   reg                       epb_clk;
   reg                       epb_cs_n;
   reg                       epb_oe_n;
   reg                       epb_r_w_n;
   reg  [3:0]                epb_be_n;
   reg  [5:29]               epb_addr;
   reg  [0:BUS_DATA_WIDTH-1] epb_data_i;
   wire [0:BUS_DATA_WIDTH-1] epb_data_o;
   wire                      epb_data_oe_n;
   wire                      epb_rdy;
   wire                      epb_doen;

   reg                       wb_clk_i;
   reg                       wb_rst_i;
              
   wire                      wbm_cyc_i;
   wire                      wbm_stb_i;
   wire                      wbm_we_i;
   wire                [3:0] wbm_sel_i;
   wire [BUS_ADDR_WIDTH-1:0] wbm_adr_i;
   wire [BUS_DATA_WIDTH-1:0] wbm_dat_i;
   wire [BUS_DATA_WIDTH-1:0] wbm_dat_o;
   wire                      wbm_ack_o;
   wire                      wbm_err_o;
   wire                      wbm_int_o;

   wire                                 wbs_cyc_o;
   wire                                 wbs_stb_o;
   wire                                 wbs_we_o;
   wire                           [3:0] wbs_sel_o;
   wire            [BUS_ADDR_WIDTH-1:0] wbs_adr_o;
   wire            [BUS_DATA_WIDTH-1:0] wbs_dat_o;
   wire [NUM_SLAVES*BUS_DATA_WIDTH-1:0] wbs_dat_i;
   wire                [NUM_SLAVES-1:0] wbs_ack_i;
   wire                [NUM_SLAVES-1:0] wbs_err_i;
   wire                [NUM_SLAVES-1:0] wbs_int_i;

   wire                      fabric_clk;
   wire [BUS_DATA_WIDTH-1:0] fabric_data_in;

   //=====================================
   // instance, "(d)esign (u)nder (t)est"
   //=====================================
   sys_block #(
      .DEV_BASE_ADDR  (`SYS_BLOCK_BASE_ADDR),
      .DEV_HIGH_ADDR  (`SYS_BLOCK_HIGH_ADDR),
      .BUS_DATA_WIDTH (BUS_DATA_WIDTH),
      .BUS_ADDR_WIDTH (BUS_ADDR_WIDTH),
      .BOARD_ID       (32'h3456789A),
      .REV_MAJ        (32'hAFAFAFAF),
      .REV_MIN        (32'hBFBCADEB),
      .REV_RCS        (32'hDEADBEEF)

   ) dut_sys_block (
      .wb_clk_i  (wb_clk_i),
      .wb_rst_i  (wb_rst_i),
      .wbs_cyc_i (wbs_cyc_o),
      .wbs_stb_i (wbs_stb_o),
      .wbs_we_i  (wbs_we_o),
      .wbs_sel_i (wbs_sel_o),
      .wbs_adr_i (wbs_adr_o),
      .wbs_dat_i (wbs_dat_o),
      .wbs_dat_o (wbs_dat_i[(SYS_BLOCK_SLI+1)*32-1:(SYS_BLOCK_SLI)*32]),
      .wbs_ack_o (wbs_ack_i[SYS_BLOCK_SLI]),
      .wbs_err_o (wbs_err_i[SYS_BLOCK_SLI]),
      .wbs_int_o (wbs_int_i[SYS_BLOCK_SLI])
   );
   
   //=====================================
   // instance, "(d)esign (u)nder (t)est"
   //=====================================
   sw_reg_wr #(
      .DEV_BASE_ADDR  (`REG_BASE_ADDR),
      .DEV_HIGH_ADDR  (`REG_HIGH_ADDR),
      .BUS_DATA_WIDTH (BUS_DATA_WIDTH),
      .BUS_ADDR_WIDTH (BUS_ADDR_WIDTH)
   ) dut_sw_reg_wr (
      .wb_clk_i  (wb_clk_i),
      .wb_rst_i  (wb_rst_i),
      .wbs_cyc_i (wbs_cyc_o),
      .wbs_stb_i (wbs_stb_o),
      .wbs_we_i  (wbs_we_o),
      .wbs_sel_i (wbs_sel_o),
      .wbs_adr_i (wbs_adr_o),
      .wbs_dat_i (wbs_dat_o),
      .wbs_dat_o (wbs_dat_i[(REG_SLI+1)*32-1:(REG_SLI)*32]),
      .wbs_ack_o (wbs_ack_i[REG_SLI]),
      .wbs_err_o (wbs_err_i[REG_SLI]),
      .wbs_int_o (wbs_int_i[REG_SLI])
   );


   //=====================================
   // instance, "(d)esign (u)nder (t)est"
   //=====================================
   bram_wb #(
      .BUS_DATA_WIDTH (BUS_DATA_WIDTH),
      .BUS_ADDR_WIDTH (BUS_ADDR_WIDTH),
      .SLEEP_COUNT    (4),
      .DEV_BASE_ADDR  (`BRAM_BASE_ADDR),
      .DEV_HIGH_ADDR  (`BRAM_HIGH_ADDR)
   ) dut_bram_wb (
      .fabric_clk      (),
      .fabric_rst      (),
      .fabric_we       (),
      .fabric_addr     (),
      .fabric_data_in  (),
      .fabric_data_out (),
      
      .wbs_clk_i (wb_clk_i),
      .wbs_rst_i (wb_rst_i),
      .wbs_cyc_i (wbs_cyc_o),
      .wbs_stb_i (wbs_stb_o),
      .wbs_we_i  (wbs_we_o),
      .wbs_sel_i (wbs_sel_o),
      .wbs_adr_i (wbs_adr_o),
      .wbs_dat_i (wbs_dat_o),
      .wbs_dat_o (wbs_dat_i[(BRAM_SLI+1)*32-1:(BRAM_SLI)*32]),
      .wbs_ack_o (wbs_ack_i[BRAM_SLI])
      //.wbs_err_o (wbs_err_i[BRAM_SLI]),
      //.wbs_int_o (wbs_int_i[BRAM_SLI])
   );


   wbs_arbiter #(
      .ARCHITECTURE   (ARCHITECTURE), 
      .BUS_DATA_WIDTH (BUS_DATA_WIDTH),  // default is 32. but can be 8, 16, 32, 64
      .BUS_ADDR_WIDTH (BUS_ADDR_WIDTH),   // default is 8.  but can be 4, 8, 16, 32
      .NUM_SLAVES     (NUM_SLAVES),
      .SLAVE_ADDR     (SLAVE_BASE),
      .SLAVE_HIGH     (SLAVE_HIGH),
      .TIMEOUT        (10)
   ) dut_wbs_arbiter (
      .wb_clk_i (wb_clk_i),
      .wb_rst_i (wb_rst_i),

      .wbm_cyc_i (wbm_cyc_i),
      .wbm_stb_i (wbm_stb_i),
      .wbm_we_i  (wbm_we_i),
      .wbm_sel_i (wbm_sel_i),
      .wbm_adr_i (wbm_adr_i),
      .wbm_dat_i (wbm_dat_i),
      .wbm_dat_o (wbm_dat_o),
      .wbm_ack_o (wbm_ack_o),
      .wbm_err_o (wbm_err_o),

      .wbs_cyc_o (wbs_cyc_o),
      .wbs_stb_o (wbs_stb_o),
      .wbs_we_o  (wbs_we_o),
      .wbs_sel_o (wbs_sel_o),
      .wbs_adr_o (wbs_adr_o),
      .wbs_dat_o (wbs_dat_o),
      .wbs_dat_i (wbs_dat_i),
      .wbs_ack_i (wbs_ack_i)
   );

   //=====================================
   // instance, "(d)esign (u)nder (t)est"
   //=====================================
   epb_wb_bridge #(
      .ARCHITECTURE ("BEHAVIORAL")
   ) dut_epb_wb_bridge (
      .wb_clk_i      (wb_clk_i),
      .wb_rst_i      (wb_rst_i),
      .wbm_cyc_o     (wbm_cyc_i),
      .wbm_stb_o     (wbm_stb_i),
      .wbm_we_o      (wbm_we_i),
      .wbm_sel_o     (wbm_sel_i),
      .wbm_adr_o     (wbm_adr_i),
      .wbm_dat_o     (wbm_dat_i),
      .wbm_dat_i     (wbm_dat_o),
      .wbm_ack_i     (wbm_ack_o),
      .wbm_err_i     (wbm_err_o),
      .wbm_int_i     (wbm_int_o),

      .epb_clk       (epb_clk),
      .epb_cs_n      (epb_cs_n),
      .epb_oe_n      (epb_oe_n),
      .epb_r_w_n     (epb_r_w_n),
      .epb_be_n      (epb_be_n),
      .epb_addr      (epb_addr),
      .epb_data_i    (epb_data_i),
      .epb_data_o    (epb_data_o),
      .epb_data_oe_n (epb_data_oe_n),
      .epb_rdy       (epb_rdy),
      .epb_doen      (epb_doen)
   );

   integer i;

   //==============
   // Initialize
   //==============
   initial
      begin
         $dumpvars;

         $display("Start Simulation");

         epb_clk   = 0;
         wb_clk_i  = 0;
         wb_rst_i  = 1;
         #3
         wb_rst_i  = 0;

         // write to bus
         epb_r_w_n  = 1'b0;
         epb_cs_n   = 1'b1; //??
         epb_be_n   = 4'h0;
         epb_oe_n   = 1'b0; //??
         epb_addr   = 32'h8;
         epb_data_i = 32'h01010101;
         #3
         epb_cs_n   = 1'b0;
         
         #15

         // read from bus
         epb_r_w_n  = 1'b1;
         epb_cs_n   = 1'b1; //??
         epb_be_n   = 4'h0;
         epb_oe_n   = 1'b0; //??
         epb_addr   = 32'h1;
         #3
         epb_cs_n   = 1'b0;
         #5

         // read from bus
         epb_r_w_n  = 1'b1;
         epb_cs_n   = 1'b1; //??
         epb_be_n   = 4'h0;
         epb_oe_n   = 1'b0; //??
         epb_addr   = 32'h2;
         #3
         epb_cs_n   = 1'b0;
         #5

         // read from bus
         epb_r_w_n  = 1'b1;
         epb_cs_n   = 1'b1; //??
         epb_be_n   = 4'h0;
         epb_oe_n   = 1'b0; //??
         epb_addr   = 32'h3;
         #3
         epb_cs_n   = 1'b0;
         #5
         // read from bus
         epb_r_w_n  = 1'b1;
         epb_cs_n   = 1'b1; //??
         epb_be_n   = 4'h0;
         epb_oe_n   = 1'b0; //??
         epb_addr   = 32'h4;
         #3
         epb_cs_n   = 1'b0;
         #5
         // read from bus
         epb_r_w_n  = 1'b1;
         epb_cs_n   = 1'b1; //??
         epb_be_n   = 4'h0;
         epb_oe_n   = 1'b0; //??
         epb_addr   = 32'h8;
         #3
         epb_cs_n   = 1'b0;
         #5
         
         // write to bus
         epb_r_w_n  = 1'b0;
         epb_cs_n   = 1'b1; //??
         epb_be_n   = 4'h0;
         epb_oe_n   = 1'b0; //??
         epb_addr   = 32'h20;
         epb_data_i = 32'hFF11FF11;
         #3
         epb_cs_n   = 1'b0;
         
         #5
         // read from bus
         epb_r_w_n  = 1'b1;
         epb_cs_n   = 1'b1; //??
         epb_be_n   = 4'h0;
         epb_oe_n   = 1'b0; //??
         epb_addr   = 32'h20;
         #3
         epb_cs_n   = 1'b0;

         #25
         
         $display("End Simulation");

         $finish;
      end

   //=====================
   // Simulate the Clock
   //=====================
   always #1 begin
      wb_clk_i = ~wb_clk_i;
      epb_clk  = ~epb_clk;
   end

endmodule
