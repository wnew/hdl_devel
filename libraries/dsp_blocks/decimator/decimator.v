//============================================================================//
//                                                                            //
//      Parameterize Decimator                                                //
//                                                                            //
//      Module name: decimator                                                //
//      Desc: parameterized decimator, current implementation decimates only  //
//            whole factors                                                   //
//      Date: June 2012                                                       //
//      Developer: Wesley New                                                 //
//      Licence: GNU General Public License ver 3                             //
//      Notes:                                                                //
//                                                                            //
//============================================================================//

module decimator #(
      //=============
      // Parameters
      //=============
      parameter ARCHITECTURE       = "BEHAVIORAL",     // BEHAVIORAL, VIRTEX5, VIRTEX6
      parameter DATA_WIDTH         = 32,
      parameter WHOLE_NUM_FACTOR   = 1,                // If the decimation factor is a whole number or not
      parameter DECI_DIV_FACTOR    = 8,
      parameter DECI_MULTI_FACTOR  = 1
   ) (
      //==============
      // Input Ports
      //==============
      input                   clk1_i,
      input                   clk2_i,
      input                   en,
      input                   rst,
      input  [DATA_WIDTH-1:0] data_in,

      //===============
      // Input Ports
      //===============
      output reg                  data_valid,
      output reg [DATA_WIDTH-1:0] data_out
   );


   //=======================================
   // Generate according to implementation
   //=======================================
   generate
      case (ARCHITECTURE)

         "BEHAVIORAL" :
         begin
            wire [31:0] count;
            
            //=======================
            // Counter Instatiation
            //=======================
            counter #(
               .ARCHITECTURE ("BEHAVIORAL"),
               .DATA_WIDTH   (32),
               .COUNT_FROM   (0),
               .COUNT_TO     (3),
               .STEP         (1)
            ) counter_inst (
               .clk (clk1_i),
               .en  (1),
               .rst (0),
               .out (count)
            );

            always @(posedge clk1_i)
            begin
               if (count == 0)
               begin
                  data_valid <= 1;
                  data_out   <= data_in;
               end
               else
                  data_valid <= 0;
            end
         end

         default :
         begin
         end

      endcase
   endgenerate
endmodule
