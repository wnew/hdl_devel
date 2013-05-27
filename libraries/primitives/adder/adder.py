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
   .DATA_WIDTH_1 ($DATA_WIDTH_1),
   .DATA_WIDTH_2 ($DATA_WIDTH_2)
) adder_$block_name (
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

   data_width = 8
   clk = Signal(bool(0))
   data1_i, data2_i = [Signal(intbv(0)[data_width:]) for i in range(2)]
   data_o = Signal(intbv(0)[data_width+1:])

   toVerilog(adder_wrapper, block_name="inst", clk=clk, data1_i=data1_i, data2_i=data2_i, data_o=data_o, DATA_WIDTH_1=data_width, DATA_WIDTH_2=data_width)


if __name__ == "__main__":
   convert()

