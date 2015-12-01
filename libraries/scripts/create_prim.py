import os

f = open("iic_infrastructure", "r")
contents = f.read().split()

name = ""
params = []
ports  = []


count = 0

for i in contents:
   
   if count == 1 and i <> "ports":
      params.append(i)

   if count == 2:
      ports.append(i)
      
   if count == 0:
      name = i
      count = 1
            
   if i == "ports":
      count = 2
      ports = []

   if i == "params":
      count = 1
      params = []


#=============================
# create python wrapper file
#=============================

g = open(name + ".py", "w")

g.write("from myhdl import *\n\n")
g.write("def " + name + "_wrapper (block_name,\n\n")
g.write("      #========\n")
g.write("      # Ports\n")
g.write("      #========\n")

str_list = ""
for i in ports:
   str_list = str_list + "      " + i + ",\n"

g.write(str_list)

g.write("\n      #=============\n")
g.write("      # Parameters\n")
g.write("      #=============\n")

for i in params:
   g.write("      " + i + " = 0,\n")
str_list = str_list[:-2]

g.write("   ):\n\n")

g.write("   #===================\n")
g.write("   # Simulation Logic\n")
g.write("   #===================\n")
g.write("   @always(CLK)\n")
g.write("   def logic():\n")
g.write("      pass\n\n")
g.write("   return logic\n\n")

g.write("#======================\n")
g.write("# " + name + " Instantiation\n")
g.write("#======================\n")
g.write(name + "_wrapper.verilog_code = \\\n")
g.write("\"\"\"\n")
g.write(name + "\n")
g.write("#(\n")


str_list = ""
for i in params:
   str_list = str_list + "   ." + i + "($" + i + "),\n" 
str_list = str_list[:-2]

g.write(str_list)

g.write("\n) " + name + "_$block_name (\n")

str_list = ""
for i in ports:
   str_list = str_list + "   ." + i + "($" + i + "),\n" 
str_list = str_list[:-2]

g.write(str_list)

g.write("\n);\n")

g.write("\"\"\"\n\n")

g.write("#=======================================\n")
g.write("# For testing of conversion to verilog\n")
g.write("#=======================================\n")

g.write("def convert():\n\n")

str_list = ""
for i in ports:
   str_list = str_list + i + ", "

str_list = str_list[:-2]

g.write("   " + str_list + " = [Signal(bool(0)) for i in range(" + str(len(ports)) + ")]\n\n")

str_list = ""
for i in ports:
   str_list = str_list + i + " = " + i + ", \n      "

str_list = str_list[:-9]

g.write("   toVerilog(" + name + "_wrapper, block_name=\"inst\", " + str_list + ")\n\n")


g.write("if __name__ == \"__main__\":\n")
g.write("   convert()\n")

g.close()
