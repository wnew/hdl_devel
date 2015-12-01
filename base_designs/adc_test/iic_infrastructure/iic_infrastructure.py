from myhdl import *

def iic_infrastructure_wrapper (block_name,

      #========
      # Ports
      #========
      sda_i,
      sda_o,
      sda_t,
      scl_i,
      scl_o,
      scl_t,
      sda,
      scl

      #=============
      # Parameters
      #=============
   ):

   #===================
   # Simulation Logic
   #===================
   @always(sda_i)
   def logic():
      pass

   return logic

#======================
# iic_infrastructure Instantiation
#======================
iic_infrastructure_wrapper.verilog_code = \
"""
iic_infrastructure
#(

) iic_infrastructure_$block_name (
   .sda_i ($sda_i),
   .sda_o ($sda_o),
   .sda_t ($sda_t),
   .scl_i ($scl_i),
   .scl_o ($scl_o),
   .scl_t ($scl_t),
   .sda   ($sda),
   .scl   ($scl)
);
"""

#=======================================
# For testing of conversion to verilog
#=======================================
def convert():

   sda_i, sda_o, sda_t, scl_i, scl_o, scl_t, sda, scl = [Signal(bool(0)) for i in range(8)]

   toVerilog(iic_infrastructure_wrapper, block_name="inst", 
      sda_i = sda_i, 
      sda_o = sda_o, 
      sda_t = sda_t, 
      scl_i = scl_i, 
      scl_o = scl_o, 
      scl_t = scl_t, 
      sda = sda, 
      scl = scl
   )

if __name__ == "__main__":
   convert()
