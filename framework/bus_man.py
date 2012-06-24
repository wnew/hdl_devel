import gen_core_info

class bus_management:
   
   def __init__(self, coreinfo_dir = "."):
      self.module_list = []
      self.core_info = gen_core_info.gen_core_info()

   def gen_bus_mem(self):
      base_addr = 0
      high_addr = 0
      for i in range(len(self.module_list)):
         if self.module_list[i]._bus_interface == "wishbone":
            base_addr = high_addr
            high_addr = high_addr + 32*int(self.module_list[i]._wb_mem_addrs)  
            self.module_list[i].wb_base_addr = base_addr
            self.module_list[i].wb_high_addr = high_addr
            self.core_info.add_device(self.module_list[i].device_name,
                                      "1",
                                      str(base_addr), 
                                      str(high_addr),
                                      self.module_list[i].has_interrupt)
      self.core_info.gen_core_info()

