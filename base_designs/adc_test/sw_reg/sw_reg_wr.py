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
      fabric_clk,
      fabric_data_out,

      #============
      # wb inputs
      #============
      wbs_clk_i,
      wbs_rst_i,
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

      #=============
      # Parameters
      #=============
      C_BASEADDR      = 0,
      C_HIGHADDR      = 32,
      C_WB_DATA_WIDTH = 32,
      C_WB_ADDR_WIDTH = 1,
      C_BYTE_EN_WIDTH = 4
   ):

   #========================
   # TODO:Simulation Logic
   #========================
   @always(wbs_clk_i.posedge)
   def logic():
      if (rst == 0 and out < COUNT_TO):
         if (en == 1):
            out == out + STEP
      else:
         out = COUNT_FROM

   # removes warning when converting to hdl
   wbs_dat_o.driven = "wire"
   wbs_ack_o.driven = "wire"
   wbs_err_o.driven = "wire"
   fabric_data_out.driven = "wire"

   return logic

#=============================
# Software Reg Instantiation
#=============================
sw_reg_wr_wrapper.verilog_code = \
"""
sw_reg_wr
#(
   .C_BASEADDR      ($C_BASEADDR), 
   .C_HIGHADDR      ($C_HIGHADDR), 
   .C_WB_DATA_WIDTH ($C_WB_DATA_WIDTH), 
   .C_WB_ADDR_WIDTH ($C_WB_ADDR_WIDTH), 
   .C_BYTE_EN_WIDTH ($C_BYTE_EN_WIDTH)  
) sw_reg_wr_$block_name (
  
   .fabric_clk      ($fabric_clk),
   .fabric_data_out ($fabric_data_out),
    
   .wbs_clk_i       ($wbs_clk_i),
   .wbs_rst_i       ($wbs_rst_i),
   .wbs_cyc_i       ($wbs_cyc_i[SLI]),
   .wbs_stb_i       ($wbs_stb_i[SLI]),
   .wbs_we_i        ($wbs_we_i),
   .wbs_sel_i       ($wbs_sel_i),
   .wbs_adr_i       ($wbs_adr_i),
   .wbs_dat_i       ($wbs_dat_i),
   .wbs_dat_o       ($wbs_dat_o[(SLI+1)*32:SLI*32]),
   .wbs_ack_o       ($wbs_ack_o[SLI])
   .wbs_err_o       ($wbs_err_o)
);
"""


#=======================================
# For testing of conversion to verilog
#=======================================
def convert():

   fabric_clk,fabric_data_out,wbs_clk_i,wbs_rst_i,wbs_cyc_i,wbs_stb_i,wbs_we_i,wbs_sel_i,wbs_adr_i,wbs_dat_i,wbs_dat_o,wbs_ack_o,wbs_err_o = [Signal(bool(0)) for i in range(13)]

   toVerilog(sw_reg_wr_wrapper, block_name="sw_reg", fabric_clk=fabric_clk,fabric_data_out=fabric_data_out,wbs_clk_i=wbs_clk_i,wbs_rst_i=wbs_rst_i,wbs_cyc_i=wbs_cyc_i,wbs_stb_i=wbs_stb_i,wbs_we_i=wbs_we_i,wbs_sel_i=wbs_sel_i,wbs_adr_i=wbs_adr_i,wbs_dat_i=wbs_dat_i,wbs_dat_o=wbs_dat_o,wbs_ack_o=wbs_ack_o,wbs_err_o=wbs_err_o)

if __name__ == "__main__":
   convert()

