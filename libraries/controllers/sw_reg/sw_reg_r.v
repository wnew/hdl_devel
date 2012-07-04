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
      parameter C_BASEADDR       = 32'h00000000,
      parameter C_HIGHADDR       = 32'h0000000F,
      parameter C_BUS_DATA_WIDTH = 32,
      parameter C_BUS_ADDR_WIDTH = 5,
      parameter C_BYTE_EN_WIDTH  = 4
   ) (
      //===============
      // fabric ports
      //===============
      input        fabric_clk,
      input [31:0] fabric_data_in,
      
      //============
      // wb inputs
      //============
      input        wbs_clk_i,
      input        wbs_rst_i,
      input        wbs_cyc_i,
      input        wbs_stb_i,
      input        wbs_we_i,
      input  [3:0] wbs_sel_i,
      input [31:0] wbs_adr_i,
      input [31:0] wbs_dat_i,
      
      //=============
      // wb outputs
      //=============
      output reg [31:0] wbs_dat_o,
      output reg        wbs_ack_o,
      output reg        wbs_err_o
   );
 
   wire a_match = wbs_adr_i >= C_BASEADDR && wbs_adr_i <= C_HIGHADDR;
 
   reg [31:0] fabric_data_in_reg;
   
   //==================
   // register buffer 
   //==================
   reg [31:0] reg_buffer;
 
   //=============
   // wb control
   //=============
   always @(posedge wbs_clk_i)
   begin
      register_readyR  <= register_ready;
      register_readyRR <= register_readyR;
      
      wbs_ack_o <= 1'b0;
      if (wbs_rst_i)
      begin
         register_request <= 1'b0;
      end
      else
      begin
         if (wbs_stb_i && wbs_cyc_i)
         begin
            wbs_ack_o <= 1'b1;
         end
      end
      if (register_readyRR)
      begin
         register_request <= 1'b0;
      end
      if (register_readyRR && register_request)
      begin
         reg_buffer <= fabric_data_in_reg;
      end
 
      if (!register_readyRR)
      begin
         /* always request the buffer */
         register_request <= 1'b1;
      end
   end
 
   //==========
   // wb read
   //==========
   always @(*)
   begin
      if (wbs_rst_i)
      begin
         register_request <= 1'b0;
      end
      if(~wbs_we_i)
      begin
         case (wbs_adr_i[6:2])
            // Check if this works, it should depend on the spacings between devices on the bus,
            // otherwise just check if the address is in range and dont worry about the case statement
            // blah blah
            5'h0:   
            begin   
               wbs_dat_o <= reg_buffer;
            end
            default:
            begin
               wbs_dat_o <= 32'b0;
            end
         endcase
      end
   end
   
   //===============
   // fabric write
   //===============
   /* Handshake signal from wb to application indicating new data should be latched */
   reg register_request;
   reg register_requestR;
   reg register_requestRR;
   /* Handshake signal from application to wb indicating data has been latched */
   reg register_ready;
   reg register_readyR;
   reg register_readyRR;
   
   always @(posedge fabric_clk)
   begin
      register_requestR  <= register_request;
      register_requestRR <= register_requestR;
      //register_readyR    <= register_ready;
      //register_readyRR   <= register_readyR;
 
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
         fabric_data_in_reg <= fabric_data_in;
      end
   end
endmodule
