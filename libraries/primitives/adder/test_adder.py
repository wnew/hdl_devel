from myhdl import *
from adder import *

def gen_sim():

    runtime = 50
    output = []
    clk = Signal(intbv(0))
    test_data1_i = Signal(intbv(0))
    test_data2_i = Signal(intbv(0))
    test_data_o  = Signal(intbv(0))
    
    dut = adder_wrapper("multi1", data1_i = test_data1_i, data2_i = test_data2_i, data_o = test_data_o)
    
    def test(clk, data1_i, data2_i, data_o):
        # set initial values
        @instance
        def initial():
            test_data1_i.next = intbv(4)
            test_data2_i.next = intbv(5)
            yield delay(0)
    
        # drive the clock
        @always(delay(1))
        def drive_clk():
            clk.next = not clk
    
        # monitor output
        @instance
        def monitor():
            while True:
                yield clk.posedge
                test_data1_i.next = test_data1_i+1
                output.append(int(test_data_o))
    
        return initial, drive_clk, monitor#, stop_sim


    check = test(clk, data1_i = test_data1_i, data2_i = test_data2_i, data_o = test_data_o)
    sim = Simulation(check, dut)
    sim.run(runtime)
    
    return output

if __name__ == "__main__":
    print gen_sim()
