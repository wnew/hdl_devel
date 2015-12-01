#==============================================================================#
#                                                                              # 
#      KAT ADC IIC wishbone controller wrapper                                 # 
#                                                                              # 
#      Module name: iic_controller_wrapper                                     # 
#      Desc: wraps the hdl for the kat adc iic wishbone controller             # 
#      Date: May 2012                                                          # 
#      Developer: Wesley New                                                   # 
#      Licence: GNU General Public License ver 3                               # 
#      Notes:                                                                  # 
#                                                                              # 
#==============================================================================#

from myhdl import *

def iic_controller_wrapper(block_name,
      #===================
      # wishbone signals
      #===================
      wbs_clk_i,
      wbs_rst_i,
      wbs_we_i,
      wbs_cyc_i,
      wbs_stb_i,
      wbs_sel_i,
      wbs_adr_i,
      wbs_dat_i,
      wbs_dat_o,
      wbs_ack_o,

      xfer_done,
      
      #==============
      # IIC signals
      #==============
      sda_i,
      sda_o,
      sda_t,
      scl_i,
      scl_o,
      scl_t,

      app_clk,
      gain_load,
      gain_value,   #[13:0]

      #=============
      # parameters
      #=============
      C_BASEADDR    = 0,
      C_HIGHADDR    = 0,
      C_WB_AWIDTH   = 32,
      C_WB_DWIDTH   = 32,
      IIC_FREQ      = 100,    #kHz
      CORE_FREQ     = 100000, #kHz
      EN_GAIN       = 0
   ):


   @always(wbs_clk_i)
   def logic():
      pass

   return logic


#===============================
# IIC Controller Instantiation
#===============================
iic_controller_wrapper.verilog_code = \
"""
iic_controller #(
   .C_BASEADDR  ($C_BASEADDR),
   .C_HIGHADDR  ($C_HIGHADDR),
   .C_WB_AWIDTH ($C_WB_AWIDTH),
   .C_WB_DWIDTH ($C_WB_DWIDTH),
   .IIC_FREQ    ($IIC_FREQ),
   .CORE_FREQ   ($CORE_FREQ),
   .EN_GAIN     ($EN_GAIN)
) iic_controller_$block_name (
   .wbs_clk_i   ($wbs_clk_i), 
   .wbs_rst_i   ($wbs_rst_i),
   .wbs_we_i    ($wbs_we_i),
   .wbs_cyc_i   ($wbs_cyc_i),
   .wbs_stb_i   ($wbs_stb_i),
   .wbs_sel_i   ($wbs_sel_i),
   .wbs_adr_i   ($wbs_adr_i),
   .wbs_dat_i   ($wbs_dat_i),
   .wbs_dat_o   ($wbs_dat_o),
   .wbs_ack_o   ($wbs_ack_o),
                       
   .xfer_done  ($xfer_done),
                       
   .sda_i      ($sda_i),
   .sda_o      ($sda_o),
   .sda_t      ($sda_t),
   .scl_i      ($scl_i),
   .scl_o      ($scl_o),
   .scl_t      ($scl_t),
                       
   .app_clk    ($app_clk),
   .gain_load  ($gain_load),
   .gain_value ($gain_value)
);
"""

#=======================================
# For testing of conversion to verilog
#=======================================
def convert():

   (wbs_clk_i, wbs_rst_i, wbs_we_i, 
   wbs_cyc_i,  wbs_stb_i, wbs_sel_i,
   wbs_adr_i,  wbs_dat_i, wbs_dat_o,
   wbs_ack_o,
        
   xfer_done,
           
   sda_i, sda_o, sda_t,
   scl_i, scl_o, scl_t,
           
   app_clk, gain_load, gain_value) = [Signal(bool(0)) for i in range(20)] 

   toVerilog(iic_controller_wrapper, block_name="inst1", 
      wbs_clk_i   = wbs_clk_i,
      wbs_rst_i   = wbs_rst_i,
      wbs_we_i    = wbs_we_i,
      wbs_cyc_i   = wbs_cyc_i,
      wbs_stb_i   = wbs_stb_i,
      wbs_sel_i   = wbs_sel_i,
      wbs_adr_i   = wbs_adr_i,
      wbs_dat_i   = wbs_dat_i,
      wbs_dat_o   = wbs_dat_o,
      wbs_ack_o   = wbs_ack_o,

      xfer_done  = xfer_done,

      sda_i      = sda_i,
      sda_o      = sda_o,
      sda_t      = sda_t,
      scl_i      = scl_i,
      scl_o      = scl_o,
      scl_t      = scl_t,
      
      app_clk    = app_clk,
      gain_load  = gain_load,
      gain_value = gain_value)

if __name__ == "__main__":
   convert()


