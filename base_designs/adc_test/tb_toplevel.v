module tb_toplevel;

reg sys_clk_n;
reg sys_clk_p;
reg aux_clk_n;
reg aux_clk_p;
wire [15:0] gpio;
reg ppc_per_clk;
reg [23:0] ppc_paddr;
reg [0:0] ppc_pcsn;
reg [30:0] ppc_pdata;
reg [2:0] ppc_pben;
reg ppc_poen;
reg ppc_pwrn;
reg ppc_pblastn;
wire ppc_prdy;
wire ppc_doen;
reg kat_adc0_clk_n;
reg kat_adc0_clk_p;
reg kat_adc0_sync_n;
reg kat_adc0_sync_p;
reg kat_adc0_overrange_n;
reg kat_adc0_overrange_p;
reg [7:0] kat_adc0_di_d_n;
reg [7:0] kat_adc0_di_d_p;
reg [7:0] kat_adc0_di_n;
reg [7:0] kat_adc0_di_p;
reg [7:0] kat_adc0_dq_d_n;
reg [7:0] kat_adc0_dq_d_p;
reg [7:0] kat_adc0_dq_n;
reg [7:0] kat_adc0_dq_p;
wire kat_adc0_spi_clk;
wire kat_adc0_spi_data;
wire kat_adc0_spi_cs;
reg kat_adc0_iic_sda;
reg kat_adc0_iic_scl;
reg v6_irqn;

initial begin
    $from_myhdl(
        sys_clk_n,
        sys_clk_p,
        aux_clk_n,
        aux_clk_p,
        ppc_per_clk,
        ppc_paddr,
        ppc_pcsn,
        ppc_pdata,
        ppc_pben,
        ppc_poen,
        ppc_pwrn,
        ppc_pblastn,
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
        kat_adc0_iic_sda,
        kat_adc0_iic_scl,
        v6_irqn
    );
    $to_myhdl(
        gpio,
        ppc_prdy,
        ppc_doen,
        kat_adc0_spi_clk,
        kat_adc0_spi_data,
        kat_adc0_spi_cs
    );
end

toplevel dut(
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

endmodule
