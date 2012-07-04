`timescale 1ns/1ps
module wbs_attach #(
    parameter C_BASEADDR    = 32'h00000000,
    parameter C_HIGHADDR    = 32'h0000FFFF,
    parameter C_WB_AWIDTH   = 32,
    parameter C_WB_DWIDTH   = 32
  ) (
    input         wbs_clk_i,
    input         wbs_rst_i,
    input         wbs_we_i,
    input         wbs_cyc_i,
    input         wbs_stb_i,
    input  [0:3]  wbs_sel_i,
    input  [0:31] wbs_dat_i,
    input  [0:31] wbs_adr_i,
    output [0:31] wbs_dat_o,
    output        wbs_ack_o,

    /**** IIC operations fifo controls *****/
    output        op_fifo_wr_en,
    output [11:0] op_fifo_wr_data,
    input         op_fifo_empty,
    input         op_fifo_full,
    input         op_fifo_over,

    /**** Receive data fifo controls *****/
    output        rx_fifo_rd_en,
    input   [7:0] rx_fifo_rd_data,
    input         rx_fifo_empty,
    input         rx_fifo_full,
    input         rx_fifo_over,
    /***** reset for both fifos *****/
    output        fifo_rst,
    /**** In high latency environment we need to block the op fifo
          in order to string together long IIC commands ****/
    output        op_fifo_block,
    /***** Was there an error during the IIC operation */
    input         op_error
  );

  /************* WB Attach ***************/

  localparam REG_OP_FIFO = 0;
  localparam REG_RX_FIFO = 1;
  localparam REG_STATUS  = 2;
  localparam REG_CTRL    = 3;

  reg op_fifo_over_reg;
  reg rx_fifo_over_reg;

  reg op_fifo_wr_en_reg;
  assign op_fifo_wr_en = op_fifo_wr_en_reg;
  reg rx_fifo_rd_en_reg;
  assign rx_fifo_rd_en = rx_fifo_rd_en_reg;

  reg op_error_reg;

  wire addr_match = wbs_adr_i >= C_BASEADDR && wbs_adr_i <= C_HIGHADDR;
  wire [31:0] local_addr = wbs_adr_i - C_BASEADDR;

  reg wbs_ack_o_reg;

  reg fifo_rst_reg;
  assign fifo_rst = fifo_rst_reg;

  reg op_fifo_block_reg;
  assign op_fifo_block = op_fifo_block_reg;

  always @(posedge wbs_clk_i) begin
    // Single cycle strobes
    wbs_ack_o_reg    <= 1'b0;
    fifo_rst_reg      <= 1'b0;
    op_fifo_wr_en_reg <= 1'b0;
    rx_fifo_rd_en_reg <= 1'b0;

    // Latch contents high
    op_error_reg     <= op_error_reg | op_error;
    op_fifo_over_reg <= op_fifo_over_reg | op_fifo_over;
    rx_fifo_over_reg <= rx_fifo_over_reg | rx_fifo_over;

    if (wbs_rst_i) begin
      op_fifo_over_reg  <= 1'b0;
      rx_fifo_over_reg  <= 1'b0;
      op_fifo_block_reg <= 1'b0;
    end else begin
      if (addr_match && !wbs_ack_o_reg && wbs_stb_i && wbs_cyc_i) begin
        wbs_ack_o_reg <= 1'b1;
        case (local_addr[3:2])
          REG_OP_FIFO: begin
            if (!wbs_we_i && wbs_sel_i[3]) begin
              op_fifo_wr_en_reg <= 1'b1;
            end
          end
          REG_RX_FIFO: begin
            if (wbs_we_i && wbs_sel_i[3]) begin
              rx_fifo_rd_en_reg <= 1'b1;
            end
          end
          REG_STATUS: begin
            if (!wbs_we_i) begin
              fifo_rst_reg     <= 1'b1;
              op_fifo_over_reg <= 1'b0;
              rx_fifo_over_reg <= 1'b0;
              op_error_reg     <= 1'b0;
            end
          end
          REG_CTRL: begin
            if (!wbs_we_i && wbs_sel_i[3]) begin
              op_fifo_block_reg <= wbs_dat_i[31];
            end
          end
        endcase
      end
    end
  end

  reg [31:0] wbs_dout;
  always @(*) begin
    case (local_addr[3:2])
      REG_OP_FIFO: begin
        wbs_dout <= 32'b0;
      end
      REG_RX_FIFO: begin
        wbs_dout <= {24'b0, rx_fifo_rd_data};
      end
      REG_STATUS: begin
        wbs_dout <= {16'b0, 7'b0, op_error_reg, 1'b0, op_fifo_over_reg, op_fifo_full, op_fifo_empty, 1'b0, rx_fifo_over_reg, rx_fifo_full, rx_fifo_empty};
      end
      REG_CTRL: begin
        wbs_dout <= {31'b0, op_fifo_block_reg};
      end
      default: begin
        wbs_dout <= 32'b0;
      end
    endcase
  end

  assign wbs_dat_o = wbs_ack_o_reg ? wbs_dout : 32'b0;
  assign wbs_ack_o  = wbs_ack_o_reg;

  /* wb fifo assignments */
  assign op_fifo_wr_data = wbs_dat_i[20:31];

endmodule
