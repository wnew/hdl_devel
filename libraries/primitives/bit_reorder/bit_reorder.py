#==============================================================================#
#                                                                              # 
#      Bit Reorderer wrapper and simulation model                              # 
#                                                                              # 
#      Module name: bit_reorder_wrapper                                        # 
#      Desc: wraps the verilog bit reorder and provides a model for simulation # 
#      Date: June 2012                                                         # 
#      Developer: Wesley New                                                   # 
#      Licence: GNU General Public License ver 3                               # 
#      Notes:                                                                  # 
#                                                                              # 
#==============================================================================#

from myhdl import *

def bit_reorder_wrapper(block_name,
      #========
      # Ports
      #========
      clk,
      en,
      vector_in,
      vector_out,

      #=============
      # Parameters
      #=============
      ARCHITECTURE = "BEHAVIORAL",
      DATA_WIDTH   = 32,
      BIT0         = 0,
      BIT1         = 1,
      BIT2         = 2,
      BIT3         = 3,
      BIT4         = 4,
      BIT5         = 5,
      BIT6         = 6,
      BIT7         = 7,
      BIT8         = 8,
      BIT9         = 9,
      BIT10        = 10,
      BIT11        = 11,
      BIT12        = 12,
      BIT13        = 13,
      BIT14        = 14,
      BIT15        = 15,
      BIT16        = 16,
      BIT17        = 17,
      BIT18        = 18,
      BIT19        = 19,
      BIT20        = 20,
      BIT21        = 21,
      BIT22        = 22,
      BIT23        = 23,
      BIT24        = 24,
      BIT25        = 25,
      BIT26        = 26,
      BIT27        = 27,
      BIT28        = 28,
      BIT29        = 29,
      BIT30        = 30,
      BIT31        = 31 
   ):

   #===================
   # Simulation Logic
   #===================
   
   @always(clk.posedge)
   def logic():
      pass
   # removes warning when converting to hdl
   vector_out.driven = "wire"

   return logic

#==============================
# Bit Reorderer Instantiation
#==============================
bit_reorder_wrapper.verilog_code = \
"""
bit_reorder 
#(
   .ARCHITECTURE ("$ARCHITECTURE"),
   .DATA_WIDTH   ($DATA_WIDTH),
) bit_reorder_$block_name (
   .clk  ($clk),
   .en   ($en),
   .in   ($vector_in),
   .out  ($vector_out)
);
"""


#=======================================
# For testing of conversion to verilog
#=======================================
def convert():

   clk, en, vector_in, vector_out = [Signal(bool(0)) for i in range(4)]

   toVerilog(bit_reorder_wrapper, block_name="", clk=clk, en=en, vector_in=vector_in, vector_out=vector_out)


if __name__ == "__main__":
   convert()

