module module_with_bugs(reset, clk, filter_in, filter_out);

input       clk, reset;
input [7:0] filter_in;

output reg [7:0] filter_out;

integer     j;

reg  [7:0] window     [63:0];
reg  [7:0] a;
reg  [6:0] i;


always @ (posedge clk or posedge reset)
begin
   if (reset == 1'b1)
   begin
      filter_out <= 2*{2'b00, filter_in[7:2]} + {1'b0, filter_in[7:1]};
      for (j = 0; j < 64; j = j + 1)
      begin
         window[j] <= filter_out;
         a <= (a + window[j]);
      end
   end
   else 
   begin
      if (i == 63)
      begin
         filter_out = (a>>6);
      end
      else
      begin 
        i = i + 1;
      end
   end
end
endmodule
