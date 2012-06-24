#==============================================================================#
#                                                                              # 
#      core_info generator                                                     # 
#                                                                              # 
#      Module name: gen_core_info                                              # 
#      Desc: Builds a list of devices on the bus and writes the memory         #
#      allocation out to the core_info.tab file to be used when creating the   #
#      bof file                                                                # 
#      Date: Jan 2012                                                          # 
#      Developer: Wesley New                                                   # 
#      Licence: GNU General Public License ver 3                               # 
#      Notes:                                                                  # 
#                                                                              # 
#==============================================================================#

import os

class gen_core_info():
   
   #==================================
   # Opens core_info.tab for writing
   #==================================
   def __init__(self):
      self.core_info_file = open("core_info.tab", "w")
      self.device_list = []
      print "opening core_info.tab for writing"

   #============================
   # Adds a device to the list
   #============================
   def add_device(self, name, wr_flag, offset, width, interrupt):
      self.device_list.append([name, wr_flag, offset, width, interrupt])
      print "adding device to core_info"

   #====================================
   # Checks for the memory allocations
   #====================================
   def _rule_check(self):
      for i in range(len(self.device_list)-1):
         #if int(self.device_list[i][3]) > int(self.device_list[i+1][j]) 
         print self.device_list[i]
      print "checking rules"
      
   #================================================
   # Writes the list out to the core_info.tab file
   #================================================
   def gen_core_info(self):
      self._rule_check()
      for i in range(len(self.device_list)):
         self.core_info_file.write(" ".join(self.device_list[i]) + "\n")
      self.core_info_file.close()
      print "generating core_info.tab"

