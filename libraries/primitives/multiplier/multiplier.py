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
      data1_i,
      data2_i,
      data_o,

      #=============
      # Parameters
      #=============
      ARCHITECTURE = "BEHAVIORAL",
      DATA_WIDTH_1 = 8,
      DATA_WIDTH_2 = 8
   ):

   #===================
   # Simulation Logic
   #===================
   
   @always_comb
   def logic():
      data_o = data1_i * data2_i 

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
   .ARCHITECTURE ("$ARCHITECTURE"),
   .DATA_WIDTH_1 ($DATA_WIDTH_1),
   .DATA_WIDTH_2 ($DATA_WIDTH_2)
) multiplier_$block_name (
   .data1_i  ($data1_i),
   .data2_i  ($data2_i),
   .data_o   ($data_o)
);
"""


#=======================================
# For testing of conversion to verilog
#=======================================
def convert():

   data1_i, data2_i, data_o = [Signal(bool(0)) for i in range(3)]

   toVerilog(multiplier_wrapper, block_name="inst", data1_i=data1_i, data2_i=data2_i, data_o=data_o)


if __name__ == "__main__":
   convert()

