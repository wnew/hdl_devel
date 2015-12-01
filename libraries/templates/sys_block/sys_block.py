#==============================================================================#
#                                                                              # 
#      Wishbone Slave template wrapper and simulation model                    # 
#                                                                              # 
#      Module name: wbs_template_wrapper                                       # 
#      Desc: wraps the verilog wbs_template                                    # 
#      Date: July 2012                                                         # 
#      Developer: Wesley New                                                   # 
#      Licence: GNU General Public License ver 3                               # 
#      Notes:                                                                  # 
#                                                                              # 
#==============================================================================#

from myhdl import *

class sys_block:

   #def __init__(self, module_name, HAS_INTERRUPT, BUS_DATA_WIDTH = 32, BUS_ADDR_WIDTH = 1, BUS_BASE_ADDR = 0, BUS_HIGH_ADDR = 0):
   #   self._bus_interface = "wishbone"    # static parameter, "none", "wishbone", "epb"
   #   self._wbs_mem_addrs  = "1"           # static paramter,  memory requirements for this module, 1 addr = 32bits
   #   self.module_name    = module_name   # the name of the module
   #   self.HAS_INTERRUPT  = HAS_INTERRUPT # set in the module form 0 = no, 1 = yes
   #   self.BUS_DATA_WIDTH  = BUS_DATA_WIDTH # set in the module form
   #   self.BUS_ADDR_WIDTH  = BUS_ADDR_WIDTH # set in the module form
   #   self.BUS_BASE_ADDR   = BUS_BASE_ADDR  # base address, this is generated by bus management
   #   self.BUS_HIGH_ADDR   = BUS_HIGH_ADDR  # high address, this is generated by bus management

   def sys_block_wrapper(self,
         #============
         # wb inputs
         #============
         wb_clk_i,
         wb_rst_i,
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
         wbs_int_o,

         #=============
         # Parameters
         #=============
         DEV_BASE_ADDR  = 0,
         DEV_HIGH_ADDR  = 32,
         BUS_DATA_WIDTH = 32,
         BUS_ADDR_WIDTH = 1
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
      @always(wb_clk_i.posedge)
      def logic():
         temp = 1
      
      # removes warning when converting to hdl
      wbs_dat_o.driven       = "wire"
      wbs_ack_o.driven       = "wire"
      wbs_err_o.driven       = "wire"
   
      return logic
  

   #========================
   # Counter Instantiation
   #========================
   # as an attribute on the wrapper function
   sys_block_wrapper.verilog_code = \
   """
   sys_block
   #(
      .DEV_BASE_ADDR  ($DEV_BASE_ADDR), 
      .DEV_HIGH_ADDR  ($DEV_HIGH_ADDR), 
      .BUS_DATA_WIDTH ($BUS_DATA_WIDTH), 
      .BUS_ADDR_WIDTH ($BUS_ADDR_WIDTH) 
   ) sys_block_$module_name (
     
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
      .wbs_int_o       ($wbs_int_o)
   );
   """


#=======================================
# For testing of conversion to verilog
#=======================================
def convert():
   x = sys_block()

   #x = sw_reg_r(module_name   = "1",
   #             HAS_INTERRUPT = "0",
   #             BUS_DATA_WIDTH = 32,
   #             BUS_ADDR_WIDTH = 1,
   #             BUS_BASE_ADDR  = 0,
   #             BUS_HIGH_ADDR  = 0)

   (wb_clk_i, wb_rst_i, wbs_cyc_i, 
   wbs_stb_i, wbs_we_i,  wbs_sel_i, 
   wbs_adr_i, wbs_dat_i, wbs_dat_o, 
   wbs_ack_o, wbs_err_o, wbs_int_o) = [Signal(bool(0)) for i in range(12)]

   toVerilog(x.sys_block_wrapper, 
             wb_clk_i       = wb_clk_i, 
             wb_rst_i       = wb_rst_i, 
             wbs_cyc_i       = wbs_cyc_i, 
             wbs_stb_i       = wbs_stb_i, 
             wbs_we_i        = wbs_we_i, 
             wbs_sel_i       = wbs_sel_i, 
             wbs_adr_i       = wbs_adr_i, 
             wbs_dat_i       = wbs_dat_i, 
             wbs_dat_o       = wbs_dat_o, 
             wbs_ack_o       = wbs_ack_o, 
             wbs_err_o       = wbs_err_o,
             wbs_int_o       = wbs_int_o
            )
   

if __name__ == "__main__":
   convert()
   
