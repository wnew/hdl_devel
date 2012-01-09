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
      wb_clk_i,
      wb_rst_i,
      wb_cyc_i,
      wb_stb_i,
      wb_we_i,
      wb_sel_i,
      wb_adr_i,
      wb_dat_i,

      #=============
      # wb outputs
      #=============
      wb_dat_o,
      wb_ack_o,
      wb_err_o,

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
   @always(wb_clk_i.posedge)
   def logic():
      if (rst == 0 and out < COUNT_TO):
         if (en == 1):
            out == out + STEP
      else:
         out = COUNT_FROM

   #========================
   # Counter Instantiation
   #========================
   __verilog__ = \
   """
   sw_reg_wr
   #(
      .C_BASEADDR      (%(C_BASEADDR)s), 
      .C_HIGHADDR      (%(C_HIGHADDR)s), 
      .C_WB_DATA_WIDTH (%(C_WB_DATA_WIDTH)s), 
      .C_WB_ADDR_WIDTH (%(C_WB_ADDR_WIDTH)s), 
      .C_BYTE_EN_WIDTH (%(C_BYTE_EN_WIDTH)s)  
   ) sw_reg_wr_%(block_name)s (
     
      .fabric_clk      (%(fabric_clk)s),
      .fabric_data_out (%(fabric_data_out)s),
                                       
      .wb_clk_i        (%(wb_clk_i)s),
      .wb_rst_i        (%(wb_rst_i)s),
      .wb_cyc_i        (%(wb_cyc_i)s),
      .wb_stb_i        (%(wb_stb_i)s),
      .wb_we_i         (%(wb_we_i)s),
      .wb_sel_i        (%(wb_sel_i)s),
      .wb_adr_i        (%(wb_adr_i)s),
      .wb_dat_i        (%(wb_dat_i)s),
                                        
      .wb_dat_o        (%(wb_dat_o)s),
      .wb_ack_o        (%(wb_ack_o)s),
      .wb_err_o        (%(wb_err_o)s)
   );
   """

   # removes warning when converting to hdl
   wb_dat_o.driven = "wire"
   wb_ack_o.driven = "wire"
   wb_err_o.driven = "wire"
   fabric_data_out.driven = "wire"

   return logic


#=======================================
# For testing of conversion to verilog
#=======================================
def convert():

   fabric_clk,fabric_data_out,wb_clk_i,wb_rst_i,wb_cyc_i,wb_stb_i,wb_we_i,wb_sel_i,wb_adr_i,wb_dat_i,wb_dat_o,wb_ack_o,wb_err_o = [Signal(bool(0)) for i in range(13)]

   toVerilog(sw_reg_wr_wrapper, block_name="sw_reg", fabric_clk=fabric_clk,fabric_data_out=fabric_data_out,wb_clk_i=wb_clk_i,wb_rst_i=wb_rst_i,wb_cyc_i=wb_cyc_i,wb_stb_i=wb_stb_i,wb_we_i=wb_we_i,wb_sel_i=wb_sel_i,wb_adr_i=wb_adr_i,wb_dat_i=wb_dat_i,wb_dat_o=wb_dat_o,wb_ack_o=wb_ack_o,wb_err_o=wb_err_o)

if __name__ == "__main__":
   convert()

