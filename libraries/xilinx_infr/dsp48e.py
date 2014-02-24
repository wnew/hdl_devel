#==============================================================================#
#                                                                              #
#      dsp48e wrapper and simulation model                                     #
#                                                                              #
#      Module name: dsp48e_wrapper                                             #
#      Desc: wraps the xilinx dsp48 in Python and provides a model for         #
#            simulation                                                        #
#      Date: June 2012                                                         #
#      Developer: Wesley New                                                   #
#      Licence: GNU General Public License ver 3                               #
#      Notes:                                                                  #
#                                                                              #
#==============================================================================#

from myhdl import *

def dsp48e_wrapper (block_name,
      #========
      # Ports
      #========
      i, # input
      o, # output
   ):

   #===================
   # Simulation Logic
   #===================
   @always(i.posedge and i.negedge)
   def logic():
      o.next = i


   # removes warning when converting to hdl
   o.driven = "wire"

   return logic

#======================
# BUFG Instantiation
#======================
dsp48e_wrapper.verilog_code = \
"""
DSP48E
#(
   .ACASCREG                        (1),                // Number of pipeline registers between A/ACIN input and ACOUT output, 0, 1, or 2
   .ALUMODEREG                      (1),                // Number of pipeline registers on ALUMODE input, 0 or 1
   .AREG                            (1),                // Number of pipeline registers on the A input, 0, 1 or 2
   .AUTORESET_PATTERN_DETECT        ("FALSE"),          // Auto-reset upon pattern detect, "TRUE" or "FALSE"
   .AUTORESET_PATTERN_DETECT_OPTINV ("MATCH"),          // Reset if "MATCH" or "NOMATCH"
   .A_INPUT                         ("DIRECT"),         // Selects A input used, "DIRECT" (A port) or "CASCADE" (ACIN port)
   .BCASCREG                        (1),                // Number of pipeline registers between B/BCIN input and BCOUT output, 0, 1, or 2
   .BREG                            (1),                // Number of pipeline registers on the B input, 0, 1 or 2
   .B_INPUT                         ("DIRECT"),         // Selects B input used, "DIRECT" (B port) or "CASCADE" (BCIN port)
   .CARRYINREG                      (1),                // Number of pipeline registers for the CARRYIN input, 0 or 1
   .CARRYINSELREG                   (1),                // Number of pipeline registers for the CARRYINSEL input, 0 or 1
   .CREG                            (1),                // Number of pipeline registers on the C input, 0 or 1
   .MASK                            (48'h3fffffffffff), // 48-bit Mask value for pattern detect
   .MREG                            (1),                // Number of multiplier pipeline registers, 0 or 1
   .MULTCARRYINREG                  (1),                // Number of pipeline registers for multiplier carry in bit, 0 or 1
   .OPMODEREG                       (1),                // Number of pipeline registers on OPMODE input, 0 or 1
   .PATTERN                         (48'h000000000000), // 48-bit Pattern match for pattern detect
   .PREG                            (1),                // Number of pipeline registers on the P output, 0 or 1
   .SEL_MASK                        ("MASK"),           // Select mask value between the "MASK" value or the value on the "C" port
   .SEL_PATTERN                     ("PATTERN"),        // Select pattern value between the "PATTERN" value or the value on the "C" port
   .SEL_ROUNDING_MASK               ("SEL_MASK"),       // "SEL_MASK", "MODE1", "MODE2"
   .USE_MULT                        ("MULT_S"),         // Select multiplier usage, "MULT" (MREG => 0), "MULT_S" (MREG => 1), "NONE" (not using multiplier)
   .USE_PATTERN_DETECT              ("NO_PATDET"),      // Enable pattern detect, "PATDET", "NO_PATDET"
   .USE_SIMD                        ("ONE48")           // SIMD selection, "ONE48", "TWO24", "FOUR12"
) DSP48E_$block_name (
   .ACOUT                           (ACOUT),            // 30-bit A port cascade output
   .BCOUT                           (BCOUT),            // 18-bit B port cascade output
   .CARRYCASCOUT                    (CARRYCASCOUT),     // 1-bit cascade carry output
   .CARRYOUT                        (CARRYOUT),         // 4-bit carry output
   .MULTSIGNOUT                     (MULTSIGNOUT),      // 1-bit multiplier sign cascade output
   .OVERFLOW                        (OVERFLOW),         // 1-bit overflow in add/acc output
   .P                               (P),                // 48-bit output
   .PATTERNBDETECT                  (PATTERNBDETECT),   // 1-bit active high pattern bar detect output
   .PATTERNDETECT                   (PATTERNDETECT),    // 1-bit active high pattern detect output
   .PCOUT                           (PCOUT),            // 48-bit cascade output
   .UNDERFLOW                       (UNDERFLOW),        // 1-bit active high underflow in add/acc output
   .A                               (A),                // 30-bit A data input
   .ACIN                            (ACIN),             // 30-bit A cascade data input
   .ALUMODE                         (ALUMODE),          // 4-bit ALU control input
   .B                               (B),                // 18-bit B data input
   .BCIN                            (BCIN),             // 18-bit B cascade input
   .C                               (C),                // 48-bit C data input
   .CARRYCASCIN                     (CARRYCASCIN),      // 1-bit cascade carry input
   .CARRYIN                         (CARRYIN),          // 1-bit carry input signal
   .CARRYINSEL                      (CARRYINSEL),       // 3-bit carry select input
   .CEA1                            (CEA1),             // 1-bit active high clock enable input for 1st stage A registers
   .CEA2                            (CEA2),             // 1-bit active high clock enable input for 2nd stage A registers
   .CEALUMODE                       (CEALUMODE),        // 1-bit active high clock enable input for ALUMODE registers
   .CEB1                            (CEB1),             // 1-bit active high clock enable input for 1st stage B registers
   .CEB2                            (CEB2),             // 1-bit active high clock enable input for 2nd stage B registers
   .CEC                             (CEC),              // 1-bit active high clock enable input for C registers
   .CECARRYIN                       (CECARRYIN),        // 1-bit active high clock enable input for CARRYIN register
   .CECTRL                          (CECTRL),           // 1-bit active high clock enable input for OPMODE and carry registers
   .CEM                             (CEM),              // 1-bit active high clock enable input for multiplier registers
   .CEMULTCARRYIN                   (CEMULTCARRYIN),    // 1-bit active high clock enable for multiplier carry in register
   .CEP                             (CEP),              // 1-bit active high clock enable input for P registers
   .CLK                             (CLK),              // Clock input
   .MULTSIGNIN                      (MULTSIGNIN),       // 1-bit multiplier sign input
   .OPMODE                          (OPMODE),           // 7-bit operation mode input
   .PCIN                            (PCIN),             // 48-bit P cascade input
   .RSTA                            (RSTA),             // 1-bit reset input for A pipeline registers
   .RSTALLCARRYIN                   (RSTALLCARRYIN),    // 1-bit reset input for carry pipeline registers
   .RSTALUMODE                      (RSTALUMODE),       // 1-bit reset input for ALUMODE pipeline registers
   .RSTB                            (RSTB),             // 1-bit reset input for B pipeline registers
   .RSTC                            (RSTC),             // 1-bit reset input for C pipeline registers
   .RSTCTRL                         (RSTCTRL),          // 1-bit reset input for OPMODE pipeline registers
   .RSTM                            (RSTM),             // 1-bit reset input for multiplier registers
   .RSTP                            (RSTP),             // 1-bit reset input for P pipeline registers
);
"""

#=======================================
# For testing of conversion to verilog
#=======================================
def convert():
   i, o = [Signal(bool(0)) for i in range(2)]
   toVerilog(dsp48e_wrapper, "buf", i, o)

if __name__ == "__main__":
   convert()
