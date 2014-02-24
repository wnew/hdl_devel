module tb_counter_wrapper;

reg clk;
reg en;
reg rst;
wire out;

initial begin
    $from_myhdl(
        clk,
        en,
        rst
    );
    $to_myhdl(
        out
    );
end

counter_wrapper dut(
    clk,
    en,
    rst,
    out
);

endmodule
