class wishbone:
   
   def __init__ (self):
      self.current_addr = 31   # the first 32 address are reserved for the intrustructure modules
      self.bus_modules  = []
      self.bus_modules.append("infr")
      self.bus_addrs    = []
      self.bus_addrs.append (31)

   def add_device (self, module_name, module_addr_width):
      self.bus_modules.append (module_name)
      self.bus_addrs.append   (self.bus_addrs[len(self.bus_addrs)-1] + module_addr_width)
      return self.bus_addrs[len(self.bus_addrs)-1] 

   def print_devices (self):
      for i in self.bus_addrs:
         print i
      for i in self.bus_modules:
         print i

