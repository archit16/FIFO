`timescale 1ns / 1ps
module fifo

#(parameter awidth =5, parameter dwidth =8) //address width and data width
(
input clk, rst, wr_en, rd_en,
input [dwidth-1:0] data_in,
output full, empty,
output reg [dwidth-1:0] data_out
);
localparam depth = 2**awidth;
reg [dwidth-1:0] mem [0:depth-1];

reg [awidth-1:0] wptr;
reg [awidth-1:0] rptr;
reg wrote;

always@(posedge clk or posedge rst)
begin
    if(rst)
    begin
        wptr <= 1'b0;
        rptr <= 1'b0;
        wrote <= 1'b0;
    end
    else
    begin
        if(rd_en && !empty)
        begin
            data_out <= mem[rptr];
            rptr <= rptr+1;
            wrote = 0;
        end
        if(wr_en && !full)
        begin
            mem[wptr] <= data_in;
            wptr <= wptr+1;
            wrote = 1;
        end
    end
end
assign empty = (rptr == wptr) && !wrote;
assign full = (rptr == wptr) && wrote;

endmodule