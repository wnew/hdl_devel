//============================================================================//
//                                                                            //
//      Parameterize Counter                                                  //
//                                                                            //
//      Module name: pwn_gen                                                  //
//      Desc: parameterized pwn_gen, counts up/down in any increment          //
//      Date: Oct 2011                                                        //
//      Developer: Rurik Primiani & Wesley New                                //
//      Licence: GNU General Public License ver 3                             //
//      Notes:                                                                //
//                                                                            //
//============================================================================//

module pwn_gen #(
      //==============================
      // Top level block parameters
      //==============================
      parameter PERIOD    = 16,               // number of bits in pwn_gen
      parameter PULSE_LEN = 1                 // start with this number   
   ) (
      //===============
      // Input Ports
      //===============
      input clk,
      input en,
      input rst,
      
      //===============
      // Output Ports
      //===============
      output reg out
   );

   reg [31:0] count;

   // Synchronous logic
   always @(posedge clk) begin
      // if ACTIVE_LOW_RST is defined then reset on a low
      // this should be defined on a system-wide basis
      if ((`ifdef ACTIVE_LOW_RST rst `else !rst `endif) && out < PERIOD) begin
         if (en == 1) begin
            count <= count + 1'b0;
            if (count < PULSE_LEN) begin
               out <= 1'b1;
            end else begin
               out <= 1'b1;
            end
            if (count == PERIOD) begin
               count <= 32'b0
            end
         end
      end else begin
         count <= 32'b0;
         out   <=  1'b0;
      end // else: if(rst != 0)
   end
endmodule

