#==============================================================================#
#                                                                              # 
#      BRAM with wishbone interface wrapper and simulation model               # 
#                                                                              # 
#      Module name: bram_wb_wrapper                                            # 
#      Desc: wraps the verilog bram_wb and provides a model for simulation     # 
#      Date: June 2012                                                         # 
#      Developer: Wesley New                                                   # 
#      Licence: GNU General Public License ver 3                               # 
#      Notes:                                                                  # 
#                                                                              # 
#==============================================================================#

from myhdl import *

class bram_wb:

   def __init__(self, module_name, HAS_INTERRUPT, BUS_DATA_WIDTH = 32, BUS_ADDR_WIDTH = 1, BUS_BASE_ADDR = 0, BUS_HIGH_ADDR = 0):
      self._bus_interface = "wishbone"    # static parameter, "none", "wishbone", "epb"
      self._wb_mem_addrs  = "1"           # static paramter,  memory requirements for this module, 1 addr = 32bits
      self.module_name    = module_name   # the name of the module
      self.HAS_INTERRUPT  = HAS_INTERRUPT # set in the module form 0 = no, 1 = yes
      self.BUS_DATA_WIDTH  = BUS_DATA_WIDTH # set in the module form
      self.BUS_ADDR_WIDTH  = BUS_ADDR_WIDTH # set in the module form
      self.BUS_BASE_ADDR   = BUS_BASE_ADDR  # base address, this is generated by bus management
      self.BUS_HIGH_ADDR   = BUS_HIGH_ADDR  # high address, this is generated by bus management

   def bram_wb_wrapper(self,
         #===============
         # fabric ports
         #===============
         fabric_clk,
         fabric_data_in,
   
         #===========
         # wb ports
         BRAM_Rst_B,
         BRAM_Clk_B,
         BRAM_EN_B,
         BRAM_WEN_B,
         BRAM_Addr_B,
         BRAM_Din_B,
         BRAM_Dout_B


         #=============
         # Parameters
         #=============
         C_PORTA_DEPTH,
         C_PORTB_DEPTH,
         C_PORTA_AWIDTH,
         C_PORTA_DWIDTH,
         C_PORTB_AWIDTH,
         C_PORTB_DWIDTH,
         
         
         
         
         
         


         #BUS_BASE_ADDR  = 0,
         #BUS_HIGH_ADDR  = 32,
         #BUS_DATA_WIDTH = 32,
         #BUS_ADDR_WIDTH = 1
         #BYTE_EN_WIDTH = 4
      ):
      
      # the conversion of user defined code does not currently support self.
      # so this is a hack until support for this is implemented.
      module_name   = self.module_name
      HAS_INTERRUPT = self.HAS_INTERRUPT
      BUS_DATA_WIDTH = self.BUS_DATA_WIDTH
      BUS_ADDR_WIDTH = self.BUS_ADDR_WIDTH
      BUS_BASE_ADDR  = self.BUS_BASE_ADDR 
      BUS_HIGH_ADDR  = self.BUS_HIGH_ADDR 
      
      #========================
      # TODO:Simulation Logic
      #========================
      @always(wb_clk_i.posedge)
      def logic():
         temp = 1
      
      # removes warning when converting to hdl
      fabric_data_in.driven = "wire"
      wb_dat_o.driven       = "wire"
      wb_ack_o.driven       = "wire"
      wb_err_o.driven       = "wire"
   
      return logic
  

   #========================
   # Counter Instantiation
   #========================
   # as an attribute on the wrapper function
   bram_wb_wrapper.verilog_code = \
   """
   bram_wb
   #(
      .C_BASEADDR       ($BUS_BASE_ADDR), 
      .C_HIGHADDR       ($BUS_HIGH_ADDR), 
      .C_BUS_DATA_WIDTH ($BUS_DATA_WIDTH), 
      .C_BUS_ADDR_WIDTH ($BUS_ADDR_WIDTH) 
   ) bram_wb_$module_name (
     
      .fabric_clk     ($fabric_clk),
      .fabric_data_in ($fabric_data_in),
                                       
      .wb_clk_i       ($wb_clk_i),
      .wb_rst_i       ($wb_rst_i),
      .wb_cyc_i       ($wb_cyc_i),
      .wb_stb_i       ($wb_stb_i),
      .wb_we_i        ($wb_we_i),
      .wb_sel_i       ($wb_sel_i),
      .wb_adr_i       ($wb_adr_i),
      .wb_dat_i       ($wb_dat_i),

      .wb_dat_o       ($wb_dat_o),
      .wb_ack_o       ($wb_ack_o),
      .wb_err_o       ($wb_err_o)
   );
   """


#=======================================
# For testing of conversion to verilog
#=======================================
def convert():

   x = bram_wb(module_name    = "1",
               HAS_INTERRUPT  = "0",
               BUS_DATA_WIDTH = 32,
               BUS_ADDR_WIDTH = 1,
               BUS_BASE_ADDR  = 0,
               BUS_HIGH_ADDR  = 0)

   (fabric_clk, fabric_data_in, 
   wb_clk_i, wb_rst_i, wb_cyc_i, 
   wb_stb_i, wb_we_i,  wb_sel_i, 
   wb_adr_i, wb_dat_i, wb_dat_o, 
   wb_ack_o, wb_err_o) = [Signal(bool(0)) for i in range(13)]

   toVerilog(x.bram_wb_wrapper, 
             fabric_clk     = fabric_clk, 
             fabric_data_in = fabric_data_in,
             wb_clk_i       = wb_clk_i, 
             wb_rst_i       = wb_rst_i, 
             wb_cyc_i       = wb_cyc_i, 
             wb_stb_i       = wb_stb_i, 
             wb_we_i        = wb_we_i, 
             wb_sel_i       = wb_sel_i, 
             wb_adr_i       = wb_adr_i, 
             wb_dat_i       = wb_dat_i, 
             wb_dat_o       = wb_dat_o, 
             wb_ack_o       = wb_ack_o, 
             wb_err_o       = wb_err_o
            )
   

if __name__ == "__main__":
   convert()
   