#==============================================================================#
#                                                                              # 
#      Software Register wrapper and simulation model                          # 
#                                                                              # 
#      Module name: sw_reg_wrapper                                             # 
#      Desc: wraps the verilog sw_reg and provides a model for simulation      # 
#      Date: Jan 2012                                                          # 
#      Developer: Wesley New                                                   # 
#      Licence: GNU General Public License ver 3                               # 
#      Notes:                                                                  # 
#                                                                              # 
#==============================================================================#

from myhdl import *

def sw_reg_wr_wrapper(block_name,
      #===============
      # fabric ports
      #===============
      fabric_clk_i,
      fabric_data_o,

      #============
      # wb inputs
      #============
      wb_clk_i,
      wb_rst_i,
      wbs_cyc_i,
      wbs_stb_i,
      wbs_we_i,
      wbs_sel_i,
      wbs_adr_i,
      wbs_dat_i,

      #=============
      # wb outputs
      #=============
      wbs_dat_o,
      wbs_ack_o,
      wbs_err_o,
      wbs_int_o,

      #=============
      # Parameters
      #=============
      DEV_BASE_ADDR  = 0,
      DEV_HIGH_ADDR  = 32,
      BUS_DATA_WIDTH = 32,
      BUS_ADDR_WIDTH = 1,
   ):

   #========================
   # TODO:Simulation Logic
   #========================
   @always(wb_clk_i.posedge)
   def logic():
      if (rst == 0 and out < COUNT_TO):
         if (en == 1):
            out == out + STEP
      else:
         out = COUNT_FROM

   # removes warning when converting to hdl
   fabric_data_o.driven = "wire"
   wbs_dat_o.driven     = "wire"
   wbs_ack_o.driven     = "wire"
   wbs_err_o.driven     = "wire"
   wbs_int_o.driven     = "wire"

   return logic

#=============================
# Software Reg Instantiation
#=============================
sw_reg_wr_wrapper.verilog_code = \
"""
sw_reg_wr
#(
   .DEV_BASE_ADDR  ($DEV_BASE_ADDR),
   .DEV_HIGH_ADDR  ($DEV_HIGH_ADDR),
   .BUS_DATA_WIDTH ($BUS_DATA_WIDTH),
   .BUS_ADDR_WIDTH ($BUS_ADDR_WIDTH)
) sw_reg_wr_$block_name (
  
   .fabric_clk_i    ($fabric_clk_i),
   .fabric_data_o   ($fabric_data_o),
    
   .wb_clk_i        ($wb_clk_i),
   .wb_rst_i        ($wb_rst_i),
   .wbs_cyc_i       ($wbs_cyc_i),
   .wbs_stb_i       ($wbs_stb_i),
   .wbs_we_i        ($wbs_we_i),
   .wbs_sel_i       ($wbs_sel_i),
   .wbs_adr_i       ($wbs_adr_i),
   .wbs_dat_i       ($wbs_dat_i),
   .wbs_dat_o       ($wbs_dat_o),
   .wbs_ack_o       ($wbs_ack_o),
   .wbs_err_o       ($wbs_err_o)
);
"""


#=======================================
# For testing of conversion to verilog
#=======================================
def convert():

   (fabric_clk_i, fabric_data_o, 
   wb_clk_i,  wb_rst_i,  wbs_cyc_i,
   wbs_stb_i, wbs_we_i,  wbs_sel_i,
   wbs_adr_i, wbs_dat_i, wbs_dat_o,
   wbs_ack_o, wbs_err_o, wbs_int_o) = [Signal(bool(0)) for i in range(14)]

   toVerilog(sw_reg_wr_wrapper, block_name="inst", 
      fabric_clk_i = fabric_clk_i,
      fabric_data_o = fabric_data_o,
      wb_clk_i  = wb_clk_i,
      wb_rst_i  = wb_rst_i,
      wbs_cyc_i = wbs_cyc_i,
      wbs_stb_i = wbs_stb_i,
      wbs_we_i  = wbs_we_i,
      wbs_sel_i = wbs_sel_i,
      wbs_adr_i = wbs_adr_i,
      wbs_dat_i = wbs_dat_i,
      wbs_dat_o = wbs_dat_o,
      wbs_ack_o = wbs_ack_o,
      wbs_err_o = wbs_err_o,
      wbs_int_o = wbs_int_o)

if __name__ == "__main__":
   convert()

