//============================================================================//
//                                                                            //
//      Software Register with bus read only                                  //
//                                                                            //
//      Module name: sw_reg_r                                                 //
//      Desc: software register with wishbone bus inferface read only and     //
//            write only from fabric interface                                //
//      Date: Dec 2011                                                        //
//      Developer: Wesley New                                                 //
//      Licence: GNU General Public License ver 3                             //
//      Notes: To avoid race conditions the software reg is split into 2      //
//             different modules                                              //
//                                                                            //
//============================================================================//
//                               _________                                    //
//                         read |         | write                             //
//                     SW <-----|   Reg   |<----- Fabric                      //
//                              |_________|                                   //
//                                                                            //
//============================================================================//

module sw_reg_r #(
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
      input        fabric_clk_i,
      input [31:0] fabric_data_i,
      
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
      output reg                      wbs_err_o
   );
   
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
   reg [BUS_DATA_WIDTH-1:0] fabric_data_i_reg;
   reg [BUS_DATA_WIDTH-1:0] reg_buf = {BUS_DATA_WIDTH{1'b0}};

   // Handshake signal from WB to application indicating data is ready to be latched
   reg register_ready;
   reg register_readyR;
   reg register_readyRR;
   // Handshake signal from application to WB indicating data has been latched
   reg register_request;
   reg register_requestR;
   reg register_requestRR;

   //===============
   // fabric logic
   //===============
   always @(posedge fabric_clk_i)
   begin
      // registering for clock domain crossing  
      register_requestR  <= register_request;
      register_requestRR <= register_requestR;

      if (register_requestRR)
      begin
         register_ready <= 1'b1;
      end

      if (!register_requestRR)
      begin
         register_ready <= 1'b0;
      end
      if (register_requestRR && !register_ready)
      begin
         register_ready <= 1'b1;
         fabric_data_i_reg = fabric_data_i;
         //$display("fabric data read %h", fabric_data_i);
      end
   end

   //=================
   // wishbone logic
   //=================
   always @ (posedge wb_clk_i) begin
      register_readyR  <= register_ready;
      register_readyRR <= register_readyR;
     
      if (register_readyRR) begin
         register_request <= 1'b0;
      end

      if (register_readyRR && register_request) begin
         /* only latch the data when the buffer is not locked */
         reg_buf <= fabric_data_i_reg;
      end

      if (!register_readyRR) begin
         /* always request the buffer */
         register_request <= 1'b1;
      end

      // reset logic 
      if (wb_rst_i) begin
         wbs_ack_o <= 0;
         wbs_err_o <= 0;
         register_request <= 1'b0;
      end
      else begin
         // when the master acks our ack, then put our ack down
         if (wbs_ack_o & ~wbs_stb_i) begin
            wbs_ack_o <= 0;
         end
         // master is requesting somethign
         if (adr_match & wbs_stb_i & wbs_cyc_i) begin
            //===============
            // read request
            //===============
            if (~wbs_we_i)
            begin 
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
