from myhdl import *

class WishboneDeviceRegister():
    def __init__(self, lreg, Offset, Name=""):
        self.lreg = lreg
        self.offset = Offset
        self.name = Name

    def AddDescription(self, desc):
        """Add registers description/documentation"""
        self.desc = desc

    def AddBits(self, bitName, bit):
        """Add a short-cut to the bit"""
        assert isinstance(bitName, str)
        if not self.__dict__.has_key(bitName):
            self.__dict__[bitName] = bit
            #self.bits.append
    
class WishboneDevice():
    def __init__(self, dat_o, ack, BaseAddr=0, Name=""):
        self.BaseAddr = BaseAddr
        self.dat_o = dat_o
        self.ack = ack
        self.registers = []
        self.name = Name

class WishboneController():
    def __init__(self, Name=""):
        self.name = Name
        
class Wishbone():

    def __init__(self, DataWidth=8, AddressWidth=16):
        self.DataWidth = DataWidth
        self.AddressWidth = AddressWidth
        self.clk = Signal(False)
        self.rst = Signal(False)
        self.cyc = Signal(False)
        self.stb = Signal(False)
        self.adr = Signal(intbv(0)[AddressWidth:])
        self.we = Signal(False)
        self.sel = Signal(intbv(0)[int(DataWidth/8)])
        self.ack = Signal(False)
        
        # The data buses are a slightly special case.  The
        # dat_o is broadcast to a the device (peripherals) 
        # and dat_i is an or of all the device buses.  This 
        # class will have a generator that will or all the buses
        # together.
        self.dat_i = Signal(intbv(0)[DataWidth:])
        self.dat_o = Signal(intbv(0)[DataWidth:])
        self.devices = []
        self.AddrDelta = 0x100

        # @todo: should do the same thing for multiple controllers,
        #        currently only 1 controller supported.

    
    def DeviceBusses(self):
        """
        After all devices/peripherals have been added this function should
        be called to get the generator that 'or's together all the device
        busses.
        """
        clk = self.clk
        dat_i = self.dat_i
        ack = self.ack
        dev_acks = [self.devices[ii].ack for ii in range(len(self.devices))]
        dev_dats = [self.devices[ii].dat_o for ii in range(len(self.devices))]

        # @todo: brain-dead.  Need to come up with the general solution
        @always_comb
        def hdl_or_combine():
            #dat_i.next = 0
            #ack.next = False
            #for ii in range(len(self.devices)):
            #    dat_i.next = dat_i or dev_dats[ii]
            #    ack.next = ack or dev_acks[ii]
            dat_i.next = dev_dats[0] | dev_dats[1] | dev_dats[2] | dev_dats[3] | \
                         dev_dats[4] | dev_dats[5] | dev_dats[6] | dev_dats[7]

            ack.next = dev_acks[0] | dev_acks[1] | dev_acks[2] | dev_acks[3] | \
                       dev_acks[4] | dev_acks[5] | dev_acks[6] | dev_acks[7]
                         
        ack0,ack1,ack2,ack3,ack4,ack5,ack6,ack7 = [Signal(False) for ii in range(8)]
        dat0,dat1,dat2,dat3,dat4,dat5,dat6,dat7 = [Signal(intbv(0)[8:]) for ii in range(8)]

        @always_comb
        def hdl_debug_monitor():
            ack0.next = dev_acks[0]
            ack1.next = dev_acks[1]
            ack2.next = dev_acks[2]
            ack3.next = dev_acks[3]
            ack4.next = dev_acks[4]
            ack5.next = dev_acks[5]
            ack6.next = dev_acks[6]
            ack7.next = dev_acks[7]

            dat0.next = dev_dats[0]
            dat1.next = dev_dats[1]
            dat2.next = dev_dats[2]
            dat3.next = dev_dats[3]
            dat4.next = dev_dats[4]
            dat5.next = dev_dats[5]
            dat6.next = dev_dats[6]
            dat7.next = dev_dats[7]
            
        return hdl_or_combine, hdl_debug_monitor


    def AddDevice(self, BaseAddress=None, Name=""):
        nextBus = Signal(intbv(0)[self.DataWidth:])
        nextAck = Signal(False)
        
        if BaseAddress is not None:
            nextAdr = BaseAddress
        else:
            if len(self.devices) > 0:
                nextAdr = self.AddrDelta+self.devices[-1].BaseAddr
            else:
                nextAdr = 0
                
        wbdev = WishboneDevice(nextBus, nextAck, nextAdr, Name)
        self.devices.append(wbdev)
        
        return wbdev

    
    def AddDeviceRegister(self, rin, rout, wbdev, Offset=0, ReadOnly=False):
        lreg = Signal(intbv(0)[self.DataWidth:])
        wbreg = WishboneDeviceRegister(lreg, Offset) # @todo : calculate offset
        wbdev.registers.append(wbreg)
        clk,rst,cyc,stb,adr,we,sel,ack,dat_i,dat_o = (self.clk,self.rst,self.cyc,self.stb,
                                                      self.adr,self.we,self.sel,wbdev.ack,
                                                      self.dat_o,wbdev.dat_o)

        selected = Signal(False)
        BaseAddr = wbdev.BaseAddr
        @always_comb
        def hdl_decode():
            if cyc and stb and (adr == BaseAddr+Offset):
                selected.next = True
            else:
                selected.next = False
                
        @always(clk.posedge)
        def hdl_wb_register():
            if not rst:
                dat_o.next = 0
                lreg.next = 0
            else:
                if selected:
                    ack.next = True
                    if we:
                        lreg.next = dat_i
                        dat_o.next = 0
                    else:
                        if ReadOnly:
                            dat_o.next = rin
                        else:
                            dat_o.next = lreg
                else:
                    dat_o.next = 0
                    ack.next = False


        @always_comb
        def hdl_assigns():
            rout.next = lreg
            
        return hdl_decode, hdl_wb_register, hdl_assigns
    
    def GetDeviceSignals(self, wbdev):
        return (self.clk, self.rst, self.cyc, self.stb,
                self.adr, self.we, self.sel, self.ack, self.dat_i, wbdev.dat_o)

    def AddController(self):
        pass

    def GetControllerSignals(self, wbctlr=None):
        return (self.clk, self.rst, self.cyc, self.stb,
                self.adr, self.we, self.sel, self.ack, self.dat_i, self.dat_o)

    def Summary(self):
        """ Create a string with the summary of the configured bus"""
        summary = ""
        for dev in self.devices:
            summary += "%s @ address 0x%04X\n" % (dev.name, dev.BaseAddr)
            for reg in dev.registers:
                summary += "  registers %s @ offset %d\n" % (reg.name, reg.offset)

        return summary
