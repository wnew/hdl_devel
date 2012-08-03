#==============================================================================#
#                                                                              # 
#      BRAM dual port wrapper and simulation model                             # 
#                                                                              # 
#      Module name: bram_sp_wrapper                                            # 
#      Desc: wraps the verilog bram_dp and provides a model for simulation     # 
#      Date: Jan 2012                                                          # 
#      Developer: Wesley New                                                   # 
#      Licence: GNU General Public License ver 3                               # 
#      Notes:                                                                  # 
#                                                                              # 
#==============================================================================#

from myhdl import *

def bram_sync_dp_wrapper(block_name,
      #========
      # Ports
      #========
      rst,
      a_clk,
      a_wr,
      a_addr,
      a_data_in,
      a_data_out,
      b_clk,
      b_wr,
      b_addr,
      b_data_in,
      b_data_out,

      #=============
      # Parameters
      #=============
      ARCHITECTURE = "BEHAVIORAL",
      RAM_DATA_WIDTH   = 32,
      RAM_ADDR_WIDTH   = 4
   ):
   
   mem = [Signal(intbv(0)[RAM_DATA_WIDTH:]) for i in range(2**RAM_ADDR_WIDTH)]

   #===================
   # Simulation Logic
   #===================
   # a_clk logic
   #===================
   @always(a_clk.posedge)
   def a_logic():
      if rst:
         a_data_out.next = 0
      else:
         a_data_out.next = mem[a_addr.val]
         if a_wr:
            mem[a_addr.val] = a_data_in.val
   
   #==============
   # b_clk logic
   #==============
   @always(b_clk.posedge)
   def b_logic():
      if rst:
         b_data_out.next = 0
      else:
         b_data_out.next = mem[b_addr.val]
         if b_wr:
            mem[b_addr.val] = b_data_in.val
   

   # removes warning when converting to hdl

   return a_logic, b_logic

   
#=============================
# BRAM Verilog Instantiation
#=============================
bram_sync_dp_wrapper.verilog_code = \
"""
bram_sync_dp #(
   .ARCHITECTURE ("$ARCHITECTURE"),
   .RAM_DATA_WIDTH   ($RAM_DATA_WIDTH),
   .RAM_ADDR_WIDTH   ($RAM_ADDR_WIDTH)
) bram_sync_dp_$block_name (
   .rst        ($rst),
   .a_clk      ($a_clk),
   .a_wr       ($a_wr),
   .a_addr     ($a_addr),
   .a_data_in  ($a_data_in),
   .a_data_out ($a_data_out),
   .b_clk      ($b_clk),
   .b_wr       ($b_wr),
   .b_addr     ($b_addr),
   .b_data_in  ($b_data_in),
   .b_data_out ($b_data_out)
);
"""


#=======================================
# For testing of conversion to verilog
#=======================================
def convert():

   rst, a_clk, a_wr, a_addr, a_data_in, a_data_out, b_clk, b_wr, b_addr, b_data_in, b_data_out = [Signal(bool(0)) for i in range(11)]

   toVerilog(bram_sync_dp_wrapper, block_name="inst", rst=rst, a_clk=a_clk, a_wr=a_wr, a_addr=a_addr, a_data_in=a_data_in, a_data_out=a_data_out, b_clk=b_clk, b_wr=b_wr, b_addr=b_addr, b_data_in=b_data_in, b_data_out=b_data_out)


if __name__ == "__main__":
   convert()

