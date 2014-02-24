from myhdl import *
import counter.counter       as counter
import multiplier.multiplier as multiplier
import adder.adder           as adder

def toplevel(
    clk,
    data_out
):
   
   count_out = Signal(intbv(0)[32:])
   
   cntr = counter.counter_wrapper(
      block_name = "1",
      COUNT_FROM = "0",
      COUNT_TO   = "1024",
      DATA_WIDTH = "32",
      clk        = clk,
      en         = 1,
      rst        = 0,
      out        = count_out
   )

   @always_comb
   def logic():
      data_out.next = count_out[32:0]

   return cntr



def convert():
   
   toVerilog(
      toplevel,
      clk,
      data_out
   )


if __name__ == "__main__":
   #convert()

   clk = Signal(bool(0))
   data_out = Signal(intbv(0)[32:])

   gen = toplevel(clk,data_out)
   sim = Simulation(gen)
   sim.run(30)

