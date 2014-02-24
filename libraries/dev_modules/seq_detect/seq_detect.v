//============================================================================//
//                                                                            //
//      Parameterize Sequence Detector                                        //
//                                                                            //
//      Module name: seq_detect                                               //
//      Desc: parameterized sequence detector with variable sequence length   //
//      Date: July 2012                                                       //
//      Developer: Wesley New                                                 //
//      Licence: GNU General Public License ver 3                             //
//      Notes:                                                                //
//                                                                            //
//============================================================================//

module seq_detect #(
      //==============================
      // Top level block parameters
      //==============================
      parameter ARCHITECTURE = "BEHAVIORAL",     // BEHAVIORAL, VIRTEX5, VIRTEX6
      parameter SEQUENCE     = 32'b0             // define the sequence to be detected   
   ) (
      //===============
      // Input Ports
      //===============
      input clk,
      input en,
      input rst,
      input in,
      
      //===============
      // Output Ports
      //===============
      output reg [DATA_WIDTH-1:0] out
   );

   //=======================================
   // Generate according to implementation
   //=======================================
   generate
      case (ARCHITECTURE)
         
         "BEHAVIORAL" : 
         begin
            // Synchronous logic
            always @(posedge clk, posedge rst)
            begin
               // if ACTIVE_LOW_RST is defined then reset on a low
               // this should be defined on a system-wide basis
               if ((`ifdef ACTIVE_LOW_RST rst `else !rst `endif) && out < COUNT_TO)
               begin
                  if (en == 1)
                  begin
                     //
                  end
               end
               else
               begin
                  //
               end // else: if(rst != 0)
            end
         end // case "BEHAVIORAL"
 
         "VIRTEX5" :
         begin
            // Instantiate V5 counter primitive
         end
     
         "VIRTEX6" :
         begin
            // Instantiate V6 counter primitive
         end
     
         default :
         begin
            // default case
         end

      endcase 
   endgenerate
endmodule

