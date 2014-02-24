#==============================================================================#
#                                                                              # 
#      Multiplier wrapper and simulation model                                 # 
#                                                                              # 
#      Module name: multiplier_wrapper                                         # 
#      Desc: wraps the verilog multiplier and provides a model for simulation  # 
#      Date: April 2012                                                        # 
#      Developer: Wesley New                                                   # 
#      Licence: GNU General Public License ver 3                               # 
#      Notes:                                                                  # 
#                                                                              # 
#==============================================================================#

from myhdl import *

def multiplier_wrapper(block_name,
      #========
      # Ports
      #========
      clk,
      data1_i,
      data2_i,
      data_o,

      #=============
      # Parameters
      #=============
      DATA_WIDTH_1 = 8,
      DATA_WIDTH_2 = 8
   ):

   #===================
   # Simulation Logic
   #===================
   
   @always_comb
   def logic():
      data_o.next = data1_i * data2_i 

   # removes warning when converting to hdl
   data_o.driven = "wire"

   return logic

#===========================
# Multiplier Instantiation
#===========================
multiplier_wrapper.verilog_code = \
"""
multiplier 
#(
   .DATA_WIDTH_1 ($DATA_WIDTH_1),
   .DATA_WIDTH_2 ($DATA_WIDTH_2)
) multiplier_$block_name (
   .clk      ($clk),
   .data1_i  ($data1_i),
   .data2_i  ($data2_i),
   .data_o   ($data_o)
);
"""


#=======================================
# For testing of conversion to verilog
#=======================================
def convert():

   clk = Signal(bool(0))
   data1_i, data2_i = [Signal(intbv(0)[8:0]) for i in range(2)]
   data_o = Signal(intbv(0)[16:0])

   toVerilog(multiplier_wrapper, block_name="inst", clk=clk, data1_i=data1_i, data2_i=data2_i, data_o=data_o)


if __name__ == "__main__":
   convert()

