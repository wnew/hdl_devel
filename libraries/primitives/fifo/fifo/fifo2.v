module fifo(
    clk,
    rst,
    
    data_in,
    enq,
    full,
    
    data_out,
    valid_out,
    deq
);

parameter fifo_width = 32;
// fifo depth is hard-wired to 16

input clk, rst;

input [fifo_width-1:0] data_in;
input enq;
output full;
reg full;

output [fifo_width-1:0] data_out;
reg [fifo_width-1:0] data_out;
output valid_out;
reg valid_out;
input deq;



reg [fifo_width-1:0] fifo_data [0:15];
reg [4:0] fifo_head, fifo_tail;
reg [4:0] next_tail;


// accept input
wire next_full = fifo_head[3:0] == next_tail[3:0] &&
    fifo_head[4] != next_tail[4];
wire is_full = fifo_head[3:0] == fifo_tail[3:0] &&
    fifo_head[4] != fifo_tail[4];
always @(posedge clk) begin
    if (rst) begin
        fifo_tail <= 0;
        next_tail <= 1;
        full <= 0;
    end else begin
        if (!full && enq) begin
            // We can only enqueue when not full
            fifo_data[fifo_tail[3:0]] <= data_in;
            next_tail <= next_tail + 1;
            fifo_tail <= next_tail;
            
            // We have to compute if it's full on next cycle
            full <= next_full;
        end else begin
            full <= is_full;
        end
    end
end


// provide output
wire is_empty = fifo_head == fifo_tail;
always @(posedge clk) begin
    if (rst) begin
        valid_out <= 0;
        data_out <= 0;
        fifo_head <= 0;
    end else begin
        // If no valid out or we're dequeueing, we want to grab
        // the next data.  If we're empty, we don't get valid_out,
        // so we don't care if it's garbage.
        if (!valid_out || deq) begin
            data_out <= fifo_data[fifo_head[3:0]];
        end
        
        if (!is_empty) begin
            if (!valid_out || deq) begin
                fifo_head <= fifo_head + 1;
            end
            valid_out <= 1;
        end else begin
            if (deq) valid_out <= 0;
        end
    end
end


endmodule
