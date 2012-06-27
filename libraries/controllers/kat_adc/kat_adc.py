#==============================================================================#
#                                                                              # 
#      KAT ADC wrapper                                                         # 
#                                                                              # 
#      Module name: kat_adc_wrapper                                            # 
#      Desc: wraps the hdl for the kat adc                                     # 
#      Date: May 2012                                                          # 
#      Developer: Wesley New                                                   # 
#      Licence: GNU General Public License ver 3                               # 
#      Notes:                                                                  # 
#                                                                              # 
#==============================================================================#

from myhdl import *

def kat_adc_wrapper(block_name,
      #===================
      # external signals
      #===================
      adc_clk_p,       
      adc_clk_n,
      adc_sync_p,
      adc_sync_n,
      adc_overrange_p,
      adc_overrange_n,
      adc_rst,
      adc_powerdown,
      adc_di_d_p,
      adc_di_d_n,
      adc_di_p,
      adc_di_n,
      adc_dq_d_p,
      adc_dq_d_n,
      adc_dq_p,
      adc_dq_n,
      
      #====================
      # user fabric ports
      #====================
      user_datai0,
      user_datai1,
      user_datai2,
      user_datai3,
      user_dataq0,
      user_dataq1,
      user_dataq2,
      user_dataq3,
      user_sync0,
      user_sync1,
      user_sync2,
      user_sync3,
      user_outofrange0,
      user_outofrange1,
      user_data_valid,
      
      #===========================
      # internal control signals
      #===========================
      mmcm_reset,
      
      ctrl_reset,
      ctrl_clk_in,
      ctrl_clk_out,
      ctrl_clk90_out,
      ctrl_clk180_out,
      ctrl_clk270_out,
      ctrl_mmcm_locked,
      
      mmcm_psclk,
      mmcm_psen,
      mmcm_psincdec,
      mmcm_psdone,

      #=============
      # parameters
      #=============
      EXTRA_REG = 1,

   ):


   @always(mmcm_reset)
   def logic():
      pass

   return logic


#========================
# KAT ADC Instantiation
#========================
kat_adc_wrapper.verilog_code = \
"""
kat_adc_interface
#(
   .EXTRA_REG ($EXTRA_REG)
) kac_adc_interface_$block_name (
   .adc_clk_p         ($adc_clk_p), 
   .adc_clk_n         ($adc_clk_n),
   .adc_sync_p        ($adc_sync_p),
   .adc_sync_n        ($adc_sync_n),
   .adc_overrange_p   ($adc_overrange_p),
   .adc_overrange_n   ($adc_overrange_n),
   .adc_rst           ($adc_rst),
   .adc_powerdown     ($adc_powerdown),
   .adc_di_d_p        ($adc_di_d_p),
   .adc_di_d_n        ($adc_di_d_n),
   .adc_di_p          ($adc_di_p),
   .adc_di_n          ($adc_di_n),
   .adc_dq_d_p        ($adc_dq_d_p),
   .adc_dq_d_n        ($adc_dq_d_n),
   .adc_dq_p          ($adc_dq_p),
   .adc_dq_n          ($adc_dq_n),
                                        
   .user_datai3       ($user_datai3),
   .user_datai2       ($user_datai2),
   .user_datai1       ($user_datai1),
   .user_datai0       ($user_datai0),
   .user_dataq3       ($user_dataq3),
   .user_dataq2       ($user_dataq2),
   .user_dataq1       ($user_dataq1),
   .user_dataq0       ($user_dataq0),
   .user_sync0        ($user_sync0),
   .user_sync1        ($user_sync1),
   .user_sync2        ($user_sync2),
   .user_sync3        ($user_sync3),
   .user_outofrange0  ($user_outofrange0),
   .user_outofrange1  ($user_outofrange1),
   .user_data_valid   ($user_data_valid),
                       
   .mmcm_reset        ($mmcm_reset),
                       
   .ctrl_reset        ($ctrl_reset),
   .ctrl_clk_in       ($ctrl_clk_in),
   .ctrl_clk_out      ($ctrl_clk_out),
   .ctrl_clk90_out    ($ctrl_clk90_out),
   .ctrl_clk180_out   ($ctrl_clk180_out),
   .ctrl_clk270_out   ($ctrl_clk270_out),
   .ctrl_mmcm_locked  ($ctrl_mmcm_locked),
                                        
   .mmcm_psclk        ($mmcm_psclk),
   .mmcm_psen         ($mmcm_psen),
   .mmcm_psincdec     ($mmcm_psincdec),
   .mmcm_psdone       ($mmcm_psdone)

);
"""

#=======================================
# For testing of conversion to verilog
#=======================================
def convert():

   (adc_clk_p,      adc_clk_n, 
   adc_sync_p,      adc_sync_n,
   adc_overrange_p, adc_overrange_n, 
   adc_rst,         adc_powerdown,
   adc_di_d_p,      adc_di_d_n, 
   adc_di_p,        adc_di_n, 
   adc_dq_d_p,      adc_dq_d_n, 
   adc_dq_p,        adc_dq_n) = [Signal(bool(0)) for i in range(16)]

   (user_datai3,     user_datai2, 
   user_datai1,      user_datai0, 
   user_dataq3,      user_dataq2, 
   user_dataq1,      user_dataq0, 
   user_sync0,       user_sync1, 
   user_sync2,       user_sync3, 
   user_outofrange0, user_outofrange1, 
   user_data_valid) = [Signal(bool(0)) for i in range(15)]

   (mmcm_reset,      ctrl_reset, 
   ctrl_clk_in,     ctrl_clk_out, 
   ctrl_clk90_out,  ctrl_clk180_out, 
   ctrl_clk270_out, ctrl_mmcm_locked, 
   mmcm_psclk,      mmcm_psen, 
   mmcm_psincdec,   mmcm_psdone) = [Signal(bool(0)) for i in range(12)]

   toVerilog(kat_adc_wrapper,                   block_name="inst1", 
             adc_clk_p=adc_clk_p,               adc_clk_n=adc_clk_n, 
	     adc_sync_p=adc_sync_p,             adc_sync_n=adc_sync_n, 
	     adc_overrange_p=adc_overrange_p,   adc_overrange_n=adc_overrange_n, 
	     adc_rst=adc_rst,                   adc_powerdown=adc_powerdown,
	     adc_di_d_p=adc_di_d_p,             adc_di_d_n=adc_di_d_n, 
	     adc_di_p=adc_di_p,                 adc_di_n=adc_di_n, 
	     adc_dq_d_p=adc_dq_d_p,             adc_dq_d_n=adc_dq_d_n, 
	     adc_dq_p=adc_dq_p,                 adc_dq_n=adc_dq_n, 
	     user_datai3=user_datai3,           user_datai2=user_datai2, 
	     user_datai1=user_datai1,           user_datai0=user_datai0, 
	     user_dataq3=user_dataq3,           user_dataq2=user_dataq2, 
	     user_dataq1=user_dataq1,           user_dataq0=user_dataq0, 
	     user_sync0=user_sync0,             user_sync1=user_sync1, 
	     user_sync2=user_sync2,             user_sync3=user_sync3, 
	     user_outofrange0=user_outofrange0, user_outofrange1=user_outofrange1, 
	     user_data_valid=user_data_valid,   mmcm_reset=mmcm_reset, 
	     ctrl_reset=ctrl_reset,             ctrl_clk_in=ctrl_clk_in, 
	     ctrl_clk_out=ctrl_clk_out,         ctrl_clk90_out=ctrl_clk90_out, 
	     ctrl_clk180_out=ctrl_clk180_out,   ctrl_clk270_out=ctrl_clk270_out, 
	     ctrl_mmcm_locked=ctrl_mmcm_locked, mmcm_psclk=mmcm_psclk, 
	     mmcm_psen=mmcm_psen,               mmcm_psincdec=mmcm_psincdec, 
	     mmcm_psdone=mmcm_psdone) 

if __name__ == "__main__":
   convert()


