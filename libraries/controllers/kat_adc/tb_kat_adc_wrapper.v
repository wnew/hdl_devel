module tb_kat_adc_wrapper;

reg adc_clk_p;
reg adc_clk_n;
reg adc_sync_p;
reg adc_sync_n;
reg adc_overrange_p;
reg adc_overrange_n;
reg adc_rst;
reg adc_powerdown;
reg adc_di_d_p;
reg adc_di_d_n;
reg adc_di_p;
reg adc_di_n;
reg adc_dq_d_p;
reg adc_dq_d_n;
reg adc_dq_p;
reg adc_dq_n;
reg user_datai3;
reg user_datai2;
reg user_datai1;
reg user_datai0;
reg user_dataq3;
reg user_dataq2;
reg user_dataq1;
reg user_dataq0;
reg user_sync0;
reg user_sync1;
reg user_sync2;
reg user_sync3;
reg user_outofrange0;
reg user_outofrange1;
reg user_data_valid;
reg mmcm_reset;
reg ctrl_reset;
reg ctrl_clk_in;
reg ctrl_clk_out;
reg ctrl_clk90_out;
reg ctrl_clk180_out;
reg ctrl_clk270_out;
reg ctrl_mmcm_locked;
reg mmcm_psclk;
reg mmcm_psen;
reg mmcm_psincdec;
reg mmcm_psdone;

initial begin
    $from_myhdl(
        adc_clk_p,
        adc_clk_n,
        adc_sync_p,
        adc_sync_n,
        adc_overrange_p,
        adc_overrange_n,
        adc_rst,
        adc_powerdown,
        adc_di_d_p,
        adc_di_d_n,
        adc_di_p,
        adc_di_n,
        adc_dq_d_p,
        adc_dq_d_n,
        adc_dq_p,
        adc_dq_n,
        user_datai3,
        user_datai2,
        user_datai1,
        user_datai0,
        user_dataq3,
        user_dataq2,
        user_dataq1,
        user_dataq0,
        user_sync0,
        user_sync1,
        user_sync2,
        user_sync3,
        user_outofrange0,
        user_outofrange1,
        user_data_valid,
        mmcm_reset,
        ctrl_reset,
        ctrl_clk_in,
        ctrl_clk_out,
        ctrl_clk90_out,
        ctrl_clk180_out,
        ctrl_clk270_out,
        ctrl_mmcm_locked,
        mmcm_psclk,
        mmcm_psen,
        mmcm_psincdec,
        mmcm_psdone
    );
end

kat_adc_wrapper dut(
    adc_clk_p,
    adc_clk_n,
    adc_sync_p,
    adc_sync_n,
    adc_overrange_p,
    adc_overrange_n,
    adc_rst,
    adc_powerdown,
    adc_di_d_p,
    adc_di_d_n,
    adc_di_p,
    adc_di_n,
    adc_dq_d_p,
    adc_dq_d_n,
    adc_dq_p,
    adc_dq_n,
    user_datai3,
    user_datai2,
    user_datai1,
    user_datai0,
    user_dataq3,
    user_dataq2,
    user_dataq1,
    user_dataq0,
    user_sync0,
    user_sync1,
    user_sync2,
    user_sync3,
    user_outofrange0,
    user_outofrange1,
    user_data_valid,
    mmcm_reset,
    ctrl_reset,
    ctrl_clk_in,
    ctrl_clk_out,
    ctrl_clk90_out,
    ctrl_clk180_out,
    ctrl_clk270_out,
    ctrl_mmcm_locked,
    mmcm_psclk,
    mmcm_psen,
    mmcm_psincdec,
    mmcm_psdone
);

endmodule
