#==============================================================================#
#                                                                              # 
#      Adder wrapper and simulation model                                      # 
#                                                                              # 
#      Module name: adder_wrapper                                              # 
#      Desc: wraps the verilog adder and provides a model for simulation       # 
#      Date: April 2012                                                        # 
#      Developer: Wesley New                                                   # 
#      Licence: GNU General Public License ver 3                               # 
#      Notes:                                                                  # 
#                                                                              # 
#==============================================================================#

from myhdl import *

def adder_wrapper(block_name,
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
      data_o.next = data1_i + data2_i

   # removes warning when converting to hdl
   data_o.driven = "wire"

   return logic

#======================
# Adder Instantiation
#======================
adder_wrapper.verilog_code = \
"""
adder 
#(
   .ARCHITECTURE ("$ARCHITECTURE"),
   .DATA_WIDTH_1 ($DATA_WIDTH_1),
   .DATA_WIDTH_2 ($DATA_WIDTH_2)
) adder_$block_name (
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

   toVerilog(adder_wrapper, block_name="inst", data1_i=data1_i, data2_i=data2_i, data_o=data_o)


if __name__ == "__main__":
   convert()

