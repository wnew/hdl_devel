from myhdl import *

def sys_block_wrapper(block_name,
      wbs_clk_i,
      wbs_rst_i,
      wbs_cyc_i,
      wbs_stb_i,
      wbs_we_i,
      wbs_sel_i,
      wbs_adr_i,
      wbs_dat_i,
      wbs_dat_o,
      wbs_ack_o,
      wbs_err_o,
      BOARD_ID="0",
      REV_MAJ="0",
      REV_MIN="0",
      REV_RCS="0"
   ):

   @always(wbs_clk_i.posedge)
   def logic():
      pass 

   __verilog__ = \
   """
   sys_block
   #(
      .BOARD_ID (%(BOARD_ID)s),
      .REV_MAJ  (%(REV_MAJ)s),
      .REV_MIN  (%(REV_MIN)s),
      .REV_RCS  (%(REV_RCS)s)
   ) sys_block_%(block_name)s (
      .wbs_clk_i (%(wbs_clk_i)s), 
      .wbs_rst_i (%(wbs_rst_i)s),
      .wbs_cyc_i (%(wbs_cyc_i)s),
      .wbs_stb_i (%(wbs_stb_i)s),
      .wbs_we_i  (%(wbs_we_i)s),
      .wbs_sel_i (%(wbs_sel_i)s),
      .wbs_adr_i (%(wbs_adr_i)s),
      .wbs_dat_i (%(wbs_dat_i)s),
      .wbs_dat_o (%(wbs_dat_o)s),
      .wbs_ack_o (%(wbs_ack_o)s),
      .wbs_err_o (%(wbs_err_o)s)
   );
   """
   
   wbs_dat_o.driven  = "wire"
   wbs_ack_o.driven  = "wire"
   wbs_err_o.driven  = "wire"

   return logic

def convert():
   wbs_clk_i, wbs_rst_i, wbm_cyc_i, wbm_stb_i, wbm_we_i, wbm_sel_i, wbm_adr_i, wbm_dat_i, wbm_dat_o, wbm_ack_o, wbm_err_o, = [Signal(bool(0))for i in range(11)]

   toVerilog(sys_block_wrapper, "inst", wbs_clk_i, wbs_rst_i, wbm_cyc_i, wbm_stb_i, wbm_we_i, wbm_sel_i, wbm_adr_i, wbm_dat_i, wbm_dat_o, wbm_ack_o, wbm_err_o)

if __name__ == "__main__":
   convert()

