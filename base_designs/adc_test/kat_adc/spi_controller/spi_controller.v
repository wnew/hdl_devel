module spi_controller(

    input         wb_clk_i,
    input         wb_rst_i,
    input         wb_we_i,
    input         wb_cyc_i,
    input         wb_stb_i,
    input  [0:3]  wb_sel_i,
    input  [0:31] wb_adr_i,
    input  [0:31] wb_data_i,
    output [0:31] wb_data_o,
    output        wb_ack_o,

    output        adc0_adc3wire_clk,
    output        adc0_adc3wire_data,
    output        adc0_adc3wire_strobe,
    output        adc0_adc_reset,
    output        adc0_mmcm_reset,
    output        adc0_psclk,
    output        adc0_psen,
    output        adc0_psincdec,
    input         adc0_psdone,
    input         adc0_clk,

    output        adc1_adc3wire_clk,
    output        adc1_adc3wire_data,
    output        adc1_adc3wire_strobe,
    output        adc1_adc_reset,
    output        adc1_mmcm_reset,
    output        adc1_psclk,
    output        adc1_psen,
    output        adc1_psincdec,
    input         adc1_psdone,
    input         adc1_clk             
  );
  parameter C_BASEADDR    = 32'h00000000;
  parameter C_HIGHADDR    = 32'h0000FFFF;
  parameter C_WB_AWIDTH   = 32;
  parameter C_WB_DWIDTH   = 32;
  parameter C_FAMILY      = "";

  /* TODO: implement AUTO configuration */
  parameter INTERLEAVED_0 = 0;
  parameter INTERLEAVED_1 = 0;
  parameter AUTOCONFIG_0  = 0;
  parameter AUTOCONFIG_1  = 0;

  /********* Global Signals *************/

  wire [15:0] adc0_config_data;
  wire  [3:0] adc0_config_addr;
  wire        adc0_config_start;
  wire        adc0_config_done;

  wire [15:0] adc1_config_data;
  wire  [3:0] adc1_config_addr;
  wire        adc1_config_start;
  wire        adc1_config_done;

  wire        adc0_reset;
  wire        adc1_reset;

  /************ Bus Logic ***************/

  wire addr_match = wb_adr_i >= C_BASEADDR && wb_adr_i <= C_HIGHADDR;
  wire [31:0] wb_addr = wb_adr_i - C_BASEADDR;

  reg wb_ack;

  /*** Registers ****/

  reg adc0_reset_reg;
  reg adc1_reset_reg;
  assign adc0_reset = adc0_reset_reg;
  assign adc1_reset = adc1_reset_reg;

  reg adc0_mmcm_psen_reg;
  reg adc0_mmcm_psincdec_reg;
  assign adc0_psen     = adc0_mmcm_psen_reg;
  assign adc0_psincdec = adc0_mmcm_psincdec_reg;
  assign adc0_psclk    = wb_clk_i;

  reg adc1_mmcm_psen_reg;
  reg adc1_mmcm_psincdec_reg;
  assign adc1_psen     = adc1_mmcm_psen_reg;
  assign adc1_psincdec = adc1_mmcm_psincdec_reg;
  assign adc1_psclk    = wb_clk_i;

  reg [15:0] adc0_config_data_reg;
  reg  [3:0] adc0_config_addr_reg;
  reg        adc0_config_start_reg;
  assign adc0_config_data  = adc0_config_data_reg;
  assign adc0_config_addr  = adc0_config_addr_reg;
  assign adc0_config_start = adc0_config_start_reg;

  reg [15:0] adc1_config_data_reg;
  reg  [3:0] adc1_config_addr_reg;
  reg        adc1_config_start_reg;
  assign adc1_config_data  = adc1_config_data_reg;
  assign adc1_config_addr  = adc1_config_addr_reg;
  assign adc1_config_start = adc1_config_start_reg;


  always @(posedge wb_clk_i) begin
    wb_ack <= 1'b0;
    
    adc0_reset_reg <= 1'b0;
    adc1_reset_reg <= 1'b0;

    adc0_mmcm_psen_reg <= 1'b0;
    adc1_mmcm_psen_reg <= 1'b0;

    adc0_config_start_reg <= 1'b0;
    adc1_config_start_reg <= 1'b0;

    if (wb_rst_i) begin
    end else begin
      if (addr_match && !wb_ack) begin
        wb_ack <= 1'b1;
        if (wb_we_i && wb_stb_i && wb_cyc_i) begin
          case (wb_addr[3:2])
            0:  begin
              if (wb_sel_i[3]) begin
                adc0_reset_reg <= wb_data_i[31];
                adc1_reset_reg <= wb_data_i[30];
              end
              if (wb_sel_i[1]) begin
                adc0_mmcm_psen_reg <= wb_data_i[15];
                adc1_mmcm_psen_reg <= wb_data_i[11];
                adc0_mmcm_psincdec_reg <= wb_data_i[14];
                adc1_mmcm_psincdec_reg <= wb_data_i[10];
              end
            end
            1:  begin
              if (wb_sel_i[3]) begin
                adc0_config_start_reg <= wb_data_i[31];
              end
              if (wb_sel_i[2]) begin
                adc0_config_addr_reg <= wb_data_i[20:23];
              end
              if (wb_sel_i[1]) begin
                adc0_config_data_reg[7:0] <= wb_data_i[8:15];
              end
              if (wb_sel_i[0]) begin
                adc0_config_data_reg[15:8] <= wb_data_i[0:7];
              end
            end
            2:  begin
              if (wb_sel_i[3]) begin
                adc1_config_start_reg <= wb_data_i[31];
              end
              if (wb_sel_i[2]) begin
                adc1_config_addr_reg <= wb_data_i[20:23];
              end
              if (wb_sel_i[1]) begin
                adc1_config_data_reg[7:0] <= wb_data_i[8:15];
              end
              if (wb_sel_i[0]) begin
                adc1_config_data_reg[15:8] <= wb_data_i[0:7];
              end
            end
            3:  begin
            end
          endcase
        end
      end
    end
  end

  reg [31:0] wb_data_out;

  always @(*) begin
    case (wb_addr[3:2])
      0: wb_data_out <= {2'b0, adc1_psdone, adc0_psdone, 4'b0, 2'b0, adc1_mmcm_psincdec_reg, adc1_mmcm_psen_reg, 2'b0, adc0_mmcm_psincdec_reg, adc0_mmcm_psen_reg, 16'b0};
      1: wb_data_out <= {adc0_config_data_reg[15:8], adc0_config_data_reg[7:0], 4'b0, adc0_config_addr_reg, 7'b0, adc0_config_done};
      2: wb_data_out <= {adc1_config_data_reg[15:8], adc1_config_data_reg[7:0], 4'b0, adc1_config_addr_reg, 7'b0, adc1_config_done};
      3: wb_data_out <= {32'b0};
    endcase
  end

  assign wb_data_o = wb_ack_o ? wb_data_out : 32'b0;
  assign wb_ack_o  = wb_ack;

  /********* DCM Reset Gen *********/


  reg [7:0] adc0_reset_counter;
  reg [7:0] adc1_reset_counter;

  reg adc0_reset_iob;
  reg adc1_reset_iob;
  // synthesis attribute IOB of adc0_reset_iob is TRUE
  // synthesis attribute IOB of adc1_reset_iob is TRUE

  always @(posedge wb_clk_i) begin

    if (wb_rst_i) begin
      adc0_reset_counter <= {8{1'b1}};
      adc1_reset_counter <= {8{1'b1}};
      adc0_reset_iob <= 1'b1;
      adc1_reset_iob <= 1'b1;
    end else begin
      adc0_reset_iob <= adc0_reset;
      adc1_reset_iob <= adc1_reset;
      if (adc0_reset_counter) begin
        adc0_reset_counter <= adc0_reset_counter - 1;
      end
      if (adc1_reset_counter) begin
        adc1_reset_counter <= adc1_reset_counter - 1;
      end
      if (adc0_reset) begin
        adc0_reset_counter <= {8{1'b1}};
      end
      if (adc1_reset) begin
        adc1_reset_counter <= {8{1'b1}};
      end
    end
  end

  assign adc0_mmcm_reset = adc0_reset_counter != 0;
  assign adc1_mmcm_reset = adc1_reset_counter != 0;
  assign adc0_adc_reset = adc0_reset_iob;
  assign adc1_adc_reset = adc1_reset_iob;

  /********* ADC0 configuration state machine *********/

  wire clk0_done;
  wire clk0_en;

  localparam CONFIG_IDLE      = 0;
  localparam CONFIG_CLKWAIT   = 1;
  localparam CONFIG_DATA      = 2;
  localparam CONFIG_FINISH    = 3;

  reg [1:0] adc0_state;

  reg [31:0] adc0_config_data_shift;

  reg [4:0] adc0_config_progress;

  always @(posedge wb_clk_i) begin
    if (wb_rst_i) begin
      adc0_state <= CONFIG_IDLE;
    end else begin
      case (adc0_state)
        CONFIG_IDLE: begin
          if (adc0_config_start) begin
            adc0_state <= CONFIG_CLKWAIT;
            adc0_config_data_shift <= {12'b1, adc0_config_addr, adc0_config_data};
          end
        end
        CONFIG_CLKWAIT: begin
          if (clk0_done) begin
            adc0_state <= CONFIG_DATA;
            adc0_config_progress <= 0;
          end
        end 
        CONFIG_DATA: begin
          if (clk0_done) begin
            adc0_config_data_shift <= adc0_config_data_shift << 1;
            adc0_config_progress <= adc0_config_progress + 1;
            if (adc0_config_progress == 31) begin
              adc0_state <= CONFIG_FINISH;
            end
          end
        end
        CONFIG_FINISH: begin
          if (clk0_done) begin
            adc0_state <= CONFIG_IDLE;
          end
        end
        default: begin
          adc0_state <= CONFIG_IDLE;
        end
      endcase
    end
  end

  assign adc0_config_done = adc0_state == CONFIG_IDLE;
  
  /* Clock Control */

  reg [3:0] clk0_counter;
  always @(posedge wb_clk_i) begin
    if (clk0_en) begin
      clk0_counter <= clk0_counter + 1;
    end else begin
      clk0_counter <= 4'b0;
    end
  end
  assign clk0_done = clk0_counter == 4'b1111;
  assign clk0_en   = adc0_state != CONFIG_IDLE;

  assign adc0_adc3wire_strobe = !(adc0_state == CONFIG_DATA);
  assign adc0_adc3wire_data   = adc0_config_data_shift[31];
  assign adc0_adc3wire_clk    = clk0_counter[3];

  /********* ADC1 configuration state machine *********/

  wire clk1_done;
  wire clk1_en;

  reg [1:0] adc1_state;

  reg [31:0] adc1_config_data_shift;

  reg [4:0] adc1_config_progress;

  always @(posedge wb_clk_i) begin
    if (wb_rst_i) begin
      adc1_state <= CONFIG_IDLE;
    end else begin
      case (adc1_state)
        CONFIG_IDLE: begin
          if (adc1_config_start) begin
            adc1_state <= CONFIG_CLKWAIT;
            adc1_config_data_shift <= {12'b1, adc1_config_addr, adc1_config_data};
          end
        end
        CONFIG_CLKWAIT: begin
          if (clk1_done) begin
            adc1_state <= CONFIG_DATA;
            adc1_config_progress <= 0;
          end
        end 
        CONFIG_DATA: begin
          if (clk1_done) begin
            adc1_config_data_shift <= adc1_config_data_shift << 1;
            adc1_config_progress <= adc1_config_progress + 1;
            if (adc1_config_progress == 31) begin
              adc1_state <= CONFIG_FINISH;
            end
          end
        end
        CONFIG_FINISH: begin
          if (clk1_done) begin
            adc1_state <= CONFIG_IDLE;
          end
        end
        default: begin
          adc1_state <= CONFIG_IDLE;
        end
      endcase
    end
  end

  assign adc1_config_done = adc1_state == CONFIG_IDLE;

  /* Clock Control */

  reg [3:0] clk1_counter;
  always @(posedge wb_clk_i) begin
    if (clk1_en) begin
      clk1_counter <= clk1_counter + 1;
    end else begin
      clk1_counter <= 4'b0;
    end
  end
  assign clk1_done = clk1_counter == 4'b1111;
  assign clk1_en   = adc1_state != CONFIG_IDLE;

  assign adc1_adc3wire_strobe = adc1_state == CONFIG_DATA;
  assign adc1_adc3wire_data   = adc1_config_data_shift[31];
  assign adc1_adc3wire_clk    = clk0_counter[3];

endmodule
