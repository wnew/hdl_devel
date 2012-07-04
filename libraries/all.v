//================
//   Primitives
//================
`include "libraries/primitives/bram/bram_sync_sp.v"
`include "libraries/primitives/bram/bram_sync_dp.v"
`include "libraries/primitives/gray_convert/gray2binary.v"
`include "libraries/primitives/gray_convert/binary2gray.v"
`include "libraries/primitives/mux/mux.v"
`include "libraries/primitives/multiplier/multiplier.v"
`include "libraries/primitives/delay/delay.v"
`include "libraries/primitives/delay/fifo_delay.v"
`include "libraries/primitives/delay/sync_delay.v"
`include "libraries/primitives/adder/adder.v"
`include "libraries/primitives/bit_reorder/bit_reorder.v"
`include "libraries/primitives/counter/counter.v"
`include "libraries/primitives/fifo/fifo.v"
`include "libraries/primitives/bit_shift/bit_shift.v"
`include "libraries/primitives/slice/slice.v"
`include "libraries/primitives/bram/bram_sync_sp.v"
`include "libraries/primitives/bram/bram_sync_dp.v"
`include "libraries/primitives/gray_counter/gray_counter.v"
//================
//   Contollers
//================
`include "libraries/controllers/kat_adc/iic_controller/miic_ops.v"
`include "libraries/controllers/kat_adc/iic_controller/rx_fifo.v"
`include "libraries/controllers/kat_adc/iic_controller/iic_wb_controller.v"
`include "libraries/controllers/kat_adc/iic_controller/wb_attach.v"
`include "libraries/controllers/kat_adc/iic_controller/cpu_op_fifo.v"
`include "libraries/controllers/kat_adc/iic_controller/fab_op_fifo.v"
`include "libraries/controllers/kat_adc/iic_controller/gain_set.v"
`include "libraries/controllers/kat_adc/interface/adc_async_fifo.v"
`include "libraries/controllers/kat_adc/interface/kat_adc_interface.v"
`include "libraries/controllers/bram_wb/bram_wb.v"
`include "libraries/controllers/sw_reg/sw_reg_r.v"
`include "libraries/controllers/sw_reg/sw_reg_wr.v"
//================
//   DSP Blocks
//================
`include "libraries/dsp_blocks/decimator/decimator.v"
