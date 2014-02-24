// File: toplevel.v
// Generated by MyHDL 0.7
// Date: Wed Aug 15 14:27:04 2012


`timescale 1ns/10ps

module toplevel (
    sys_clk_n,
    sys_clk_p,
    aux_clk_n,
    aux_clk_p,
    gpio,
    ppc_per_clk,
    ppc_paddr,
    ppc_pcsn,
    ppc_pdata,
    ppc_pben,
    ppc_poen,
    ppc_pwrn,
    ppc_pblastn,
    ppc_prdy,
    ppc_doen,
    kat_adc0_clk_n,
    kat_adc0_clk_p,
    kat_adc0_sync_n,
    kat_adc0_sync_p,
    kat_adc0_overrange_n,
    kat_adc0_overrange_p,
    kat_adc0_di_d_n,
    kat_adc0_di_d_p,
    kat_adc0_di_n,
    kat_adc0_di_p,
    kat_adc0_dq_d_n,
    kat_adc0_dq_d_p,
    kat_adc0_dq_n,
    kat_adc0_dq_p,
    kat_adc0_spi_clk,
    kat_adc0_spi_data,
    kat_adc0_spi_cs,
    kat_adc0_iic_sda,
    kat_adc0_iic_scl,
    v6_irqn
);


input sys_clk_n;
input sys_clk_p;
input aux_clk_n;
input aux_clk_p;
output [15:0] gpio;
wire [15:0] gpio;
input ppc_per_clk;
input [23:0] ppc_paddr;
input [0:0] ppc_pcsn;
input [30:0] ppc_pdata;
input [2:0] ppc_pben;
input ppc_poen;
input ppc_pwrn;
input ppc_pblastn;
output ppc_prdy;
wire ppc_prdy;
output ppc_doen;
wire ppc_doen;
input kat_adc0_clk_n;
input kat_adc0_clk_p;
input kat_adc0_sync_n;
input kat_adc0_sync_p;
input kat_adc0_overrange_n;
input kat_adc0_overrange_p;
input [7:0] kat_adc0_di_d_n;
input [7:0] kat_adc0_di_d_p;
input [7:0] kat_adc0_di_n;
input [7:0] kat_adc0_di_p;
input [7:0] kat_adc0_dq_d_n;
input [7:0] kat_adc0_dq_d_p;
input [7:0] kat_adc0_dq_n;
input [7:0] kat_adc0_dq_p;
output kat_adc0_spi_clk;
wire kat_adc0_spi_clk;
output kat_adc0_spi_data;
wire kat_adc0_spi_data;
output kat_adc0_spi_cs;
wire kat_adc0_spi_cs;
input kat_adc0_iic_sda;
input kat_adc0_iic_scl;
input v6_irqn;

wire sys_clk;
wire kat_adc0_mmcm_reset;
wire epb_data_o;
wire [31:0] count_out;
wire iic_sda_o;
wire epb_clk;


assign iic_sda_o = 0;




   clk_infrastructure 
   #(
      .ARCHITECTURE     ("BEHAVIORAL"),
      .CLK_FREQ         (100)
   ) clk_infrustructure_1 (
      .sys_clk_n        (sys_clk_n),
      .sys_clk_p        (sys_clk_p),
      .sys_clk          (sys_clk), 
      .sys_clk90        (sys_clk90), 
      .sys_clk180       (sys_clk180), 
      .sys_clk270       (sys_clk270),
      .sys_clk_lock     (sys_clk_lock), 
      .op_power_on_rst  (power_on_rst),
      .sys_clk2x        (sys_clk2x), 
      .sys_clk2x90      (sys_clk2x90), 
      .sys_clk2x180     (sys_clk2x180), 
      .sys_clk2x270     (sys_clk2x270),
      .epb_clk_in       (ppc_per_clk),
      .epb_clk          (epb_clk),
      .aux_clk_n        (aux_clk_n), 
      .aux_clk_p        (aux_clk_p),
      .aux_clk          (aux_clk), 
      .aux_clk90        (aux_clk90), 
      .aux_clk180       (aux_clk180), 
      .aux_clk270       (aux_clk270),
      .aux_clk2x        (aux_clk2x), 
      .aux_clk2x90      (aux_clk2x90), 
      .aux_clk2x180     (aux_clk2x180), 
      .aux_clk2x270     (aux_clk2x270),
      .idelay_rst       (power_on_rst),
      .idelay_rdy       (idelay_rdy)
   );
   


   reset_block
   #(
      .ARCHITECTURE ("BEHAVIORAL"),
      .DELAY        ("10"),
      .WIDTH        ("50")
   ) reset_block_1 (
      .clk         (sys_clk),
      .async_rst_i (power_on_rst),
      .rst_i       (power_on_rst),
      .rst_o       (sys_rst)
   );
   


   epb_wb_bridge
   #(
      .ARCHITECTURE ("BEHAVIORAL")
   ) epb_wb_bridge_1 (
      .wb_clk_i (epb_clk), .wb_rst_i (wbm_rst_i),
      .wb_cyc_o (wbm_cyc_o), .wb_stb_o (wbm_stb_o), .wb_we_o  (wbm_we_o), .wb_sel_o (wbm_sel_o),
      .wb_adr_o (wbm_adr_o), .wb_dat_o (wbm_dat_o), .wb_dat_i (wbm_dat_i),
      .wb_ack_i (wbm_ack_i), .wb_err_i (wbm_err_i),

      .epb_clk       (epb_clk),
      .epb_cs_n      (ppc_pcsn),      .epb_oe_n   (ppc_poen),   .epb_r_w_n (ppc_pwrn), .epb_be_n (ppc_pben),
      .epb_addr      (ppc_paddr),
      .epb_data_i    (epb_data_i),    .epb_data_o (epb_data_o),
      .epb_data_oe_n (epb_data_oe_n),
      .epb_rdy       (ppc_prdy),
      .epb_doen      (ppc_doen)
   );
   


   epb_infrastructure
   #(
      .ARCHITECTURE ("VIRTEX6")
   ) epb_infrastructure_1 (
      .epb_data_buf  (ppc_pdata),
      .epb_data_oe_n (epb_data_oe_n),
      .epb_data_i    (epb_data_o),
      .epb_data_o    (epb_data_i)
   );
   


   wbs_arbiter
   #(
      .ARCHITECTURE ("BEHAVIOURAL"),
      .NUM_SLAVES   (1),
      .SLAVE_ADDR   (0),
      .SLAVE_HIGH   (65535),
      .TIMEOUT      (1024)
   ) wbs_arbiter_1 (
      .wb_clk_i (epb_clk), .wb_rst_i (wbm_rst_i), 
      
      .wbm_cyc_i (wbm_cyc_o), .wbm_stb_i (wbm_stb_o), .wbm_we_i  (wbm_we_o), .wbm_sel_i (wbm_sel_o), 
      .wbm_adr_i (wbm_adr_o), .wbm_dat_i (wbm_dat_o), .wbm_dat_o (wbm_dat_i), 
      .wbm_ack_o (wbm_ack_i),
      
      .wbs_cyc_o (wbs_cyc_o), .wbs_stb_o (wbs_stb_o), .wbs_we_o  (wbs_we_o), .wbs_sel_o (wbs_sel_o), 
      .wbs_adr_o (wbs_adr_o), .wbs_dat_o (wbs_dat_o), .wbs_dat_i (wbs_dat_i), 
      .wbs_ack_i (wbs_ack_i)
   );
   


sys_block
#(
   .DEV_BASE_ADDR  (0), 
   .DEV_HIGH_ADDR  (32), 
   .BUS_DATA_WIDTH (32), 
   .BUS_ADDR_WIDTH (1) 
) sys_block_1 (
  
   .wb_clk_i        (epb_clk),
   .wb_rst_i        (wbm_rst_i),
   .wbs_cyc_i       (wbs_cyc_o),
   .wbs_stb_i       (wbs_stb_o),
   .wbs_we_i        (wbs_we_o),
   .wbs_sel_i       (wbs_sel_o),
   .wbs_adr_i       (wbs_adr_o),
   .wbs_dat_i       (wbs_dat_o),
   .wbs_dat_o       (wbs_dat_i),
   .wbs_ack_o       (wbs_ack_i),
   .wbs_err_o       (wbs_err_i)
);



counter 
#(
   .ARCHITECTURE ("BEHAVIORAL"),
   .DATA_WIDTH   (32),
   .COUNT_FROM   (0),
   .COUNT_TO     (32'h10000000),
   .STEP         (1)
) counter_1 (
   .clk  (sys_clk),
   .en   (1),
   .rst  (0),
   .out  (count_out)
);



kat_adc_interface
#(
   .EXTRA_REG (1)
) kac_adc_interface_1 (
   .adc_clk_p         (kat_adc0_clk_p), 
   .adc_clk_n         (kat_adc0_clk_n),
   .adc_sync_p        (kat_adc0_sync_p),
   .adc_sync_n        (kat_adc0_sync_n),
   .adc_overrange_p   (kat_adc0_overrange_p),
   .adc_overrange_n   (kat_adc0_overrange_n),
   .adc_rst           (kat_adc0_adc_rst),
   .adc_powerdown     (kat_adc0_adc_powerdown),
   .adc_di_d_p        (kat_adc0_di_d_p),
   .adc_di_d_n        (kat_adc0_di_d_n),
   .adc_di_p          (kat_adc0_di_p),
   .adc_di_n          (kat_adc0_di_n),
   .adc_dq_d_p        (kat_adc0_dq_d_p),
   .adc_dq_d_n        (kat_adc0_dq_d_n),
   .adc_dq_p          (kat_adc0_dq_p),
   .adc_dq_n          (kat_adc0_dq_n),
                                        
   .user_datai3       (kat_adc0_user_datai3),
   .user_datai2       (kat_adc0_user_datai2),
   .user_datai1       (kat_adc0_user_datai1),
   .user_datai0       (user_datai0),
   .user_dataq3       (kat_adc0_user_dataq3),
   .user_dataq2       (kat_adc0_user_dataq2),
   .user_dataq1       (kat_adc0_user_dataq1),
   .user_dataq0       (kat_adc0_user_dataq0),
   .user_sync0        (kat_adc0_user_sync0),
   .user_sync1        (kat_adc0_user_sync1),
   .user_sync2        (kat_adc0_user_sync2),
   .user_sync3        (kat_adc0_user_sync3),
   .user_outofrange0  (kat_adc0_user_outofrange0),
   .user_outofrange1  (kat_adc0_user_outofrange1),
   .user_data_valid   (kat_adc0_user_data_valid),
                       
   .mmcm_reset        (kat_adc0_mmcm_reset),
                       
   .ctrl_reset        (kat_adc0_adc_reset),
   .ctrl_clk_in       (kat_adc0_clk),
   .ctrl_clk_out      (kat_adc0_clk),
   .ctrl_clk90_out    (kat_adc0_clk90_out),
   .ctrl_clk180_out   (kat_adc0_clk180_out),
   .ctrl_clk270_out   (kat_adc0_clk270_out),
   .ctrl_mmcm_locked  (kat_adc0_mmcm_locked),
                                        
   .mmcm_psclk        (kat_adc0_psclk),
   .mmcm_psen         (kat_adc0_psen),
   .mmcm_psincdec     (kat_adc0_psincdec),
   .mmcm_psdone       (kat_adc0_psdone)

);



spi_controller
#(
   .C_BASEADDR    (0),
   .C_HIGHADDR    (0),
   .C_WB_AWIDTH   (0),
   .C_WB_DWIDTH   (0),
   .C_FAMILY      (0),
   .INTERLEAVED_0 (0),
   .INTERLEAVED_1 (0),
   .AUTOCONFIG_0  (0),
   .AUTOCONFIG_1  (0)
) spi_controller_1 (
   .wb_clk_i             (epb_clk),
   .wb_rst_i             (wbm_rst_i),
   .wb_we_i              (wbs_we_o),
   .wb_cyc_i             (wbs_cyc_o),
   .wb_stb_i             (wbs_stb_o),
   .wb_sel_i             (wbs_sel_o),
   .wb_adr_i             (wbs_adr_o),
   .wb_dat_i             (wbs_dat_o),
   .wb_dat_o             (wbs_dat_i),
   .wb_ack_o             (wbs_ack_i),
   .adc0_adc3wire_clk    (kat_adc0_spi_clk),
   .adc0_adc3wire_data   (kat_adc0_spi_data),
   .adc0_adc3wire_strobe (kat_adc0_spi_cs),
   .adc0_adc_reset       (kat_adc0_adc_reset),
   .adc0_mmcm_reset      (kat_adc0_mmcm_reset),
   .adc0_psclk           (kat_adc0_psclk),
   .adc0_psen            (kat_adc0_psen),
   .adc0_psincdec        (kat_adc0_psincdec),
   .adc0_psdone          (kat_adc0_psdone),
   .adc0_clk             (kat_adc0_clk),
   .adc1_adc3wire_clk    (kat_adc_spi_controller_adc1_adc3wire_clk),
   .adc1_adc3wire_data   (kat_adc_spi_controller_adc1_adc3wire_data),
   .adc1_adc3wire_strobe (kat_adc_spi_controller_adc1_adc3wire_strobe),
   .adc1_adc_reset       (kat_adc_spi_controller_adc1_adc_reset),
   .adc1_mmcm_reset      (kat_adc_spi_controller_adc1_mmcm_reset),
   .adc1_psclk           (kat_adc_spi_controller_adc1_psclk),
   .adc1_psen            (kat_adc_spi_controller_adc1_psen),
   .adc1_psincdec        (kat_adc_spi_controller_adc1_psincdec),
   .adc1_psdone          (kat_adc_spi_controller_adc1_psdone),
   .adc1_clk             (kat_adc_spi_controller_adc1_clk)
);



iic_controller #(
   .C_BASEADDR  (0),
   .C_HIGHADDR  (0),
   .C_WB_AWIDTH (32),
   .C_WB_DWIDTH (32),
   .IIC_FREQ    (100),
   .CORE_FREQ   (100000),
   .EN_GAIN     (0)
) iic_controller_1 (
   .wbs_clk_i   (epb_clk), 
   .wbs_rst_i   (wbm_rst_i),
   .wbs_we_i    (wbs_we_o),
   .wbs_cyc_i   (wbs_cyc_o),
   .wbs_stb_i   (wbs_stb_o),
   .wbs_sel_i   (wbs_sel_o),
   .wbs_adr_i   (wbs_adr_o),
   .wbs_dat_i   (wbs_dat_o),
   .wbs_dat_o   (wbs_dat_i),
   .wbs_ack_o   (wbs_ack_i),
                       
   .xfer_done  (0),
                       
   .sda_i      (iic_sda_i),
   .sda_o      (iic_sda_o),
   .sda_t      (iic_sda_t),
   .scl_i      (iic_scl_i),
   .scl_o      (iic_scl_o),
   .scl_t      (iic_scl_t),
                       
   .app_clk    (kat_adc_iic_controller_app_clk),
   .gain_load  (1),
   .gain_value (1)
);



iic_infrastructure
#(

) iic_infrastructure_1 (
   .sda_i (iic_sda_o),
   .sda_o (iic_sda_i),
   .sda_t (iic_sda_t),
   .scl_i (iic_scl_o),
   .scl_o (iic_scl_i),
   .scl_t (iic_scl_t),
   .sda   (kat_adc0_iic_sda),
   .scl   (kat_adc0_iic_scl)
);



bram_wb
#(
   .BUS_BASE_ADDR  (0), 
   .BUS_HIGH_ADDR  (32), 
   .BUS_DATA_WIDTH (32), 
   .BUS_ADDR_WIDTH (16) 
) bram_wb_1 (
  
   .fabric_clk      (kat_adc0_clk),
   .fabric_rst      (sys_rst),
   .fabric_we       (1),
   .fabric_addr     (count_out),
   .fabric_data_in  (user_datai0),
   .fabric_data_out (bram_wrap_fabric_data_out),
                                    
   .wbs_clk_i       (epb_clk),
   .wbs_rst_i       (wbm_rst_i),
   .wbs_cyc_i       (wbs_cyc_o),
   .wbs_stb_i       (wbs_stb_o),
   .wbs_we_i        (wbs_we_o),
   .wbs_sel_i       (wbs_sel_o),
   .wbs_adr_i       (wbs_adr_o),
   .wbs_dat_i       (wbs_dat_o),
   .wbs_dat_o       (wbs_dat_i),
   .wbs_ack_o       (wbs_ack_i)
);



sw_reg_r
#(
   .C_BASEADDR       (0), 
   .C_HIGHADDR       (32), 
   .C_BUS_DATA_WIDTH (32), 
   .C_BUS_ADDR_WIDTH (1) 
) sw_reg_r_1 (
  
   .fabric_clk     (kat_adc0_clk),
   .fabric_data_in (count_out),

   .wbs_clk_i       (epb_clk),
   .wbs_rst_i       (wbm_rst_i),
   .wbs_cyc_i       (wbs_cyc_o),
   .wbs_stb_i       (wbs_stb_o),
   .wbs_we_i        (wbs_we_o),
   .wbs_sel_i       (wbs_sel_o),
   .wbs_adr_i       (wbs_adr_o),
   .wbs_dat_i       (wbs_dat_o),
   .wbs_dat_o       (wbs_dat_i),
   .wbs_ack_o       (wbs_ack_i),
   .wbs_err_o       (wbs_err_i)
);



assign gpio = count_out[32-1:16];

endmodule
