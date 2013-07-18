module sine_cos #(
      parameter DATA_WIDTH = 8
   ) (
      input  clk,
      input  rst,
      input  en,
      output [DATA_WIDTH-1:0] sine,
      output [DATA_WIDTH-1:0] cos
   );

   reg [DATA_WIDTH-1:0] sine_reg, cos_reg;
   
   assign      sine = sine_reg + {cos_reg[7], cos_reg[7], cos_reg[7], cos_reg[7:3]};
   assign      cos  = cos_reg  - {sine   [7], sine   [7], sine   [7], sine   [7:3]};

   always@(posedge clk or negedge rst) begin
      if (!rst) begin
          sine_reg <= 0;
          cos_reg  <= 120;
      end else begin
         if (en) begin
            sine_reg <= sine;
            cos_reg  <= cos;
         end
      end
   end
endmodule // sine_cos
