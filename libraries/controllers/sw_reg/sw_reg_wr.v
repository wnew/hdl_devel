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

module sw_reg_wr #(
      //=============
      // parameters
      //=============
      parameter DEV_BASE_ADDR  = {BUS_ADDR_WIDTH{1'b0}}, // default 32'h0
      parameter DEV_HIGH_ADDR  = {{(BUS_ADDR_WIDTH-4){1'b0}}, 4'hF}, // default 32'h000000EE
      parameter BUS_DATA_WIDTH = 32,  // default is 32. but can be 8, 16, 32, 64
      parameter BUS_ADDR_WIDTH = 8    // default is 8.  but can be 4, 8, 16, 32
   ) (
      //===============
      // fabric ports
      //===============
      input             fabric_clk_i,
      output reg [31:0] fabric_data_o,
      
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
   reg [BUS_DATA_WIDTH-1:0] reg_buf = {BUS_DATA_WIDTH{1'b0}};

   // Handshake signal from WB to application indicating data is ready to be latched
   reg register_ready;
   reg register_readyR;
   reg register_readyRR;
   // Handshake signal from application to WB indicating data has been latched
   reg register_done;
   reg register_doneR;
   reg register_doneRR;

   //===============
   // fabric logic
   //===============
   always @(posedge fabric_clk_i)
   begin
      // registering for clock domain crossing  
      register_readyR  <= register_ready;
      register_readyRR <= register_readyR;

      if (!register_readyRR)
      begin
         register_done <= 1'b0;
      end

      if (register_readyRR)
      begin
         register_done <= 1'b1;
         fabric_data_o <= reg_buf;
         //$display("fabric data read %h", fabric_data_o);
      end
   end

   //=================
   // wishbone logic
   //=================
   always @ (posedge wb_clk_i) begin
      register_doneR  <= register_done;
      register_doneRR <= register_doneR;
      // reset logic
      if (register_doneRR)
      begin
         register_ready <= 1'b0;
      end
      
     if (wb_rst_i) begin
         wbs_ack_o <= 0;
         wbs_err_o <= 0;
         wbs_int_o <= 0;
         register_ready <= 1'b0;
      end
      else begin
         // when the master acks our ack, then put our ack down
         if (wbs_ack_o & ~wbs_stb_i) begin
            wbs_ack_o <= 0;
         end
         // master is requesting somethign
         if (adr_match & wbs_stb_i & wbs_cyc_i) begin
            //================
            // write request
            //================
            if (wbs_we_i) begin
               register_ready <= 1'b1;
               // bring the address down to the base address
               case (wbs_adr_i - DEV_BASE_ADDR)
                  // writing something to address
                  32'h0: begin
                     // byte enabled writes, depending on the data width of the bus
                     // this isnt able to be done with generate statements as
                     // cant be used inside always blocks. BLAH!
                     // these take into account a possible data width of up to 64 bits
                     if (BYTE_ENABLES >= 1)
                        if (wbs_sel_i[0])
                           reg_buf  [7:0] <= wbs_dat_i[7:0];
                     if (BYTE_ENABLES >= 2)
                        if (wbs_sel_i[1])
                           reg_buf [15:8] <= wbs_dat_i[15:8];
                     if (BYTE_ENABLES >= 3)
                        if (wbs_sel_i[2])
                           reg_buf[23:16] <= wbs_dat_i[23:16];
                     if (BYTE_ENABLES >= 4)
                        if (wbs_sel_i[3])
                           reg_buf[31:24] <= wbs_dat_i[31:24];
                     if (BYTE_ENABLES >= 5)
                        if (wbs_sel_i[4])
                           reg_buf[39:32] <= wbs_dat_i[39:32];
                     if (BYTE_ENABLES >= 6)
                        if (wbs_sel_i[5])
                           reg_buf[47:40] <= wbs_dat_i[47:40];
                     if (BYTE_ENABLES >= 7)
                        if (wbs_sel_i[6])
                           reg_buf[55:48] <= wbs_dat_i[55:48];
                     if (BYTE_ENABLES >= 8)
                        if (wbs_sel_i[7])
                           reg_buf[63:56] <= wbs_dat_i[63:56];
                     
                     //$display("user wrote %h", reg_buf);
                  end
                  //add as many addresses as you need here
                  default: begin
                     //$display("no case for write address %h", wbs_adr_i);
                  end
               endcase
            end
            
            //===============
            // read request
            //===============
            else begin 
               case (wbs_adr_i - DEV_BASE_ADDR)
                  32'h0: begin
                     //reading something from address 0
                     //$display("user read %h", reg_buf);
                     wbs_dat_o <= reg_buf;
                  end
                  //add as many addresses as you need here
                  default: begin
                     //$display("no case for read address %h", wbs_adr_i);
                  end
               endcase
            end
            wbs_ack_o <= 1;
         end
      end
   end
endmodule
