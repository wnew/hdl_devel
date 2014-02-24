//============================================================================//
//                                                                            //
//      Software Register read and write on wishbone bus                      //
//                                                                            //
//      Module name: sw_reg_wr                                                //
//      Desc: Software register with read and write on wishbone interface     //
//            and read only on fabric interface                               //
//      Date: Dec 2011                                                        //
//      Developer: Wesley New                                                 //
//      Licence: GNU General Public License ver 3                             //
//      Notes: To avoid race conditions the software reg is split into 2      //
//             different modules                                              //
//                                                                            //
//============================================================================//
//                                _________                                   //
//                  read & write |         | read only                        //
//               SW <----------> |   Reg   | --------> Fabric                 //
//                               |_________|                                  //
//                                                                            //
//============================================================================//


module sw_reg_wr #(
      //================
      // parameters
      //================
      parameter C_BASEADDR      = 32'h00000000,
      parameter C_HIGHADDR      = 32'h0000000F,
      parameter C_WB_DATA_WIDTH = 32,
      parameter C_WB_ADDR_WIDTH = 1,
      parameter C_BYTE_EN_WIDTH = 4
   ) (
      //================
      // wb inputs
      //================
      input         wbs_clk_i,
      input         wbs_rst_i,
      input         wbs_cyc_i,
      input         wbs_stb_i,
      input         wbs_we_i,
      input   [3:0] wbs_sel_i,
      input  [31:0] wbs_adr_i,
      input  [31:0] wbs_dat_i,
      
      //================
      // wb outputs
      //================
      output [31:0] wbs_dat_o,
      output        wbs_ack_o,
      output        wbs_err_o,
 
      //================
      // fabric ports
      //================
      input         fabric_clk,
      output        fabric_data_out
   );
 
   wire a_match = wbs_adr_i >= C_BASEADDR && wbs_adr_i <= C_HIGHADDR;
 
   //================
   // register buffer 
   //================
   reg [31:0] reg_buffer;
 
   //================
   // wb control
   //================
   reg wbs_ack_reg;
   assign wbs_ack_o = wbs_ack_reg;
   always @(posedge wbs_clk_i)
   begin
      wbs_ack_reg <= 1'b0;
      if (wbs_rst_i)
      begin
       //
      end
      else
      begin
         if (wbs_stb_i && wbs_cyc_i)
         begin
            wbs_ack_reg <= 1'b1;
         end
      end
   end
 
   //================
   // wb write
   //================
   always @(posedge wbs_clk_i)
   begin
      register_doneR  <= register_done;
      register_doneRR <= register_doneR;
      // reset
      if (wbs_rst_i)
      begin
         reg_buffer <= 32'd0;
         register_ready <= 1'b0;
      end
      else
      begin
         if (a_match && wbs_stb_i && wbs_cyc_i && wbs_we_i)
         begin
            register_ready <= 1'b1;
            case (wbs_adr_i[6:2])
               // byte enables
               5'h0:
               begin
                  if (wbs_sel_i[0])
                     reg_buffer[7:0] <= wbs_dat_i[7:0];
                  if (wbs_sel_i[1])
                     reg_buffer[15:8] <= wbs_dat_i[15:8];
                  if (wbs_sel_i[2])
                     reg_buffer[23:16] <= wbs_dat_i[23:16];
                  if (wbs_sel_i[3])
                     reg_buffer[31:24] <= wbs_dat_i[31:24];
               end
            endcase
         end
      end
      if (register_doneRR)
      begin
         register_ready <= 1'b0;
      end
   end
 
   //================
   // wb read
   //================
   reg [31:0] wbs_dat_o_reg;
   assign wbs_dat_o = wbs_dat_o_reg;
 
   always @(*)
   begin
      if(~wbs_we_i)
      begin
         case (wbs_adr_i[6:2])
            5'h0:   
               wbs_dat_o_reg <= reg_buffer;
            default:
               wbs_dat_o_reg <= 32'b0;
         endcase
      end
   end
 
   
   //================
   // fabric read
   //================
   reg [31:0] fabric_data_out_reg; 
   /* Handshake signal from OPB to application indicating data is ready to be latched */
   reg register_ready;
   reg register_readyR; 
   reg register_readyRR; 
   /* Handshake signal from application to OPB indicating data has been latched */
   reg register_done;
   reg register_doneR;
   reg register_doneRR;
   assign fabric_data_out = fabric_data_out_reg; 
  
   always @(posedge fabric_clk) 
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
         fabric_data_out_reg <= reg_buffer; 
      end 
   end

endmodule
