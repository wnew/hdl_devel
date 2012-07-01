from myhdl import * 

def spi_controller_wrapper (block_name,

      #========
      # Ports
      #========
      wb_clk_i,
      wb_rst_i,
      wb_we_i,
      wb_cyc_i,
      wb_stb_i,
      wb_sel_i,
      wb_adr_i,
      wb_dat_i,
      wb_dat_o,
      wb_ack_o,
      adc0_adc3wire_clk,
      adc0_adc3wire_data,
      adc0_adc3wire_strobe,
      adc0_adc_reset,
      adc0_mmcm_reset,
      adc0_psclk,
      adc0_psen,
      adc0_psincdec,
      adc0_psdone,
      adc0_clk,
      adc1_adc3wire_clk,
      adc1_adc3wire_data,
      adc1_adc3wire_strobe,
      adc1_adc_reset,
      adc1_mmcm_reset,
      adc1_psclk,
      adc1_psen,
      adc1_psincdec,
      adc1_psdone,
      adc1_clk,
      
      #=============
      # Parameters
      #=============
      C_BASEADDR    = 0,
      C_HIGHADDR    = 0,
      C_WB_AWIDTH   = 0,
      C_WB_DWIDTH   = 0,
      C_FAMILY      = 0,
      INTERLEAVED_0 = 0,
      INTERLEAVED_1 = 0,
      AUTOCONFIG_0  = 0,
      AUTOCONFIG_1  = 0
   ):

   #===================
   # Simulation Logic
   #===================
   @always(wb_clk_i)
   def logic():
      pass

   return logic

#===============================
# spi_controller Instantiation
#===============================
spi_controller_wrapper.verilog_code = \
"""
spi_controller
#(
   .C_BASEADDR    ($C_BASEADDR),
   .C_HIGHADDR    ($C_HIGHADDR),
   .C_WB_AWIDTH   ($C_WB_AWIDTH),
   .C_WB_DWIDTH   ($C_WB_DWIDTH),
   .C_FAMILY      ($C_FAMILY),
   .INTERLEAVED_0 ($INTERLEAVED_0),
   .INTERLEAVED_1 ($INTERLEAVED_1),
   .AUTOCONFIG_0  ($AUTOCONFIG_0),
   .AUTOCONFIG_1  ($AUTOCONFIG_1)
) spi_controller_$block_name (
   .wb_clk_i             ($wb_clk_i),
   .wb_rst_i             ($wb_rst_i),
   .wb_we_i              ($wb_we_i),
   .wb_cyc_i             ($wb_cyc_i),
   .wb_stb_i             ($wb_stb_i),
   .wb_sel_i             ($wb_sel_i),
   .wb_adr_i             ($wb_adr_i),
   .wb_dat_i             ($wb_dat_i),
   .wb_dat_o             ($wb_dat_o),
   .wb_ack_o             ($wb_ack_o),
   .adc0_adc3wire_clk    ($adc0_adc3wire_clk),
   .adc0_adc3wire_data   ($adc0_adc3wire_data),
   .adc0_adc3wire_strobe ($adc0_adc3wire_strobe),
   .adc0_adc_reset       ($adc0_adc_reset),
   .adc0_mmcm_reset      ($adc0_mmcm_reset),
   .adc0_psclk           ($adc0_psclk),
   .adc0_psen            ($adc0_psen),
   .adc0_psincdec        ($adc0_psincdec),
   .adc0_psdone          ($adc0_psdone),
   .adc0_clk             ($adc0_clk),
   .adc1_adc3wire_clk    ($adc1_adc3wire_clk),
   .adc1_adc3wire_data   ($adc1_adc3wire_data),
   .adc1_adc3wire_strobe ($adc1_adc3wire_strobe),
   .adc1_adc_reset       ($adc1_adc_reset),
   .adc1_mmcm_reset      ($adc1_mmcm_reset),
   .adc1_psclk           ($adc1_psclk),
   .adc1_psen            ($adc1_psen),
   .adc1_psincdec        ($adc1_psincdec),
   .adc1_psdone          ($adc1_psdone),
   .adc1_clk             ($adc1_clk)
);
"""

#=======================================
# For testing of conversion to verilog
#=======================================
def convert():

   wb_clk_i, wb_rst_i, wb_we_i, wb_cyc_i, wb_stb_i, wb_sel_i, wb_adr_i, wb_dat_i, wb_dat_o, wb_ack_o, adc0_adc3wire_clk, adc0_adc3wire_data, adc0_adc3wire_strobe, adc0_adc_reset, adc0_mmcm_reset, adc0_psclk, adc0_psen, adc0_psincdec, adc0_psdone, adc0_clk, adc1_adc3wire_clk, adc1_adc3wire_data, adc1_adc3wire_strobe, adc1_adc_reset, adc1_mmcm_reset, adc1_psclk, adc1_psen, adc1_psincdec, adc1_psdone, adc1_clk = [Signal(bool(0)) for i in range(30)]

   toVerilog(spi_controller_wrapper, block_name="inst", wb_clk_i = wb_clk_i, wb_rst_i = wb_rst_i, wb_we_i = wb_we_i, wb_cyc_i = wb_cyc_i, wb_stb_i = wb_stb_i, wb_sel_i = wb_sel_i, wb_adr_i = wb_adr_i, wb_dat_i = wb_dat_i, wb_dat_o = wb_dat_o, wb_ack_o = wb_ack_o, adc0_adc3wire_clk = adc0_adc3wire_clk, adc0_adc3wire_data = adc0_adc3wire_data, adc0_adc3wire_strobe = adc0_adc3wire_strobe, adc0_adc_reset = adc0_adc_reset, adc0_mmcm_reset = adc0_mmcm_reset, adc0_psclk = adc0_psclk, adc0_psen = adc0_psen, adc0_psincdec = adc0_psincdec, adc0_psdone = adc0_psdone, adc0_clk = adc0_clk, adc1_adc3wire_clk = adc1_adc3wire_clk, adc1_adc3wire_data = adc1_adc3wire_data, adc1_adc3wire_strobe = adc1_adc3wire_strobe, adc1_adc_reset = adc1_adc_reset, adc1_mmcm_reset = adc1_mmcm_reset, adc1_psclk = adc1_psclk, adc1_psen = adc1_psen, adc1_psincdec = adc1_psincdec, adc1_psdone = adc1_psdone, adc1_clk = adc1_clk)

if __name__ == "__main__":
   convert()
