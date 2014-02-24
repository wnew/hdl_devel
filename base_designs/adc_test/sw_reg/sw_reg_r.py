#==============================================================================#
#                                                                              # 
#      Software Register wrapper and simulation model                          # 
#                                                                              # 
#      Module name: sw_reg_r_wrapper                                           # 
#      Desc: wraps the verilog sw_reg_r and provides a model for simulation    # 
#      Date: Jan 2012                                                          # 
#      Developer: Wesley New                                                   # 
#      Licence: GNU General Public License ver 3                               # 
#      Notes:                                                                  # 
#                                                                              # 
#==============================================================================#

from myhdl import *

#class sw_reg_r:

   #def __init__(self, module_name, HAS_INTERRUPT, BUS_DATA_WIDTH = 32, BUS_ADDR_WIDTH = 1, BUS_BASE_ADDR = 0, BUS_HIGH_ADDR = 0):
   #   self._bus_interface = "wishbone"    # static parameter, "none", "wishbone", "epb"
   #   self._wbs_mem_addrs  = "1"           # static paramter,  memory requirements for this module, 1 addr = 32bits
   #   self.module_name    = module_name   # the name of the module
   #   self.HAS_INTERRUPT  = HAS_INTERRUPT # set in the module form 0 = no, 1 = yes
   #   self.BUS_DATA_WIDTH  = BUS_DATA_WIDTH # set in the module form
   #   self.BUS_ADDR_WIDTH  = BUS_ADDR_WIDTH # set in the module form
   #   self.BUS_BASE_ADDR   = BUS_BASE_ADDR  # base address, this is generated by bus management
   #   self.BUS_HIGH_ADDR   = BUS_HIGH_ADDR  # high address, this is generated by bus management

def sw_reg_r_wrapper(
      #===============
      # fabric ports
      #===============
      fabric_clk,
      fabric_data_in,

      #============
      # wb inputs
      #============
      wbs_clk_i,
      wbs_rst_i,
      wbs_cyc_i,
      wbs_stb_i,
      wbs_we_i ,
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
      module_name    = 1,
      BUS_BASE_ADDR  = 0,
      BUS_HIGH_ADDR  = 32,
      BUS_DATA_WIDTH = 32,
      BUS_ADDR_WIDTH = 1,
      BYTE_EN_WIDTH  = 4
   ):
   
   # the conversion of user defined code does not currently support self.
   # so this is a hack until support for this is implemented.
   #module_name   =1 
   #HAS_INTERRUPT = self.HAS_INTERRUPT
   #BUS_DATA_WIDTH = self.BUS_DATA_WIDTH
   #BUS_ADDR_WIDTH = self.BUS_ADDR_WIDTH
   #BUS_BASE_ADDR  = self.BUS_BASE_ADDR 
   #BUS_HIGH_ADDR  = self.BUS_HIGH_ADDR 
   
   #========================
   # TODO:Simulation Logic
   #========================
   @always(wbs_clk_i.posedge)
   def logic():
      temp = 1
   
   # removes warning when converting to hdl
   fabric_data_in.driven = "wire"
   wbs_dat_o.driven       = "wire"
   wbs_ack_o.driven       = "wire"
   wbs_err_o.driven       = "wire"

   return logic
  

#========================
# Counter Instantiation
#========================
# as an attribute on the wrapper function
sw_reg_r_wrapper.verilog_code = \
"""
sw_reg_r
#(
   .C_BASEADDR       ($BUS_BASE_ADDR), 
   .C_HIGHADDR       ($BUS_HIGH_ADDR), 
   .C_BUS_DATA_WIDTH ($BUS_DATA_WIDTH), 
   .C_BUS_ADDR_WIDTH ($BUS_ADDR_WIDTH) 
) sw_reg_r_$module_name (
  
   .fabric_clk     ($fabric_clk),
   .fabric_data_in ($fabric_data_in),

   .wbs_clk_i       ($wbs_clk_i),
   .wbs_rst_i       ($wbs_rst_i),
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
   x = sw_reg_r()

   #x = sw_reg_r(module_name   = "1",
   #             HAS_INTERRUPT = "0",
   #             BUS_DATA_WIDTH = 32,
   #             BUS_ADDR_WIDTH = 1,
   #             BUS_BASE_ADDR  = 0,
   #             BUS_HIGH_ADDR  = 0)

   (fabric_clk, fabric_data_in, 
   wbs_clk_i, wbs_rst_i, wbs_cyc_i, 
   wbs_stb_i, wbs_we_i,  wbs_sel_i, 
   wbs_adr_i, wbs_dat_i, wbs_dat_o, 
   wbs_ack_o, wbs_err_o) = [Signal(bool(0)) for i in range(13)]

   toVerilog(x.sw_reg_r_wrapper, 
             fabric_clk     = fabric_clk, 
             fabric_data_in = fabric_data_in,
             wbs_clk_i       = wbs_clk_i, 
             wbs_rst_i       = wbs_rst_i, 
             wbs_cyc_i       = wbs_cyc_i, 
             wbs_stb_i       = wbs_stb_i, 
             wbs_we_i        = wbs_we_i, 
             wbs_sel_i       = wbs_sel_i, 
             wbs_adr_i       = wbs_adr_i, 
             wbs_dat_i       = wbs_dat_i, 
             wbs_dat_o       = wbs_dat_o, 
             wbs_ack_o       = wbs_ack_o, 
             wbs_err_o       = wbs_err_o
            )
   

if __name__ == "__main__":
   convert()
   
