from myhdl import *
#import sys
#sys.path.append("../roach2/")
#sys.path.append("../../libraries/")
import clk_infrastructure.clk_infrastructure as clk_infr
import epb_infrastructure.epb_infrastructure as epb_infr
import epb_wb_bridge.epb_wb_bridge           as epb_wb_bridge
import reset_block.reset_block               as reset_blk
import sys_block.sys_block                   as sys_blk
import wbs_arbiter.wbs_arbiter               as wbs_arb       
import counter.counter                       as counter
import iic_infrastructure.iic_infrastructure as iic_infr
import kat_adc.iic_controller                as iic_cont
import kat_adc.spi_controller                as spi_cont
import kat_adc.kat_adc                       as kat_adc
import bram_wb.bram_wb                       as bram_wb
import sw_reg.sw_reg_r                       as sw_reg_r

def toplevel(
    #=========
    # Clocks
    #=========
    sys_clk_n,
    sys_clk_p,
    aux_clk_n,
    aux_clk_p,

    #========
    # GPIOs
    #========
    gpio,     #[15:0]

    #===================
    # EPB bus from PPC
    #===================
    ppc_per_clk,  
    ppc_paddr,    #[5:29]
    ppc_pcsn,     #[1:0]
    ppc_pdata,    #[0:31]
    ppc_pben,     #[0:3]
    ppc_poen,
    ppc_pwrn,
    ppc_pblastn,
    ppc_prdy,
    ppc_doen,

    #==============
    # ADC 0 Ports
    #==============
    # clock
    kat_adc0_clk_n,
    kat_adc0_clk_p,
    kat_adc0_sync_n,
    kat_adc0_sync_p,
    kat_adc0_overrange_n,
    kat_adc0_overrange_p,
    # data
    kat_adc0_di_d_n, #[7:0]
    kat_adc0_di_d_p, #[7:0]
    kat_adc0_di_n,   #[7:0]
    kat_adc0_di_p,   #[7:0]
    kat_adc0_dq_d_n, #[7:0]
    kat_adc0_dq_d_p, #[7:0]
    kat_adc0_dq_n,   #[7:0]
    kat_adc0_dq_p,   #[7:0]
    # spi interface
    kat_adc0_spi_clk,
    kat_adc0_spi_data,
    kat_adc0_spi_cs,

    # iic interface
    kat_adc0_iic_sda,
    kat_adc0_iic_scl,

    v6_irqn
):

   NUM_SLAVES         = 5
   SYS_BLOCK_SLI      = 1
   SW_REG_SLI         = 2
   SPI_CONTROLLER_SLI = 3
   IIC_CONTROLLER_SLI = 4
   BRAM_WB_SLI        = 5

   (sys_rst,     sys_clk,      sys_clk90, 
   sys_clk180,   sys_clk270,   sys_clk_lock, 
   power_on_rst, sys_clk2x,    sys_clk2x90, 
   sys_clk2x180, sys_clk2x270, aux_clk, 
   aux_clk90,    aux_clk180,   aux_clk270, 
   aux_clk2x,    aux_clk2x90,  aux_clk2x180, 
   aux_clk2x270, idelay_rdy) = [Signal(bool(0)) for i in range(20)]

   (wbm_clk_i, wbm_rst_i,  wbm_cyc_o, 
   wbm_stb_o,  wbm_we_o,   wbm_sel_o, 
   wbm_adr_o,  wbm_dat_o,  wbm_dat_i, 
   wbm_ack_i,  wbm_err_i,  epb_clk, 
   epb_data_i, epb_data_o, epb_data_oe_n) = [Signal(bool(0)) for i in range(15)]

   clk_inf = clk_infr.clk_infrastructure_wrapper(
      block_name      = "1", 
      sys_clk_n       = sys_clk_n, 
      sys_clk_p       = sys_clk_p, 
      sys_clk         = sys_clk, 
      sys_clk90       = sys_clk90, 
      sys_clk180      = sys_clk180, 
      sys_clk270      = sys_clk270, 
      sys_clk_lock    = sys_clk_lock, 
      op_power_on_rst = power_on_rst, 
      sys_clk2x       = sys_clk2x, 
      sys_clk2x90     = sys_clk2x90, 
      sys_clk2x180    = sys_clk2x180, 
      sys_clk2x270    = sys_clk2x270, 
      epb_clk_in      = ppc_per_clk, 
      epb_clk         = epb_clk, 
      aux_clk_n       = aux_clk_n, 
      aux_clk_p       = aux_clk_p, 
      aux_clk         = aux_clk, 
      aux_clk90       = aux_clk90, 
      aux_clk180      = aux_clk180, 
      aux_clk270      = aux_clk270, 
      aux_clk2x       = aux_clk2x, 
      aux_clk2x90     = aux_clk2x90, 
      aux_clk2x180    = aux_clk2x180, 
      aux_clk2x270    = aux_clk2x270, 
      idelay_rst      = power_on_rst, 
      idelay_rdy      = idelay_rdy
   )

   # maybe change clock to slower epb clock
   rst_blk = reset_blk.reset_block_wrapper(
      block_name  = "1",
      clk         = sys_clk,
      async_rst_i = power_on_rst,
      rst_i       = power_on_rst,
      rst_o       = sys_rst
   )


   wbm_clk_i = epb_clk

   epb_wb_brdg = epb_wb_bridge.epb_wb_bridge_wrapper(
      block_name    = "1",
      wb_clk_i      = wbm_clk_i,
      wb_rst_i      = wbm_rst_i,
      wb_cyc_o      = wbm_cyc_o,
      wb_stb_o      = wbm_stb_o,
      wb_we_o       = wbm_we_o,
      wb_sel_o      = wbm_sel_o,
      wb_adr_o      = wbm_adr_o,
      wb_dat_o      = wbm_dat_o,
      wb_dat_i      = wbm_dat_i,
      wb_ack_i      = wbm_ack_i,
      wb_err_i      = wbm_err_i,
      epb_clk       = epb_clk,
      epb_cs_n      = ppc_pcsn,
      epb_oe_n      = ppc_poen,
      epb_r_w_n     = ppc_pwrn,
      epb_be_n      = ppc_pben,
      epb_addr      = ppc_paddr,
      epb_data_o    = epb_data_o,
      epb_data_i    = epb_data_i,
      epb_data_oe_n = epb_data_oe_n,
      epb_rdy       = ppc_prdy,
      epb_doen      = ppc_doen
   )

   wbs_we_o,  wbs_sel_o, wbs_adr_o, wbs_dat_o = [Signal(bool(0)) for i in range(4)]
   #wbs_cyc_o, wbs_stb_o, wbs_ack_i, wbs_err_i = [Signal(intbv(0)[NUM_SLAVES:]) for i in range(4)] 
   wbs_cyc_o, wbs_stb_o, wbs_ack_i, wbs_err_i, = [Signal(intbv(0)[32:]) for i in range(4)] 
   wbs_dat_i = Signal(intbv(0)[32*NUM_SLAVES:]) 


   epb_in = epb_infr.epb_infrastructure_wrapper(
      block_name    = "1", 
      epb_data_buf  = ppc_pdata, 
      epb_data_oe_n = epb_data_oe_n, 
      epb_data_i    = epb_data_o, 
      epb_data_o    = epb_data_i
   )

   wbs_ar = wbs_arb.wbs_arbiter_wrapper(
      block_name = "1",
      wb_clk_i   = wbm_clk_i,
      wb_rst_i   = wbm_rst_i,
      wbm_cyc_i  = wbm_cyc_o,
      wbm_stb_i  = wbm_stb_o,
      wbm_we_i   = wbm_we_o,
      wbm_sel_i  = wbm_sel_o,
      wbm_adr_i  = wbm_adr_o,
      wbm_dat_i  = wbm_dat_o,
      wbm_dat_o  = wbm_dat_i,
      wbm_ack_o  = wbm_ack_i,
      wbm_err_o  = wbm_err_i,
      wbs_cyc_o  = wbs_cyc_o,
      wbs_stb_o  = wbs_stb_o,
      wbs_we_o   = wbs_we_o,
      wbs_sel_o  = wbs_sel_o,
      wbs_adr_o  = wbs_adr_o,
      wbs_dat_o  = wbs_dat_o,
      wbs_dat_i  = wbs_dat_i,
      wbs_ack_i  = wbs_ack_i
   )

   sys_bl = sys_blk.sys_block_wrapper(
      block_name  = "1",
      wb_clk_i    = wbm_clk_i,
      wb_rst_i    = wbm_rst_i,
      wbs_cyc_i   = wbs_cyc_o,
      wbs_stb_i   = wbs_stb_o,
      wbs_we_i    = wbs_we_o,
      wbs_sel_i   = wbs_sel_o,
      wbs_adr_i   = wbs_adr_o,
      wbs_dat_i   = wbs_dat_o,
      wbs_dat_o   = wbs_dat_i,
      wbs_ack_o   = wbs_ack_i,
      wbs_err_o   = wbs_err_i
   )

   (iic_sda_i, iic_sda_o, iic_sda_t,
   iic_scl_i,  iic_scl_o, iic_scl_t) = [Signal(bool(0)) for i in range(6)] 
   
   (kat_adc0_reset,     kat_adc0_clk,        kat_adc0_clk90_out, 
   kat_adc0_clk180_out, kat_adc0_clk270_out, kat_adc0_mmcm_locked, 
   kat_adc0_mmcm_reset, kat_adc0_psclk,      kat_adc0_psen,
   kat_adc0_psincdec,   kat_adc0_psdone) = [Signal(bool(0)) for i in range(11)]
   
   iic_inf = iic_infr.iic_infrastructure_wrapper(
      block_name = "1",
      sda_i = iic_sda_o,
      sda_o = iic_sda_i,
      sda_t = iic_sda_t,
      scl_i = iic_scl_o,
      scl_o = iic_scl_i,
      scl_t = iic_scl_t,
      sda   = kat_adc0_iic_sda,
      scl   = kat_adc0_iic_scl
   )

   kat_adc_iic_controller = iic_cont.iic_controller_wrapper(
      block_name = "1",
      wbs_clk_i = wbm_clk_i, 
      wbs_rst_i = wbm_rst_i, 
      wbs_cyc_i = wbs_cyc_o,
      wbs_stb_i = wbs_stb_o,
      wbs_we_i  = wbs_we_o, 
      wbs_sel_i = wbs_sel_o, 
      wbs_adr_i = wbs_adr_o, 
      wbs_dat_i = wbs_dat_o, 
      wbs_dat_o = wbs_dat_i,
      wbs_ack_o = wbs_ack_i,
      
      xfer_done = 0,
      
      sda_i = iic_sda_i,
      sda_o = iic_sda_o,
      sda_t = iic_sda_t,
      scl_i = iic_scl_i,
      scl_o = iic_scl_o,
      scl_t = iic_scl_t,

      app_clk     = kat_adc0_clk,
      gain_load   = 1,
      gain_value  = 1
   )
   
   (kat_adc0_adc_reset,
   kat_adc0_mmcm_reset,
   kat_adc0_psclk,
   kat_adc0_psen,
   kat_adc0_psincdec,
   kat_adc0_psdone,
   kat_adc0_clk) = [Signal(bool(0)) for i in range(7)] 

   kat_adc_spi_controller = spi_cont.spi_controller_wrapper(
      block_name = "1",
      wb_clk_i = wbm_clk_i, 
      wb_rst_i = wbm_rst_i, 
      wb_cyc_i = wbs_cyc_o,
      wb_stb_i = wbs_stb_o,
      wb_we_i  = wbs_we_o, 
      wb_sel_i = wbs_sel_o, 
      wb_adr_i = wbs_adr_o, 
      wb_dat_i = wbs_dat_o, 
      wb_dat_o = wbs_dat_i,
      wb_ack_o = wbs_ack_i,

      adc0_adc3wire_clk    = kat_adc0_spi_clk,
      adc0_adc3wire_data   = kat_adc0_spi_data,
      adc0_adc3wire_strobe = kat_adc0_spi_cs,
      adc0_adc_reset       = kat_adc0_adc_reset,
      adc0_mmcm_reset      = kat_adc0_mmcm_reset,
      adc0_psclk           = kat_adc0_psclk,
      adc0_psen            = kat_adc0_psen,
      adc0_psincdec        = kat_adc0_psincdec,
      adc0_psdone          = kat_adc0_psdone,
      adc0_clk             = kat_adc0_clk,

      adc1_adc3wire_clk    = Signal(bool(0)), #kat_adc1_spi_clk,
      adc1_adc3wire_data   = Signal(bool(0)), #kat_adc1_spi_data,
      adc1_adc3wire_strobe = Signal(bool(0)), #kat_adc1_spi_cs,
      adc1_adc_reset       = Signal(bool(0)), #kat_adc1_adc0_reset,
      adc1_mmcm_reset      = Signal(bool(0)), #kat_adc1_mmcm_reset,
      adc1_psclk           = Signal(bool(0)), #kat_adc1_psclk,
      adc1_psen            = Signal(bool(0)), #kat_adc1_psen,
      adc1_psincdec        = Signal(bool(0)), #kat_adc1_psincdec,
      adc1_psdone          = Signal(bool(0)), #kat_adc1_psdone,
      adc1_clk             = Signal(bool(0)), #kat_adc1_clk
   )

   user_datai0 = Signal(intbv(0)[8:])

   kat_adc0 = kat_adc.kat_adc_wrapper(
      block_name = "1",
      #===================
      # external signals
      #===================
      adc_clk_p       = kat_adc0_clk_p,
      adc_clk_n       = kat_adc0_clk_n,
      adc_sync_p      = kat_adc0_sync_p,  
      adc_sync_n      = kat_adc0_sync_n,
      adc_overrange_p = kat_adc0_overrange_p,
      adc_overrange_n = kat_adc0_overrange_n,
      adc_rst         = Signal(bool(0)),
      adc_powerdown   = Signal(bool(0)),
      adc_di_d_p      = kat_adc0_di_d_p,
      adc_di_d_n      = kat_adc0_di_d_n,
      adc_di_p        = kat_adc0_di_p,
      adc_di_n        = kat_adc0_di_n,
      adc_dq_d_p      = kat_adc0_dq_d_p,
      adc_dq_d_n      = kat_adc0_dq_d_n,
      adc_dq_p        = kat_adc0_dq_p,
      adc_dq_n        = kat_adc0_dq_n,

      #====================
      # user fabric ports
      #====================
      user_datai0      = user_datai0,
      user_datai1      = Signal(bool(0)),
      user_datai2      = Signal(bool(0)),
      user_datai3      = Signal(bool(0)),
      user_dataq0      = Signal(bool(0)),
      user_dataq1      = Signal(bool(0)),
      user_dataq2      = Signal(bool(0)),
      user_dataq3      = Signal(bool(0)),
      user_sync0       = Signal(bool(0)),
      user_sync1       = Signal(bool(0)),
      user_sync2       = Signal(bool(0)),
      user_sync3       = Signal(bool(0)),
      user_outofrange0 = Signal(bool(0)),
      user_outofrange1 = Signal(bool(0)),
      user_data_valid  = Signal(bool(0)),

      ctrl_reset       = kat_adc0_adc_reset,
      ctrl_clk_in      = kat_adc0_clk,
      ctrl_clk_out     = kat_adc0_clk,
      ctrl_clk90_out   = kat_adc0_clk90_out,
      ctrl_clk180_out  = kat_adc0_clk180_out,
      ctrl_clk270_out  = kat_adc0_clk270_out,
      ctrl_mmcm_locked = kat_adc0_mmcm_locked,
      mmcm_reset       = kat_adc0_mmcm_reset,
      mmcm_psclk       = kat_adc0_psclk,
      mmcm_psen        = kat_adc0_psen,
      mmcm_psincdec    = kat_adc0_psincdec,
      mmcm_psdone      = kat_adc0_psdone     
   )

   count_out = Signal(intbv(0)[32:])

   #bram = bram_wb.bram_wb()
   bram_wrap = bram_wb.bram_wb_wrapper(
      block_name = "1",
      #===============
      # fabric ports
      #===============
      fabric_clk      = kat_adc0_clk,
      fabric_rst      = sys_rst,
      fabric_we       = 1,
      fabric_addr     = count_out,
      fabric_data_in  = user_datai0,
      fabric_data_out = Signal(bool(0)),

      #===========
      # wb ports
      #===========
      wbs_clk_i = wbm_clk_i,
      wbs_rst_i = wbm_rst_i,
      wbs_we_i  = wbs_we_o,
      wbs_cyc_i = wbs_cyc_o,
      wbs_stb_i = wbs_stb_o,
      wbs_sel_i = wbs_sel_o,
      wbs_adr_i = wbs_adr_o,
      wbs_dat_i = wbs_dat_o,
      wbs_dat_o = wbs_dat_i,
      wbs_ack_o = wbs_ack_i,
     
      BUS_BASE_ADDR   = 0,
      BUS_HIGH_ADDR   = 32,
      BUS_DATA_WIDTH  = 32,
      BUS_ADDR_WIDTH  = 16,
      BUS_BE_WIDTH    = 4
   )

   #sr = sw_reg_r.sw_reg_r()
   swreg = sw_reg_r.sw_reg_r_wrapper(
      fabric_clk     = kat_adc0_clk,
      fabric_data_in = count_out,

      wbs_clk_i = wbm_clk_i,
      wbs_rst_i = wbm_rst_i,
      wbs_cyc_i = wbs_cyc_o,
      wbs_stb_i = wbs_stb_o,
      wbs_we_i  = wbs_we_o,
      wbs_sel_i = wbs_sel_o,
      wbs_adr_i = wbs_adr_o,
      wbs_dat_i = wbs_dat_o,
      wbs_dat_o = wbs_dat_i,
      wbs_ack_o = wbs_ack_i,
      wbs_err_o = wbs_err_i,

      module_name    = 1,
      BUS_BASE_ADDR  = 0,
      BUS_HIGH_ADDR  = 32,
      BUS_DATA_WIDTH = 32,
      BUS_ADDR_WIDTH = 1,
      BYTE_EN_WIDTH  = 4
   )

   cntr = counter.counter_wrapper(
      block_name = "1", 
      clk        = sys_clk, 
      en         = 1, 
      rst        = 0, 
      out        = count_out,
      DATA_WIDTH = 32,
      COUNT_FROM = 0,
      COUNT_TO   = "32'h10000000",
      STEP       = 1
   )

   @always_comb
   def logic():
      gpio.next = count_out[32:16]

   return clk_inf, rst_blk, epb_wb_brdg, epb_in, wbs_ar, sys_bl, cntr, kat_adc0, kat_adc_spi_controller, kat_adc_iic_controller, iic_inf, bram_wrap, swreg, logic



def convert():
   (sys_clk_n, sys_clk_p, 
   aux_clk_n,  aux_clk_p) = [Signal(bool(0)) for i in range(4)]

   (ppc_per_clk, ppc_poen, ppc_pwrn, 
   ppc_pblastn,  ppc_prdy, ppc_doen, 
   v6_irqn)    = [Signal(bool(0)) for i in range(7)]

   ppc_paddr = Signal(intbv(0)[29:5])   #[5:29]
   ppc_pcsn  = Signal(intbv(0)[1:])     #[1:0]
   ppc_pben  = Signal(intbv(0)[3:])     #[0:3]

   ppc_pdata = TristateSignal(intbv(0)[31:])   #[0:31]
   gpio = Signal(intbv(0)[16:])

   (kat_adc0_clk_n,
   kat_adc0_clk_p,
   kat_adc0_sync_n,
   kat_adc0_sync_p,
   kat_adc0_overrange_n,
   kat_adc0_overrange_p) = [Signal(bool(0)) for i in range(6)]

   # data 
   (kat_adc0_di_d_n, #[7:0]
   kat_adc0_di_d_p,  #[7:0]
   kat_adc0_di_n,    #[7:0]
   kat_adc0_di_p,    #[7:0]
   kat_adc0_dq_d_n,  #[7:0]
   kat_adc0_dq_d_p,  #[7:0]
   kat_adc0_dq_n,    #[7:0]
   kat_adc0_dq_p) = [Signal(intbv(0)[8:]) for i in range(8)]   #[7:0]

   (kat_adc0_spi_clk, kat_adc0_spi_dat, kat_adc0_spi_cs,
   kat_adc0_iic_sda,  kat_adc0_iic_scl) = [Signal(bool(0)) for i in range(5)]

   toVerilog(
      toplevel,
      sys_clk_n,
      sys_clk_p,
      aux_clk_n,
      aux_clk_p,
      gpio,
      ppc_per_clk,
      ppc_paddr,
      ppc_pcsn,
      ppc_pdata,
      ppc_pben,
      ppc_poen,
      ppc_pwrn,
      ppc_pblastn,
      ppc_prdy,
      ppc_doen,
      kat_adc0_clk_n,
      kat_adc0_clk_p,
      kat_adc0_sync_n,
      kat_adc0_sync_p,
      kat_adc0_overrange_n,
      kat_adc0_overrange_p,
      kat_adc0_di_d_n,
      kat_adc0_di_d_p,
      kat_adc0_di_n,
      kat_adc0_di_p,
      kat_adc0_dq_d_n,
      kat_adc0_dq_d_p,
      kat_adc0_dq_n,
      kat_adc0_dq_p,
      kat_adc0_spi_clk,
      kat_adc0_spi_dat,
      kat_adc0_spi_cs,
      kat_adc0_iic_sda,
      kat_adc0_iic_scl,
      v6_irqn
   )


if __name__ == "__main__":
   convert()

