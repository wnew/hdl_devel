//============================================================================//
//                                                                            //
//      Parameterize BRAM with wishbone interface                             //
//                                                                            //
//      Module name: bram_wb                                                  //
//      Desc: parameterized dual-port bram with a wishbone interface on one   //
//      port.                                                                 //
//      Date: June 2012                                                       //
//      Developer: Wesley New                                                 //
//      Licence: GNU General Public License ver 3                             //
//      Notes:                                                                //
//                                                                            //
//============================================================================//

module bram_wb #(
      //=============
      // Parameters
      //=============
      parameter BUS_BASE_ADDR  = 0,
      parameter BUS_HIGH_ADDR  = 32,
      parameter BUS_DATA_WIDTH = 32,
      parameter BUS_ADDR_WIDTH = 8,
      parameter BUS_BE_WIDTH   = 4,
      parameter SLEEP_COUNT    = 4
   ) (
      //===============
      // Fabric Ports
      //===============
      input                       fabric_clk,
      input                       fabric_rst,
      input                       fabric_we,
      input  [RAM_ADDR_WIDTH-1:0] fabric_addr,
      input  [RAM_DATA_WIDTH-1:0] fabric_data_in,
      output [RAM_DATA_WIDTH-1:0] fabric_data_out,

      //=================
      // Wishbone Ports
      //=================
      input  wire                      wbs_clk_i,
      input  wire                      wbs_rst_i,
      input  wire                      wbs_cyc_i,
      input  wire                      wbs_stb_i,
      input  wire                      wbs_we_i,
      input  wire [BUS_BE_WIDTH-1:0]   wbs_sel_i,
      input  wire [BUS_ADDR_WIDTH-1:0] wbs_adr_i,
      input  wire [BUS_DATA_WIDTH-1:0] wbs_dat_i,
      output reg  [BUS_DATA_WIDTH-1:0] wbs_dat_o,
      output reg                       wbs_ack_o
   );

   //===================
   // Local Parameters
   //===================
   localparam RAM_DATA_WIDTH = 32;
   localparam RAM_ADDR_WIDTH = 8;
   localparam DATA_DEPTH = 2 ** RAM_ADDR_WIDTH;

   //======================
   // Local Reg and Wires
   //======================
   wire [RAM_DATA_WIDTH-1:0] read_data;
   reg  [RAM_DATA_WIDTH-1:0] write_data;
   reg  [RAM_ADDR_WIDTH-1:0] ram_adr;
   reg  [3:0]                ram_sleep;
   reg                       en_ram;

   //================
   // BRAM instance
   //================   
   bram_sync_dp #(
         .DATA_WIDTH (RAM_DATA_WIDTH),
         .ADDR_WIDTH (RAM_ADDR_WIDTH)
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
   //=================
   // Wishbone Logic
   //=================
   always @ (posedge wbs_clk_i) begin
      if (fabric_rst || wbs_rst_i) begin
         wbs_dat_o   <= 32'h00000000;
         wbs_ack_o   <= 0;
         ram_sleep   <= SLEEP_COUNT;
         ram_adr     <= 0;
         en_ram      <= 0;
      end
      else begin
         //when the master acks our ack, then put our ack down
         if (wbs_ack_o & ~wbs_stb_i) begin
            wbs_ack_o <= 0;
            en_ram <= 0;
         end
   
         if (wbs_stb_i & wbs_cyc_i) begin
            //master is requesting somethign
            en_ram <= 1;
            ram_adr <= wbs_adr_i[BUS_ADDR_WIDTH:0];
            if (wbs_we_i) begin
               //write request
               //the bram module will handle all the writes
               write_data <= wbs_dat_i;
               //$display ("write a:%h, d:%h", wbs_adr_i[ADDR_WIDTH:0], wbs_dat_i);
            end
   
            else begin
               //read request
               wbs_dat_o <= read_data;
               //wbs_dat_o <= wbs_adr_i;
               //$display ("read a:%h, d:%h", wbs_adr_i[ADDR_WIDTH:0], read_data);
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



