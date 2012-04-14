from myhdl import *
import mux

out = Signal(intbv(0))

inst = mux.mux_wrapper("mux_inst",select=intbv(1),data_in=intbv(10),data_out=out,DATA_WIDTH=32,SELECT_LINES=5)
sim = Simulation(inst)
sim.run(10)

print out

