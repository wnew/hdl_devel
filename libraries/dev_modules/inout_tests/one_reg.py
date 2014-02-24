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

def one_reg(block_name,
      #========
      # Ports
      #========
      clk,
      we,
      data,
   ):

   data_driver   = Signal(intbv(0)[32:])
   data_receiver = Signal(intbv(0)[32:])

   #===================
   # Simulation Logic
   #===================
   @always(clk.posedge)
   def logic():
      if we == 1:
         data.next = data_driver
      else:
         data_receiver.next = data

   # removes warning when converting to hdl
   #data.driven = "wire"

   return logic

#=======================================
# For testing of conversion to verilog
#=======================================
def convert():

   clk, we = [Signal(bool(0)) for i in range(2)]
   data    =  TristateSignal(intbv(0)[32:]) 
   toVerilog(one_reg, block_name="inst", clk=clk, we=we, data=data)


if __name__ == "__main__":
   convert()

