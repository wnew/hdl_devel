typedef struct {
   bit        wb_clk_i;
   bit        wb_rst_i;
   bit        wb_cyc_i;
   bit        wb_stb_i;
   bit        wb_we_i;
   bit        wb_sel_i;
   bit [31:0] wb_adr_i;
} wishbone_i;

wb_i = wishbone;

typedef struct {
   bit [31:0] wb_dat_i;
   bit [31:0] wb_dat_o;
   bit        wb_ack_o;
} wishbone_o;

wb_o = wishbone;

