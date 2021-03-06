#==============================================================================#
#                                                                              # 
#      Slice wrapper and simulation model                                      # 
#                                                                              # 
#      Module name: slice_wrapper                                              # 
#      Desc: wraps the verilog slice module and provides  simulation model     # 
#      Date: Nov 2011                                                          # 
#      Developer: Wesley New                                                   # 
#      Licence: GNU General Public License ver 3                               # 
#      Notes:                                                                  # 
#                                                                              # 
#==============================================================================#

from myhdl import *

def slice_wrapper(block_name,
      #========
      # Ports
      #========
      clk,
      data_in,
      data_out,
      
      #=============
      # Parameters
      #=============
      ARCHITECTURE="BEHAVIORAL",
      INPUT_DATA_WIDTH=8,
      OFFSET_REL_TO_MSB=1,
      OFFSET_1=0,
      OFFSET_2=7
   ):
   
   #===================
   # Simulation Logic
   #===================
   @always(clk.posedge)
   def logic():
      if OFFSET_REL_TO_MSB:
         data_out.next = data_in[OFFSET_2:OFFSET_1]
      else:
         data_out.next = data_in[OFFSET_1:OFFSET_2]


   # removes warning when converting to hdl
   data_out.driven = "wire"

   return logic
   

#==============================
# Slice Verilog Instantiation
#==============================
slice_wrapper.verilog_code = \
"""
slice 
#(
   .ARCHITECTURE      ($ARCHITECTURE),
   .INPUT_DATA_WIDTH  ($INPUT_DATA_WIDTH),
   .OFFSET_REL_TO_MSB ($OFFSET_REL_TO_MSB),
   .OFFSET_1          ($OFFSET_1),
   .OFFSET_2          ($OFFSET_2)
) slice_$block_name (
   .clk      ($clk),
   .data_in  ($data_in),
   .data_out ($data_out)
);
"""

#=======================================
# For testing of conversion to verilog
#=======================================
def convert():

  clk, data_in, data_out = [Signal(bool(0)) for i in range(3)]

  toVerilog(slice_wrapper, block_name="slice2", clk=clk, data_in=data_in, data_out=data_out)


if __name__ == "__main__":
   convert()

