#==============================================================================#
#                                                                              # 
#      BRAM single port wrapper and simulation model                           # 
#                                                                              # 
#      Module name: bram_sp_wrapper                                            # 
#      Desc: wraps the verilog bram_sp and provides a model for simulation     # 
#      Date: Jan 2012                                                          # 
#      Developer: Wesley New                                                   # 
#      Licence: GNU General Public License ver 3                               # 
#      Notes:                                                                  # 
#                                                                              # 
#==============================================================================#

from myhdl import *

def bram_sync_sp_wrapper(block_name,
      #========
      # Ports
      #========
      clk,
      rst,
      wr,
      addr,
      data_in,
      data_out,

      #=============
      # Parameters
      #=============
      RAM_DATA_WIDTH = 32,
      RAM_ADDR_WIDTH = 4
   ):

   mem = [Signal(intbv(0)[RAM_DATA_WIDTH:]) for i in range(2**RAM_ADDR_WIDTH)]

   #===================
   # Simulation Logic
   #===================
   # a_clk logic
   #===================
   @always(clk.posedge)
   def logic():
      if rst:
         data_out.next = 0
      else:
         data_out.next = mem[addr.val]
         if wr:
            mem[addr.val] = data_in.val
   
   
   # removes warning when converting to hdl

   return logic


#=============================
# BRAM Verilog Instantiation
#=============================
bram_sync_sp_wrapper.verilog_code = \
"""
bram_sync_sp
#(
   .RAM_DATA_WIDTH ($RAM_DATA_WIDTH),
   .RAM_ADDR_WIDTH ($RAM_ADDR_WIDTH)
) bram_sync_sp_$block_name (
   .clk      ($clk),
   .rst      ($rst),
   .wr       ($wr),
   .addr     ($addr),
   .data_in  ($data_in),
   .data_out ($data_out)
);
"""


#=======================================
# For testing of conversion to verilog
#=======================================
def convert():

   clk, rst, wr, addr, data_in, data_out = [Signal(bool(0)) for i in range(6)]

   toVerilog(bram_sync_sp_wrapper, block_name="inst", clk=clk, rst=rst, wr=wr, addr=addr, data_in=data_in, data_out=data_out)


if __name__ == "__main__":
   convert()

