module tb_one_reg;

reg clk;
reg we;
wire [31:0] data;

initial begin
    $from_myhdl(
        clk,
        we
    );
    $to_myhdl(
        data
    );
end

one_reg dut(
    clk,
    we,
    data
);

endmodule
