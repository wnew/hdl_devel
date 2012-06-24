class config:
   """ The configuration settings for a myhdl design """
  
   fpga_device = ""
   clk_doms    = []

   fpga_vendor_list   = ["xilinx", "altera"]
   fpga_device_list   = ["virtex5", "virtex6"]
   
   r1_fpga = ['xilinx virtex5']
   r2_fpga = ['xilinx virtex6']
   r1_clks = ['sys_clk', 'sys_2x_clk', 'aux_clk', 'arb_clk', 'adc1_clk', 'adc2_clk']
   r2_clks = ['sys_clk', 'sys_2x_clk', 'aux_clk', 'arb_clk', 'adc1_clk', 'adc2_clk']
   r1_bus  = ['opb']
   r2_bus  = ['wishbone']
   r1 = {'fpga':r1_fpga, 'clks':r1_clks, 'bus':r1_bus}
   r2 = {'fpga':r2_fpga, 'clks':r2_clks, 'bus':r2_bus}
   hw_plats = {"roach":r1, "roach2":r2}
   
   
   def __init__(self, hw_plat, clk_doms):
      self.hw_plat  = hw_plat
      self.clk_doms = clk_doms # list of clocks each of which is a clock domain
   

   def config_check(self):
      if self.hw_plat not in self.hw_plats:
         print self.hw_plat + "is not supported"
         return False
      for i in range(len(self.clk_doms)):
         if self.clk_doms[i] not in self.hw_plats[self.hw_plat]['clks']:
            return False
      return True

