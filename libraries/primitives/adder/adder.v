//============================================================================//
//                                                                            //
//      Parameterize adder                                                    //
//                                                                            //
//      Module name: adder                                                    //
//      Desc: parameterized asyncronous adder module                          //
//      Date: Mar 2012                                                        //
//      Developer: Kaushal Buch                                               //
//      Licence: GNU General Public License ver 3                             //
//      Notes:                                                                //
//                                                                            //
//============================================================================//

module adder #(
      
      //=============================
      // Top level block parameters
      //=============================
      parameter ARCHITECTURE = "BEHAVIORAL", // BEHAVIORAL, VIRTEX5, VIRTEX6
      parameter DATA_WIDTH_1 = 8,            // number of input bits for input 1 
      parameter DATA_WIDTH_2 = 8             // number of input bits for input 2
   ) (
      //==============
      // Input Ports
      //==============
      input wire [DATA_WIDTH_1-1:0] data1_i,
      input wire [DATA_WIDTH_2-1:0] data2_i,
      //===============
      // Output Ports
      //===============
      `ifdef DATA_WIDTH_1 > DATA_WIDTH_2
      output [DATA_WIDTH_1:0] data_o
      `else
      output [DATA_WIDTH_2:0] data_o
      `endif
   );

   //=======================================
   // Generate according to implementation
   //=======================================
   generate
   	
      case (ARCHITECTURE)
         "BEHAVIORAL" :
         begin
           assign data_o = data1_i + data2_i;
         end // case "BEHAVIORAL"
   
         "VIRTEX5" :
         begin
            // Instantiate V5 demux primitive
         end
   
         "VIRTEX6" :
         begin
            // Instantiate V6 demux primitive
         end
   
         default:
         begin
            // default
         end

      endcase
   endgenerate
endmodule
