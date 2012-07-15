`define testbenches

//================
//   Primitives
//================
`include "primitives/bram/bram_sync_sp.v"
`include "primitives/bram/bram_sync_dp.v"
`include "primitives/gray_convert/gray2binary.v"
`include "primitives/gray_convert/binary2gray.v"
`include "primitives/mux/mux.v"
`include "primitives/multiplier/multiplier.v"
`include "primitives/delay/delay.v"
`include "primitives/delay/fifo_delay.v"
`include "primitives/delay/sync_delay.v"
`include "primitives/adder/adder.v"
`include "primitives/bit_reorder/bit_reorder.v"
`include "primitives/counter/counter.v"
`include "primitives/fifo/fifo.v"
`include "primitives/bit_shift/bit_shift.v"
`include "primitives/slice/slice.v"
`include "primitives/bram/bram_sync_sp.v"
`include "primitives/bram/bram_sync_dp.v"
`include "primitives/gray_counter/gray_counter.v"
`ifdef testbenches
`include "primitives/bram/bram_sync_sp_tb.v"
`include "primitives/bram/bram_sync_dp_tb.v"
`include "primitives/gray_convert/gray2binary_tb.v"
`include "primitives/gray_convert/binary2gray_tb.v"
`include "primitives/mux/mux_tb.v"
`include "primitives/multiplier/multiplier_tb.v"
`include "primitives/delay/delay_tb.v"
`include "primitives/adder/adder_tb.v"
`include "primitives/bit_reorder/bit_reorder_tb.v"
`include "primitives/counter/counter_tb.v"
`include "primitives/fifo/fifo_tb.v"
`include "primitives/bit_shift/bit_shift_tb.v"
`include "primitives/slice/slice_tb.v"
`include "primitives/bram/bram_sync_sp_tb.v"
`include "primitives/bram/bram_sync_dp_tb.v"
`include "primitives/gray_counter/gray_counter_tb.v"
`endif
//================
//   Contollers
//================
`include "controllers/kat_adc/iic_controller/miic_ops.v"
`include "controllers/kat_adc/iic_controller/rx_fifo.v"
`include "controllers/kat_adc/iic_controller/iic_wb_controller.v"
`include "controllers/kat_adc/iic_controller/wb_attach.v"
`include "controllers/kat_adc/iic_controller/cpu_op_fifo.v"
`include "controllers/kat_adc/iic_controller/fab_op_fifo.v"
`include "controllers/kat_adc/iic_controller/gain_set.v"
`include "controllers/kat_adc/interface/adc_async_fifo.v"
`include "controllers/kat_adc/interface/kat_adc_interface.v"
`include "controllers/bram_wb/bram_wb.v"
`include "controllers/sw_reg/sw_reg_r.v"
`include "controllers/sw_reg/sw_reg_wr.v"
`ifdef testbenches
`include "controllers/kat_adc/iic_controller/iic_wb_controller_tb.v"
`include "controllers/kat_adc/interface/adc_async_fifo_tb.v"
`include "controllers/kat_adc/interface/kat_adc_interface_tb.v"
`include "controllers/bram_wb/bram_wb_tb.v"
`include "controllers/sw_reg/sw_reg_r_tb.v"
`include "controllers/sw_reg/sw_reg_wr_tb.v"
`endif
//================
//   DSP Blocks
//================
`include "dsp_blocks/decimator/decimator.v"
`ifdef testbenches
`include "dsp_blocks/decimator/decimator_tb.v"
`endif
