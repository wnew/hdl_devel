module bram_wb #(
      parameter DATA_WIDTH  = 32,
      parameter ADDR_WIDTH  = 8,
      parameter SLEEP_COUNT = 4
   ) (
      input  fabric_clk,
      input  fabric_rst,
      input  fabric_we,
      input  fabric_addr,
      input  fabric_data_in,
      output fabric_data_out,

      //Add signals to control your device here

      input  wire                  wbs_clk_i,
      input  wire                  wbs_rst_i,
      input  wire                  wbs_we_i,
      input  wire                  wbs_cyc_i,
      input  wire [3:0]            wbs_sel_i,
      input  wire                  wbs_stb_i,
      input  wire [DATA_WIDTH-1:0] wbs_dat_i,
      input  wire [DATA_WIDTH-1:0] wbs_adr_i,
      output reg  [DATA_WIDTH-1:0] wbs_dat_o,
      output reg                   wbs_int_o,
      output reg                   wbs_ack_o
   );

   localparam DATA_DEPTH = 2 ** ADDR_WIDTH;


wire [31:0]         read_data;
reg  [31:0]         write_data;
reg  [DATA_DEPTH:0] ram_adr;
reg  [3:0]          ram_sleep;
reg                 en_ram;

bram_sync_dp #(
      .DATA_WIDTH (DATA_WIDTH),
      .ADDR_WIDTH (ADDR_WIDTH)
   ) bram_inst (
      .rst        (wbs_rst_i || fabric_rst),
      .en         (en_ram),
      
      .a_clk      (fabric_clk),
      .a_wr       (fabric_we),
      .a_addr     (fabric_addr),
      .a_data_in  (fabric_data_in),
      .a_data_out (fabric_data_out),
      
      .b_clk      (wbs_clk_i),
      .b_wr       (wbs_we_i),
      .b_addr     (ram_adr),
      .b_data_in  (write_data),
      .b_data_out (read_data)
);

// TODO: make sure the logic below is working!!!!
//blocks
always @ (posedge wbs_clk_i) begin
   if (fabric_rst || wbs_rst_i) begin
      wbs_dat_o   <= 32'h0;
      wbs_ack_o   <= 0;
      wbs_int_o   <= 0;
      ram_sleep   <= SLEEP_COUNT;
      ram_adr     <= 0;
      en_ram      <= 0;
   end

   else begin
      //when the master acks our ack, then put our ack down
      if (wbs_ack_o & ~wbs_stb_i)begin
         wbs_ack_o <= 0;
         en_ram <= 0;
      end

      if (wbs_stb_i & wbs_cyc_i) begin
         //master is requesting somethign
         en_ram <= 1;
         ram_adr <= wbs_adr_i[DATA_DEPTH:0];
         if (wbs_we_i) begin
            //write request
            //the bram module will handle all the writes
            write_data <= wbs_dat_i;
            //$display ("write a:%h, d:%h", wbs_adr_i[DATA_DEPTH:0], wbs_dat_i);
         end

         else begin
            //read request
            wbs_dat_o <= read_data;
            //wbs_dat_o <= wbs_adr_i;
            //$display ("read a:%h, d:%h", wbs_adr_i[DATA_DEPTH:0], read_data);
         end
         if (ram_sleep > 0) begin
            ram_sleep <= ram_sleep - 1;
         end
         else begin
            wbs_ack_o <= 1;
            ram_sleep <= SLEEP_COUNT;
         end
      end
   end
end


endmodule



