#==============================================================================#
#                                                                              # 
#      Software Register wrapper and simulation model                          # 
#                                                                              # 
#      Module name: wbs_module_wrapper                                           # 
#      Desc: wraps the verilog wbs_module and provides a model for simulation    # 
#      Date: Jan 2012                                                          # 
#      Developer: Wesley New                                                   # 
#      Licence: GNU General Public License ver 3                               # 
#      Notes:                                                                  # 
#                                                                              # 
#==============================================================================#

from myhdl    import *
from wishbone import Wishbone

class wbs_module:

   def wbs_module_wrapper(self,
         #===============
         # fabric ports
         #===============
         fabric_clk,
         fabric_data_in,
   
         #=========
         # wb bus 
         #=========
         wb
      ):
      
      rin   = Signal(intbv(0)[8:])
      rout  = Signal(intbv(0)[8:])
      wbdev = wb.AddDevice(Name="wbs_module")
      iReg  = wb.AddDeviceRegister(rin, rout, wbdev)

      # the conversion of user defined code does not currently support self.
      # so this is a hack until support for this is implemented.
      lbus = wb.AddController()
      clk, rst, cyc, stb, adr, we, sel, ack, dat_i, dat_o = wb.GetControllerSignals(lbus)
      print wb.GetControllerSignals()
      print wb.Summary()

      #========================
      # TODO:Simulation Logic
      #========================
      @always(wb.clk.posedge)
      def logic():
         temp = 1
      
      return iReg, logic
  

   #========================
   # Counter Instantiation
   #========================
   # as an attribute on the wrapper function
   wbs_module_wrapper.verilog_code = \
   """
   wbs_module
   #(
      .C_BUS_DATA_WIDTH (32), 
      .C_BUS_ADDR_WIDTH (2) 
   ) wbs_module_inst (
     
      .fabric_clk     ($fabric_clk),
      .fabric_data_in ($fabric_data_in),
                                       
      .wbs_clk_i       ($clk),
      .wbs_rst_i       ($rst),
      .wbs_cyc_i       ($cyc),
      .wbs_stb_i       ($stb),
      .wbs_we_i        ($we),
      .wbs_sel_i       ($sel),
      .wbs_adr_i       ($adr),
      .wbs_dat_i       ($dat_i),

      .wbs_dat_o       ($dat_o),
      .wbs_ack_o       ($ack),
      .wbs_err_o       (0)
   );
   """


#=======================================
# For testing of conversion to verilog
#=======================================
def convert():

   wb = Wishbone(DataWidth=32, AddressWidth=8)
   
   x = wbs_module()

   (fabric_clk, fabric_data_in) = [Signal(bool(0)) for i in range(2)]

   toVerilog(x.wbs_module_wrapper, 
             fabric_clk     = fabric_clk, 
             fabric_data_in = fabric_data_in,
             wb             = wb)

   iBus = wb.DeviceBusses()
   print iBus
   

if __name__ == "__main__":
   convert()
   
