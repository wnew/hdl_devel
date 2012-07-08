//============================================================================//
//                                                                            //
//      Parameterize Wishbone Slave Template                                  //
//                                                                            //
//      Module name: wbs_template                                             //
//      Desc: parameterized wishbone slave template, with byte enables and    //
//            parameterized address and data widths.                          //
//      Date: July 2012                                                       //
//      Developer: Wesley New                                                 //
//      Licence: GNU General Public License ver 3                             //
//      Notes:                                                                //
//                                                                            //
//============================================================================//

module sys_block #(
      //=============
      // parameters
      //=============
      parameter DEV_BASE_ADDR  = {BUS_ADDR_WIDTH{1'b0}}, // default 32'h0
      parameter DEV_HIGH_ADDR  = {{(BUS_ADDR_WIDTH-4){1'b0}}, 4'hF}, // default 32'h000000EE
      parameter BUS_DATA_WIDTH = 32,  // default is 32. but can be 8, 16, 32, 64
      parameter BUS_ADDR_WIDTH = 8,   // default is 8.  but can be 4, 8, 16, 32
      parameter BOARD_ID       = 32'h0,
      parameter REV_MAJ        = 32'h0,
      parameter REV_MIN        = 32'h0,
      parameter REV_RCS        = 32'h0

   ) (
      //============
      // wb inputs
      //============
      input                      wb_clk_i,
      input                      wb_rst_i,
      input                      wbs_cyc_i,
      input                      wbs_stb_i,
      input                      wbs_we_i,
      input   [BYTE_ENABLES-1:0] wbs_sel_i,
      input [BUS_ADDR_WIDTH-1:0] wbs_adr_i,
      input [BUS_DATA_WIDTH-1:0] wbs_dat_i,
      
      //=============
      // wb outputs
      //=============
      output reg [BUS_DATA_WIDTH-1:0] wbs_dat_o,
      output reg                      wbs_ack_o,
      output reg                      wbs_err_o,
      output reg                      wbs_int_o
   );
  
   integer i;
 
   //===================
   // local parameters
   //===================
   // byte enable is always the data width/8
   // thus the data width is only able to be multiples of 8
   localparam BYTE_ENABLES = BUS_DATA_WIDTH / 8;
   
   //========
   // wires
   //========
   wire adr_match = wbs_adr_i >= DEV_BASE_ADDR && wbs_adr_i <= DEV_HIGH_ADDR;

   //============
   // registers
   //============
   reg [BUS_DATA_WIDTH-1:0] scratchpad [3:0];
   //blocks
   always @ (posedge wb_clk_i) begin
      // reset logic
      if (wb_rst_i) begin
         wbs_dat_o <= {BUS_DATA_WIDTH{1'b0}};
         wbs_ack_o <= 0;
         wbs_int_o <= 0;
      end
   
      else begin
         // when the master acks our ack, then put our ack down
         if (wbs_ack_o & ~wbs_stb_i) begin
            wbs_ack_o <= 0;
         end
         // master is requesting somethign
         if (adr_match & wbs_stb_i & wbs_cyc_i) begin
            wbs_dat_o <= wbs_dat_o_reg;
            //================
            // write request
            //================
            if (wbs_we_i) begin
               // bring the address down to the base address
               case (wbs_adr_i - DEV_BASE_ADDR)
                  // writing something to address
                  32'h4: begin
                     // byte enabled writes, depending on the data width of the bus
                     // this isnt able to be done with generate statements as
                     // cant be used inside always blocks. BLAH!
                     // these take into account a possible data width of up to 64 bits
                     if (BYTE_ENABLES >= 1)
                        if (wbs_sel_i[0])
                           scratchpad[0][7:0] <= wbs_dat_i[7:0];
                     if (BYTE_ENABLES >= 2)
                        if (wbs_sel_i[1])
                           scratchpad[0] [15:8] <= wbs_dat_i[15:8];
                     if (BYTE_ENABLES >= 3)
                        if (wbs_sel_i[2])
                           scratchpad[0][23:16] <= wbs_dat_i[23:16];
                     if (BYTE_ENABLES >= 4)
                        if (wbs_sel_i[3])
                           scratchpad[0][31:24] <= wbs_dat_i[31:24];
                     if (BYTE_ENABLES >= 5)
                        if (wbs_sel_i[4])
                           scratchpad[0][39:32] <= wbs_dat_i[39:32];
                     if (BYTE_ENABLES >= 6)
                        if (wbs_sel_i[5])
                           scratchpad[0][47:40] <= wbs_dat_i[47:40];
                     if (BYTE_ENABLES >= 7)
                        if (wbs_sel_i[6])
                           scratchpad[0][55:48] <= wbs_dat_i[55:48];
                     if (BYTE_ENABLES >= 8)
                        if (wbs_sel_i[7])
                           scratchpad[0][63:56] <= wbs_dat_i[63:56];
                  end
                  32'h5: begin
                     if (BYTE_ENABLES >= 1)
                        if (wbs_sel_i[0])
                           scratchpad[1]  [7:0] <= wbs_dat_i[7:0];
                     if (BYTE_ENABLES >= 2)
                        if (wbs_sel_i[1])
                           scratchpad[1] [15:8] <= wbs_dat_i[15:8];
                     if (BYTE_ENABLES >= 3)
                        if (wbs_sel_i[2])
                           scratchpad[1][23:16] <= wbs_dat_i[23:16];
                     if (BYTE_ENABLES >= 4)
                        if (wbs_sel_i[3])
                           scratchpad[1][31:24] <= wbs_dat_i[31:24];
                     if (BYTE_ENABLES >= 5)
                        if (wbs_sel_i[4])
                           scratchpad[1][39:32] <= wbs_dat_i[39:32];
                     if (BYTE_ENABLES >= 6)
                        if (wbs_sel_i[5])
                           scratchpad[1][47:40] <= wbs_dat_i[47:40];
                     if (BYTE_ENABLES >= 7)
                        if (wbs_sel_i[6])
                           scratchpad[1][55:48] <= wbs_dat_i[55:48];
                     if (BYTE_ENABLES >= 8)
                        if (wbs_sel_i[7])
                           scratchpad[1][63:56] <= wbs_dat_i[63:56];
                  end
                  32'h6: begin
                     if (BYTE_ENABLES >= 1)
                        if (wbs_sel_i[0])
                           scratchpad[2]  [7:0] <= wbs_dat_i[7:0];
                     if (BYTE_ENABLES >= 2)
                        if (wbs_sel_i[1])
                           scratchpad[2] [15:8] <= wbs_dat_i[15:8];
                     if (BYTE_ENABLES >= 3)
                        if (wbs_sel_i[2])
                           scratchpad[2][23:16] <= wbs_dat_i[23:16];
                     if (BYTE_ENABLES >= 4)
                        if (wbs_sel_i[3])
                           scratchpad[2][31:24] <= wbs_dat_i[31:24];
                     if (BYTE_ENABLES >= 5)
                        if (wbs_sel_i[4])
                           scratchpad[2][39:32] <= wbs_dat_i[39:32];
                     if (BYTE_ENABLES >= 6)
                        if (wbs_sel_i[5])
                           scratchpad[2][47:40] <= wbs_dat_i[47:40];
                     if (BYTE_ENABLES >= 7)
                        if (wbs_sel_i[6])
                           scratchpad[2][55:48] <= wbs_dat_i[55:48];
                     if (BYTE_ENABLES >= 8)
                        if (wbs_sel_i[7])
                           scratchpad[2][63:56] <= wbs_dat_i[63:56];
                  end
                  32'h7: begin
                     if (BYTE_ENABLES >= 1)
                        if (wbs_sel_i[0])
                           scratchpad[3]  [7:0] <= wbs_dat_i[7:0];
                     if (BYTE_ENABLES >= 2)
                        if (wbs_sel_i[1])
                           scratchpad[3] [15:8] <= wbs_dat_i[15:8];
                     if (BYTE_ENABLES >= 3)
                        if (wbs_sel_i[2])
                           scratchpad[3][23:16] <= wbs_dat_i[23:16];
                     if (BYTE_ENABLES >= 4)
                        if (wbs_sel_i[3])
                           scratchpad[3][31:24] <= wbs_dat_i[31:24];
                     if (BYTE_ENABLES >= 5)
                        if (wbs_sel_i[4])
                           scratchpad[3][39:32] <= wbs_dat_i[39:32];
                     if (BYTE_ENABLES >= 6)
                        if (wbs_sel_i[5])
                           scratchpad[3][47:40] <= wbs_dat_i[47:40];
                     if (BYTE_ENABLES >= 7)
                        if (wbs_sel_i[6])
                           scratchpad[3][55:48] <= wbs_dat_i[55:48];
                     if (BYTE_ENABLES >= 8)
                        if (wbs_sel_i[7])
                           scratchpad[3][63:56] <= wbs_dat_i[63:56];
                     end
   
                  //add as many addresses as you need here
                  default: begin
                  end
               endcase
            end
            
            //===============
            // read request
            //===============
            else begin 
               case (wbs_adr_i - DEV_BASE_ADDR)
		  32'h0:   wbs_dat_o_reg <= BOARD_ID;
		  32'h1:   wbs_dat_o_reg <= REV_MAJ;
		  32'h2:   wbs_dat_o_reg <= REV_MIN;
		  32'h3:   wbs_dat_o_reg <= REV_RCS;
		  32'h4:   wbs_dat_o_reg <= scratchpad[0];
		  32'h5:   wbs_dat_o_reg <= scratchpad[1];
		  32'h6:   wbs_dat_o_reg <= scratchpad[2];
		  32'h7:   wbs_dat_o_reg <= scratchpad[3];
                  //add as many addresses as you need here
                  default: begin
                     wbs_dat_o_reg <= 32'b0;
                  end
               endcase
            end
            wbs_ack_o <= 1;
         end
         // if not (adr_match, wbs_cyc_i or wb_stb_i) release the Kraken!... I mean the data_o port
         else
            wbs_dat_o = 32'hxxxxxxxx;
      end
   end
   reg [BUS_DATA_WIDTH-1:0] wbs_dat_o_reg;
   //assign wbs_dat_o = wbs_dat_o_reg;
endmodule
